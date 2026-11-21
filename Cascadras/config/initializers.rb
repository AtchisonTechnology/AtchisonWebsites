# Bridgetown configuration for cascadras.com (WEB-32).
#
# For reloadable site metadata (title, description, the Fathom site ID), see
# `src/_data/site_metadata.yml`. This file is not reloaded by
# `bin/bridgetown start`; restart the server after changing it.

Bridgetown.configure do |config|
  # On a Netlify Deploy Preview, build against the deploy's own hostname, so
  # canonical and og:url describe the preview rather than production. Every
  # other build (local, production, branch deploy) uses the production URL.
  # Same rule as the other sites in this repo (Spec0004).
  preview_url = ENV["DEPLOY_PRIME_URL"].to_s
  preview_build = ENV["CONTEXT"] == "deploy-preview" && !preview_url.empty?
  url(preview_build ? preview_url : "https://cascadras.com")

  template_engine "erb"
end
