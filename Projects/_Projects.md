# Projects — Future Ideas & New Items

This file tracks work that has not yet been turned into a formal Spec#### or
Bug#### markdown file. Once an idea is defined enough to become a real
specification or bug, create the file in `Projects/In Development/` (from the
spec-bug-process skill's templates), assign it the next sequential ID, and
remove it from this list.

---

## Future Ideas

(Ideas not yet well-defined enough to become a Spec or Bug. No ID assigned.)

<!--
### Idea title
- **Description:** What the idea is.
- **Notes:** Any additional context, open questions, or considerations.
-->

---

## New Items Needing Specs/Bugs

(Items that are clear enough to become a Spec#### or Bug#### but the file
hasn't been created yet.)

### BusinessBreakthrough30 sitemap.xml has no permalink
- **Type:** Bug
- **Description:** `BusinessBreakthrough30/src/sitemap.xml.erb` is missing the
  `permalink: /sitemap.xml` front-matter key that the other four sites have, so
  it builds to `/sitemap.xml/index.html`. The `Sitemap:` line in that site's
  `robots.txt` points at `https://businessbreakthrough30.com/sitemap.xml`,
  which therefore does not resolve.
- **Notes:** Found during Spec0003 and recorded there as out of scope; carried
  here at that spec's archival so it is not lost. Predates Spec0003. The other
  four sites were confirmed to carry the key, so the fix is one line in one
  file.

### Restore the Coursera specialization framing once approved
- **Type:** Spec
- **Description:** `scalable-availability-software-architecture.md` and
  `cloud-architecture-for-scalable-systems.md` currently describe themselves
  as "companion courses, best taken in this order" rather than naming a
  Coursera specialization. Once Coursera approves the *Architecting Scalable
  Systems Like Meta, Google, and Amazon* specialization (or whatever title it
  ships under), restore the specialization framing — with the approved title
  — to both files' `summary:` and About sections.
- **Notes:** Found and deliberately deferred during Spec0013's fact-check
  (§2a/§6): as of that spec, the specialization was in review with Coursera,
  real but unapproved, and naming an unapproved specialization risked being
  wrong twice if Coursera's approved title differs. Carried here at Spec0013's
  archival so it is not lost. This is a one-paragraph change to two files
  once Lee confirms the specialization is live and knows its final title.

### Confirm Deploy Previews are enabled for stosa
- **Type:** Spec
- **Description:** On [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4), Netlify built deploy previews for
  `LeeAtchison`, `TheSoftwareConductor`, `BusinessBreakthrough30`, and
  `ArchitectingForScale` — twelve check runs, three per site — but posted
  nothing at all for `stosa`. Check that site's Branches and deploy contexts
  panel and enable Deploy Previews if they are off.
- **Notes:** Not conclusive. That PR merged about twenty seconds after it
  opened, and ArchitectingForScale's checks only started after the merge, so
  stosa may simply have been slower to report rather than disabled. This is
  the one part of Spec0004's Open Question 1 that its deploy did not settle;
  carried here at that spec's archival. Cheapest confirmation is to look at
  the checks on the next PR that touches `stosa/`.

<!--
### Item title
- **Type:** Spec | Bug
- **Description:** What needs to be created.
- **Notes:** Any additional context.
-->
