# SAI article-end subscribe form: add "please subscribe" messaging around it

* **Linear:** [WEB-5](https://linear.app/atchison-technlology/issue/WEB-5)
* **Formerly:** Spec0032
* **Date Created:** 2026-10-11
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

**Decided 2026-10-11** (Lee approved the proposed copy and the episode-page extension):

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
4. **Copy (approved 2026-10-11):**
   - Heading: **"Enjoyed this? Get the next one."**
   - Pitch: "Practical architecture thinking, every Tuesday morning. From
     someone still doing the work."
   - Below the form: "Join <%= site.metadata.subscriber_count %> architects &
     engineering leaders. Unsubscribe anytime."
5. **The subscriber count comes from `site.metadata.subscriber_count`**, the
   same hand-maintained value the home and subscribe pages use, so it is never
   hard-coded.
6. **Episode pages** use the same partial, with the heading **"Enjoyed this
   episode? Get the next one."** — passed in as the partial's `heading` local;
   pitch and count line unchanged.
7. **Kit button text** is left as-is; it lives in Kit, not this repo.

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

All resolved 2026-10-11.

1. ~~**Copy.**~~ **Decided:** use the proposed copy as written. Approve the proposed heading, pitch, and count line, or supply
   replacements. Lee's voice: short, warm, no hype.
2. ~~**Episode pages.**~~ **Decided:** yes, same partial with episode wording. `_layouts/episode.erb` has the same bare form at its end.
   Use the same partial there too (with "Enjoyed this episode?"-style wording),
   or leave episodes alone for now?
3. ~~**Kit button text.**~~ **Decided:** out of scope; keep Kit's current label. The button label lives in Kit's form settings, not in
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
* **2026-10-11** — Lee approved the proposed copy and chose to give episode
  pages the same block ("Enjoyed this episode? Get the next one."). Button
  label left to Kit. Status moved to Implementing at Lee's request
  ("Implement it"); implemented on `main` (small template + CSS change).
* **2026-10-11** — Implemented: new `_partials/_article_subscribe.erb`
  (optional `heading` local, defaulting to the article heading), rendered by
  `_layouts/article.erb` and `_layouts/episode.erb` in place of the bare
  form; three new rules in `frontend/styles/index.css` using existing tokens
  only. Verified in a local build: 68 article pages and 5 episode pages carry
  the block, no page still has the bare form; desktop keeps Kit's
  side-by-side field+button; 375px phone width wraps cleanly with no
  horizontal scroll. Site has no dark mode, so that test is N/A.
* **2026-10-11** — Lee confirmed this work stays on mainline (no branch/PR).
  The site build was failing on five upcoming episodes whose slugs lack their
  category's ID prefix. At Lee's direction, the slug-prefix check was removed
  from `sai_podcast.rb` entirely — the prefix is a naming convention nothing
  on the site depends on, so it caught no real problem. The check that
  `category:` is one of the seven known labels stays, since that label is
  displayed. The real site now builds clean, with no warnings: 68 article pages and 10 episode pages carry the block.
