# The `articles` collection is the entire site: every published SAI
# newsletter issue, byte-identical to its old Kit URL (Spec0024).
#
# This builder:
#   1. Validates every article at read time (slug/basename, date, category
#      and series labels) and warns on a non-published `status`.
#   2. Strips a pasted body's leading title block and trailing bio when they
#      match front matter exactly — the file on disk is never touched.
#   3. Drops any article whose `date` is in the future from this build
#      entirely (not rendered, not listed, not in the feed or sitemap), so
#      copying a file at 🚀 Ready is safe ahead of its Tuesday send.
#   4. Generates one page per category and per series from `_data/categories.yml`
#      and `_data/series.yml`.
#   5. Rewrites the sai-email/email UTM tags a pasted body and the rendered
#      bio both carry into sai-web/referral, and makes a self-link to this
#      site relative and untagged — one pass, applied to every page's
#      rendered HTML, so body content and the bio partial share one rule
#      instead of two.
#
# See Spec0024 Part 4.
require "uri"
require "date"

class Builders::SaiContent < SiteBuilder
  # Domains that get a sai-web/referral rewrite (Social Media/UTM Standard.md,
  # "Lee's Domains"). This site's own domain is handled separately below —
  # a link to it is internal, not tagged at all.
  LEE_DOMAINS = %w[
    leeatchison.com
    thesoftwareconductor.com
    architectingforscale.com
    tidesoundings.com
    stosa.org
  ].freeze

  SELF_HOST = "softwarearchitectureinsights.com".freeze

  TITLE_BLOCK_RE = /
    \A\s*
    \#\s*(?<h1>[^\n]+)\n
    \s*\n
    \*(?<subtitle>[^\n*]+)\*\n
    \s*\n
    -{3,}\n
    \s*
  /x

  VALID_CHANGEFREQ = %w[always hourly daily weekly monthly yearly never].freeze

  def build
    hook :site, :post_read do |site|
      categories_by_label = site.data.categories.each_with_object({}) { |c, h| h[c["label"]] = c }
      series_by_label      = site.data.series.each_with_object({}) { |s, h| h[s["label"]] = s }
      bio_template          = site.data.bio["template"]

      resources = site.collections["articles"].resources

      resources.each do |resource|
        validate_slug!(resource)
        validate_date!(resource)
        validate_categories!(resource, categories_by_label)
        validate_series!(resource, series_by_label)
        warn_on_status(resource)

        strip_title_block!(resource)
        strip_bio!(resource, bio_template)
        resource.data[:bio_html] = render_bio(bio_template, resource.data.slug)
      end

      resources.reject! { |resource| future_dated?(resource) }
    end

    # Runs after generators (category/series pages included) and before
    # rendering, so every page's sitemap_priority/sitemap_changefreq — hand
    # written or generator-assigned — gets checked once, in one place.
    hook :site, :pre_render do |site|
      site.resources.each do |resource|
        validate_sitemap_priority!(resource)
        validate_sitemap_changefreq!(resource)
      end
    end

    generator do
      site.data.categories.each do |category|
        add_resource :categories, "#{category["key"]}.md" do
          layout "category"
          permalink "/categories/#{category["key"]}/"
          title category["label"]
          category_key category["key"]
          description category["description"]
          sitemap_priority 0.6
          sitemap_changefreq "weekly"
          content ""
        end
      end

      site.data.series.each do |series|
        add_resource :series, "#{series["key"]}.md" do
          layout "series"
          permalink "/series/#{series["key"]}/"
          title series["label"]
          series_key series["key"]
          description series["description"]
          sitemap_priority 0.6
          sitemap_changefreq "weekly"
          content ""
        end
      end
    end

    hook :resources, :post_render do |resource|
      next unless resource.output.is_a?(String) && resource.output.include?("<html")

      resource.output = rewrite_web_utm(resource.output)
    end
  end

  private

  # ---------------------------------------------------------------------
  # Validation
  # ---------------------------------------------------------------------

  def validate_slug!(resource)
    return if resource.data.slug.to_s == resource.basename_without_ext

    raise "#{resource.relative_path}: slug: #{resource.data.slug.inspect} does not match " \
          "the filename #{resource.basename_without_ext.inspect} — the article ID, the " \
          "filename, and slug: must always agree"
  end

  def validate_date!(resource)
    # Not resource.data.date: by the time this hook runs, Bridgetown has
    # already defaulted a missing date to the current build time as a side
    # effect of something reading resource.date (the accessor method, which
    # does `data["date"] ||= site.time`) before this hook fires -- so
    # data.date is never actually nil here even when the front matter never
    # set one. model.data_attributes is the original parsed front matter,
    # untouched by that fallback, so it's the only reliable way to detect a
    # genuinely missing date (verified empirically -- see git history for
    # this line if the mechanism ever needs re-diagnosing).
    return if resource.model.data_attributes["date"]

    raise "#{resource.relative_path}: missing required date: — Bridgetown sorts the " \
          "archive on it and the future-date filter depends on it"
  end

  def validate_categories!(resource, categories_by_label)
    Array(resource.data.categories).each do |label|
      next if categories_by_label.key?(label)

      raise "#{resource.relative_path}: categories: #{label.inspect} is not a known " \
            "category — see src/_data/categories.yml for the exact labels"
    end
  end

  def validate_series!(resource, series_by_label)
    return unless resource.data.series
    return if series_by_label.key?(resource.data.series)

    raise "#{resource.relative_path}: series: #{resource.data.series.inspect} is not a " \
          "known series — see src/_data/series.yml for the exact labels"
  end

  def validate_sitemap_priority!(resource)
    priority = resource.data.sitemap_priority
    return if priority.nil?
    return if priority.is_a?(Numeric) && (0..1).cover?(priority)

    raise "#{resource.relative_path}: sitemap_priority: #{priority.inspect} is out of " \
          "range — must be between 0 and 1"
  end

  def validate_sitemap_changefreq!(resource)
    changefreq = resource.data.sitemap_changefreq
    return if changefreq.nil?
    return if VALID_CHANGEFREQ.include?(changefreq)

    raise "#{resource.relative_path}: sitemap_changefreq: #{changefreq.inspect} is not " \
          "valid — expected one of #{VALID_CHANGEFREQ.join(", ")}"
  end

  def warn_on_status(resource)
    status = resource.data.status
    return if status.nil? || status == "published"

    Bridgetown.logger.warn "SaiContent:",
      "#{resource.relative_path}: status: #{status} (expected published) — " \
      "check this wasn't copied in by mistake"
  end

  # ---------------------------------------------------------------------
  # Future-date filter (Spec0024 Part 4)
  # ---------------------------------------------------------------------

  def future_dated?(resource)
    article_date(resource) > Time.now.to_date
  end

  def article_date(resource)
    date = resource.data.date
    date.is_a?(String) ? Date.parse(date) : date.to_date
  end

  # ---------------------------------------------------------------------
  # Body rule 1 — strip a leading H1 / italic subtitle / --- that matches
  # front matter exactly. The layout owns the title block.
  # ---------------------------------------------------------------------

  def strip_title_block!(resource)
    match = TITLE_BLOCK_RE.match(resource.content.to_s)
    return unless match
    return unless match[:h1].strip == resource.data.title.to_s.strip
    return unless resource.data.subtitle && match[:subtitle].strip == resource.data.subtitle.to_s.strip

    resource.content = resource.content.sub(TITLE_BLOCK_RE, "")
  end

  # ---------------------------------------------------------------------
  # Body rule 3 — strip a trailing bio paragraph that starts with the same
  # sentence as the standard bio, preceded by a `---`. If the pattern isn't
  # found, nothing is stripped and the layout still renders its own bio —
  # a visible duplicate rather than a missing one.
  # ---------------------------------------------------------------------

  def strip_bio!(resource, bio_template)
    strip_match = Regexp.escape(resource.site.data.bio["strip_match"].to_s)
    bio_re = /\n-{3,}\n\s*\*?#{strip_match}.*\z/m
    resource.content = resource.content.to_s.sub(bio_re, "\n")
  end

  def render_bio(template, slug)
    markdown_links_to_html(format(template, campaign: slug))
  end

  # The bio template is prose with plain `[text](url)` links and nothing
  # else — no need for a full Markdown pipeline for one paragraph.
  def markdown_links_to_html(text)
    text.gsub(/\[([^\]]+)\]\(([^)]+)\)/) { %(<a href="#{Regexp.last_match(2)}">#{Regexp.last_match(1)}</a>) }
  end

  # ---------------------------------------------------------------------
  # Body rule 2 — output-HTML UTM rewrite, applied to every rendered page
  # (Spec0024 Part 4). Runs on final HTML, so it sees `&amp;`-escaped
  # ampersands and doesn't care about Markdown vs. already-rendered links.
  # ---------------------------------------------------------------------

  def rewrite_web_utm(html)
    # Scoped to <body> only. Applied to the whole page, this rewrite was
    # also mangling <head> tags with an href to this site -- notably
    # <link rel="canonical">, which it stripped down to a relative path
    # the same way it correctly relativizes a self-link in article prose.
    # Canonical (and anything else in <head>) needs to stay exactly as
    # the template rendered it.
    body_start = html.index("<body")
    return html unless body_start

    html[0...body_start] + html[body_start..].gsub(/href="([^"]+)"/) do
      %(href="#{rewrite_href(Regexp.last_match(1))}")
    end
  end

  def rewrite_href(href)
    unescaped = href.gsub("&amp;", "&")
    uri = begin
      URI.parse(unescaped)
    rescue URI::InvalidURIError
      return href
    end
    return href unless uri.host

    if uri.host.sub(/\Awww\./, "") == SELF_HOST
      return (uri.path.to_s.empty? ? "/" : uri.path) + uri.fragment.to_s.then { |f| f.empty? ? "" : "##{f}" }
    end

    return href unless LEE_DOMAINS.include?(uri.host.sub(/\Awww\./, ""))
    return href unless uri.query

    params = URI.decode_www_form(uri.query)
    return href unless params.include?(%w[utm_source sai-email]) && params.include?(%w[utm_medium email])

    params = params.map do |k, v|
      case k
      when "utm_source" then [k, "sai-web"]
      when "utm_medium" then [k, "referral"]
      else [k, v]
      end
    end
    uri.query = URI.encode_www_form(params)
    uri.to_s.gsub("&", "&amp;")
  end
end
