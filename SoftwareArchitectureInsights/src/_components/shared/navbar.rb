class Shared::Navbar < Bridgetown::Component
  LINKS = [
    { label: "Home",      path: "/" },
    { label: "Articles",  path: "/posts" },
    { label: "AI-Native", path: "/series/ai-native-architecture" },
    { label: "AI Ethics", path: "/series/ai-ethics" },
    { label: "Series",    path: "/series" },
    { label: "Podcast",   path: "/podcast" },
    { label: "About",     path: "/about" },
  ].freeze

  attr_reader :metadata, :resource

  def initialize(metadata:, resource:)
    @metadata, @resource = metadata, resource
  end

  def links
    LINKS
  end

  # Current page wins on exact match; an article or category page highlights
  # its parent nav item (Articles) via the prefix.
  #
  # Most specific wins. "/series" is a prefix of "/series/ai-ethics", so on
  # the AI Ethics page both links match on prefix alone — only the longest
  # matching path stays highlighted, which keeps the two dedicated series
  # links lit on their own pages while "Series" lights up on the index and
  # on every series that has no nav item of its own.
  def active?(path)
    return false unless matches?(path)

    LINKS.none? { |l| l[:path].length > path.length && matches?(l[:path]) }
  end

  def link_classes(link)
    active?(link[:path]) ? "is-active" : ""
  end

  private

  def matches?(path)
    current = @resource&.relative_url.to_s
    return current == "/" if path == "/"

    current == "#{path}/" || current.start_with?("#{path}/")
  end
end
