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
| 1 | Spec0001 | STOSA site: book CTA, refreshed bio, and Atchison Academy hero | Add an Architecting for Scale CTA band, update the About bio, verify no Soundings references remain, and add an Atchison Academy hero above the footer on stosa.org — [PR #1](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/1) |

---

## In Spec Development/Refinement

*Flesh out the spec/bug details so it can be passed on for implementation. When complete, move to **Implementing**.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| 1 | Spec0002 | Change the atchisonacademy.com alias redirect from permanent to temporary | Switch the two atchisonacademy.com rules in LeeAtchison/netlify.toml from 301 to 302, since the domain will become its own site and a permanent redirect is cached indefinitely by browsers |

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
| — | *(none)* | — | — | — |
