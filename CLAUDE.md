# CLAUDE.md

Guidance for Claude Code when working in the **AtchisonWebsites** monorepo.

## What this repo is

Five independent [Bridgetown](https://www.bridgetownrb.com) static sites, each
deployed separately to Netlify, sharing one repo, one dev workflow, and one
Spec/Bug process:

| Directory | Site | Live URL |
|---|---|---|
| `LeeAtchison` | Lee Atchison personal site | leeatchison.com |
| `TheSoftwareConductor` | The Software Conductor | thesoftwareconductor.com |
| `stosa` | STOSA framework | stosa.org |
| `BusinessBreakthrough30` | Business Breakthrough 30 | businessbreakthrough30.com |
| `ArchitectingForScale` | Architecting for Scale (book site) | architectingforscale.com |

Each site has its own `CLAUDE.md` with its architecture, layouts, CSS tokens,
and content conventions. **Read the site's own CLAUDE.md before changing
anything inside it.** This file covers only the repo-wide process.

There are no Rails apps, no databases, and no separate Vite dev server here —
esbuild runs inside `bridgetown start`.

## Commands (repo root)

```bash
make            # list targets
make dev        # foreman: run all five sites at once, on derived ports
make ports      # show the dev ports this checkout will use
make test       # unit-test the port derivation
make clean      # remove stray .DS_Store files

bin/site-port stosa        # one site's port in this checkout
bin/site-port --all        # all of them
bin/site-port --worktree   # "main", or the worktree name
```

To run a single site: `<Site>/bin/dev` (derives its port and starts
Bridgetown). Per-site build/deploy commands live in each site's own CLAUDE.md.

## Development Process

This project follows the `spec-bug-process` skill (Spec/Bug tracking,
worktrees, resource isolation). Project parameters:

- **Sites/services:** five, indices 0–4 — see `Projects/services.md`. Indices
  are permanent; a new site takes the next unused index.
- **Worktrees:** `.claude/worktrees/`, named exactly `spec####` / `bug####`
  (gitignored).
- **Credentials keys:** none. These are static sites with no encrypted
  credentials, so a fresh worktree has nothing secret to copy in. See
  `.worktreeinclude` (intentionally empty) — but a fresh worktree does need
  `bundle install` and `npm install` per site.
- **Synchronized doc artifacts in-scope for specs:** none.
- **Process overrides:**
  - **No database isolation** — there are no databases. Only ports are
    derived. Everything in the skill's `resource-isolation.md` about
    `database.yml`, `db:prepare`, and the `psql` cleanup rule is inert here,
    and worktree cleanup accordingly covers only the worktree, its branch,
    and any running servers.
  - **No Vite band** — the 5173/6173 frontend band is unused; each site
    serves its own assets.
  - **Worktree name is the repo-root basename**, since sites are
    subdirectories of the repo (`lib/worktree_env.rb` handles this; the
    equivalent trap in a Rails layout is `Rails.root.parent.basename`).

### Port derivation

`lib/worktree_env.rb` is the single source of truth; every consumer re-derives
independently at startup, so nothing is generated, recorded, or passed around.
Consumers: `bin/site-port`, each `<Site>/bin/dev`, each
`<Site>/config/puma.rb` (fallback when `BRIDGETOWN_PORT` is unset).

Following the skill's scheme exactly, with `N` = the worktree's numeric ID:

| Index | Site | main | `spec####` | `bug####` |
|---|---|---|---|---|
| 0 | `LeeAtchison` | 3000 | 3000 + N | 4000 + N |
| 1 | `TheSoftwareConductor` | 8000 | 8000 + N | 9000 + N |
| 2 | `stosa` | 10000 | 10000 + N | 11000 + N |
| 3 | `BusinessBreakthrough30` | 12000 | 12000 + N | 13000 + N |
| 4 | `ArchitectingForScale` | 14000 | 14000 + N | 15000 + N |

IDs start at `0001`, so main (N = 0) never collides. IDs above `999` overflow
into the next block — which shows up immediately as a port-bind failure, not
as silent cross-talk. `make test` proves every combination up to 999 is unique.

**Note:** the ports for `TheSoftwareConductor`, `stosa`, and
`BusinessBreakthrough30` changed from the old flat 3010/3020/3030 when this
scheme was adopted, so that spec worktree ports could never collide with a
site running on main.

### Tracking

Everything tracked lives in `Projects/`:

| File | Purpose |
|---|---|
| `_Project Tracker.md` | Status of every Spec/Bug — the source of truth |
| `_Projects.md` | Ideas not yet turned into a Spec/Bug |
| `services.md` | Site registry + port table |
| `In Development/` | Active Spec/Bug files |
| `zArchive/` | Closed and Cancelled files |

Spec/Bug files are created from the skill's bundled templates (not copied into
this repo). A Spec/Bug's **Systems Impacted** field must name the specific
site(s) it touches, using the directory names above — that is what determines
which sites a worktree needs booted and rebuilt.

Reminders that matter most here: never change a Spec/Bug's workflow status
without being asked; never commit, push, or open a PR without explicit
permission; keep the tracker in sync with every Spec/Bug change automatically.
