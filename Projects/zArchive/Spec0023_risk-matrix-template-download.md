# Risk Matrix Template download on architectingforscale.com

* **ID:** Spec0023
* **Status:** Closed
* **Date Created:** 2026-09-02
* **Date Implemented:** 2026-09-02
* **Systems Impacted:** ArchitectingForScale, LeeAtchison (link only, plus `shared/_books`)

---

## Problem/Requirement

The book *Architecting for Scale* references a free downloadable Risk Matrix
Template in its "The Risk Matrix" chapter. Two places on the web properties
already promise that download, and neither one delivers it:

1. **architectingforscale.com home page** — the "What's Inside" benefits list
   in `ArchitectingForScale/src/index.erb` reads "How to identify, measure, and
   reduce risk in distributed systems, **with a free downloadable Risk Matrix
   Template**". The phrase is plain text. There is no link anywhere on the
   site, and no way for a visitor to get the file.

2. **leeatchison.com book page** — `shared/_books/architecting-for-scale.md`
   carries a "Free Resource" section linking to `/Risk%20Matrix%20Template.xlsx`.
   That link renders live at
   `https://leeatchison.com/books/architecting-for-scale/` and **returns 404**.
   The `.xlsx` file does not exist anywhere in this repo (verified: no `.xlsx`
   file is tracked in the monorepo), so the link has been broken since the
   site moved to Bridgetown.

The requirement is to host the spreadsheet on architectingforscale.com, surface
it prominently on that site's home page, and repair the leeatchison.com
reference so it points at the one real copy.

**Why architectingforscale.com owns the file:** the template is a companion
artifact to the book, and the book site is the canonical destination for
book-related material. Hosting it once there, rather than in `shared/`, avoids
adding a binary-asset symlink pattern to `shared/` for a single file that only
one site genuinely needs to serve.

---

## Solution/Fix/Change

### 1. Add the spreadsheet to the ArchitectingForScale site

Commit the `.xlsx` into the AFS site only:

```
ArchitectingForScale/src/downloads/risk-matrix-template.xlsx
```

Served at `https://architectingforscale.com/downloads/risk-matrix-template.xlsx`.

Filename is normalized to lowercase-dash-separated, matching the repo's
convention for shared content and eliminating the `%20` escaping the old path
required. Bridgetown copies unrecognized static files under `src/` through to
`output/` unchanged, so no config change is needed; `build.processing.html`
`pretty_urls` applies only to HTML and does not affect this path.

The existing AFS `netlify.toml` long-cache header rule matches only
`png|jpg|js|css|svg|woff|ttf|eot|ico|woff2`, so the `.xlsx` falls under the
global `Cache-Control: public, max-age=604800` rule. Seven days is acceptable
for a file that changes rarely; no header change is proposed.

**Source file:** Lee supplied the file directly (2026-09-02). It is a single
sheet, `Sheet1`, with a 13-column header row (Risk ID, System, Owner,
Description, Date Identified, Likelihood, Severity, Mitigation Plan, Status,
ETA, Monitoring, Triggered Plan, Comments) plus one worked example row. 11 KB.
The implementation writes it to the path above under the normalized filename;
it does not need to transit `assets_inbox/`.

### 2. Add a "Free Resource" callout band to the AFS home page

Insert a new section into `ArchitectingForScale/src/index.erb`. Proposed
placement: **between the "What's Inside" section (`id="the-book"`) and the
Endorsements section (`id="endorsements"`)**, so the callout sits immediately
after the bullet that promises it, while the reader is still in "what do I get"
mode and well before the Buy section.

Proposed structure, following the existing section conventions in this file
(a wrapper `<section>` with an `id`, an inner container, `btn`/`btn-primary`
classes for the CTA):

```erb
<!-- Free Resource -->
<section id="risk-matrix" class="section">
  <div class="section-inner">
    <h2>Free download: the Risk Matrix Template</h2>
    <p>The Risk Matrix is the tool at the center of the book's risk
       management chapters. This is the working spreadsheet, ready to fill in
       with your own systems. No signup required.</p>
    <a href="<%= relative_url '/downloads/risk-matrix-template.xlsx' %>"
       class="btn btn-primary">Download the Risk Matrix Template (.xlsx)</a>
  </div>
</section>
```

Notes on the markup:

- Uses `relative_url`, consistent with every other internal asset reference in
  `index.erb`.
- No `target="_blank"`: this is a file download, not a navigation away from the
  site, and the browser handles it in place.
- The section alternates background correctly only if the surrounding
  `section`/`section alt` rhythm is preserved. "What's Inside" is `section`
  (white) and Endorsements is `section alt` (grey). Inserting a plain `section`
  between them puts two white bands back to back. The implementation should
  either make the new band `section alt` and flip Endorsements to `section`, or
  give the callout its own distinct treatment. **Open question below.**
- Copy follows the site's content rules: no em-dashes.

### 3. Link the existing "What's Inside" bullet

In the same file, turn the existing plain-text promise into an in-page link to
the new callout, so the bullet resolves somewhere:

```erb
<li>How to identify, measure, and reduce risk in distributed systems, with a
    <a href="#risk-matrix">free downloadable Risk Matrix Template</a></li>
```

### 4. Repair the leeatchison.com reference

In `shared/_books/architecting-for-scale.md`, replace the broken site-relative
path with an absolute cross-domain link to the AFS copy:

```markdown
## Free Resource

Download a free [Risk Matrix Template](https://architectingforscale.com/downloads/risk-matrix-template.xlsx)
as discussed in "The Risk Matrix" chapter of the book.
```

This is a `shared/` edit. The book is shown only on leeatchison.com
(`show_leeatchison: true`, no `show_academy` key), so only that site's rendering
changes, but the edit still lands under `shared/` and LeeAtchison's Netlify
`ignore` pathspec already covers `':(top)shared'` (Bug0002), so the site will
rebuild.

### 5. No redirect for the old path

Considered and rejected. A 301 from `/Risk Matrix Template.xlsx` to the new AFS
URL would normally be the careful thing to do, but there is nothing to preserve:
that path never served a file. It has returned 404 for the entire life of the
Bridgetown site, so no bookmark, inbound link, or search result can be pointing
at a working version of it. The reference in `shared/_books/` was the only thing
producing that URL, and step 4 changes it at the source.

Adding the redirect would leave a permanent rule in `netlify.toml` maintaining
compatibility with a URL that never worked.

### Explicitly out of scope

- **No email gating.** The download is ungated. The book text and the book page
  both describe it as a free companion resource, not a lead magnet, and gating
  it would contradict copy already in print.
- **No `shared/` hosting or symlinks.** One copy, on one site.
- **No AtchisonAcademy change.** The book is not shown there.
- **No Netlify redirect.** See section 5 above.

---

## Testing

1. **Local build, AFS.** Run `ArchitectingForScale/bin/dev`, load the home page,
   confirm the new callout section renders with correct background alternation
   against its neighbors, and confirm the "What's Inside" bullet link jumps to
   it.
2. **Download works locally.** Click the download button; confirm the browser
   downloads a valid `.xlsx` that opens in Excel and Numbers without a repair
   prompt (a corrupted binary committed through a text-mode path is the failure
   mode to rule out).
3. **Build output.** Run `bin/bridgetown build` in the AFS site and confirm
   `output/downloads/risk-matrix-template.xlsx` exists and is byte-identical to
   the source (`cmp` the two). Confirms Bridgetown passes the binary through
   untouched.
4. **Local build, LeeAtchison.** Run `LeeAtchison/bin/dev`, load
   `/books/architecting-for-scale/`, confirm the Free Resource link now points
   at the absolute architectingforscale.com URL.
5. **Responsive.** Check the callout at the 680px breakpoint; confirm the button
   does not overflow and the copy reflows to one column.
6. **Deploy preview.** Confirm both sites build in their deploy previews and the
   AFS preview serves the file (previews use the preview domain, so the
   cross-domain link from the LeeAtchison preview will point at production AFS,
   which is expected).
7. **Post-deploy.** Verify `https://architectingforscale.com/downloads/risk-matrix-template.xlsx`
   returns 200 with a spreadsheet content type, and that the Free Resource link
   on `https://leeatchison.com/books/architecting-for-scale/` reaches it.

---

## Summary of Steps Needed

1. Write the supplied spreadsheet to
   `ArchitectingForScale/src/downloads/risk-matrix-template.xlsx`.
2. Add the "Free Resource" callout section to `ArchitectingForScale/src/index.erb`,
   resolving the section-alternation question.
3. Link the existing "What's Inside" bullet to `#risk-matrix`.
4. Update the Free Resource link in `shared/_books/architecting-for-scale.md`
   to the absolute AFS URL.
5. Run the testing steps above on both sites.
6. Netlify/DNS: nothing required. No new domain, no new site, no environment
   variable. (Lee handles any Netlify-side work by hand; this spec's changes are
   all in-repo.)

---

## Open Questions

1. **Section background alternation.** Inserting the callout between "What's
   Inside" (`section`, white) and Endorsements (`section alt`, grey) breaks the
   alternating rhythm. Options: (a) make the callout `section alt` and flip
   Endorsements to `section`, cascading a flip through the rest of the page;
   (b) make the callout a visually distinct band in its own right, similar to
   the existing `newsletter-callout` treatment, so it deliberately interrupts
   the rhythm rather than participating in it. **Proposed: (b)** — a free
   download deserves to stand out, and it avoids touching every section class
   below it. Not yet decided.

2. **Callout copy.** The heading and body text above are a first draft. Lee may
   want different wording, particularly whether to name the chapter explicitly.

3. **Does the spreadsheet itself need updating?** Inspected 2026-09-02. The
   column structure matches the matrix described in the book and needs no
   change. The one worked example row, however, carries dates of 2015-10-13
   and 2016-05-26, which will read as stale to anyone who opens it. Options:
   (a) ship as is; (b) refresh the two dates to something recent; (c) drop the
   example row entirely and ship a clean header-only template. **Proposed:
   (b)** — the example row is genuinely useful for showing how to fill each
   column, and only the dates give away its age. **Decided 2026-09-02:** (b).
   Date Identified moved 2015-10-13 to 2026-06-15 and ETA 2016-05-26 to
   2026-10-15, edited directly in the sheet XML so no other cell, style, or the
   table definition changed. The refreshed file is what gets committed.

4. **Example row wording.** ~~The mitigation cell reads "Cache the date for a
   period of time. We can use the cached copy of the we can't get it
   directly."~~ **Decided 2026-09-02:** fixed. The cell now reads "Cache the
   data for a period of time. We can use the cached copy if we can't get it
   directly." Edited in `sharedStrings.xml`; no other string changed.

5. ~~**Redirect `from` escaping.**~~ Moot: no redirect is being added
   (Solution section 5).

---

## History of Updates

**2026-09-02** — Spec created. Lee asked for a link to the Risk Matrix
spreadsheet on the architectingforscale.com home page. Research found the file
is not in the repo at all, and that an existing link to it on the
leeatchison.com book page (from `shared/_books/architecting-for-scale.md`) has
been returning 404 in production. Scope therefore widened from "add a link" to
"host the file, link it on AFS, repair the leeatchison.com reference."

**2026-09-02** — Lee decided the spreadsheet lives only in the
ArchitectingForScale site, and that leeatchison.com links to it cross-domain
rather than hosting its own copy. A `shared/`-plus-symlinks option was
considered and rejected as overhead for a single file that one site serves.

**2026-09-02** — Lee decided the home page treatment is a dedicated callout
band plus linking the existing "What's Inside" bullet, and that the download is
ungated (no Kit email capture).

**2026-09-02** — Lee supplied the spreadsheet. Inspected: 13-column header plus
one worked example row, structure matches the book. Only issue found is the
example row's 2015/2016 dates (see Open Question 3). The file has not yet been
written into the repo; that happens at implementation.

**2026-09-02** — Open Question 3 resolved: the example row stays, with its two
dates refreshed to 2026-06-15 and 2026-10-15. Edited in the sheet XML directly
rather than through a library rewrite, so formatting, column widths, the frozen
header pane, and the table definition are unchanged. Reviewing the row also
surfaced two likely typos in the mitigation text, raised as Open Question 4.

**2026-09-02** — Open Question 4 resolved: the two typos in the example row's
mitigation text are corrected ("date" to "data", and the dropped word in the
second sentence). Lee approved the wording. The prepared file now carries both
the date refresh and this fix, and is the exact artifact to commit at
implementation.

**2026-09-02** — Status moved to Implementing at Lee's direction, implemented
directly on `main` (no worktree). All six repo changes are in place:

1. `ArchitectingForScale/src/downloads/risk-matrix-template.xlsx` added.
2. New `resource-callout` section in `ArchitectingForScale/src/index.erb`,
   placed between "What's Inside" and Endorsements.
3. `.resource-callout` styles added to `frontend/styles/index.css`.
4. The "What's Inside" bullet now links to `#risk-matrix`.
5. `shared/_books/architecting-for-scale.md` repointed at the absolute AFS URL.
6. 301 redirect for the old path added to `LeeAtchison/netlify.toml`.

Open Question 1 resolved as proposed, option (b): the callout is its own band
(accent tint, ruled top and bottom, centered) rather than a `section`/`section
alt` participant, so no cascading class flip was needed and the download reads
as an offer rather than as more body copy. It is visually distinct from the
dark `newsletter-callout` further down the page.

**Verification performed:** ERB compiles (`RubyVM::InstructionSequence.compile`
on the rendered template source), CSS braces balance, the appended TOML parses
and yields the expected redirect, the committed `.xlsx` opens and carries both
the refreshed dates and the corrected mitigation text, and the only remaining
reference to the old `Risk Matrix Template.xlsx` path in the repo is the
redirect source itself.

**Not yet verified — needs Lee:** a real Bridgetown build and visual check. The
sandboxed shell has Ruby 3.0 and no installed gems, so `bin/bridgetown build`
fails there with `Could not find bridgetown-2.1.2`. Testing steps 1 through 6
still need to be run on Lee's machine. Nothing is committed or pushed.

**2026-09-02** — Lee decided against the 301 redirect on leeatchison.com; the
book page reference is simply repointed at the ArchitectingForScale URL instead.
Rationale: the old path never served a file, so a redirect would preserve
nothing and would leave a permanent `netlify.toml` rule supporting a URL that
was only ever broken. The redirect block has been removed;
`LeeAtchison/netlify.toml` is back to matching HEAD, so LeeAtchison's only
change in this spec is the `shared/_books/` edit. Open Question 5 is moot.

**2026-09-02** — Closed and archived. Lee confirmed the implementation and is
taking the changes through commit and push himself. Final scope as shipped:
the spreadsheet added at `ArchitectingForScale/src/downloads/risk-matrix-template.xlsx`
(with refreshed example dates and the corrected mitigation wording), the
`resource-callout` band and its styles on the AFS home page, the "What's
Inside" bullet linked to it, and `shared/_books/architecting-for-scale.md`
repointed at the absolute AFS URL. No redirect and no `netlify.toml` change on
any site.

One clarification recorded for the future: the repointed book link renders only
on leeatchison.com. The book carries `show_leeatchison: true` and no
`show_academy` key, so AtchisonAcademy's `shared_content.rb` drops it at read
time and never generates a page for it. The Academy does still rebuild on this
change, because its Netlify `ignore` pathspec covers `':(top)shared'`, but its
output is unchanged. Putting the book on the Academy would be a separate spec
(adding `show_academy`/`order_academy`/`feature_academy` plus a
`canonical_site` decision, which the builder enforces).
