# Selling pages: sales pages, offer pages, and the helpers their layouts use
# (Spec0031).
#
# A **sales page** is the permanent, public page for a product. It renders
# with `layout: sales` from a data file, `src/_data/sales/<product>.yml`,
# named by the page's `sales_data:` key. A course's sales page is its own
# course page; a non-course product gets a standalone page.
#
# An **offer page** is a special-price copy of a sales page for one campaign:
# one file in the `offers` collection (`src/_offers/`), rendered with
# `layout: offer` from the same data file, overriding only price, Buy link,
# headline, intro, end date and extra sections. Kit has no discount-code
# field, so every special price needs its own page carrying its coupon link.
#
# At `:site, :post_read` this builder validates every offer and fails the
# build with a readable message if one is wrong, marks every offer noindex
# and sitemap-excluded, computes its `offer_state` (`active`/`ended`) from
# `redirect_at`, and drops hidden offers. It runs at high priority so it sees
# each product's sales page before `shared_content.rb` drops hidden courses —
# an offer inherits its sales page's hidden state.
require "uri"

class Builders::Offers < SiteBuilder
  # Buy-link tracking (Spec0031 §A8). Arrival parameters copied on by
  # frontend/javascript/index.js win over these.
  UTM_SOURCE = "atchisonacademy"
  UTM_MEDIUM = "web"

  REQUIRED_KEYS = %i[product permalink price buy_url].freeze

  def build
    hook :site, :post_read, priority: :high do |site|
      offers = site.collections["offers"]&.resources || []
      offers.each { |offer| prepare_offer!(site, offer) }

      # Sales and offer pages are full-width. index.css's generic-page rules
      # box every page that isn't homepage/book/course, and those selectors
      # are kept identical to LeeAtchison's copy, so selling pages opt out the
      # way the webinar pages do: with the "course" body class. "selling"
      # scopes this site's own selling-page rules.
      (site.resources.select { |r| r.data.sales_data } + offers).each do |resource|
        resource.data.page_class = [resource.data.page_class, "course", "selling"].compact.uniq.join(" ")
      end
      validate_unique_permalinks!(offers)
      offers.reject! { |offer| hidden_offer?(site, offer) }
    end

    # The product's sales data hash, for a sales page (`sales_data:`) or an
    # offer (`product:`); nil for any other page.
    helper :sales_data_for do |resource|
      sales_for(resource)
    end

    # Everything a selling-page partial needs, with the offer's overrides
    # already applied, so no partial branches on sales-vs-offer.
    helper :selling_page do |resource|
      SellingPage.new(sales_for(resource), offer?(resource) ? resource : nil)
    end

    # Selling-page copy from a sales data file, as HTML: escaped first, then
    # **bold**, *italic*, and {contact} — a link to the data file's
    # contact_url, labelled contact_label — expanded. Nothing else is
    # interpreted, so copy can't inject markup.
    helper :sales_text do |text, sales|
      html = ERB::Util.html_escape(text.to_s)
        .gsub(/\*\*(.+?)\*\*/, '<strong>\\1</strong>')
        .gsub(/\*(.+?)\*/, '<em>\\1</em>')
      if sales&.contact_url
        link = %(<a href="#{ERB::Util.html_escape(sales.contact_url)}">#{ERB::Util.html_escape(sales.contact_label)}</a>)
        html = html.gsub("{contact}", link)
      end
      html.html_safe
    end

    # A Kit checkout URL with this site's tracking tags appended. Merges into
    # any query string already present (the launch coupon link has one).
    helper :buy_link do |url, content:, campaign: nil|
      self.class.tag_url(url, content: content, campaign: campaign)
    end

    # The URL to send a reader to for a product right now: the named offer if
    # it exists in this build (not hidden) and is active, else the product's
    # sales page. Used by pages that link to "the current price", e.g. the
    # webinar replay page.
    helper :current_offer_url do |product, offer_slug|
      offer = site.collections["offers"].resources.find do |r|
        r.data.product == product && r.data.permalink.to_s.end_with?("/#{offer_slug}/")
      end
      if offer && offer.data.offer_state == "active"
        offer.relative_url
      else
        site.data.sales[product].sales_url
      end
    end
  end

  def self.tag_url(url, content:, campaign: nil)
    uri = URI.parse(url)
    params = URI.decode_www_form(uri.query.to_s)
    tags = [["utm_source", UTM_SOURCE], ["utm_medium", UTM_MEDIUM]]
    tags << ["utm_campaign", campaign] if campaign
    tags << ["utm_content", content]
    uri.query = URI.encode_www_form(params + tags)
    uri.to_s
  end

  private

  def offer?(resource)
    resource.respond_to?(:collection) && resource.collection&.label == "offers"
  end

  def sales_for(resource)
    return nil unless resource

    key = resource.data.sales_data || (offer?(resource) ? resource.data.product : nil)
    key && site.data.sales && site.data.sales[key]
  end

  def prepare_offer!(site, offer)
    where = offer.relative_path.to_s
    data = offer.data

    missing = REQUIRED_KEYS.reject { |key| data[key] }
    raise "#{where}: offer is missing #{missing.join(", ")}" unless missing.empty?

    # Rule 1: the product names a sales data file.
    sales = site.data.sales && site.data.sales[data.product]
    unless sales
      raise "#{where}: product: #{data.product} has no sales data file — expected " \
            "src/_data/sales/#{data.product}.yml"
    end

    # Rule 2: the permalink is the sales page URL plus exactly one segment.
    sales_url = sales["sales_url"].to_s
    unless data.permalink.to_s.match?(%r{\A#{Regexp.escape(sales_url)}[a-z0-9][a-z0-9-]*/\z})
      raise "#{where}: permalink: #{data.permalink} must be #{sales_url}<offer-slug>/ — " \
            "the product's sales page URL plus one path segment"
    end

    # Rule 4: an offer is a lower price, or it isn't an offer.
    unless data.price.is_a?(Numeric) && data.price < sales["price"]
      raise "#{where}: price: #{data.price} must be a number lower than the standard " \
            "price (#{sales["price"]}) in src/_data/sales/#{data.product}.yml"
    end

    # Rule 6: the page can't go away before the advertised end.
    ends_at = time_or_nil!(where, data, :ends_at)
    redirect_at = time_or_nil!(where, data, :redirect_at) || ends_at
    if ends_at && redirect_at < ends_at
      raise "#{where}: redirect_at (#{redirect_at}) is earlier than ends_at (#{ends_at})"
    end

    data.redirect_at = redirect_at
    data.offer_state = redirect_at && Time.now >= redirect_at ? "ended" : "active"

    # Always unlisted. No opt-out.
    data.noindex = true
    data.sitemap_exclude = true
  end

  # Rule 5.
  def validate_unique_permalinks!(offers)
    offers.group_by { |offer| offer.data.permalink }.each do |permalink, group|
      next if group.length < 2

      raise "#{group.map(&:relative_path).join(", ")}: offers share permalink #{permalink}"
    end
  end

  def time_or_nil!(where, data, key)
    value = data[key]
    return nil if value.nil?
    return value if value.is_a?(Time)

    raise "#{where}: #{key}: #{value.inspect} must be a timestamp with a UTC offset, " \
          "e.g. 2026-11-22T23:59:59-08:00"
  end

  # An offer is hidden when it says so itself, or while its product's sales
  # page is hidden. Same production/deploy-preview rule as everything else.
  def hidden_offer?(site, offer)
    return true if Builders::SharedContent.hidden?(offer)

    sales_page = site.resources.find { |r| r.data.sales_data == offer.data.product }
    sales_page && Builders::SharedContent.hidden?(sales_page)
  end

  # The view model the sales/offer partials render from. `offer` is nil on a
  # sales page.
  class SellingPage
    attr_reader :sales, :offer

    def initialize(sales, offer)
      @sales, @offer = sales, offer
    end

    def offer? = !offer.nil?
    def price = offer? ? offer.data.price : sales.price
    def standard_price = sales.price
    def headline = (offer? && offer.data.headline) || sales.hook
    # An offer's short paragraph under the headline; nil on a sales page.
    def intro = offer? ? offer.data.intro : nil
    def buy_label = (offer? && offer.data.buy_label) || sales.buy_label
    def campaign = offer? ? offer.data.utm_campaign : nil
    def offer_body? = offer? && !offer.content.to_s.strip.empty?
    def extra_sections = (offer? && offer.data.extra_sections) || []

    def buy_url(content)
      base = offer? ? offer.data.buy_url : sales.buy_url
      Builders::Offers.tag_url(base, content: content, campaign: campaign)
    end

    def fathom_event
      return sales.fathom_event unless offer?

      "#{sales.fathom_event}-#{offer.data.permalink.to_s.split("/").last}"
    end

    def money(amount) = "$#{amount}"

    # "Ends Sunday, November 22 at midnight Pacific", or nil when the offer
    # has no advertised end or doesn't show it. An offer's `end_line:`
    # replaces the generated wording.
    def end_line
      return nil unless offer? && offer.data.show_end && offer.data.ends_at
      return offer.data.end_line if offer.data.end_line

      t = offer.data.ends_at
      clock = t.hour == 23 && t.min == 59 ? "midnight" : t.strftime("%-l:%M%P")
      # -07:00 is read as Pacific daylight time; set end_line: for anything else.
      zone = { -8 => "Pacific", -7 => "Pacific" }.fetch(t.utc_offset / 3600, t.strftime("UTC%:z"))
      "Ends #{t.strftime("%A, %B %-d")} at #{clock} #{zone}"
    end

    def trailer_id = sales.trailer&.vimeo_id
  end
end
