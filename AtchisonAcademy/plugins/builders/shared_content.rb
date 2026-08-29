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
# See Spec0008.
class Builders::SharedContent < SiteBuilder
  COLLECTIONS = %w[books courses].freeze

  SHOW_FLAG    = :show_academy
  FEATURE_FLAG = :feature_academy
  ORDER_KEY    = :order_academy

  def build
    hook :site, :post_read do |site|
      COLLECTIONS.each do |label|
        resources = site.collections[label].resources
        resources.each { |resource| validate!(resource) }
        resources.select! { |resource| resource.data[SHOW_FLAG] }
      end
    end
  end

  private

  # `feature_*` and `order_*` are only meaningful alongside the matching
  # `show_*`. Carrying one without it means the item was edited for a site it
  # is not on — surface that as a build failure rather than a silent no-op.
  def validate!(resource)
    return if resource.data[SHOW_FLAG]

    stray = [FEATURE_FLAG, ORDER_KEY].select { |key| resource.data.key?(key) }
    return if stray.empty?

    raise "#{resource.relative_path}: #{stray.join(", ")} set without #{SHOW_FLAG} " \
          "— this item is not on atchisonacademy.com"
  end
end
