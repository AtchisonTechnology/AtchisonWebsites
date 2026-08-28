class Shared::Navbar < Bridgetown::Component
  LINKS = [
    { label: "Home",         path: "/" },
    { label: "Books",        path: "/books" },
    { label: "Courses",      path: "/courses" },
    { label: "Lee Atchison", path: "https://leeatchison.com", external: true },
  ].freeze

  def initialize(metadata:, resource:)
    @metadata, @resource = metadata, resource
  end

  def links
    LINKS
  end

  # Current page wins on exact match; section pages (a book or course detail)
  # highlight their parent nav item via the prefix. External links never match,
  # since `relative_url`-shaped resource URLs never equal an absolute URL.
  def active?(path)
    current = @resource&.relative_url.to_s
    return current == "/" if path == "/"

    current == path || current.start_with?("#{path}/")
  end

  def link_classes(link)
    classes = []
    classes << "nav-featured" if link[:featured]
    classes << "is-active" if active?(link[:path])
    classes.join(" ")
  end
end
