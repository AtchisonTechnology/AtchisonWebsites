# Retire leeatchison.com/academy and point all Academy links at atchisonacademy.com

* **ID:** Spec0006
* **Status:** Closed
* **Date Created:** 2026-08-28
* **Date Implemented:** 2026-08-29
* **Systems Impacted:** `LeeAtchison`, plus two documentation-only corrections
  in `AtchisonAcademy` (`README.md`, `CLAUDE.md`) that this change falsifies —
  see History, 2026-08-29. No other site, and no code or content change to
  `AtchisonAcademy`.
* **Pull Request:** [PR #7](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/7)

---

## Problem/Requirement

Spec0005 built `AtchisonAcademy/` — a standalone Bridgetown site whose home
page is the content that currently lives at `leeatchison.com/academy`. It
stopped at the repo boundary by design and changed nothing on `LeeAtchison`.

So the Academy content now exists twice, and leeatchison.com still behaves as
if it is the Academy's home:

* `LeeAtchison/src/academy.erb` renders the full Academy landing page at
  `/academy`.
* The navbar's **Academy** entry points at `/academy`.
* `courses.erb` has two prominent buttons pointing at `/academy` — the hero's
  "Atchison Academy &rarr;" and the closing CTA band's "Explore the Academy
  &rarr;".

Lee's instruction: remove `leeatchison.com/academy`, and send everything on
leeatchison.com that refers to the Academy to `https://atchisonacademy.com`
instead.

### Scope: repo work only

Same boundary Spec0005 used: this spec covers the file changes inside
`LeeAtchison/`. Creating the Netlify site for `AtchisonAcademy/` and moving the
domain were Lee's to do by hand, and he has already done both — see below.

### The domain move is already done

**Confirmed by Lee, 2026-08-28: `atchisonacademy.com` already resolves to the
new standalone site.** The Netlify site exists, the domain has been moved off
leeatchison.com, and there is no prerequisite left to wait on. This spec can be
implemented and merged whenever it is ready.

Two consequences, both of which shape the work below.

**The two alias redirects are now dead code.** `LeeAtchison/netlify.toml` still
carries the forced 302s Spec0002 added, sending `atchisonacademy.com/*` and
`www.atchisonacademy.com/*` to `https://leeatchison.com/academy/`. A rule whose
`from` is a full URL only fires for requests arriving at *that* Netlify site
with that Host header — and the domain no longer routes there. So the rules
cannot fire, and removing them changes no live behavior. That is a smaller,
safer edit than it would have been a day ago, but it still has to happen:
Spec0002's own comment says these are to be deleted, not changed, once the
standalone site exists.

**The duplicate-content window is open right now.** The Academy content is
live at two addresses today — `atchisonacademy.com` and
`leeatchison.com/academy` — with leeatchison.com's copy carrying the canonical
tags, the older domain authority, and every existing inbound link. Spec0005's
Open Question 3 accepted this window on the grounds that it would be short.
Closing it is what this spec is for, so "short" now depends on this shipping.

One thing to confirm at implementation rather than assume: that **both** the
apex and the `www.` variant were moved. A half-moved domain — apex on the new
site, `www.` still an alias on leeatchison.com — would leave
`www.atchisonacademy.com` relying on a redirect this spec deletes, and it would
start serving the whole leeatchison.com site under that hostname. Testing
step 8 checks both.

---

## Solution/Fix/Change

Six files under `LeeAtchison/`, one of them deleted, plus two scope additions
taken at implementation (sections 7 and 8).

### 1. Delete `src/academy.erb`

The page and its two commented-out `https://atchisonacademy.com` CTA blocks go
away entirely. Its content already lives at `AtchisonAcademy/src/index.erb`.

Nothing else on the site reads it, and no layout, partial, or data file
references it.

### 2. `netlify.toml` — remove two rules, add two

**Remove** the two `atchisonacademy.com` alias `[[redirects]]` blocks and the
comment block above them. Spec0002's own comment says these are to be
*deleted, not changed*, once the standalone site exists:

```toml
[[redirects]]
  from = "https://atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 302
  force = true

[[redirects]]
  from = "https://www.atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 302
  force = true
```

The comment block's opening line — "Domain redirects must come first" — goes
with them; after this change there are no domain redirects in the file, only
path rules.

**Add**, modeled on the existing `/ai-native` pair immediately below:

```toml
# /academy was the Atchison Academy landing page until the Academy became its
# own site at atchisonacademy.com (Spec0005, Spec0006). These are 301 —
# permanent, deliberately, and the opposite of the 302s Spec0002 used for the
# alias domain. That destination was going to change; this one is not, and a
# permanent redirect is what transfers the page's accumulated search ranking
# to the new domain instead of stranding it.
[[redirects]]
  from = "/academy"
  to = "https://atchisonacademy.com/"
  status = 301
  force = true

[[redirects]]
  from = "/academy/*"
  to = "https://atchisonacademy.com/"
  status = 301
  force = true
```

`force = true` matches the `/ai-native` pattern. With the page deleted nothing
is served at that path anyway, so `force` changes no behavior here — it is
kept for consistency with the neighboring rules rather than for effect.

The splat rule flattens any deeper path to the Academy home page. There were
never any pages under `/academy/`, so nothing is being lost — see Open
Question 4.

### 3. `src/_components/shared/navbar.rb` — Academy goes external

```ruby
{ label: "Academy",   path: "https://atchisonacademy.com", external: true },
```

Position unchanged (between Courses and About), label unchanged. `active?`
already returns `false` for any path that is not the current resource's
relative URL, so an absolute URL simply never highlights — no change needed
there, and none to `link_classes`.

### 4. `src/_components/shared/navbar.erb` — handle external links

`navbar.erb` currently wraps every path in `relative_url`, which would mangle
an absolute URL. Spec0005 already solved this in
`AtchisonAcademy/src/_components/shared/navbar.erb` for that site's outbound
"Lee Atchison" link. **Copy that branch verbatim** so the two files stay
identical apart from the brand text:

```erb
<% links.each do |link| %>
  <li>
    <% if link[:external] %>
      <a href="<%= link[:path] %>"
         class="<%= link_classes(link) %>"
         target="_blank" rel="noopener noreferrer"><%= link[:label] %></a>
    <% else %>
      <a href="<%= relative_url link[:path] %>"
         class="<%= link_classes(link) %>"
         <% if active?(link[:path]) %>aria-current="page"<% end %>><%= link[:label] %></a>
    <% end %>
  </li>
<% end %>
```

Two sibling files diverging on the same problem is how the next person ends up
fixing this twice. After this change, `diff` on the two `navbar.erb` files
should show only the `nav-brand` line.

### 5. `src/courses.erb` — two buttons

| Line | Element | Change |
|---|---|---|
| ~15 | Hero button, "Atchison Academy &rarr;" | `href="/academy"` &rarr; `href="https://atchisonacademy.com"` |
| ~83 | Closing CTA band, "Explore the Academy &rarr;" | same |

Both already carry `rel="noopener noreferrer"`. Both need `target="_blank"`
added if Open Question 1 lands on new-tab. Copy is unchanged — both labels read
correctly as outbound links.

The closing `.courses-cta-section` band itself stays: its heading, logo, and
paragraph are promotional copy for the Academy and are still accurate on
leeatchison.com. Only the button's destination changes. (Spec0005 removed this
whole band from the *Academy's own* copy of `courses.erb`, where it was
self-referential. Here it is not.)

### 6. Docs: `LeeAtchison/CLAUDE.md` and `LeeAtchison/README.md`

Both describe the Academy page as part of this site.

* `CLAUDE.md` line ~35 — remove `academy.erb` from the `src/` tree listing.
* `CLAUDE.md` line ~91 — the collection front-matter paragraph describes
  `featured` as "highlights on Academy page" and `academy` /
  `academy_featured` as "shown on Academy page". Reword: `featured` is used by
  `books.erb` and `courses.erb` on this site and is unaffected; `academy` and
  `academy_featured` become inert here and are read only by
  `AtchisonAcademy/src/index.erb`.
* `README.md` lines ~57 and ~71–72 — same three fields, same rewording.

`logo-academy.png` **stays**. It is still used by the `index.erb` platform card
and the `courses.erb` CTA band.

### 7. `frontend/styles/index.css` — delete the dead Academy rules

Added at implementation, 2026-08-29, with Lee's approval.

Deleting `academy.erb` strands its entire stylesheet section — the
`/* Academy page */` block, 96 lines covering `.academy-hero` (and its
`::after`, `-inner`, `-logo`, `h1`, `p`), `.academy-section`,
`.academy-section--alt`, `.academy-cta` (and `-inner`, `-logo`), and the
`max-width: 640px` media query that reflows the CTA. Every one of those
selectors was used by `academy.erb` and by nothing else; verified by grepping
`src/` for each class name individually before deleting.

The block is bounded by its own banner comment and the "Error pages" banner
that follows, so it comes out whole with no neighbors disturbed. `.courses-cta-section`
is a different selector and is untouched — the `courses.erb` CTA band stays.

### 8. `AtchisonAcademy/README.md` and `AtchisonAcademy/CLAUDE.md` — stale status

Added at implementation, 2026-08-29.

Both files state as present fact that `atchisonacademy.com` is an alias domain
on the leeatchison.com site redirecting to `leeatchison.com/academy/`, and that
deleting those rules is future cutover work. This change is that cutover work,
so merging it makes both passages false. `AtchisonAcademy/README.md`'s Status
callout and `AtchisonAcademy/CLAUDE.md`'s "Netlify and the alias redirect"
section are rewritten to describe the finished state and to name where the
`/academy` 301s now live. Documentation only — no code, content, config, or
build change in `AtchisonAcademy`.

---

## Testing

Steps 1–6 are local. Steps 7–8 need a deploy preview and production, because
`netlify.toml` redirects are not applied by `bin/bridgetown start` and cannot
be tested locally at all.

1. **Build.** `cd LeeAtchison && bin/bridgetown deploy` succeeds. `output/` has
   no `academy/` directory, and the page count is one lower than before.

2. **No `/academy` links survive.** Grep the built HTML for `href="/academy`
   and `/academy/` — zero hits. (`logo-academy.png` will match a naive grep for
   "academy"; exclude it.)

3. **The outbound links are right.** Grep built HTML for
   `atchisonacademy.com` — expect exactly three per page set: the navbar entry
   (on every page), and the two `courses.erb` buttons (on `/courses/`). Each
   href is the bare absolute URL, **not** a `relative_url`-mangled
   `/https://atchisonacademy.com`.

4. **Navbar renders correctly in all three positions.** Check the built HTML
   of `/` (root, where `relative_url` is a no-op and a regression would hide),
   `/books/`, and a book detail page such as
   `/books/the-software-conductor/`. On each: the Academy `<a>` has an absolute
   href, `target="_blank"`, `rel="noopener noreferrer"`, and no
   `aria-current`. Every other nav item is unchanged.

5. **`navbar.erb` diff.** `diff LeeAtchison/src/_components/shared/navbar.erb
   AtchisonAcademy/src/_components/shared/navbar.erb` shows only the
   `nav-brand` line.

6. **Sitemap.** `/academy/` is gone from `sitemap.xml`; every remaining `<loc>`
   still resolves.

7. **Redirects, on the PR's deploy preview.** Netlify applies path
   `[[redirects]]` on Deploy Previews, so these are testable before merge:

   ```bash
   curl -sI https://<preview-host>/academy       # 301 -> https://atchisonacademy.com/
   curl -sI https://<preview-host>/academy/      # 301 -> https://atchisonacademy.com/
   curl -sI https://<preview-host>/academy/foo   # 301 -> https://atchisonacademy.com/
   curl -sI https://<preview-host>/ai-native     # 301 -> /ainative/ (unchanged)
   ```

   Confirm the `/ai-native` pair still works — removing the block above it is
   the kind of edit that takes a neighbor with it.

8. **Production, after merge.**

   ```bash
   curl -sI https://leeatchison.com/academy      # 301 -> https://atchisonacademy.com/
   curl -sI https://leeatchison.com/academy/     # 301 -> https://atchisonacademy.com/
   curl -sI https://atchisonacademy.com          # 200, the new site, unchanged
   curl -sI https://www.atchisonacademy.com      # the new site (200, or one hop to the apex)
   ```

   The two `atchisonacademy.com` checks are the ones that matter, and they are
   checking that this change did *nothing* to them — the domain moved before
   this shipped, so deleting rules that can no longer fire must be invisible
   there. If `www.atchisonacademy.com` breaks or starts serving leeatchison.com
   content, the `www.` variant was never moved off the alias and was quietly
   depending on the rule this spec deleted. That is a Netlify fix, not a repo
   one, and it is the only way this change can surface a surprise.

   Also confirm there is no redirect chain: `/academy` should be one hop to
   `https://atchisonacademy.com/`, not a hop that lands on another redirect.

9. **Nothing else pointed here.** Already verified at spec time: the whole repo
   contains no other reference to `leeatchison.com/academy` in built or source
   content, and `stosa/src/index.erb`'s "Visit Atchison Academy" button already
   points at `https://atchisonacademy.com` directly. Re-grep at implementation
   in case something landed in between.

---

## Summary of Steps Needed

1. Resolve the Open Questions below.
2. Re-confirm `https://atchisonacademy.com` **and**
   `https://www.atchisonacademy.com` both serve the new site before starting.
   Lee confirmed the move on 2026-08-28; the `www.` half is the one worth
   checking rather than assuming.
3. Decide branching mode (Open Question 5) and set up the worktree if used.
4. Delete `LeeAtchison/src/academy.erb`.
5. Edit `LeeAtchison/netlify.toml`: remove the two alias rules and their
   comment block, add the two `/academy` 301s.
6. Edit `navbar.rb` (external Academy entry) and `navbar.erb` (external-link
   branch, copied from `AtchisonAcademy`).
7. Repoint the two `courses.erb` buttons.
8. Update `LeeAtchison/CLAUDE.md` and `README.md`.
9. Run Testing steps 1–6 locally.
10. Request permission to commit; create a PR on request.
11. Run Testing step 7 on the deploy preview.
12. Merge, then run Testing step 8 against production.
13. (Already done at spec creation: the "Cut atchisonacademy.com over to the
    standalone AtchisonAcademy site" entry was removed from
    `Projects/_Projects.md`, since Lee's completed Netlify work plus this spec
    are that item in full.)

---

## Open Questions

1. **New tab or same tab for the outbound Academy links?** The navbar entry
   and the two `courses.erb` buttons all leave the site now.
   *Recommendation: new tab (`target="_blank" rel="noopener noreferrer"`) for
   all three, matching `stosa/src/index.erb`'s existing "Visit Atchison
   Academy" button and the outbound "Lee Atchison" entry in
   `AtchisonAcademy`'s navbar. Three sites, one convention for cross-property
   links.*

   **Decided 2026-08-29 (Lee):** new tab, as recommended. All three links carry
   `target="_blank" rel="noopener noreferrer"`.

2. **The `index.erb` platform card.** The home page's "Training & Education"
   section has an Atchison Academy platform card — logo, name, one line of
   copy — that is a plain `<div>`, not a link. Its sibling LinkedIn Learning
   card is also not a link. Now that the Academy has its own site, the card is
   the most natural place on the home page to send someone there.
   *Recommendation: leave it alone in this spec. Lee's instruction was about
   menu items and it is not one; making one of two sibling cards clickable is a
   design change, not a link repoint, and it belongs in whatever spec revisits
   that section.*

   **Decided 2026-08-29 (Lee):** leave it alone, as recommended. The card stays
   a non-clickable `<div>`, matching its LinkedIn Learning sibling.

3. **The `academy` and `academy_featured` front matter on `LeeAtchison`'s two
   books and eight courses.** With `academy.erb` deleted, nothing on this site
   reads either flag — the only reader is `AtchisonAcademy/src/index.erb`,
   which has its own copies of those files. (`featured` is different: `books.erb`
   and `courses.erb` both use it and it stays.)
   *Recommendation: leave the flags in place and say so in the docs. Ten files
   edited to delete two inert lines each is churn with a real cost — it makes
   `LeeAtchison`'s and `AtchisonAcademy`'s copies of the same resource stop
   being diff-able, which is the property Spec0005 deliberately preserved.*

   **Decided 2026-08-29 (Lee):** leave them, as recommended. No book or course
   file is touched; `LeeAtchison/CLAUDE.md` and `README.md` now say the two
   `academy*` flags are inert here and name `AtchisonAcademy` as their only
   reader.

4. **Should `/academy/*` preserve deep paths?** As written, everything under
   `/academy/` lands on the Academy home page. There has never been a page
   under `/academy/`, so no real URL is being flattened.
   *Recommendation: keep the flat target. A path-preserving rule
   (`to = "https://atchisonacademy.com/:splat"`) would forward garbage paths to
   the new site to 404 there instead of redirecting them somewhere useful.*

   **Decided 2026-08-29 (Lee):** flat target, as recommended. Both rules point
   at `https://atchisonacademy.com/` with no `:splat`.

5. **Branching mode.** `main`, or a `spec0006` worktree?
   *Recommendation: a Claude Code remote session branch, as Spec0002, Spec0003,
   and Spec0005 used. The change is six files in one site and needs a dev
   server to verify the navbar; a full local worktree is more setup than it
   earns, and `main` is the wrong place for anything that has a deploy preview
   to check.*

   **Decided 2026-08-29 (Lee):** a Claude Code remote session branch, as
   recommended — `claude/spec0005-spec0006-jxfv1k`. No worktree, so no worktree
   cleanup at close.

---

## History of Updates

* **2026-08-28** Spec created at Lee's request: remove `leeatchison.com/academy`
  and point every Academy reference on leeatchison.com at
  `https://atchisonacademy.com` instead. This resolves Spec0005's Open
  Question 4, which deliberately deferred the `leeatchison.com/academy`
  decision to cutover time.
* **2026-08-28** Three scope decisions taken with Lee at creation:
  * **The `/academy` URL:** delete the page and add a **301** to
    `https://atchisonacademy.com/`, rather than 404ing it or keeping a slim
    promo page. Inbound links, bookmarks, and existing search results keep
    working, and the permanent status is what moves the page's ranking to the
    new domain.
  * **Scope:** repo work only, matching Spec0005's boundary. The Netlify site
    and the domain move are Lee's by hand.
  * **Navbar:** keep the Academy entry, pointed outward — not removed.
* **2026-08-28** Worked through the ordering constraint, then had it removed.
  The first draft made the Netlify domain move a hard merge gate, on the
  reasoning that merging first would leave `atchisonacademy.com` as an alias on
  leeatchison.com with no rules governing it — serving the whole leeatchison.com
  site under a second domain. (The opposite risk, a live redirect pointing at a
  deleted page, never existed: the rules and the page are in the same repo and
  go in the same change.) **Lee then confirmed the domain move was already
  done**, which collapses the gate entirely and downgrades the two alias rules
  from live infrastructure to dead code that cannot fire. Rewrote the section,
  Summary step 2, and Testing step 8 accordingly.
* **2026-08-28** Two things the completed domain move changes rather than
  simply removes. First, the duplicate-content window Spec0005's Open Question 3
  accepted as "short" is open *now* and stays open until this ships — that is
  the argument for this spec's priority. Second, the one residual risk is a
  half-moved domain: if `www.atchisonacademy.com` was left as an alias while the
  apex moved, it is quietly depending on a rule this spec deletes. Made checking
  both hostnames an explicit step rather than an assumption (Summary step 2,
  Testing step 8).
* **2026-08-28** Audited every `/academy` reference in the repo rather than
  trusting Spec0005's list, which named three places. Found the same three —
  `navbar.rb`, and two buttons in `courses.erb` — and confirmed there is no
  fourth: no layout, partial, data file, or other site links to
  `leeatchison.com/academy`, and `stosa/src/index.erb`'s Academy button already
  points at `https://atchisonacademy.com` directly, so `stosa` needs no change.
* **2026-08-28** Found the `navbar.erb` problem: it wraps every path in
  `relative_url`, so an absolute URL in `LINKS` would be mangled. Spec0005
  already fixed this in `AtchisonAcademy`'s copy for that site's outbound link,
  so this spec copies that branch verbatim rather than inventing a second
  solution, and Testing step 5 asserts the two files stay identical apart from
  the brand text.
* **2026-08-28** Checked the front-matter flags before proposing any cleanup:
  `featured` is live on this site (`books.erb` and `courses.erb` both select on
  it) and must not be touched; only `academy` and `academy_featured` go inert.
  That distinction is wrong in both `LeeAtchison/CLAUDE.md` and `README.md`
  today, which describe `featured` as an Academy-page field — folded the
  correction into this spec since those files are being edited anyway.
* **2026-08-28** Noted that `netlify.toml` redirects cannot be tested by the
  local dev server at all, so the redirect checks are split: deploy preview
  before merge (Testing step 7, including a regression check on the adjacent
  `/ai-native` rules), production after (Testing step 8).
* **2026-08-28** Removed the "Cut atchisonacademy.com over to the standalone
  AtchisonAcademy site" entry from `Projects/_Projects.md` on creating this
  file. That entry had four parts — create the Netlify site, move the domain,
  delete the alias redirects, and decide what happens to
  `leeatchison.com/academy`. Lee has completed the first two by hand; this spec
  is the other two, and its Open Question 4 inheritance from Spec0005 is
  resolved rather than carried forward again.
* **2026-08-29** All five Open Questions resolved with Lee, each landing on the
  spec's recommendation: new tab for all three outbound links (OQ1), the
  `index.erb` platform card left as a non-clickable div (OQ2), the `academy` and
  `academy_featured` front matter left in place and documented as inert (OQ3),
  a flat `/academy/*` target with no `:splat` (OQ4), and a Claude Code remote
  session branch rather than a worktree (OQ5).
* **2026-08-29** Implemented. `src/academy.erb` deleted; `netlify.toml`'s two
  dead `atchisonacademy.com` alias 302s and their comment block removed and the
  two `/academy` 301s added above the `/ai-native` pair; `navbar.rb`'s Academy
  entry made external; `navbar.erb` replaced wholesale with `AtchisonAcademy`'s
  copy with only the brand text changed; both `courses.erb` buttons repointed
  and given `target="_blank"`; `LeeAtchison/CLAUDE.md` and `README.md` updated.
  One deviation worth naming: the `active?` comment in `navbar.rb` also picked
  up `AtchisonAcademy`'s extra sentence explaining why external links never
  highlight, so the two `navbar.rb` files now differ only in their `LINKS`
  lists. That is a comment, not behavior, and it serves the same
  don't-let-the-siblings-drift argument section 4 makes for `navbar.erb`.
* **2026-08-29** Two scope additions taken at implementation, both recorded as
  Solution sections 7 and 8. **The dead CSS** (section 7): Lee approved
  removing it rather than shipping 96 orphaned lines, after each selector was
  grepped individually against `src/` to confirm `academy.erb` was its only
  user. **The stale `AtchisonAcademy` docs** (section 8): its `README.md` and
  `CLAUDE.md` both assert as current fact that `atchisonacademy.com` is still an
  alias redirecting to `leeatchison.com/academy/` and that removing those rules
  is future work — statements this change makes false at merge. Corrected them
  under the process rule that documentation tracking the code a spec changes is
  in scope for that spec, and widened Systems Impacted accordingly. Doc-only;
  nothing in `AtchisonAcademy` builds differently.
* **2026-08-29** Testing steps 1–6 and 9 run and passing, on a production
  build (`bin/bridgetown frontend:build` + `bin/bridgetown build` with
  `BRIDGETOWN_ENV=production` — `bin/bridgetown deploy` is the same two steps
  and was unavailable in this session's sandbox).
  * **1.** Build clean. No `output/academy/` directory; 31 HTML files, one
    fewer than before. esbuild bundles `index.css` at 44.84KB with no error
    after the section-7 deletion.
  * **2.** Zero `href="/academy"` or `href="/academy/"` in any built page.
  * **3.** `atchisonacademy.com` appears once on every page (the navbar) and
    three times on `/courses/` (navbar plus the two buttons). No
    `relative_url`-mangled `/https://atchisonacademy.com` anywhere.
  * **4.** Navbar checked on `/` (where `relative_url` is a no-op and a
    regression would hide), `/books/`, and `/books/the-software-conductor/`.
    On all three the Academy `<a>` has the bare absolute href,
    `target="_blank"`, `rel="noopener noreferrer"`, and no `aria-current`;
    every other item still resolves relatively, `/ainative` keeps
    `nav-featured`, and `Books` still takes `is-active` and `aria-current` on
    the books pages.
  * **5.** `diff` of the two `navbar.erb` files shows only the `nav-brand`
    line, as required.
  * **6.** `sitemap.xml` has 29 `<loc>` entries, none of them `/academy/`.
  * **9.** Re-grepped the whole repo: no source file outside `Projects/` refers
    to `leeatchison.com/academy` any more, and `stosa/src/index.erb`'s "Visit
    Atchison Academy" button already pointed at `https://atchisonacademy.com`,
    so `stosa` needed no change. Remaining hits are archived spec text
    (deliberate historical record) and the corrected past-tense sentences in
    `AtchisonAcademy`'s docs.
  * **Not yet run:** steps 7 and 8. Netlify does not apply `[[redirects]]` to a
    local build, so the `/academy` 301s, the `/ai-native` regression check, and
    the `www.atchisonacademy.com` question are only answerable on the PR's
    deploy preview and then in production.
* **2026-08-29** [PR #7](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/7)
  opened from `claude/spec0005-spec0006-jxfv1k`; moved to Verifying. That PR
  carries both this spec's implementation and Spec0005's close-out. Testing
  step 7 is now runnable against the PR's deploy preview — the `/academy` and
  `/academy/*` 301s, the `/ai-native` regression check, and the
  `www.atchisonacademy.com` hostname question all wait on it.
* **2026-08-29** Testing step 7 attempted against the PR's `leeatchison`
  deploy preview (`https://deploy-preview-7--leeatchison.netlify.app`) and
  **blocked by the environment, not by anything in the change**: this session's
  network egress proxy refuses `netlify.app`, so every `curl -sI` returned 403
  from the proxy rather than reaching Netlify. Step 7 therefore still has to be
  run by hand, against that preview host, before merge.

  Two partial signals in the meantime, neither a substitute. Netlify's own
  **"Redirect rules - leeatchison" check passed** on commit `894d7bc`, which
  means the rewritten `netlify.toml` parses and both `/academy` rules deployed
  — it does not exercise them. And the other four sites' checks came back
  `neutral` (nothing changed for them), which is the expected shape for a
  single-site change.
* **2026-08-29** Closed at Lee's request.
  [PR #7](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/7) is
  merged to `main` (merged by Lee, 2026-08-29): `leeatchison.com/academy` is
  gone, `/academy` and `/academy/*` 301 to `https://atchisonacademy.com/`, the
  navbar entry and both `courses.erb` buttons point at the new domain, the dead
  alias redirects and the 96 orphaned CSS lines are removed, and the
  `AtchisonAcademy` docs are corrected. No worktree was used (the work ran on a
  Claude Code remote session branch, `claude/spec0005-spec0006-jxfv1k`), so
  there is nothing to clean up.

  **Carried out of this spec unverified:** Testing steps 7 and 8. Step 7 (the
  `/academy` and `/academy/*` 301s, the `/ai-native` regression check) was never
  run against a live host — the deploy preview was unreachable from the
  implementation session's proxy — and step 8 (the `www.atchisonacademy.com`
  hostname question) likewise. Both are now checkable directly against
  production leeatchison.com and should be spot-checked by hand; anything they
  turn up is a new Bug, not a reopening of this spec.
