#!/usr/bin/env ruby
# frozen_string_literal: true

# URL-coverage check for the SAI Bridgetown site (Spec0024 Part 6).
#
# Two independent checks, either of which can run alone:
#
#   1. Sitemap <-> output/ coverage (always runs; needs only a local build).
#      (a) every <loc> in the built sitemap.xml corresponds to an
#          index.html under output/
#      (b) every indexable index.html under output/ (no sitemap_exclude,
#          no noindex on the resource -- approximated here by checking the
#          rendered page for <meta name="robots" content="noindex">, since
#          this script has no access to front matter after the build)
#          appears in the sitemap
#
#   2. Kit inventory coverage (only if --kit-inventory is given): for every
#      public_url in the Kit export snapshot that answered 200 on Kit,
#      assert the same path exists in output/, or matches a netlify.toml
#      [[redirects]] rule, or matches a generated former_slug rule in
#      output/_redirects.
#
# Usage:
#   ruby script/check_urls.rb [--dir output] [--kit-inventory path.json] [--base https://deploy-preview-N--site.netlify.app]
#
# --base, when given, makes the Kit-inventory check fetch over HTTP instead
# of reading output/ from disk -- for running against a Netlify deploy
# preview or production (Spec0024 Part 7, cutover checklist step 4/7).
# Sitemap <-> output/ coverage always reads the local build; it has no
# meaningful "against a live URL" mode since it already IS the build output.

require "json"
require "optparse"
require "rexml/document"
require "net/http"
require "uri"

options = { dir: "output" }
OptionParser.new do |opts|
  opts.on("--dir DIR", "Local build output directory (default: output)") { |v| options[:dir] = v }
  opts.on("--kit-inventory PATH", "Kit export snapshot JSON to check coverage against") { |v| options[:kit_inventory] = v }
  opts.on("--base URL", "Base URL to HTTP-check the Kit inventory against, instead of the local build") { |v| options[:base] = v.chomp("/") }
end.parse!

failures = []

# ---------------------------------------------------------------------
# 1. Sitemap <-> output/ coverage
# ---------------------------------------------------------------------

def read_local_paths(dir)
  Dir.glob(File.join(dir, "**", "index.html")).map do |path|
    rel = path.delete_prefix(dir).delete_suffix("index.html")
    rel = "/" if rel.empty?
    rel
  end.sort
end

def noindex_page?(dir, url_path)
  file = File.join(dir, url_path, "index.html")
  return false unless File.exist?(file)

  File.read(file, encoding: "UTF-8").include?('name="robots" content="noindex"')
end

sitemap_path = File.join(options[:dir], "sitemap.xml")
if File.exist?(sitemap_path)
  doc = REXML::Document.new(File.read(sitemap_path, encoding: "UTF-8"))
  base_url = nil
  sitemap_urls = []
  doc.elements.each("urlset/url/loc") do |loc|
    uri = URI.parse(loc.text)
    base_url ||= "#{uri.scheme}://#{uri.host}"
    sitemap_urls << uri.path
  end
  sitemap_urls.sort!

  local_paths = read_local_paths(options[:dir])
  # 404/500 and other non-"/"-suffixed pages are not real pages for this check.
  # Pagination pages 2+ (page/2/, page/3/, ...) are deliberately left out of
  # the sitemap by sitemap.xml.erb itself -- only page 1 of a paginated
  # listing (its canonical URL, e.g. /posts/) is included, the common
  # practice for paginated archives. Excluded here to match, not because
  # they're noindexed.
  indexable_local_paths = local_paths.reject { |p| noindex_page?(options[:dir], p) || p =~ %r{/page/\d+/\z} }

  missing_from_output = sitemap_urls - local_paths
  missing_from_output.each { |p| failures << "sitemap.xml lists #{p} but output/#{p}index.html does not exist" }

  missing_from_sitemap = indexable_local_paths - sitemap_urls
  missing_from_sitemap.each { |p| failures << "output/#{p}index.html is indexable but missing from sitemap.xml" }

  puts "Sitemap <-> output/: #{sitemap_urls.size} sitemap URLs, #{local_paths.size} local pages, " \
       "#{missing_from_output.size} missing from output, #{missing_from_sitemap.size} missing from sitemap"
else
  failures << "#{sitemap_path} does not exist -- run the build first"
end

# ---------------------------------------------------------------------
# 2. Kit inventory coverage (optional)
# ---------------------------------------------------------------------

def netlify_redirect_rules(dir_root)
  toml = File.read(File.join(dir_root, "netlify.toml"), encoding: "UTF-8")
  rules = []
  toml.scan(/\[\[redirects\]\]\s*\n\s*from\s*=\s*"([^"]+)"\s*\n\s*to\s*=\s*"([^"]+)"/m) do |from, to|
    rules << [from, to]
  end
  rules
end

def redirected?(path, rules, redirects_file_lines)
  rules.any? do |from, _to|
    pattern = from.end_with?("/*") ? from.delete_suffix("/*") : from
    from.end_with?("/*") ? path.start_with?(pattern) : path == from
  end || redirects_file_lines.any? do |line|
    from = line.split(/\s+/).first
    next false unless from

    pattern = from.end_with?("/*") ? from.delete_suffix("/*") : from
    from.end_with?("/*") ? path.start_with?(pattern) : path == from
  end
end

if options[:kit_inventory]
  inventory = JSON.parse(File.read(options[:kit_inventory], encoding: "UTF-8"))
  live_urls = inventory.select { |e| e["status"] == 200 }.map { |e| URI.parse(e["public_url"]).path }

  rules = netlify_redirect_rules(File.expand_path("..", __dir__))
  redirects_file = File.join(options[:dir], "_redirects")
  redirects_lines = File.exist?(redirects_file) ? File.readlines(redirects_file, encoding: "UTF-8") : []

  misses = live_urls.reject do |path|
    if options[:base]
      uri = URI.parse("#{options[:base]}#{path}")
      begin
        res = Net::HTTP.get_response(uri)
        res = Net::HTTP.get_response(URI.parse(res["location"])) if res.is_a?(Net::HTTPRedirection) && res["location"]
        res.is_a?(Net::HTTPSuccess)
      rescue StandardError
        false
      end
    else
      served = File.exist?(File.join(options[:dir], path.delete_prefix("/"), "index.html")) ||
        File.exist?(File.join(options[:dir], "#{path.delete_prefix("/")}.html"))
      served || redirected?(path, rules, redirects_lines)
    end
  end

  misses.each { |p| failures << "Kit inventory URL #{p} is not served and matches no redirect rule" }
  puts "Kit inventory: #{live_urls.size} live URLs checked, #{misses.size} misses"
end

if failures.empty?
  puts "check_urls: all checks passed."
  exit 0
else
  puts "check_urls: #{failures.size} FAILURE(S):"
  failures.each { |f| puts "  - #{f}" }
  exit 1
end
