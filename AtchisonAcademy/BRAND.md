# Atchison Academy — Brand Instructions for Website Construction

**Audience: an AI coding agent building the Atchison Academy website.** Read this before writing any
markup, CSS, or component. It tells you what the brand is, which files to use, and — importantly —
what *not* to invent.

**Source of truth:** `Marketing/Brand/_Brand Assets.md` in the Atchison Academy folder. This file is
the web-specific instruction set derived from it. If the two ever disagree, `_Brand Assets.md` wins
and this file needs updating.

> **How to use this file.** Copy it into the website repo — `BRAND.md` at the root works — and add a
> line to the repo's `CLAUDE.md` pointing at it, so it loads on every session rather than only when
> someone remembers to paste it:
>
> ```
> Brand, color, typography and logo rules: see BRAND.md. Follow it exactly; do not invent brand values.
> ```
>
> Copying it in beats pasting it into a chat: it stays with the project, and it gets reviewed in a
> diff when it changes.

---

## 0. Rules that override everything else

1. **Do not invent brand values.** No new colors, no new fonts, no new logo variants, no tagline. If
   this document doesn't give you a value, it doesn't exist yet — say so and ask.
2. **Do not modify the logo.** Never recolor it, never re-add a drop shadow, never stretch, rotate,
   outline, or apply effects. Use the supplied file for the situation.
3. **Do not use a color as text without checking §2's table.** Three of the brand colors fail on
   white and will silently produce unreadable type. The table says which.
4. **Copy the asset files into the repo.** Do not hotlink to Dropbox and do not regenerate the logo
   from scratch. §4 lists exactly what to copy.
5. **Everything must pass WCAG AA.** Every pairing in §2 is pre-checked. If you need a combination
   that isn't listed, compute the ratio and state it — do not guess.

---

## 1. What this site is

Atchison Academy is Lee Atchison's own course business — software architecture and cloud computing
courses he sells himself, alongside his platform courses (Coursera, O'Reilly, Pluralsight) and four
books. Site pages will include a **course listing**, **course detail**, and an
**enrollment/waitlist** flow.

**Tone of the design:** credible, technical, uncluttered. This is a practitioner selling expertise to
other practitioners — architects, staff engineers, engineering leaders. Not a bootcamp, not a
consumer ed-tech product. Restraint reads as competence here; decoration does not.

✅ **The domain question is SETTLED, and both sites exist**
*(corrected 2026-09-04 — this file previously said it was undecided, which was wrong)*:

| Domain | What it is | Runs on |
|---|---|---|
| **`atchisonacademy.com`** | The Academy's public site — marketing and sales pages | Bridgetown on Netlify |
| **`courses.atchisonacademy.com`** | Course delivery — the courses and their lessons, and the domain the Vimeo embed lock is set to | **Cedarras**, since 2026-09-20 |

⚠️ **Only the marketing site is Lee's to design.** The course site is Cedarras's own interface, so
nothing in this file styles it.

⚠️ **`leeatchison.com` is Lee's personal/professional site. Academy pages do not go there.**

---

## 2. Color

### CSS custom properties — copy this block verbatim

```css
:root {
  /* Core — from the logo */
  --aa-deep:        #0F3D91;  /* primary: headings, links, primary button      */
  --aa-blue:        #1E66D0;  /* secondary: sub-heads, active states           */
  --aa-sky:         #49B3FF;  /* DARK GROUNDS ONLY                             */

  /* Accent — teal */
  --aa-teal:        #0C7375;  /* the text-safe teal, for light grounds         */
  --aa-teal-light:  #20C7C9;  /* dark grounds only. NOT a text color on white  */
  --aa-cyan:        #73E0FF;  /* decorative on dark                            */

  /* Emphasis — amber, the only warm color in the system */
  --aa-amber:       #96560B;  /* amber as TYPE                                 */
  --aa-amber-fill:  #F2A93B;  /* amber as FILL. Never as type on white         */

  /* Neutrals */
  --aa-ink:         #262626;  /* body text                                     */
  --aa-ink-muted:   #5A6472;  /* captions, metadata                            */
  --aa-night:       #0A1B3A;  /* dark ground: footer, dark sections            */
  --aa-night-2:     #12294F;  /* dark gradients, dark cards                    */

  /* Surfaces */
  --aa-white:       #FFFFFF;
  --aa-tint-1:      #F4F8FE;  /* page / section background                     */
  --aa-tint-2:      #E6EFFB;  /* callouts, table stripes                       */
  --aa-rule:        #CFE0F5;  /* hairlines. NEVER type                         */
  --aa-rule-strong: #9CBDE4;  /* hairlines that must read on a tinted ground   */
}
```

### ⚠️ The three colors that are not text colors on white

This is the single easiest way to ship something unreadable. Memorize it:

| Color | On white | Why it's a trap |
|---|---|---|
| `--aa-teal-light` `#20C7C9` | **2.08** ✗ | It's the logo's own teal, so it *feels* like the brand teal. For type on light, use `--aa-teal` `#0C7375` |
| `--aa-sky` `#49B3FF` | **2.29** ✗ | Fine on `--aa-night`. Never on white |
| `--aa-amber-fill` `#F2A93B` | **2.00** ✗ | It's a **fill**. For amber type, use `--aa-amber` `#96560B` |

### Pre-checked pairings — use these without recomputing

| Foreground | Background | Ratio | Use for |
|---|---|---|---|
| `--aa-ink` | `--aa-white` | 15.13 AAA | Body text |
| `--aa-ink` | `--aa-tint-1` | 14.20 AAA | Body on tinted sections |
| `--aa-deep` | `--aa-white` | 10.02 AAA | Headings, links |
| `--aa-deep` | `--aa-tint-1` | 9.40 AAA | Headings on tinted sections |
| `--aa-deep` | `--aa-tint-2` | 8.63 AAA | Headings in callouts |
| `--aa-white` | `--aa-deep` | 10.02 AAA | **Primary button** |
| `--aa-white` | `--aa-blue` | 5.43 AA | Secondary button |
| `--aa-ink` | `--aa-amber-fill` | 7.58 AAA | **CTA button** — see below |
| `--aa-ink-muted` | `--aa-white` | 6.00 AA | Captions, metadata |
| `--aa-ink-muted` | `--aa-tint-1` | 5.63 AA | Captions on tint |
| `--aa-teal` | `--aa-white` | 5.64 AA | Secondary links, bylines |
| `--aa-teal` | `--aa-tint-1` | 5.29 AA | Same, on tint |
| `--aa-amber` | `--aa-white` | 5.78 AA | Amber as type |
| `--aa-white` | `--aa-night` | 17.06 AAA | Dark sections, footer |
| `--aa-cyan` | `--aa-night` | 11.24 AAA | Accent on dark |
| `--aa-sky` | `--aa-night-2` | 6.30 AA | Links on dark cards |
| `--aa-amber-fill` | `--aa-night` | 8.54 AAA | CTA on a dark section |

### The CTA button — this one is specified, don't redesign it

**`--aa-amber-fill` background, `--aa-ink` text.** 7.58:1.

Amber exists in this palette for exactly one reason: the logo is entirely blue and cyan, so nothing
in it can mean *this is the action*. Amber is that signal, and it stops working the moment it's used
for anything else.

**Use amber only for the primary conversion action** — "Get the course", "Enroll", "Join the
waitlist". One per page, ideally one per screen. Everything else that needs to look clickable uses
`--aa-deep` (solid) or a `--aa-deep` outline.

### Color hierarchy in one sentence

Blue is structure, teal is supporting detail, amber is the action, ink is what people read.

---

## 3. Typography

```css
--aa-font: "Aptos Display", "Aptos", "Carlito", "Calibri",
           "Segoe UI", "Helvetica Neue", Arial, sans-serif;
```

**Aptos Display is the brand face.** It ships with Microsoft Office, so Lee has it and most visitors
will not. **Self-host Carlito** as the web fallback — it's open-licensed, metric-compatible with
Calibri, and from the same design lineage as Aptos. Without it, the stack falls to Helvetica/Arial
and the site stops looking related to the slides.

- Self-host Carlito Regular + Bold as WOFF2. Do not load it from a third-party CDN.
- `font-display: swap`.
- Set `--aa-font` on `html` and let everything inherit. No per-component font declarations.

**Weights:** 400 body, 600 sub-heads, 700 headings and the wordmark. Do not use ultralight or black.

**No monospace face has been chosen.** If the site needs code samples, use a system mono stack
(`ui-monospace, SFMono-Regular, Menlo, Consolas, monospace`) and flag that a real choice is
outstanding — do not pick one and treat it as brand.

---

## 4. Logo — which file, where

**Copy these from `Marketing/Brand/` into the repo** (suggested: `/public/brand/`):

| Source | Use it for |
|---|---|
| `Logo/Atchison Academy Lockup Horizontal Outlined.svg` | **Site header.** Outlined = no font dependency, renders identically everywhere |
| `Logo/Atchison Academy Lockup Horizontal Reverse Outlined.svg` | Header or footer on a dark ground |
| `Logo/Atchison Academy Lockup Stacked Outlined.svg` | Narrow columns, square spaces, social cards |
| `Logo/Atchison Academy Mark.svg` | The mark alone at **128px or larger** |
| `Logo/Atchison Academy Mark Small.svg` | The mark at **32–128px** |
| `Logo/Atchison Academy Mark Mono.svg` | **32px and below**, and anywhere one flat color is needed |
| `Web/favicon.ico` | 16/32/48/64px favicon |
| `Web/apple-touch-icon-180.png` | `<link rel="apple-touch-icon">` |

### ⚠️ Always use the `Outlined` lockups on the web

Both lockups ship twice. The plain `.svg` files carry **live text** in Aptos Display — correct on
Lee's machine, wrong for visitors who don't have the font, because the wordmark reflows. The
`Outlined` versions are vector paths and render identically for everyone. **On the web, always use
`Outlined`.**

### Size rules — these are not stylistic

The mark packs four ideas into one shape (shield, architectural A, network nodes, open book), so it
does not survive being scaled down. This was tested at every size:

| Size | File | What happens if you use the wrong one |
|---|---|---|
| ≥128px | `Mark.svg` | — |
| 32–128px | `Mark Small.svg` | The full mark's book turns into a smudge and its nodes into noise |
| ≤32px | `Mark Mono.svg` | The full mark stops being a recognizable shape entirely |

**Clear space:** at least **25% of the mark's height** on all four sides. Nothing intrudes — not
text, not a viewport edge, not another logo.

**Minimum sizes:** horizontal lockup 180px wide; stacked lockup 120px wide; mark alone 16px using
the mono variant.

### Never

- Recolor the gradient. One flat color? That's what `Mark Mono.svg` is for (it uses
  `fill="currentColor"`, so set `color:` in CSS).
- Put the full mark on a mid-tone blue. Its own gradient runs `#0F3D91 → #49B3FF` and it vanishes
  into anything in that range. Safe grounds: white, `--aa-tint-1`, `--aa-night`.
- Re-add a drop shadow.
- Set the wordmark in any font other than Aptos Display — which is why you use the outlined file.

---

## 5. Backgrounds and imagery

`Backgrounds/` holds a matched dark and light 16:9 pair. **These are designed for slides and the
Streamyard backdrop, not for web hero sections.** Their composition assumes a 16:9 frame with the
mark top-left and a clear right third.

**Do not stretch them across a hero band.** If a hero needs a background, build one in CSS from the
tokens — a `--aa-tint-1 → --aa-tint-2` gradient, or `--aa-night → --aa-night-2` for a dark section.
That scales to any viewport; a 16:9 raster does not.

**Lee prefers light backgrounds.** That's his standing choice for videos and webinars, and the site
should follow: light ground by default, dark reserved for a footer or a deliberate section break.

**Artwork style**, if the site carries illustrations:

> Warm editorial illustration, clean lines, muted palette that sits beside `--aa-deep` and
> `--aa-teal-light` on white. **No text baked into the image.** Landscape, roughly 2:1 to 1:1, at
> least 1600px wide.

⚠️ **Do not reuse artwork from the Coursera courses.** It was generated against a rust-orange accent
that isn't in this palette and will read as a different brand.

**No Open Graph image exists yet.** If the site needs one, build it from the tokens and the stacked
lockup, then tell Lee it should be added to `Marketing/Brand/` — don't leave it only in the repo.

---

## 6. Components — the specified ones

**Links** (body copy): `--aa-deep`, underlined. Hover: `--aa-blue`. Don't remove the underline in
running text.

**Buttons:**

| Kind | Fill | Text | When |
|---|---|---|---|
| CTA | `--aa-amber-fill` | `--aa-ink` | The conversion action. One per screen |
| Primary | `--aa-deep` | `--aa-white` | Main navigation actions |
| Secondary | transparent, 2px `--aa-deep` border | `--aa-deep` | Everything else |

**Focus rings are mandatory.** 2px `--aa-blue` with a 2px offset, on every interactive element.
Never `outline: none` without a visible replacement.

**Cards** (course listing): `--aa-white` on a `--aa-tint-1` page, 1px `--aa-rule` border. On a
tinted ground use `--aa-rule-strong` — `--aa-rule` is deliberately faint and disappears on tint.

**Callouts:** `--aa-tint-2` background, `--aa-deep` heading, `--aa-ink` body.

**Dark sections / footer:** `--aa-night` background, `--aa-white` text, `--aa-cyan` or `--aa-sky`
for links, the Reverse lockup.

---

## 7. Dark mode

**Optional — ask Lee before building it.** The palette supports it (that's what the Night tokens
are for), but nobody has decided whether the site needs it, and a half-built dark mode is worse than
none.

If it's approved: `--aa-night` becomes the page ground, `--aa-white` the body text, `--aa-sky` and
`--aa-cyan` take over from `--aa-deep` and `--aa-teal` for links, `--aa-amber-fill` stays the CTA
(8.54:1 on night). Swap to the Reverse lockups. Define the light palette on bare `:root` and
override only what changes.

---

## 8. Accessibility floor

- WCAG **AA** minimum, everywhere. §2's table is pre-checked; anything else, compute and state it.
- Visible focus on every interactive element.
- Real semantic headings in order. Don't fake a heading with a styled `div`.
- `alt` text on the logo: **"Atchison Academy"**. Decorative marks get `alt=""`.
- Don't rely on color alone to carry meaning.
- Respect `prefers-reduced-motion`.

---

## 9. Still undecided — ask, don't invent

| | Status |
|---|---|
| ~~Domain / hosting~~ | ✅ **CLOSED.** Both addresses and the mechanism are settled — see §1. Marketing is Bridgetown on Netlify, courses are Cedarras, video is Vimeo, checkout is Kit (`Course Delivery.md`) |
| Tagline | **None exists.** Do not write one |
| Icon set | **Not built.** If icons are needed, propose an approach — don't mix in a random icon library |
| Monospace face | **Not chosen.** System stack for now |
| Open Graph image | **Not built** |
| Dark mode | **Not decided** |

---

*Derived from `Marketing/Brand/_Brand Assets.md`, 2026-08-26. Update both together.*
