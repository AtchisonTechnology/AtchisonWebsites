# Point the pre-launch webinar link at the new /architecting-with-ai URL

**PR:** [#15](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/15)

* **ID:** Spec0012
* **Status:** Verifying
* **Date Created:** 2026-08-29
* **Date Implemented:** 2026-08-29
* **Systems Impacted:** `shared/` (rendered by `AtchisonAcademy`)

---

## Problem/Requirement

The free live webinar behind the *Architecting Systems That Use AI* pre-launch
course has moved to a shorter Kit slug:

| | URL |
|---|---|
| Old | `https://softwarearchitectureinsights.com/webinar-architecting-systems-with-ai` |
| New | `https://softwarearchitectureinsights.com/architecting-with-ai` |

The repo still stores the old URL. It appears in exactly **one** live place —
`shared/_courses/architecting-systems-with-ai.md`, line 8:

```yaml
prelaunch_url: "https://softwarearchitectureinsights.com/webinar-architecting-systems-with-ai"
```

That single value is rendered by **two** buttons (the hero CTA and the closing
CTA) on the Academy course page, via the `prelaunch_cta_url` helper added in
Spec0010 §3a. Pre-launch courses are Academy-only, so `atchisonacademy.com` is
the only site that renders it; `LeeAtchison`'s `shared_content.rb` drops the
resource at read time because it carries no `show_leeatchison`.

**Nothing is currently broken.** Verified 2026-08-29: both the old and the new
URL resolve 200 and serve the same Kit landing page ("Your AI Provider Will
Fail. Design for It. | Live Sept 30"). Per Lee, the old slug is being
redirected to the new one on the Kit side. So this change has **no merge gate
in either direction** — it can land before or after the redirect without a
window where the course page's CTA breaks. It is a correctness and hygiene
change: the repo should name the canonical URL, not one that only works
because a redirect is standing behind it.

### Why it matters beyond tidiness

The pre-launch link exists to feed Lee's validation analysis (Spec0010 §3a),
and the helper appends UTM parameters at render time. A redirect hop between
the click and the landing page is one more place those parameters can be
dropped — Kit's redirect behavior for query strings is not something this repo
controls or can test. Naming the destination directly removes the hop.

---

## Solution/Fix/Change

One line, one file.

**`shared/_courses/architecting-systems-with-ai.md`**

```diff
-prelaunch_url: "https://softwarearchitectureinsights.com/webinar-architecting-systems-with-ai"
+prelaunch_url: "https://softwarearchitectureinsights.com/architecting-with-ai"
```

### What deliberately does **not** change

- **The course file name and slug.** The course page stays at
  `/courses/architecting-systems-with-ai/`. Only the outbound webinar
  destination moves.
- **`utm_campaign`.** The helper derives it from
  `resource.basename_without_ext`, so it remains
  `architecting-systems-with-ai-prelaunch`. Keeping the campaign name stable
  across the URL change is what lets the before/after clicks stay in one series
  in the analysis. *(This is a consequence of not renaming the file, not a
  separate edit.)*
- **`prelaunch_cta` and `prelaunch_note`.** The wording ("Save Your Seat — Free
  Live Webinar", the Wednesday, September 30 date) is unaffected by a URL
  change and is out of scope here. The body copy's September 30 reference is
  likewise untouched — see Open Question 1 for what happens to all of it after
  the webinar airs.
- **`shared/_courses/service-ownership.md`.** The other pre-launch course
  points at `/service-ownership-diagnostic`, a different Kit page. Not
  affected.
- **`Projects/zArchive/Spec0010_...md`.** It records the old URL in several
  places. Archived specs are the historical record of what was decided and
  built at the time; they are **not** updated to reflect later changes. Leave
  it alone.

### Outside the repo — Lee's, already done

Per the standing boundary on this repo's specs, Kit landing pages, slugs and
redirects are Lee's to do by hand and are never spec'd as implementation
steps. Recorded here as state, not as work:

- The new `/architecting-with-ai` page exists and is live. ✔
- The old `/webinar-architecting-systems-with-ai` slug redirects to it.
  *(Lee, 2026-08-29)*

The Kit-side UTM capture gap flagged in Spec0010 §3a — no `utm_source` /
`utm_campaign` custom fields on the form, so the parameters reach the page and
are dropped at submit — is **unchanged by this spec** and remains open. This
change makes the link cleaner; it does not make the analysis work.

---

## Testing

There is no Netlify redirect, no build plugin change and no Ruby change here,
so this is verified by rendering the one page that uses the value.

1. **Build guard still passes.** `availability: prelaunch` requires both
   `prelaunch_url` and `prelaunch_cta`, and forbids `platform_url`
   (`validate_availability!` in each site's `shared_content.rb`). Editing the
   URL's value keeps all three conditions satisfied; a clean
   `AtchisonAcademy` build is the check.
2. **Run the Academy site** — `AtchisonAcademy/bin/dev` (port 16000 on `main`;
   `bin/site-port AtchisonAcademy` if working in a worktree) — and open
   `/courses/architecting-systems-with-ai/`.
3. **Both CTAs point at the new URL, correctly tagged.** Hero and closing
   buttons should each resolve to:

   ```
   https://softwarearchitectureinsights.com/architecting-with-ai
     ?utm_source=atchisonacademy.com&utm_medium=course-page
     &utm_campaign=architecting-systems-with-ai-prelaunch
     &utm_content=hero        # footer on the closing CTA
   ```

   Confirm `utm_campaign` still reads `architecting-systems-with-ai-prelaunch`
   — an unchanged campaign name is the signal the file was not renamed.
4. **No query string in front matter.** `prelaunch_url` must stay clean; the
   helper composes the query. `grep -n 'prelaunch_url' shared/_courses/*.md`
   should show no `?` in either value.
5. **Link check.** The new URL resolves 200 (verified 2026-08-29; re-check at
   implementation time, since the page is Kit-hosted and outside this repo's
   control).
6. **No stragglers.** `grep -rI "webinar-architecting-systems-with-ai" .
   --exclude-dir=.git --exclude-dir=output` should return only the archived
   `Spec0010` file, which is intentionally left as-is.

Note that `leeatchison.com` needs no check: the resource never reaches its
build.

---

## Summary of Steps Needed

1. Edit `prelaunch_url` in `shared/_courses/architecting-systems-with-ai.md`
   to the new URL.
2. Build/serve `AtchisonAcademy` and confirm both CTAs on the course page
   carry the new URL with unchanged UTM tagging (Testing 2–4).
3. Run the two greps (Testing 4 and 6) and the link check (Testing 5).
4. Trivial enough for `main` — no worktree needed — but that call is Lee's at
   implementation time.

---

## Open Questions

1. **What happens to this course's pre-launch block after September 30?**
   Not blocking this spec, and raised in Spec0010's own history: once the
   webinar has aired, `prelaunch_cta` ("Save Your Seat"), `prelaunch_note` and
   the body copy's "Wednesday, September 30" all go stale on the same day, and
   the link starts pointing at a registration page for a past event. Spec0010
   leaned toward rewriting the three values to evergreen wording (e.g. sending
   readers to a replay) rather than removing the pre-launch block. Worth its
   own small spec in early October rather than being folded in here.
   *(Proposed — not decided.)*

---

## History of Updates

- **2026-08-29 — Spec created.** Lee: the webinar URL is changing from
  `/webinar-architecting-systems-with-ai` to `/architecting-with-ai`; update
  the course metadata that refers to it.
- **2026-08-29 — Scope confirmed as one line.** Repo-wide grep found the old
  URL in exactly two files: the live course front matter, and archived
  Spec0010. Only the former is in scope.
- **2026-08-29 — Both URLs verified live, and the old one is being
  redirected.** Fetched both: each returns the same Kit landing page. Lee
  confirmed the old slug redirects to the new one. That removes any merge
  ordering gate — recorded above so a future reader does not re-derive it.
- **2026-08-29 — `utm_campaign` stability called out explicitly.** The
  campaign name derives from the file's basename, so leaving the file name
  alone keeps pre- and post-change clicks in one series. Worth stating because
  "the URL changed, so rename the course to match" is the tempting wrong move.
- **2026-08-29 — Archived Spec0010 deliberately not updated.** Archived specs
  are a record of what was decided then, not a live index of current values.
- **2026-08-29 — Post-webinar cleanup split out** as Open Question 1 rather
  than being absorbed into this change.
- **2026-08-29 — Implemented.** `prelaunch_url` updated in
  `shared/_courses/architecting-systems-with-ai.md`. Verified via a clean
  `AtchisonAcademy` build and inspection of the rendered course page: both the
  hero and closing CTA hrefs point at the new URL with `utm_campaign`
  unchanged at `architecting-systems-with-ai-prelaunch`. The repo-wide grep
  found no stragglers outside the archived Spec0010 and this spec file
  itself. PR created for review.
