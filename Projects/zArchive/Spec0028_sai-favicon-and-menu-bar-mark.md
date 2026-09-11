# SAI favicon and menu-bar mark: thicker conductor that reads at small sizes

* **ID:** Spec0028
* **Status:** Implementing
* **Date Created:** 2026-09-11
* **Date Implemented:**
* **Systems Impacted:** SoftwareArchitectureInsights

---

## Problem/Requirement

The SAI site's favicon and menu-bar mark are drawn from the thin line-art
conductor. At the sizes they are shown, the lines nearly disappear:

- **Favicon.** At 16 and 32 px (browser tabs) the current icons are a few faint
  dots, in both light and dark tabs.
- **Menu-bar mark.** `Shared::Navbar` shows the full square logo
  (`/images/brand/sai-square-conductor.svg`: conductor, podium, and the words
  "Software Architecture Insights") at 36 × 36 CSS px (`.nav-brand-mark`).
  The figure is faint, and the logo's own text is unreadable and duplicates the
  site title rendered right beside it.

Lee chose replacements on 2026-09-11 (podcast planning session, see
`assets_inbox/brand-mark/favicon-mockups.png` and `nav-mark-mockup.png`).

---

## Solution/Fix/Change

New artwork is ready in **`SoftwareArchitectureInsights/assets_inbox/brand-mark/`**
(see its `README.md`). It is the same conductor from
`src/images/brand/conductor-illustration-tall.png`, cropped tight to head, raised
arm and baton, with lines thickened more at smaller sizes.

**Decided (Lee, 2026-09-11):**

1. **Favicon: the "Blue" version.** Paper-colored conductor (#F6F3EC) on brand
   blue (#1E5FA8). Same palette as the site with the roles swapped; it matches
   the podcast show art. Replace, same filenames:
   - `src/favicon.ico` (16/32/48 in one file)
   - `src/favicon-16x16.png`, `src/favicon-32x32.png`, `src/favicon-48x48.png`
   - `src/favicon-192x192.png`
   - `src/apple-touch-icon.png` (180)
   - `src/icon-512.png`
2. **Menu-bar mark: brand-blue conductor on transparent,** no box and no text,
   sitting directly on the paper menu bar next to the site title. Add
   `assets_inbox/brand-mark/sai-nav-mark.png` (108 × 108, i.e. 3× the 36 px
   display size) to `src/images/brand/`, and point `navbar.erb`'s
   `nav-brand-mark` image at it instead of `sai-square-conductor.svg`. Keep the
   36 px CSS size.

`sai-square-conductor.svg` stays in the repo; it is only no longer used by the
navbar. Nothing else in `src/` references it or the 16/48/192/512 icons today
(`_head.erb` links only `favicon.ico`, `favicon-32x32.png`, and
`apple-touch-icon.png`).

---

## Testing

- Build and open the site: the tab shows the blue conductor in a light and a
  dark browser theme.
- Menu bar at desktop and phone widths: mark is crisp (check on a high-resolution
  screen), aligned with the title, no box around it.
- `favicon.ico` loads (request `/favicon.ico` directly).
- Browsers cache favicons hard: test in a private window.

---

## Summary of Steps Needed

2. Copy the seven favicon files from `assets_inbox/brand-mark/` over the ones in `src/`.
3. Copy `sai-nav-mark.png` to `src/images/brand/`; update `navbar.erb`.
4. Test as above.

---

## Open Questions

1. ~~**Web app manifest.**~~ **Decided (Lee, 2026-09-11): skip it.** The 192 and
   512 icons are replaced but no `site.webmanifest` is added; iPhones use
   `apple-touch-icon.png` for home-screen icons.
2. ~~**Kit.**~~ **Decided (Lee, 2026-09-11): no change.** The email header is not
   affected by this change, and the Kit-hosted website is no longer used, so its
   favicon is irrelevant.

---

## History of Updates

* **2026-09-11** — Spec created from the SAI podcast planning session. Lee chose
  the "Blue" favicon and a transparent brand-blue menu-bar mark from mockups;
  all artwork placed in `SoftwareArchitectureInsights/assets_inbox/brand-mark/`
  for implementation.
* **2026-09-11** — Lee resolved Open Question 2: leave Kit's favicon and email
  header alone.
* **2026-09-11** — Lee resolved Open Question 1: no web app manifest. All Open
  Questions resolved.
* **2026-09-11** — Implemented: copied the seven favicon files and
  `sai-nav-mark.png` from `assets_inbox/brand-mark/` into `src/`, and updated
  `navbar.erb` to reference `sai-nav-mark.png` instead of
  `sai-square-conductor.svg`. Verified with a full site build and a dev-server
  smoke test (home page, `favicon.ico`, `favicon-32x32.png`,
  `apple-touch-icon.png`, and the nav mark all serve 200; nav mark renders at
  108×108 RGBA transparent, displayed at the existing 36px CSS size).
