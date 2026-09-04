class Shared::Navbar < Bridgetown::Component
  LINKS = [
    { label: "Home",      path: "/" },
    { label: "Articles",  path: "/posts" },
    { label: "AI-Native", path: "/series/ai-native-architecture" },
    { label: "About",     path: "/about" },
    { label: "Links",     path: "/links" },
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
  def active?(path)
    current = @resource&.relative_url.to_s
    return current == "/" if path == "/"

    current == "#{path}/" || current.start_with?("#{path}/")
  end

  def link_classes(link)
    active?(link[:path]) ? "is-active" : ""
  end
end
