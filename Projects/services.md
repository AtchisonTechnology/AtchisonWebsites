# Site Registry

Explicit, stable mapping of sites to service indices for the
spec-bug-process port-derivation scheme. **Indices are permanent:** a retired
site keeps its index forever (marked Retired), and a new site takes the next
unused index — never reuse or renumber, or every other site's dev ports shift
out from under existing muscle memory and references.

This project is a monorepo of **Bridgetown static sites**, not Rails services.
There are no databases, so the skill's database-isolation half does not apply —
only ports are derived. Each site serves its own built HTML directly; there is
no separate Vite frontend, so the 5173/6173 Vite band is unused here.

Port scheme (per the skill's resource-isolation reference, followed exactly):

- Service 0: main `3000`, spec worktrees `3000 + N`, bug worktrees `4000 + N`
- Service s (1–9): main `8000 + (s-1)*2000`,
  spec `8000 + (s-1)*2000 + N`, bug `spec_base + 1000 + N`

where `N` is the numeric part of the worktree name (`spec0012` → 12).
`main` is simply `N = 0`, and IDs start at `0001`, so main never collides.

Maximum 10 sites (indices 0–9). Each block holds IDs up to 999.

| Index | Site (directory) | Live URL | Status | main | spec#### | bug#### |
|---|---|---|---|---|---|---|
| 0 | `LeeAtchison` | leeatchison.com | Active | 3000 | 3000 + N | 4000 + N |
| 1 | `TheSoftwareConductor` | thesoftwareconductor.com | Active | 8000 | 8000 + N | 9000 + N |
| 2 | `stosa` | stosa.org | Active | 10000 | 10000 + N | 11000 + N |
| 3 | `BusinessBreakthrough30` | businessbreakthrough30.com | Active | 12000 | 12000 + N | 13000 + N |
| 4 | `ArchitectingForScale` | architectingforscale.com | Active | 14000 | 14000 + N | 15000 + N |

Derivation lives in `lib/worktree_env.rb` (repo root) and is the single source
of truth. Every consumer re-derives independently at startup:

- `bin/site-port <Site>` — CLI used by `Procfile`, `Makefile`, and humans
- `<Site>/bin/dev` — sets `BRIDGETOWN_PORT` and starts the site
- `<Site>/config/puma.rb` — derives as a fallback when `BRIDGETOWN_PORT` is unset

Run `bin/site-port --all` to print the current checkout's ports for every site.
