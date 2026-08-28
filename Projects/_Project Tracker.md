# Project Tracker

Human-readable view of every Spec/Bug in the system — the single source of
truth for workflow status. Sections are ordered for quick human scanning
(most actionable work first); within a section, rows are sorted by
**Priority** (1 = highest) — except Archived, which has no Priority column
since ordering doesn't matter there.

Priority numbers may be hand-edited in any table that has one. When that
happens, re-sort that table by the new numbers and renormalize to
consecutive integers starting at 1.

---

## Implementing

*Ready to be passed on to implementation.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| 1 | Spec0004 | Configure Netlify Deploy Previews across all five sites | Make preview builds emit their own hostname in canonical, og:url and the sitemap by reading CONTEXT/DEPLOY_PRIME_URL in each site's config/initializers.rb, so Spec0003's outstanding preview verification can actually be run |

---

## Verifying

*Review the code in the worktree/branch, test locally, then create and review the PR.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## In Spec Development/Refinement

*Flesh out the spec/bug details so it can be passed on for implementation. When complete, move to **Implementing**.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## Next in Line (For Spec Development)

*Ready to be worked on. Move to **In Spec Development/Refinement** to begin fleshing out the spec's details.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## Hold/Deferred

*Not currently being worked on, deliberately.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## Archived (Closed and Cancelled)

*Completed (Closed) or abandoned (Cancelled) items. Files live in `zArchive/`.*

| ID | Title | Short Description | Status | Date Completed |
|---|---|---|---|---|
| Spec0001 | STOSA site: book CTA, refreshed bio, and Atchison Academy hero | Add an Architecting for Scale CTA band, update the About bio, verify no Soundings references remain, and add an Atchison Academy hero above the footer on stosa.org — [PR #1](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/1) | Closed | 2026-08-28 |
| Spec0002 | Change the atchisonacademy.com alias redirect from permanent to temporary | Switch the two atchisonacademy.com rules in LeeAtchison/netlify.toml from 301 to 302, since the domain will become its own site and a permanent redirect is cached indefinitely by browsers — [PR #2](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/2) | Closed | 2026-08-28 |
| Spec0003 | Standardize head metadata across all five sites | Add canonical and per-page Open Graph tags to all five head partials, fix the stosa og:image 404, add the missing OG set to leeatchison.com, and replace portrait social images — [PR #2](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/2) | Closed | 2026-08-28 |
