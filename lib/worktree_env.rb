# frozen_string_literal: true

# Single source of truth for per-worktree dev-resource derivation in the
# AtchisonWebsites monorepo (spec-bug-process skill).
#
# This repo is a monorepo of Bridgetown STATIC SITES, not Rails services:
# there are no databases, so only PORTS are derived. There is also no separate
# Vite dev server (esbuild runs inside `bridgetown start`), so the skill's
# 5173/6173 Vite band is unused here.
#
# Worktree checkouts live at .claude/worktrees/spec####/ or
# .claude/worktrees/bug####/. The worktree name is the basename of the REPO
# ROOT -- one level above each site directory. Every consumer re-derives
# independently at startup; nothing is generated, recorded, or passed around.
#
# Port scheme (skill's resource-isolation reference, followed exactly):
#
#   service 0        spec: 3000 + N               bug: 4000 + N
#   service s (1-9)  spec: 8000 + (s-1)*2000 + N  bug: spec_base + 1000 + N
#
# where N is the numeric part of the worktree name (spec0012 -> 12).
# `main` is N = 0. Spec/Bug IDs start at 0001, so main never collides.
#
# Service indices are PERMANENT -- see Projects/services.md.
module WorktreeEnv
  NAME_PATTERN = /\A(spec|bug)(\d+)\z/.freeze

  SERVICES = {
    "LeeAtchison" => 0,
    "TheSoftwareConductor" => 1,
    "stosa" => 2,
    "BusinessBreakthrough30" => 3,
  }.freeze

  MAX_SERVICES = 10

  REPO_ROOT = File.expand_path("..", __dir__)

  Info = Struct.new(:kind, :id, :name, keyword_init: true) do
    def main?
      kind == :main
    end

    def to_s
      main? ? "main" : name
    end
  end

  class << self
    # Basename of the repo root == the worktree directory name (or the plain
    # checkout name on main, which does not match NAME_PATTERN and so yields
    # main's defaults).
    def worktree_name(root = REPO_ROOT)
      File.basename(File.expand_path(root))
    end

    # Derives worktree info from an arbitrary directory name. Exposed
    # separately so the math can be unit-tested without touching the
    # filesystem.
    def for_worktree(name)
      match = NAME_PATTERN.match(name.to_s)
      return Info.new(kind: :main, id: 0, name: name.to_s) unless match

      Info.new(kind: match[1].to_sym, id: match[2].to_i, name: name.to_s)
    end

    def current(root = REPO_ROOT)
      for_worktree(worktree_name(root))
    end

    # Canonical directory name for a site, matched case-insensitively so
    # `stosa`, `Stosa`, and `STOSA` all resolve.
    def canonical_service(service)
      key = service.to_s
      SERVICES.keys.find { |s| s.casecmp(key).zero? } ||
        raise(KeyError, "Unknown site #{service.inspect}. Known sites: #{SERVICES.keys.join(', ')}. " \
                        "Add it to lib/worktree_env.rb and Projects/services.md with the next unused index.")
    end

    def index_for(service)
      SERVICES.fetch(canonical_service(service))
    end

    def port_base(service_index, kind)
      unless (0...MAX_SERVICES).cover?(service_index)
        raise ArgumentError, "Service index #{service_index} out of range (0-#{MAX_SERVICES - 1})"
      end

      if service_index.zero?
        kind == :bug ? 4000 : 3000
      else
        spec_base = 8000 + (service_index - 1) * 2000
        kind == :bug ? spec_base + 1000 : spec_base
      end
    end

    # The dev port for a site in the given worktree (defaults to this checkout).
    def port_for(service, name = worktree_name)
      info = for_worktree(name)
      port_base(index_for(service), info.kind) + info.id
    end

    def ports(name = worktree_name)
      SERVICES.keys.each_with_object({}) { |site, h| h[site] = port_for(site, name) }
    end
  end
end
