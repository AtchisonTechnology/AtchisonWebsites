# SAI article-end subscribe form: add "please subscribe" messaging around it

* **ID:** Spec0032
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-10-11
* **Date Implemented:**
* **Systems Impacted:** SoftwareArchitectureInsights

---

## Problem/Requirement

Every SAI article ends with the Kit inline subscribe form ("Basic Form",
`site.metadata.kit_inline_form_uid`), rendered by `_layouts/article.erb`:

```erb
<div class="article-subscribe">
  <div class="article-subscribe-inner">
    <%= render "kit_form", uid: site.metadata.kit_inline_form_uid %>
  </div>
</div>
```

That is all a reader sees: an email field and a button, with no heading, no
reason to subscribe, and no social proof. A reader who just finished an
article — the moment they are most likely to subscribe — is never actually
asked.

The home page and `/subscribe` already wrap the same form with a pitch and the
"Join 1,000+ architects & engineering leaders" line. Article pages are the
only place the form appears bare.

This matters more now: Lee's paid LinkedIn promotion of the "Level 2" article
(Paid Growth campaign CMP-002, starting 2026-10-26) will send new readers to
the site, and article pages are where many of them will land.

---

## Solution/Fix/Change

**Proposed (not yet decided):**

1. **New partial `src/_partials/_article_subscribe.erb`** that renders the whole
   article-end block: a short heading, one or two lines of pitch, the existing
   `kit_form` partial, and the subscriber-count line.
2. **`_layouts/article.erb`** renders that partial in place of the current
   `.article-subscribe` block.
3. **Layout.** The heading and copy sit inside `.article-subscribe` but
   *outside* `.article-subscribe-inner`, so the text stays at the article's
   reading width. Only the Kit embed keeps its existing breakout (the 700px
   measurement workaround described in `index.css`). Add styles for the new
   heading/copy using existing CSS tokens; no new colors.
4. **Copy (proposed, Lee to approve or rewrite):**
   - Heading: **"Enjoyed this? Get the next one."**
   - Pitch: "Practical architecture thinking, every Tuesday morning. From
     someone still doing the work."
   - Below the form: "Join <%= site.metadata.subscriber_count %> architects &
     engineering leaders. Unsubscribe anytime."
5. **The subscriber count comes from `site.metadata.subscriber_count`**, the
   same hand-maintained value the home and subscribe pages use, so it is never
   hard-coded.

Out of scope: the home page and `/subscribe` (already have messaging), any
change to the Kit form itself in Kit, and per-article or per-campaign custom
copy.

---

## Testing

- Build the site and open several articles: the heading, pitch, form, and count
  line appear at the end, after the author bio.
- Desktop and phone widths: copy wraps at the article text width; the Kit form
  still switches to its side-by-side field+button layout on desktop.
- Light and dark appearance (if the site supports both): text is legible.
- Home page and `/subscribe` are unchanged.
- Episode pages: unchanged, unless Open Question 2 decides otherwise.
- Changing `subscriber_count` in `site_metadata.yml` updates the article line.

---

## Summary of Steps Needed

1. Resolve the Open Questions (final copy, episode pages, button text).
2. Create `_partials/_article_subscribe.erb`.
3. Replace the `.article-subscribe` block in `_layouts/article.erb` with the partial.
4. Add CSS for the heading and copy in `frontend/styles/index.css`.
5. (If decided) do the same in `_layouts/episode.erb`.
6. Test as above.

---

## Open Questions

1. **Copy.** Approve the proposed heading, pitch, and count line, or supply
   replacements. Lee's voice: short, warm, no hype.
2. **Episode pages.** `_layouts/episode.erb` has the same bare form at its end.
   Use the same partial there too (with "Enjoyed this episode?"-style wording),
   or leave episodes alone for now?
3. **Kit button text.** The button label lives in Kit's form settings, not in
   this repo. Keep Kit's current label, or change it in Kit (e.g., "Subscribe —
   it's free") alongside this spec? A Kit-side change is Lee's to make by hand.

---

## History of Updates

* **2026-10-11** — Spec created at Lee's request from the Paid Growth project.
  Lee confirmed the article-end form renders as a blank form with no messaging
  around it. Researched `article.erb`, `_kit_form.erb`, `subscribe.erb`,
  `index.erb`, `episode.erb`, `site_metadata.yml`, and the
  `.article-subscribe` CSS. Solution and copy are proposals only; three Open
  Questions for Lee.
