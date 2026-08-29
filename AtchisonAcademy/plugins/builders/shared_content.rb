# The books and courses collections live in the repo-root `shared/` folder and
# are reached through symlinks at src/_books and src/_courses, so this site
# reads all 22 items — including the ones that belong only to another site.
#
# Filter at read time, not in the index templates: a resource left in the
# collection generates its own /books/:slug/ or /courses/:slug/ page and a
# sitemap entry regardless of what any template renders. `site.resources` is
# derived from the collections on every call, so dropping a resource here also
# drops it from the related-item strips on the book and course layouts.
#
# This builder also resolves each item's `canonical_site` into a cross-domain
# `rel=canonical` and a sitemap exclusion on the site that does not own the
# page, and fails the build when that key is missing or wrong.
#
# See Spec0008 and Spec0009.
class Builders::SharedContent < SiteBuilder
  COLLECTIONS = %w[books courses].freeze

  # Every site that carries these collections, keyed by the site suffix used
  # in the `show_`/`feature_`/`order_`/`canonical_site` vocabulary.
  #
  # DUPLICATED, DELIBERATELY: this constant is identical in
  # LeeAtchison/plugins/builders/shared_content.rb and the two copies must be
  # kept in sync by hand. That matches how Spec0006 and Spec0007 already
  # hardcode cross-property URLs in each site's own files, and avoids a
  # cross-directory read that would have to keep working in worktrees and on
  # Netlify. These domains change roughly never, and a divergence shows up
  # immediately in the canonical tag of the first page you look at.
  #
  # A seventh site joins by adding one entry here, in both copies.
  SITES = {
    "leeatchison" => { show: :show_leeatchison, url: "https://leeatchison.com" },
    "academy"     => { show: :show_academy,     url: "https://atchisonacademy.com" },
  }.freeze

  # The one line that differs between this file and the LeeAtchison copy.
  SITE_KEY = "academy"

  SITE         = SITES.fetch(SITE_KEY)
  SHOW_FLAG    = SITE[:show]
  FEATURE_FLAG = :"feature_#{SITE_KEY}"
  ORDER_KEY    = :"order_#{SITE_KEY}"

  def build
    hook :site, :post_read do |site|
      COLLECTIONS.each do |label|
        resources = site.collections[label].resources
        resources.each do |resource|
          validate!(resource)
          apply_canonical!(resource)
        end
        resources.select! { |resource| resource.data[SHOW_FLAG] }
      end
    end
  end

  private

  def validate!(resource)
    validate_stray_site_keys!(resource)
    validate_canonical_site!(resource)
  end

  # `feature_*` and `order_*` are only meaningful alongside the matching
  # `show_*`. Carrying one without it means the item was edited for a site it
  # is not on — surface that as a build failure rather than a silent no-op.
  def validate_stray_site_keys!(resource)
    return if resource.data[SHOW_FLAG]

    stray = [FEATURE_FLAG, ORDER_KEY].select { |key| resource.data.key?(key) }
    return if stray.empty?

    raise "#{resource.relative_path}: #{stray.join(", ")} set without #{SHOW_FLAG} " \
          "— this item is not on #{host(SITE_KEY)}"
  end

  # An item shown on two sites must say which site's page is the original,
  # and it may only name a site it actually appears on. A `canonical_site`
  # on a single-site item is fine: it states, truthfully, where that page
  # belongs.
  #
  # Both sites read all 22 resources at `post_read`, so these rules are
  # checked identically in each copy of this builder and every deploy
  # enforces them independently.
  def validate_canonical_site!(resource)
    canonical_site = resource.data[:canonical_site]
    shown_on = SITES.keys.select { |key| resource.data[SITES[key][:show]] }

    if canonical_site.nil?
      return if shown_on.length < 2

      raise "#{resource.relative_path}: shown on #{shown_on.join(", ")} but has no " \
            "canonical_site — an item on more than one site must name the site whose " \
            "page is the original"
    end

    unless SITES.key?(canonical_site)
      raise "#{resource.relative_path}: canonical_site: #{canonical_site} is not a known " \
            "site — expected one of #{SITES.keys.join(", ")}"
    end

    return if shown_on.include?(canonical_site)

    raise "#{resource.relative_path}: canonical_site: #{canonical_site} but " \
          "#{SITES[canonical_site][:show]} is not set — this item is not on " \
          "#{host(canonical_site)}"
  end

  # When the canonical page lives on another site, point this site's copy at
  # it and stop volunteering the page for indexing. The page itself stays
  # live, linked, and reachable.
  #
  # `sitemap_exclude` is already honored by the reject clause in
  # sitemap.xml.erb, so the sitemap template needs no change.
  #
  # The URL is always the other site's production URL, deploy previews
  # included: Netlify serves previews with an automatic noindex header, so a
  # production canonical costs nothing there, and there is no way to know the
  # other site's preview URL anyway. See Spec0004 and Spec0009.
  def apply_canonical!(resource)
    canonical_site = resource.data[:canonical_site]
    return if canonical_site.nil? || canonical_site == SITE_KEY

    resource.data[:canonical_url] = "#{SITES.fetch(canonical_site)[:url]}#{resource.relative_url}"
    resource.data[:sitemap_exclude] = true
  end

  def host(site_key)
    SITES.fetch(site_key)[:url].sub(%r{\Ahttps?://}, "")
  end
end
