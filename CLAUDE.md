# CLAUDE.md

Guidance for Claude Code when working in the **AtchisonWebsites** monorepo.

## What this repo is

Eight independent [Bridgetown](https://www.bridgetownrb.com) static sites, each
deployed separately to Netlify, sharing one repo, one dev workflow, and one
Spec/Bug process:

| Directory | Site | Live URL |
|---|---|---|
| `LeeAtchison` | Lee Atchison personal site | leeatchison.com |
| `TheSoftwareConductor` | The Software Conductor | thesoftwareconductor.com |
| `stosa` | STOSA framework | stosa.org |
| `BusinessBreakthrough30` | Business Breakthrough 30 | businessbreakthrough30.com |
| `ArchitectingForScale` | Architecting for Scale (book site) | architectingforscale.com |
| `AtchisonAcademy` | Atchison Academy | atchisonacademy.com |
| `AtchisonAcademyCourses` | Atchison Academy Courses (unlisted course content; does not join `shared/`) | courses.atchisonacademy.com |
| `SoftwareArchitectureInsights` | Software Architecture Insights (weekly newsletter site; email stays on Kit; does not join `shared/`) | softwarearchitectureinsights.com |

Each site has its own `CLAUDE.md` with its architecture, layouts, CSS tokens,
and content conventions. **Read the site's own CLAUDE.md before changing
anything inside it.** This file covers only the repo-wide process.

There are no Rails apps, no databases, and no separate Vite dev server here —
esbuild runs inside `bridgetown start`.

## `shared/` — content two sites read

```
shared/
├── _books/         # 10 book resources
├── _courses/       # 18 course resources
└── images/
    ├── books/      # Book cover images, one copy for both sites
    └── courses/    # Course card images (empty until Spec0020)
```

These are the canonical Bridgetown collection files for books and courses.
`LeeAtchison` and `AtchisonAcademy` reach them through **symlinks** — their
`src/_books` and `src/_courses` each point at `../../shared/…` — so there is
one copy of every book and course, not two (Spec0008). Git stores the
symlinks (mode 120000) and Netlify checks them out with the rest of the repo,
so dev and deploy both see real files; both sites' dev watchers follow them,
so one edit live-rebuilds both.

The card art those files point at is shared the same way (Spec0019).
`cover_image` is a site-relative `/images/books/<slug>.<ext>` path, so each
site's `src/images/books` and `src/images/courses` are also **symlinks** —
`../../../shared/images/books` and `../../../shared/images/courses`, one
directory deeper than the collection symlinks above, so three `../` instead
of two. Same rule applies: edit the files under `shared/images/`, never
replace a symlink with a real directory. Both sites publish all four book
covers today, including the two only leeatchison.com links to — accepted in
Spec0019 as unreferenced-but-harmless CDN files rather than building a
per-site filter for ~190KB.

Front matter, not directory placement, decides what each site shows: a
`show_`/`feature_`/`order_` key per site (`show_leeatchison`, `show_academy`,
and so on), with a `plugins/builders/shared_content.rb` in each site dropping
the items it does not carry at read time. Each site's `CLAUDE.md` documents
the full key set. **Edit these files under `shared/`, and remember an edit
lands on both sites.** Never replace a symlink with a real directory — that
silently re-creates the duplication this replaced.

Ten items are shown on both sites, so each carries one more key —
`canonical_site` (Spec0009), naming the site whose page is the SEO original,
in the same site-suffix vocabulary. The same builder resolves it: on the site
that does *not* own the page it emits a cross-domain `<link rel="canonical">`
at the other domain and drops the page from that site's sitemap, while
`og:url` stays self-referential everywhere. The key is set on every book and course,
not just the overlapping ten, and both builders enforce two rules that fail
the build — an item on more than one site with no `canonical_site`, and a
`canonical_site` naming a site the item is not shown on. That is what stops a
new item, or a flipped `show_` flag, from silently re-creating duplicate
pages. Each builder holds a duplicated `SITES` registry of site key → `show_`
flag and production URL; **the two copies must be kept in sync by hand.**

No other site defines these collections. A new site joins by adding its own
three keys, its two symlinks and its builder, plus one `SITES` entry in each
existing builder — no change to existing content. `AtchisonAcademyCourses`
(Spec0021) deliberately does **not** join: its `courses`/`lessons`
collections are unlisted purchaser-only content, not marketing metadata, so
it carries no symlinks into `shared/`, no `shared_content.rb`, and no entry
in either existing builder's `SITES` registry. Its own validation builder
does a read-only filename check against `shared/_courses` (to confirm a
derived purchase-page link won't 404) — that is the only thing it reads from
`shared/`.

## Commands (repo root)

```bash
make            # list targets
make dev        # foreman: run all seven sites at once, on derived ports
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

- **Sites/services:** eight, indices 0–7 — see `Projects/services.md`. Indices
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
| 5 | `AtchisonAcademy` | 16000 | 16000 + N | 17000 + N |
| 6 | `AtchisonAcademyCourses` | 18000 | 18000 + N | 19000 + N |
| 7 | `SoftwareArchitectureInsights` | 20000 | 20000 + N | 21000 + N |

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
| `_Projects.md` | Ideas not yet turned into a Spec/Bug |
| `services.md` | Site registry + port table |
| `In Development/` | Active Spec/Bug files — each file's Status field is the source of truth |
| `zArchive/` | Closed and Cancelled files |

Spec/Bug files are created from the skill's bundled templates (not copied into
this repo). A Spec/Bug's **Systems Impacted** field must name the specific
site(s) it touches, using the directory names above — that is what determines
which sites a worktree needs booted and rebuilt.

There is no central tracker file: each Spec/Bug file's own **Status** field is
the sole source of truth for its state (the old `_Project Tracker.md` was
retired 2026-09-01 because every branch touched it, causing constant merge
conflicts). To see the status of everything, grep `Status:` across
`Projects/In Development/`.

Reminders that matter most here: never change a Spec/Bug's workflow status
without being asked; never commit, push, or open a PR without explicit
permission.

## File deletion permission

Claude's shell on this machine cannot delete files until Lee approves a
per-session delete-permission request. It is OK to ask Lee for that
permission whenever a task needs it — but only when he is at the computer
and paying attention. Never fire the permission prompt from an unattended,
scheduled, or headless run; for a long-running task that might need
deletion later, ask for the permission up front, before Lee steps away.
If permission isn't available, fall back to `mv` into `_to_delete/`.
