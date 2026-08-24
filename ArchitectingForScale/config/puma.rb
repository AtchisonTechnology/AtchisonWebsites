# Puma is a fast, concurrent web server for Ruby & Rack
#
# Learn more at: https://puma.io
# Bridgetown configuration documentation:
# https://www.bridgetownrb.com/docs/configuration/puma

# This port number typically gets overridden by Bridgetown's boot & config loader
# so you probably don't want to touch the number here
#
# Dev port is derived per git worktree: main gets this site's base port, a
# spec####/bug#### worktree gets base + the ID. Single source of truth is
# ../../lib/worktree_env.rb; the table is in ../../Projects/services.md.
#
# BRIDGETOWN_PORT (exported by bin/dev) always wins. This fallback keeps a bare
# `bin/bridgetown start` on the right port too. If the helper isn't reachable
# (site checked out on its own, outside the monorepo), fall back to 4000.
port ENV.fetch("BRIDGETOWN_PORT") {
  begin
    require File.expand_path("../../lib/worktree_env", __dir__)
    WorktreeEnv.port_for(File.basename(File.expand_path("..", __dir__)))
  rescue LoadError
    4000
  end
}

# You can adjust the number of workers (separate processes) and threads
# (per process) based on your production system
#
if ENV["BRIDGETOWN_ENV"] == "production"
  workers ENV.fetch("BRIDGETOWN_CONCURRENCY") { 4 }
end

max_threads_count = ENV.fetch("BRIDGETOWN_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("BRIDGETOWN_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

pidfile ENV["PIDFILE"] || "tmp/pids/server.pid"

# Preload the application for maximum performance
#
preload_app!

# Use the Bridgetown logger format
#
require "bridgetown-core/rack/logger"
log_formatter do |msg|
  Bridgetown::Rack::Logger.message_with_prefix msg
end
