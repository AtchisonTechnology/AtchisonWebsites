# The `episodes` collection: one page per SAI podcast episode, at
# /podcast/<episode-id>/. Kept as a sibling to plugins/builders/sai_content.rb
# rather than folded into it — episodes are a distinct collection with their
# own validation rules and no article-editing side effects.
#
# This builder:
#   1. Validates every episode at read time (date-prefixed filename against
#      slug and date, required date, slug's category prefix against
#      category:, tags: from the allowed set, every source_articles slug
#      exists in the articles collection).
#   2. Drops any episode whose `date` is in the future from a production
#      build (not rendered, not listed on /podcast/, not in the sitemap),
#      the same mechanism and Pacific-time comparison (PacificDate) as
#      articles — an episode file can be committed ahead of its Tuesday
#      release and appears only after the scheduled rebuild.
#   3. Splits the body at a `## Transcript` heading: everything above it is
#      the summary/key-points shown in the main episode body, everything
#      below is the full transcript the layout renders inside a collapsed
#      "Show transcript" section (Spec0027, Solution #3). An episode with no
#      such heading just renders with no transcript section.
#
# See Spec0027.
require "date"

class Builders::SaiPodcast < SiteBuilder
  # Episode ID prefix for each of the seven categories (Episode Tracker.md,
  # "Quick reference"). The slug's prefix and the category: label must agree.
  CATEGORY_PREFIXES = {
    "Beyond the Article"     => "beyond-",
    "Then vs. Now"           => "then-now-",
    "Teardown"                => "teardown-",
    "Questions I Get Asked"  => "asked-",
    "Course Spin-off"        => "course-",
    "Interview"               => "interview-",
    "Reading"                  => "reading-",
  }.freeze

  VALID_TAGS = %w[Contrarian Series].freeze

  FILENAME_RE = /\A(?<date>\d{4}-\d{2}-\d{2})-(?<slug>.+)\z/.freeze

  def build
    hook :site, :post_read do |site|
      articles_by_slug = site.collections["articles"].resources.each_with_object({}) do |r, h|
        h[r.data.slug.to_s] = r
      end

      resources = site.collections["episodes"].resources

      resources.each do |resource|
        validate_slug!(resource)
        validate_date!(resource)
        validate_category!(resource)
        validate_tags!(resource)
        validate_source_articles!(resource, articles_by_slug)
        split_transcript!(resource)
      end

      resources.reject! { |resource| future_dated?(resource) }
    end
  end

  private

  # ---------------------------------------------------------------------
  # Transcript split
  # ---------------------------------------------------------------------

  def split_transcript!(resource)
    content = resource.content.to_s
    match = content.match(/\n##\s*Transcript\s*\n/i)
    return unless match

    resource.data[:transcript_source] = content[match.end(0)..].to_s
    resource.content = content[0...match.begin(0)]
  end

  def validate_slug!(resource)
    basename = resource.basename_without_ext
    match = FILENAME_RE.match(basename)

    unless match
      raise "#{resource.relative_path}: filename #{basename.inspect} is not date-prefixed " \
            "— episode files must be named YYYY-MM-DD-<episode-id>.md, using the " \
            "episode's release date"
    end

    unless match[:slug] == resource.data.slug.to_s
      raise "#{resource.relative_path}: slug: #{resource.data.slug.inspect} does not match " \
            "the filename #{basename.inspect} — the episode ID, the part of the " \
            "filename after the date prefix, and slug: must always agree"
    end

    file_date = match[:date]
    front_matter_date = episode_date(resource).strftime("%Y-%m-%d")
    return if file_date == front_matter_date

    raise "#{resource.relative_path}: the filename's date prefix #{file_date.inspect} does " \
          "not match date: #{front_matter_date.inspect} — rename the file whenever " \
          "the release date moves"
  end

  def validate_date!(resource)
    # Same fallback trap as articles (see sai_content.rb#validate_date! for
    # why model.data_attributes, not resource.data.date, is the check).
    return if resource.model.data_attributes["date"]

    raise "#{resource.relative_path}: missing required date: — the future-date filter " \
          "and the episode list's sort depend on it"
  end

  def validate_category!(resource)
    category = resource.data.category.to_s
    prefix = CATEGORY_PREFIXES[category]

    unless prefix
      raise "#{resource.relative_path}: category: #{resource.data.category.inspect} is not " \
            "one of the seven known categories — see " \
            "Builders::SaiPodcast::CATEGORY_PREFIXES"
    end

    slug = resource.data.slug.to_s
    return if slug.start_with?(prefix)

    raise "#{resource.relative_path}: slug: #{slug.inspect} does not start with " \
          "#{prefix.inspect}, the ID prefix for category: #{category.inspect}"
  end

  def validate_tags!(resource)
    Array(resource.data.tags).each do |tag|
      next if VALID_TAGS.include?(tag)

      raise "#{resource.relative_path}: tags: #{tag.inspect} is not a known tag — " \
            "expected one of #{VALID_TAGS.join(", ")}"
    end
  end

  def validate_source_articles!(resource, articles_by_slug)
    Array(resource.data.source_articles).each do |slug|
      next if articles_by_slug.key?(slug.to_s)

      raise "#{resource.relative_path}: source_articles: #{slug.inspect} does not match " \
            "any article's slug:"
    end
  end

  # ---------------------------------------------------------------------
  # Future-date filter — same mechanism as articles (sai_content.rb), in
  # Pacific time (PacificDate, plugins/builders/pacific_date.rb) so an
  # episode goes live no earlier than its scheduled Tuesday there.
  # ---------------------------------------------------------------------

  def future_dated?(resource)
    return false unless episode_date(resource).strftime("%Y-%m-%d") > Builders::PacificDate.today

    Bridgetown.env.production? && ENV["CONTEXT"] != "deploy-preview"
  end

  def episode_date(resource)
    date = resource.data.date
    date.is_a?(String) ? Date.parse(date) : date.to_date
  end
end
