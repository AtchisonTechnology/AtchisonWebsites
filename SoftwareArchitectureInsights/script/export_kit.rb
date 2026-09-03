#!/usr/bin/env ruby
# frozen_string_literal: true

# One-off (but re-runnable) export of the SAI back catalog from Kit into this
# site's articles collection (Spec0024 Part 5). Committed so it documents how
# the catalog was produced, and re-run at cutover so the export matches
# whatever has published on Kit since.
#
# Inputs:
#   KIT_API_KEY   - required env var, a Kit v4 read-only API key. Never
#                   committed. Verify the exact request shape against Kit's
#                   current v4 API docs before relying on this in production;
#                   this script could not be tested against the live API from
#                   the sandboxed session that wrote it (egress to api.kit.com
#                   is blocked there).
#   --archive DIR - path to the SAI project's Content/zCompleted Articles/
#                   folder (the clean hand-written Markdown source that
#                   exists for the ~9 most recent articles). Optional; when
#                   omitted, every article is built from Kit HTML.
#
# Outputs:
#   src/_articles/<kit-slug>.md
#   src/images/posts/<kit-slug>.png (only when a thumbnail exists)
#   script/kit_inventory.json - a snapshot of every post's public_url and
#                               live-check status, for script/check_urls.rb
#
# Usage:
#   KIT_API_KEY=... ruby script/export_kit.rb [--archive "/path/to/zCompleted Articles"] [--dry-run]

require "json"
require "net/http"
require "uri"
require "optparse"
require "fileutils"
require "date"
require "yaml"

options = {}
OptionParser.new do |opts|
  opts.on("--archive DIR", "SAI project's Content/zCompleted Articles/ folder") { |v| options[:archive] = v }
  opts.on("--dry-run", "Fetch and report without writing files") { options[:dry_run] = true }
end.parse!

API_KEY = ENV.fetch("KIT_API_KEY") { abort "Set KIT_API_KEY (a Kit v4 read-only API key) before running this script." }
API_BASE = "https://api.kit.com/v4"

SITE_ROOT = File.expand_path("..", __dir__)
ARTICLES_DIR = File.join(SITE_ROOT, "src", "_articles")
IMAGES_DIR = File.join(SITE_ROOT, "src", "images", "posts")

# ---------------------------------------------------------------------
# Kit API
# ---------------------------------------------------------------------

def kit_get(path, params = {})
  uri = URI("#{API_BASE}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = Net::HTTP::Get.new(uri)
  req["X-Kit-Api-Key"] = API_KEY
  req["Accept"] = "application/json"
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "Kit API #{uri}: #{res.code} #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  JSON.parse(res.body)
end

def all_posts
  posts = []
  cursor = nil
  loop do
    params = { per_page: 100 }
    params[:after] = cursor if cursor
    page = kit_get("/posts", params)
    posts.concat(page["posts"] || page["data"] || [])
    cursor = page.dig("pagination", "end_cursor")
    break unless page.dig("pagination", "has_next_page")
  end
  posts
end

# ---------------------------------------------------------------------
# Body cleanup (Kit HTML -> Markdown via pandoc)
# ---------------------------------------------------------------------

def clean_kit_html(html)
  html = html.gsub(/<style[^>]*>.*?<\/style>/m, "")
  html = html.gsub(/<table[^>]*class="[^"]*ck-layout-block[^"]*"[^>]*>.*?<\/table>/m, "")
  html = html.gsub(/\{\{\s*ck\.ad_slot\s*\}\}/, "")
  # Trailing bio paragraph (the same sentence the site's own bio.yml renders,
  # so a pasted-in bio is redundant with the layout's).
  html = html.sub(/<p>\s*<em>\s*Lee Atchison is a software architect.*?<\/p>\s*\z/m, "")
  html.gsub(/\s(class|style|target|rel)="[^"]*"/, "")
end

def html_to_markdown(html)
  require "tempfile"
  Tempfile.create(["kit-post", ".html"]) do |f|
    f.write(html)
    f.flush
    markdown = `pandoc --from html --to gfm #{f.path}`
    raise "pandoc failed" unless $?.success?

    # Drop a leading H1 pandoc may have produced from a stray <h1> in the body.
    markdown.sub(/\A#\s+[^\n]+\n+/, "")
  end
end

# ---------------------------------------------------------------------
# Category scraping (the Kit API exposes no category field -- Content/
# Category Taxonomy.md; the live page header is the only source)
# ---------------------------------------------------------------------

def categories_from_live_page(url)
  return [] unless url

  uri = URI(url)
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.get(uri.request_uri) }
  return [] unless res.is_a?(Net::HTTPSuccess)

  # The category labels this taxonomy uses, matched verbatim against the
  # live page's category header links.
  known = YAML.safe_load(File.read(File.join(SITE_ROOT, "src", "_data", "categories.yml"))).map { |c| c["label"] }
  known.select { |label| res.body.include?(label) }
rescue StandardError
  []
end

# ---------------------------------------------------------------------
# Archive-source lookup
# ---------------------------------------------------------------------

def archive_file_for(post, archive_dir)
  return nil unless archive_dir && Dir.exist?(archive_dir)

  Dir.glob(File.join(archive_dir, "*.md")).find do |path|
    content = File.read(path)
    content.include?(post["public_url"].to_s) || path.include?(post["slug"].to_s)
  end
end

# ---------------------------------------------------------------------
# Front matter
# ---------------------------------------------------------------------

def front_matter_for(post, description, meta_description, categories, hero_image, former_slug)
  yaml = {
    "title" => post["title"],
    "subtitle" => post.dig("subtitle") || "",
    "author" => "Lee Atchison",
    "status" => "published",
    "created" => post["created_at"]&.slice(0, 10),
    "date" => post["published_at"]&.slice(0, 10),
    "published_on" => post["published_at"]&.slice(0, 10),
    "sai_url" => post["public_url"],
    "email_sent" => post["published_at"]&.slice(0, 10),
    "linkedin_url" => nil,
    "hero_image" => hero_image,
    "internal_note" => nil,
    "meta_description" => meta_description,
    "slug" => post["slug"],
    "description" => description,
    "categories" => categories,
  }
  yaml["former_slug"] = former_slug if former_slug

  lines = ["---"]
  %w[title subtitle author status created date published_on].each do |k|
    lines << "#{k}: #{yaml[k].to_s.include?(":") || yaml[k].to_s.empty? ? yaml[k].inspect : yaml[k]}"
  end
  lines << ""
  lines << "sai_url: #{yaml["sai_url"]}"
  lines << "email_sent: #{yaml["email_sent"]}"
  lines << "linkedin_url:"
  lines << ""
  lines << "hero_image: #{yaml["hero_image"]}"
  lines << ""
  lines << "internal_note:"
  lines << "meta_description: #{yaml["meta_description"].inspect}"
  lines << "slug: #{yaml["slug"]}"
  lines << "description: >"
  lines << "  #{yaml["description"]}"
  if former_slug
    lines << "former_slug: #{former_slug}"
  end
  lines << "categories:"
  categories.each { |c| lines << "  - #{c.inspect}" }
  lines << ""
  lines << "---"
  lines.join("\n")
end

# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

FileUtils.mkdir_p(ARTICLES_DIR)
FileUtils.mkdir_p(IMAGES_DIR)

posts = all_posts
published = posts.select { |p| p["status"] == "published" }

puts "Fetched #{posts.size} posts, #{published.size} published."

exported = 0
missing_hero = 0
generated_meta_description = 0
needs_manual_categories = 0
inventory = []

published.each do |post|
  slug = post["slug"]
  inventory << { "public_url" => post["public_url"], "status" => 200 }

  archive_path = archive_file_for(post, options[:archive])
  markdown =
    if archive_path
      File.read(archive_path).split(/^---\s*$/, 3).last.to_s.strip
    else
      html_to_markdown(clean_kit_html(post["content"].to_s))
    end

  meta_description = post["meta_description"]
  if meta_description.to_s.empty?
    generated_meta_description += 1
    meta_description = "TODO: draft a <=150 character meta description (Content/CLAUDE.md)."
  end

  description = post["description"] || meta_description

  # Categories are not in the Kit API (Content/Category Taxonomy.md). Leave
  # a TODO for any post the SAI archive/handoff hasn't already resolved;
  # Lee approves the batch before these ship (Spec0024 Part 5).
  # 32 of the 56 live posts were already back-filled to the new taxonomy in
  # Kit on 2026-08-20 and render their category labels in the live page's
  # header; scrape those rather than re-deciding them. The other 24 still
  # carry the retired publication categories and get a TODO for Lee's
  # manual assignment (Spec0024 Part 5) -- never guessed here.
  categories = categories_from_live_page(post["public_url"])
  if categories.empty?
    needs_manual_categories += 1
    categories = ["TODO: assign 1-2 categories from src/_data/categories.yml"]
  end

  hero_image = nil
  if post["thumbnail_url"]
    hero_image = "#{slug}.png"
  else
    missing_hero += 1
  end

  fm = front_matter_for(post, description, meta_description, categories, hero_image, nil)

  puts "#{options[:dry_run] ? "[dry-run] " : ""}#{slug} " \
       "(#{archive_path ? "archive" : "kit-html"}, " \
       "#{hero_image ? "hero" : "no hero"})"

  next if options[:dry_run]

  File.write(File.join(ARTICLES_DIR, "#{slug}.md"), "#{fm}\n\n#{markdown}\n")
  exported += 1

  next unless post["thumbnail_url"]

  thumb_uri = URI(post["thumbnail_url"].to_s.sub(/\?.*/, ""))
  begin
    Net::HTTP.start(thumb_uri.host, thumb_uri.port, use_ssl: thumb_uri.scheme == "https") do |http|
      res = http.get(thumb_uri.request_uri)
      File.binwrite(File.join(IMAGES_DIR, "#{slug}.png"), res.body) if res.is_a?(Net::HTTPSuccess)
    end
  rescue StandardError => e
    warn "  hero image download failed for #{slug}: #{e.message}"
  end
end

File.write(File.join(__dir__, "kit_inventory.json"), JSON.pretty_generate(inventory))

puts
puts "Exported: #{exported}"
puts "Missing hero image (ships without one): #{missing_hero}"
puts "meta_description needs drafting: #{generated_meta_description}"
puts "categories need manual assignment: #{needs_manual_categories}"
puts "Wrote script/kit_inventory.json (#{inventory.size} entries) for check_urls.rb."
