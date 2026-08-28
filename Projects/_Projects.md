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

<!--
### Item title
- **Type:** Spec | Bug
- **Description:** What needs to be created.
- **Notes:** Any additional context.
-->
