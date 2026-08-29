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
| — | — | *(none)* | — |

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
| Spec0004 | Configure Netlify Deploy Previews across all five sites | Make preview builds emit their own hostname in canonical, og:url and the sitemap by reading CONTEXT/DEPLOY_PRIME_URL in each site's config/initializers.rb — [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) | Closed | 2026-08-28 |
| Spec0005 | Create the standalone AtchisonAcademy site | Add a sixth Bridgetown site, AtchisonAcademy (site index 5, port 16000), paralleling LeeAtchison's configuration and structure, with the current leeatchison.com/academy page as its home page and the academy-flagged books and courses as its collections — [PR #6](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/6) | Closed | 2026-08-29 |
| Spec0006 | Retire leeatchison.com/academy and point all Academy links at atchisonacademy.com | Delete `LeeAtchison/src/academy.erb`, 301 `/academy` to `https://atchisonacademy.com/`, repoint the navbar entry and the two `courses.erb` buttons at the new domain, and remove the now-dead alias redirects — repo work only; the domain move is already done — [PR #7](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/7) | Closed | 2026-08-29 |
