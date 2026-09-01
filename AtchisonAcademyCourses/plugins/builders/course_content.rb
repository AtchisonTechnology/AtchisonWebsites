# Validates the `courses` and `lessons` collections and fails the build loud
# on anything that would silently ship a broken or guessable URL. Style
# matches AtchisonAcademy/LeeAtchison's `shared_content.rb`.
#
# This site does NOT join the repo-root `shared/` collections (Spec0021 Open
# Question 3) — `courses`/`lessons` here are this site's own content, not
# marketing metadata, so there are no symlinks and no `show_`/`canonical_site`
# keys. The one thing this builder does read from `shared/` is a read-only
# filename check (`shared/_courses/<course_id>.md` must exist) used only to
# confirm a derived `purchase_url` won't 404 — that check never mutates
# anything under `shared/` and does not add this site to either existing
# builder's `SITES` registry.
#
# See Spec0021.
class Builders::CourseContent < SiteBuilder
  MIN_SECRET_LENGTH = 8
  CONTENT_TYPES = %w[video text resources].freeze

  def build
    hook :site, :post_read do |site|
      courses = site.collections["courses"].resources
      lessons = site.collections["lessons"].resources

      courses.each { |course| validate_course!(course) }
      validate_no_duplicate_course_ids_or_secrets!(courses)

      courses_by_id = courses.each_with_object({}) { |c, h| h[c.data[:course_id]] = c }
      lessons.each { |lesson| validate_lesson!(lesson, courses_by_id) }
      validate_no_duplicate_lesson_pairs!(lessons)
    end

    # `course_id` must equal the marketing site's course-file slug, so the
    # purchase URL never needs its own front-matter key (Spec0021 Part 3). An
    # explicit `purchase_url` on the course overrides this for a course whose
    # two IDs must ever diverge, and for the placeholder course, which has no
    # marketing page.
    helper :course_purchase_url do |course|
      course.data[:purchase_url] || "https://atchisonacademy.com/courses/#{course.data[:course_id]}/"
    end

    # A course's lessons, sorted by (module, lesson) — the ordering prev/next
    # navigation and the outline sidebar both walk.
    helper :course_lessons do |site, course|
      site.collections["lessons"].resources
        .select { |l| l.data[:course] == course.data[:course_id] }
        .sort_by { |l| [l.data[:module], l.data[:lesson]] }
    end
  end

  private

  def validate_course!(course)
    path = course.relative_path

    missing = [:course_id, :secret, :title, :permalink].reject { |key| course.data[key] }
    unless missing.empty?
      raise "#{path}: missing #{missing.join(', ')} — every course needs course_id, " \
            "secret, title, and permalink"
    end

    secret = course.data[:secret].to_s
    if secret.length < MIN_SECRET_LENGTH
      raise "#{path}: secret #{secret.inspect} is shorter than #{MIN_SECRET_LENGTH} " \
            "characters — a short secret is guessable"
    end

    expected_permalink = "/#{course.data[:course_id]}/#{secret}/"
    if course.data[:permalink] != expected_permalink
      raise "#{path}: permalink #{course.data[:permalink].inspect} does not match " \
            "#{expected_permalink.inspect} (course_id + secret)"
    end

    validate_cover_image!(course)
    validate_purchase_url!(course)
  end

  # `cover_image` is optional; when present, the file it points at must
  # actually exist under src/, or a typo'd path would silently ship a broken
  # image on the course index.
  def validate_cover_image!(course)
    cover_image = course.data[:cover_image]
    return unless cover_image

    disk_path = File.join(course.site.source, cover_image.to_s.sub(%r{\A/}, ""))
    return if File.exist?(disk_path)

    raise "#{course.relative_path}: cover_image #{cover_image.inspect} does not exist " \
          "at #{disk_path} — fix the path or remove the key"
  end

  # A course with no purchase_url override must derive one from a real
  # marketing-site course file, or the link on the sharing notice would 404.
  # This is a read-only filename check against shared/_courses — it does not
  # add this site to the shared collections.
  def validate_purchase_url!(course)
    return if course.data[:purchase_url]

    course_id = course.data[:course_id]
    shared_file = File.expand_path("../shared/_courses/#{course_id}.md", course.site.root_dir)
    return if File.exist?(shared_file)

    raise "#{course.relative_path}: no purchase_url override and no " \
          "shared/_courses/#{course_id}.md — the derived purchase link " \
          "(https://atchisonacademy.com/courses/#{course_id}/) would 404. Add a " \
          "purchase_url override, or fix course_id to match the marketing course's slug."
  end

  def validate_no_duplicate_course_ids_or_secrets!(courses)
    courses.group_by { |c| c.data[:course_id] }.each do |course_id, group|
      next if group.length < 2

      raise "Duplicate course_id #{course_id.inspect} on: " \
            "#{group.map(&:relative_path).join(', ')}"
    end

    courses.group_by { |c| c.data[:secret] }.each do |secret, group|
      next if group.length < 2

      raise "Duplicate secret #{secret.inspect} on: #{group.map(&:relative_path).join(', ')}"
    end
  end

  def validate_lesson!(lesson, courses_by_id)
    path = lesson.relative_path
    course_id = lesson.data[:course]
    course = courses_by_id[course_id]

    unless course
      raise "#{path}: course #{course_id.inspect} does not exist"
    end

    module_number = lesson.data[:module]
    declared_modules = (course.data[:modules] || []).map(&:number)
    unless declared_modules.include?(module_number)
      raise "#{path}: module #{module_number.inspect} is not declared on course " \
            "#{course_id.inspect} (declared modules: #{declared_modules.join(', ')})"
    end

    content_type = lesson.data[:content_type]
    unless CONTENT_TYPES.include?(content_type)
      raise "#{path}: content_type #{content_type.inspect} is invalid — expected one of " \
            "#{CONTENT_TYPES.join(', ')}"
    end

    if content_type == "video" && !lesson.data[:vimeo_id].to_s.match?(/\A\d+\z/)
      raise "#{path}: content_type: video requires a numeric vimeo_id"
    end

    if content_type == "resources" && (lesson.data[:resources] || []).empty?
      raise "#{path}: content_type: resources requires a non-empty resources list"
    end

    expected_permalink = "#{course.data[:permalink]}#{module_number}x#{lesson.data[:lesson]}/"
    if lesson.data[:permalink] != expected_permalink
      raise "#{path}: permalink #{lesson.data[:permalink].inspect} does not match " \
            "#{expected_permalink.inspect} (course permalink + module x lesson)"
    end
  end

  def validate_no_duplicate_lesson_pairs!(lessons)
    lessons.group_by { |l| [l.data[:course], l.data[:module], l.data[:lesson]] }.each do |key, group|
      next if group.length < 2

      course_id, module_number, lesson_number = key
      raise "Duplicate lesson #{module_number}x#{lesson_number} on course " \
            "#{course_id.inspect}: #{group.map(&:relative_path).join(', ')}"
    end
  end
end
