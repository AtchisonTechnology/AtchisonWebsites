#!/usr/bin/env ruby
# frozen_string_literal: true

# Downloads and web-sizes hero images for the back-catalog articles that
# have a Kit thumbnail_url but no local hero_image yet (Spec0024 Part 5).
# Written because the session that exported the articles could not reach
# Kit's image CDN (embed.filekitcdn.com is blocked from that sandbox) --
# run this instead from a machine with normal internet access.
#
# For each entry in script/needs_hero_image.json:
#   1. Download thumbnail_url, stripping Kit's ?w=800&fit=max-style resize
#      query params to get the original.
#   2. Web-size to 1600px wide with `sips -Z 1600` (the convention the
#      other sites in this repo use) and convert to PNG.
#   3. Save as src/images/posts/<slug>.png.
#   4. Set hero_image: <slug>.png in src/_articles/<slug>.md (only the
#      blank `hero_image:` line -- nothing else in the file is touched).
#
# Requires `sips` (macOS only). Idempotent and safe to re-run: skips any
# slug that already has a src/images/posts/<slug>.png on disk.
#
# Usage: ruby script/download_hero_images.rb

require "json"
require "net/http"
require "uri"
require "fileutils"
require "tempfile"

SITE_ROOT = File.expand_path("..", __dir__)
ARTICLES_DIR = File.join(SITE_ROOT, "src", "_articles")
IMAGES_DIR = File.join(SITE_ROOT, "src", "images", "posts")
MANIFEST = File.join(__dir__, "needs_hero_image.json")

abort "sips not found -- this script needs macOS's sips command." if `which sips`.strip.empty?

FileUtils.mkdir_p(IMAGES_DIR)

manifest = JSON.parse(File.read(MANIFEST))
puts "#{manifest.size} articles in the manifest."

downloaded = 0
skipped_existing = 0
failed = []

manifest.each do |entry|
  slug = entry["slug"]
  url = entry["thumbnail_url"]
  out_path = File.join(IMAGES_DIR, "#{slug}.png")

  if File.exist?(out_path)
    skipped_existing += 1
    next
  end

  uri = URI(url.sub(/\?.*/, ""))
  begin
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 20) do |http|
      http.get(uri.request_uri)
    end

    unless res.is_a?(Net::HTTPSuccess)
      failed << "#{slug}: HTTP #{res.code} for #{uri}"
      next
    end

    Tempfile.create(["hero", File.extname(uri.path)]) do |tmp|
      tmp.binmode
      tmp.write(res.body)
      tmp.flush

      unless system("sips", "-Z", "1600", "-s", "format", "png", tmp.path, "--out", out_path, out: File::NULL, err: File::NULL)
        failed << "#{slug}: sips conversion failed"
        next
      end
    end

    article_path = File.join(ARTICLES_DIR, "#{slug}.md")
    if File.exist?(article_path)
      content = File.read(article_path, encoding: "UTF-8")
      updated = content.sub(/^hero_image: *$/, "hero_image: #{slug}.png")
      if updated == content
        failed << "#{slug}: downloaded, but couldn't find a blank hero_image: line in #{article_path} to update -- set it by hand"
      else
        File.write(article_path, updated, encoding: "UTF-8")
      end
    else
      failed << "#{slug}: downloaded, but src/_articles/#{slug}.md doesn't exist"
    end

    downloaded += 1
    puts "  #{slug}: done"
  rescue StandardError => e
    failed << "#{slug}: #{e.class}: #{e.message}"
  end
end

puts
puts "Downloaded: #{downloaded}"
puts "Already had an image, skipped: #{skipped_existing}"
puts "Failed (#{failed.size}):"
failed.each { |f| puts "  #{f}" }
