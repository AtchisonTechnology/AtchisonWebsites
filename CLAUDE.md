# CLAUDE.md

Guidance for Claude Code when working in the **AtchisonWebsites** monorepo.

## What this repo is

Seven independent [Bridgetown](https://www.bridgetownrb.com) static sites, each
deployed separately to Netlify, sharing one repo, one dev workflow, and one
development process:

| Directory | Site | Live URL |
|---|---|---|
| `LeeAtchison` | Lee Atchison personal site | leeatchison.com |
| `TheSoftwareConductor` | The Software Conductor | thesoftwareconductor.com |
| `stosa` | STOSA framework | stosa.org |
| `BusinessBreakthrough30` | Business Breakthrough 30 | businessbreakthrough30.com |
| `ArchitectingForScale` | Architecting for Scale (book site) | architectingforscale.com |
| `AtchisonAcademy` | Atchison Academy | atchisonacademy.com |
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
existing builder — no change to existing content. A site whose content is
not marketing metadata need not join at all: `AtchisonAcademyCourses`
(Spec0021) never did, and that site was removed from the repo on 2026-09-20.
`SoftwareArchitectureInsights` is likewise standalone.

## Commands (repo root)

```bash
make            # list targets
make dev        # foreman: run all seven sites at once, each on its own port
make clean      # remove stray .DS_Store files
```

To run a single site: `<Site>/bin/dev` (starts it on that site's port; see
`Projects/services.md`). Per-site build/deploy commands live in each site's own CLAUDE.md.

## Development Process

This project follows the `linear-dev-process` skill (Linear issue tracking,
the spec in the Linear issue, PR flow). Project parameters:

- **Linear team:** Atchison Websites (`WEB`).
- **Sites:** see `Projects/services.md`. A spec's **Systems Impacted** field
  names the specific site(s) it touches, using the directory names above.
- **Worktrees:** not used. All work happens in the main checkout.
- **Credentials keys:** none. These are static sites with no encrypted
  credentials.
- **Synchronized doc artifacts in-scope for specs:** none.
- **Process overrides:** none.

### How work is tracked

Every issue lives in Linear, team **Atchison Websites (WEB)**.

- **The spec is the Linear issue's description.** Don't create spec files.
- **Status lives only in Linear.** Never record status in the repo.
- `Projects/` holds `services.md`: the site registry and dev ports.
- The old spec files (`Projects/WEB-<n>.md`) and the pre-Linear `Spec####`/`Bug####`
  archive were deleted on 2026-10-30. Every WEB spec is in its issue. A
  `Spec####` or `Bug####` reference points at the archive, which is in git
  history:
  https://github.com/AtchisonTechnology/AtchisonWebsites/tree/c55040f22a06b89d5ab2c299c7ebffe2dc3ed6f9/Projects/zArchive
- Building happens on the issue's branch (`gitBranchName`), only after Lee
  says "ok to implement." Lee merges every pull request.

To see the status of everything, query the Linear team, not the files.

Reminders that matter most here: never change an issue's status without
being asked; never commit, push, or open a PR without explicit permission.
The one exception, a developer agent after Lee's "ok to implement," is in
the skill.

## File deletion permission

Claude's shell on this machine cannot delete files until Lee approves a
per-session delete-permission request. It is OK to ask Lee for that
permission whenever a task needs it — but only when he is at the computer
and paying attention. Never fire the permission prompt from an unattended,
scheduled, or headless run; for a long-running task that might need
deletion later, ask for the permission up front, before Lee steps away.
If permission isn't available, fall back to `mv` into `_to_delete/`.
