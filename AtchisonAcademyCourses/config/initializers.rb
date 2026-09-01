# Welcome to Bridgetown!
#
# This configuration file is for settings which affect your whole site.
#
# For more documentation on using this initializers file, visit:
# https://www.bridgetownrb.com/docs/configuration/initializers/
#
# A list of all available configuration options can be found here:
# https://www.bridgetownrb.com/docs/configuration/options
#
# For technical reasons, this file is *NOT* reloaded automatically when you use
# `bin/bridgetown start`. If you change this file, please restart the server process.
#
# For reloadable site metadata like title, SEO description, social media
# handles, etc., take a look at `src/_data/site_metadata.yml`

Bridgetown.configure do |config|
  # The base hostname & protocol for your site, e.g. https://example.com
  #
  # On a Netlify Deploy Preview, build against the deploy's own hostname, so
  # that og:url and any absolute links describe the preview rather than
  # production. Everywhere else the literal below is used unconditionally:
  # local builds (CONTEXT unset), the production build (CONTEXT
  # "production"), and branch deploys (CONTEXT "branch-deploy"). Keying on
  # CONTEXT rather than falling back on DEPLOY_PRIME_URL is deliberate —
  # on a production build Netlify sets DEPLOY_PRIME_URL from the site's
  # domain configuration, and no Netlify UI setting should be able to
  # rewrite the production URL. Branch deploys keep the production URL
  # because they do not get Netlify's automatic noindex header. See Spec0004
  # (this site has no sitemap or canonical tags to key on CONTEXT for, but
  # the same preview-awareness pattern is followed for consistency and for
  # the derived purchase_url in plugins/builders/course_content.rb, which
  # always uses the production atchisonacademy.com literal regardless).
  preview_url = ENV["DEPLOY_PRIME_URL"].to_s
  preview_build = ENV["CONTEXT"] == "deploy-preview" && !preview_url.empty?
  url(preview_build ? preview_url : "https://courses.atchisonacademy.com")

  # Available options are `erb` (default), `serbea`, or `liquid`
  template_engine "erb"

  # Collections are defined in bridgetown.config.yml

  # For more documentation on how to configure your site using this initializers file,
  # visit: https://edge.bridgetownrb.com/docs/configuration/initializers/
end
