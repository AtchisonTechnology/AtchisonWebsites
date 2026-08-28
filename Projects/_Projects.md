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

### Cut atchisonacademy.com over to the standalone AtchisonAcademy site
- **Type:** Spec
- **Description:** Spec0005 created the `AtchisonAcademy/` site in the repo but
  deliberately stopped at the repo boundary. The cutover is everything at the
  Netlify and DNS layer, plus the one decision it defers: create the Netlify
  site pointed at `AtchisonAcademy/` and configure its build settings; move
  `atchisonacademy.com` (and `www.`) off the leeatchison.com site, where it is
  currently an alias domain, and onto the new site; **delete** — not change —
  the two 302 `atchisonacademy.com` redirect rules in
  `LeeAtchison/netlify.toml`, which the comment block above them says are to be
  removed once the standalone site exists; and decide what happens to
  `leeatchison.com/academy`.
- **Notes:** Carried from Spec0005's Open Question 4, deliberately deferred by
  Lee on 2026-08-28 rather than forgotten. The realistic options for
  `leeatchison.com/academy` are: keep it as a promotional page linking out to
  the Academy; 301 it to `atchisonacademy.com`; or delete it. Whichever is
  chosen, the `/academy` navbar entry in
  `LeeAtchison/src/_components/shared/navbar.rb` and the `/academy` hero button
  and closing CTA in `LeeAtchison/src/courses.erb` all point at it and would
  have to follow. Until this lands, the Academy content lives at two addresses
  and the new site is reachable only at its Netlify subdomain — Spec0005's
  Open Question 3 records why that interim state is safe and short.

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
