# Rework the Academy courses hero, and give Academy-native courses a platform

* **ID:** Spec0011
* **Status:** Implementing
* **Date Created:** 2026-08-29
* **Date Implemented:** 2026-08-29
* **Systems Impacted:** `AtchisonAcademy`, `LeeAtchison`, `shared/`

---

## Problem/Requirement

### 1. The courses hero links to one of three platforms

`AtchisonAcademy/src/courses.erb` opens with a hero that carries exactly one
outbound button:

```erb
<div class="btn-group" style="justify-content:flex-start; margin-top:1.5rem;">
  <a href="https://www.linkedin.com/learning/instructors/lee-atchison"
     class="btn btn-outline" target="_blank" rel="noopener noreferrer">LinkedIn Learning</a>
</div>
```

Three platforms deliver courses on this page — Coursera, LinkedIn Learning, and
O'Reilly Media — and only one of them is linked. Either all three belong there or
none do.

**Where the asymmetry came from.** It is not a decision; it is a leftover.
`git log --follow` shows this file has been touched three times, and the button is
present in the first of them, `0a34f98` (Spec0005, the commit that created the
standalone Academy site). The Academy courses page was adapted from
`LeeAtchison/src/courses.erb`, whose hero carries **two** buttons:

```erb
<a href="https://atchisonacademy.com" class="btn btn-primary">Atchison Academy &rarr;</a>
<a href="https://www.linkedin.com/learning/instructors/lee-atchison" class="btn btn-outline">LinkedIn Learning</a>
```

On leeatchison.com that pair makes sense: it is a personal site pointing at the two
places Lee's courses live. Spec0005 correctly dropped the "Atchison Academy →"
button — you are already there — and carried the second one across unexamined. What
survived is half of a link pair whose other half no longer applied.

Spec0005 knew it was provisional. Its image manifest lists the asset as
`linkedin-learners-badge.png | courses.erb hero, **if that block is kept** | copy`.
The block was kept by default, and the question it was hedging has been open since.

### 2. The badge is a bigger problem than the button

The button sits in a two-column hero beside `courses-hero-badge`, which renders
`/images/linkedin-learners-badge.png` at 160×160 (source is 400×400). The button is
effectively that badge's caption — which is why Coursera and O'Reilly have no
natural place in this hero, and why adding two more buttons would not restore
symmetry so much as create a new one.

Inspecting the asset turned up four separate problems, none of which is about
platform parity:

- **It is opaque.** The PNG is mode `RGB` with no alpha channel, on a cream ground
  (`#FDF9F6`). `.collection-hero` is a `linear-gradient(140deg, var(--navy), var(--navy-mid), var(--blue))`.
  So the badge renders today as a **cream square block sitting on a navy gradient**,
  with a `drop-shadow` filter applied to what is effectively a rectangle. This is a
  live visual defect, not a hypothetical.
- **It is off-palette.** The rosette is terracotta and salmon (roughly `#B5432A` /
  `#E8917A`). The Academy's token set is navy `#0f2942`, navy-mid `#1a3f6b`, blue
  `#1e5fa8`, teal `#06b6d4`. Nothing in the badge is in the site's palette, because
  it is LinkedIn's artwork, not the Academy's.
- **The figure is stale.** The badge reads `100,000`. `LeeAtchison/src/courses.erb`
  states "over 160,000 professionals worldwide" in prose on the equivalent page.
- **The copy is singular.** "learners have taken **my course**" — on a page listing
  ten of them.

Taken together, a LinkedIn-branded rosette is also the one element that most implies
LinkedIn Learning is this page's home platform, which is precisely the confusion the
button raises. Removing the button and leaving the badge would fix the smaller half.

**All four defects apply equally to `LeeAtchison/src/courses.erb`**, which renders its
own copy of the same file through a byte-identical CSS rule against a byte-identical
hero gradient — and where the stale-figure problem is sharpest, since that page's
prose says "over 160,000 professionals worldwide" in the paragraph directly beside a
badge reading `100,000`. Neither number is current: Lee's figure as of 2026-08-29 is
**180,000+**. See §6 for the full inventory of where it appears.

### 3. Nothing non-subscription is actually available yet

The natural follow-on — "if all three platforms are linked, make it very clear there
are courses here that need no subscription" — cannot be honored today, because
there are none.

Sixteen resources live in `shared/_courses/`. Ten carry `show_academy: true` and
survive a production build. Every one of them that a reader can actually take is on
a third-party subscription platform:

| Order | Course | Platform | State |
|---|---|---|---|
| 1 | Cloud Architecture for Scalable Systems | Coursera | live, featured |
| 2 | Scalable Availability in Software Architecture | Coursera | live, featured |
| 3 | Software Architecture: From Developer to Architect | LinkedIn Learning | live, featured |
| 4 | Cloud Migration Fundamentals | O'Reilly Media | live, featured |
| 5 | Avoiding Bad Decisions in Your Cloud Strategy | LinkedIn Learning | live |
| 6 | Cloud Architecture: Advanced Concepts | LinkedIn Learning | live |
| 9 | Framing Cloud Discussions for the C-Suite | LinkedIn Learning | live |
| 11 | Understanding the Impact of a Merger for IT Teams | LinkedIn Learning | live |
| 12 | Architecting Systems That Use AI | — | `prelaunch` |
| 13 | Service Ownership and Criticality at Scale | — | `prelaunch` |
| 14 | Cloud Cost Architecture | — | `hidden: true` |
| 15 | Velocity-Safe Architecture | — | `hidden: true` |

The four Academy-native courses are the whole of the non-subscription story, and all
four are either `hidden: true` (dropped from production by Spec0010's builder) or
`availability: prelaunch` (a "Coming Soon" page that sends the reader to a webinar or
a diagnostic, not to a course). **Zero courses are currently purchasable or takeable
at atchisonacademy.com.** Copy promising otherwise would be a promise the page cannot
keep.

### 4. The access information already exists, in a better place

Spec0010 built exactly the mechanism this hero would be duplicating.
`shared/_data/platforms.yml` holds, per platform, an `access_note`, an `info_url` +
`info_label` pointing at that platform's pricing and free-trial page, and a
`cta_label`. `_layouts/course.erb` renders all of it twice per course page — hero and
footer — and each card in `courses.erb` carries a `.course-card-platform` label.

So the site already answers "where does this live and what does it cost", per course,
at the moment the reader has chosen a course. Three buttons above the fold invert
that: they ask a visitor to pick a vendor before seeing a single course title, on the
one page whose job is to move them into the catalog below. It is a leak, not a
navigation aid.

### 5. Academy-native courses render an empty platform label

None of the four Academy-native courses carries a `platform:` key. Three templates
read that key directly into a label:

- `courses.erb` — `<span class="course-card-platform"><%= course.data.platform %></span>`
- `_layouts/course.erb` — `<span class="course-platform-badge"><%= data.platform || "Course" %></span>`
- `_layouts/course.erb` (More Courses strip) — `<span class="more-course-platform"><%= course.data.platform %></span>`

The two `prelaunch` courses are shielded — every one of those sites branches to a
"Coming Soon" badge first — but the two `hidden: true` courses are not. They are
`availability: available` by default, so they render an empty `<span>` in dev builds
and on Netlify deploy previews today, and would do so in production the moment either
draft ships. `.course-card-platform` is plain colored text inside a `gap: 0.5rem`
flex column, so an empty one collapses to a stray gap above the title rather than
anything obvious — it will not be noticed at launch, which is the problem.

`platforms.yml` already defines the value these courses want:

```yaml
"Atchison Academy":
  access_note: "Offered directly through Atchison Academy."
  info_url:    ~
  info_label:  ~
  cta_label:   "Get the Course"
```

No course uses it. It was written in Spec0010 in anticipation of this and never
wired up.

---

## Solution/Fix/Change

Four changes. Nothing here alters how any currently-live course renders.

### 1. Remove the outbound button from the Academy courses hero

Delete the `.btn-group` div from `AtchisonAcademy/src/courses.erb` entirely. No
Coursera button, no O'Reilly button, no LinkedIn Learning button. The asymmetry that
matters is between *three linked exits and one*, and it disappears when the count
goes to zero rather than to three.

`LeeAtchison/src/courses.erb` is **not** touched. Its two-button hero is correct for
that site: it points at the Academy and at LinkedIn Learning, which is where a visitor
to a personal site would want to be sent.

### 2. Revise the hero paragraph to carry the message the button was carrying

The paragraph absorbs the "several platforms are involved" fact and hands the
specifics off to the per-course pages, where they are accurate. The platforms are
deliberately **not** enumerated: naming the three live ones reads as a list of other
people's platforms on the Academy's own site, and naming four would include a
destination that does not exist yet.

> In-depth training on software architecture, cloud computing, and technology
> leadership, taught by Lee Atchison and delivered through Atchison Academy and its
> affiliated learning platforms. Every course page names the platform it is on and
> what getting in actually takes.

The first sentence is unchanged from today. The second is new, and is the whole of
the replacement for the button — it tells the reader the information exists and where
to find it, without spending a click to get there.

### 3. Replace the LinkedIn badge with a neutral reach badge — on **both** sites

Retire `linkedin-learners-badge.png` and put a platform-neutral reach badge in its
place on the Academy courses hero *and* on the `LeeAtchison` courses hero. This fixes
all four defects in Problem §2 at once and removes the last element implying LinkedIn
Learning is either page's home platform.

**One asset, used byte-identically on both sites.** The two heroes are already
identical in every dimension that matters: both `.collection-hero` rules are the same
`linear-gradient(140deg, var(--navy), var(--navy-mid), var(--blue))`, both sites
define `--navy: #0f2942`, `--navy-mid: #1a3f6b`, `--blue: #1e5fa8`, `--teal: #06b6d4`,
and both `.courses-hero-badge img` rules are the same 160×160 `object-fit: contain`
with the same `drop-shadow`. No per-site variant is needed.

**New asset — `learners-badge.png`:**

| Requirement | Value | Why |
|---|---|---|
| Dimensions | 400 × 400 | Matches the retired asset; CSS renders at 160×160 on both sites, so 2.5× for retina |
| Mode | **RGBA, transparent background** | The current badge is opaque `RGB` on cream and renders as a square block on the navy gradient. This is the requirement that must not be missed. |
| Palette | Site tokens — navy `#0f2942`, blue `#1e5fa8`, teal `#06b6d4`, white | Reads as Lee's own mark rather than a platform's, and holds contrast against the navy→blue hero gradient on both sites |
| Headline figure | **`180,000+`** | Lee's current figure, confirmed 2026-08-29. Supersedes the `160,000` published on `LeeAtchison`; see §6 for the other two places that number appears. |
| Sub-copy | plural, platform-neutral — e.g. "learners worldwide" | The retired badge reads "learners have taken my course", singular, on pages listing eight to sixteen of them |
| No third-party marks | — | No LinkedIn, Coursera or O'Reilly wordmark or logo |

**Placement.** Raw source into `AtchisonAcademy/assets_inbox/` per that directory's
convention (staging only, never referenced directly). The sized export is copied into
**both** `AtchisonAcademy/src/images/learners-badge.png` and
`LeeAtchison/src/images/learners-badge.png`.

Two copies, because `src/images/` is not symlinked between the sites — only `_books`,
`_courses` and `_data/platforms.yml` are shared — and Spec0005 established per-site
image copies as the pattern (`logo-academy.png` and `pets404.png` already live in
both). Symlinking a `shared/_images/` subtree was considered and rejected: it would
introduce a new shared-binary pattern for a one-file benefit, and unlike the
duplicated `SITES` registry these copies are inert — a badge that drifts is a badge
somebody edited on purpose. **Copy the same exported file to both paths; do not
re-export twice.**

Update the `<img>` in both `courses.erb` files to the new filename with alt text
matching the badge copy, and delete both copies of
`src/images/linkedin-learners-badge.png` once nothing references them.

**What does *not* change on `LeeAtchison`.** Its hero keeps both buttons —
"Atchison Academy →" and "LinkedIn Learning". That pair is correct on a personal
site: it points at the two places Lee's courses live, and the LinkedIn button there is
navigation, not a caption for the badge. Only the badge and its alt text change.
Solution §1 and §2 remain Academy-only.

**Sequencing.** The asset is Lee's to produce and the rest of the spec does not
depend on it. If it is not ready when the code work is, ship §1, §2, §4 and swap the
images in a follow-up commit rather than blocking — but do not ship §1 and §2 while
leaving the LinkedIn badge as the only thing left in the Academy hero, since that
makes the implication stronger, not weaker.

### 4. Give all four Academy-native courses `platform: Atchison Academy`, and guard it

Add the key to `shared/_courses/`:

- `architecting-systems-with-ai.md`
- `cloud-cost-architecture.md`
- `service-ownership.md`
- `velocity-safe-architecture.md`

No `platform_url` is added. Spec0010's `validate_availability!` explicitly forbids
`platform_url` on a `prelaunch` course, and the two hidden drafts have nowhere to
point yet either.

**Visible effect today: none.** The two prelaunch courses branch to "Coming Soon"
before the platform label in all three templates, and the prelaunch branches in
`course.erb` override `cta_label`, `access_note`, `info_url` and `info_label`, so the
new `platforms.yml` lookup is computed and discarded. The two hidden drafts pick up a
correct "ATCHISON ACADEMY" label in dev and preview builds instead of an empty span.
The value earns its keep at launch, when a course flips from `prelaunch` or `hidden`
to live and inherits a correct badge, access note and CTA label with no further edit.

**The guard.** Extend `validate_availability!` in **both** copies of
`plugins/builders/shared_content.rb` (`AtchisonAcademy/` and `LeeAtchison/`) so a
course with `availability: available` — the default when the key is absent — must
carry a `platform:`. A prelaunch course is exempt: it renders "Coming Soon"
everywhere and may legitimately not know its platform yet.

Both copies are required. Both sites read all sixteen course resources at `post_read`
and validate every one before the `show_` reject clause runs, so a rule added to only
one copy fails asymmetrically — a bad file would break the Academy build and pass the
LeeAtchison build, the confusing failure mode Spec0009's duplicated `SITES` note
already warns about.

This follows the fail-loud pattern Spec0010 established: the empty span is a silent
template no-op today, and the point of the validator is that the next Academy-native
course cannot reintroduce it.

Deliberately **not** added: a rule requiring `platform_url` on available courses. Both
hidden drafts legitimately have none — they are unfinished, not broken — and a rule
that fires on them would have to be worked around immediately.

### 5. Rewrite the `LeeAtchison` hero prose, and update the figure everywhere it appears

With the badge carrying the number, the `LeeAtchison` courses hero would state it
twice side by side. Drop it from the prose and let the badge carry it — which also
leaves the figure in one place per page instead of two, and that is the whole point,
because a repo-wide grep for `[0-9]{2,3},000` found it living in **four** spots at
**three** different values:

| File | Line | Today | Action |
|---|---|---|---|
| `AtchisonAcademy/src/courses.erb` | 19 | `100,000` (badge alt text) | New badge + alt text — §3 |
| `LeeAtchison/src/courses.erb` | 20 | `100,000` (badge alt text) | New badge + alt text — §3 |
| `LeeAtchison/src/courses.erb` | 13 | `over 160,000` (hero prose) | **Drop the figure** — below |
| `LeeAtchison/src/index.erb` | 146 | `160,000+` (`.stat-card` on the home page) | **Update to `180,000+`** — below |

**Hero prose (`LeeAtchison/src/courses.erb`).** Replace:

> Lee's courses have reached over 160,000 professionals worldwide, covering software
> architecture, cloud computing, and technology leadership.

with a version that carries no number, letting the badge beside it do that work:

> Lee's courses cover software architecture, cloud computing, and technology
> leadership, and are delivered through Atchison Academy and its affiliated learning
> platforms.

**Home page stat card (`LeeAtchison/src/index.erb:146`).** `160,000+` becomes
`180,000+`. Strictly this is outside the courses-hero scope, but it is the same claim
on the page one click upstream, and shipping a `180,000+` badge while the home page
says `160,000+` reproduces exactly the drift this spec exists to remove. The
surrounding `.stat-label` ("learners have taken Lee's courses") and `.stat-desc` are
unchanged.

**After this spec the figure lives in exactly two places** — the badge artwork (both
sites, one file) and the home-page stat card — and both are listed here, so the next
update has a checklist instead of a grep.

### 6. Complete the `LeeAtchison` home-page platform cards

`LeeAtchison/src/index.erb:156–175` renders a `.platform-cards` block under the
heading "Learn from a Master Architect" listing exactly two platforms —
**Atchison Academy** and **LinkedIn Learning**. Coursera and O'Reilly Media are
missing, though four of the ten live courses are on them, including both Coursera
courses, which are `order_academy` 1 and 2 and featured on the Academy.

This is the same asymmetry that prompted the spec, one page upstream. It resolves the
opposite way, and that difference is the point: **these cards are descriptive, not
outbound.** Each is a `<div>` — an icon, a name, a line of context — with no `href`
anywhere in the block. Nobody leaves the page by clicking one. The argument against
three buttons in the courses hero (§1) was that they are exits that ask a visitor to
choose a vendor before seeing a course; it does not apply to a static list whose only
job is to say where the work lives. An incomplete list here is simply inaccurate.

**Add two cards, and reorder.** Final order: Atchison Academy first (Lee's own), then
the three platforms alphabetically — Coursera, LinkedIn Learning, O'Reilly Media.

| Card | Icon | Sub-copy |
|---|---|---|
| Atchison Academy | `logo-academy.png` (existing `.platform-logo-wrap`) | Courses and training directly from Lee |
| Coursera | new inline SVG | The *Architecting Scalable Systems* specialization |
| LinkedIn Learning | existing inline SVG | Software architecture and cloud leadership courses |
| O'Reilly Media | new inline SVG | *Cloud Migration Fundamentals* |

**Icons, not logos.** The two new cards get inline SVGs in the existing
`.platform-icon-wrap` pattern — 24-unit viewBox, `fill: none`, `stroke: currentColor`,
`stroke-width: 2`, inheriting `stroke: var(--blue)` from the existing rule. This
matches how LinkedIn Learning is already drawn: the block ships exactly one real
logo, Lee's own. Using third-party wordmarks would mean shipping trademarked artwork,
introduce three more palettes into a section built on `--blue`, and make the Academy's
own logo the odd one out rather than the distinguished one.

**Sub-copy is shortened across all four**, including the two existing cards, so the
cards read as a set. The current LinkedIn line quotes a full course title in quotation
marks and the Academy line runs to nine words; at half width (see below) both wrap
badly.

**Layout.** `.platform-cards` is `display: flex; flex-direction: column; gap: 1rem`,
sitting in the `1.6fr` column of a `grid-template-columns: 1fr 1.6fr` section whose
`align-items: center` puts the stat card beside it. Four stacked cards add roughly
165px to that column and leave the stat card floating small against a much taller
stack. Change `.platform-cards` to a **2 × 2 grid** at desktop:

```css
.platform-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}
```

and add `.platform-cards { grid-template-columns: 1fr; }` to the existing breakpoint
at `frontend/styles/index.css:~1950` that already collapses `.courses-inner` to one
column, so the four cards stack on mobile as they do today.

At `--max-w: 1100px` the `1.6fr` column is roughly 640px, so a half-width cell gives
about 230px of text beside the 40px icon — which is why the sub-copy is shortened. If
the 2 × 2 still reads cramped when built, the fallback is a single column of four and
a taller section; that is a visual call to make against the running page, not from
the CSS. **Verify against `LeeAtchison/bin/dev` before settling.**

**Note.** The Atchison Academy card's copy ("courses and training directly from Lee")
has the same aspirational-claim problem as the rest of Problem §3 — nothing is
currently takeable there. It is left as-is here, and is covered by the §7 deferral.

### 7. Defer the no-subscription messaging

Nothing in this spec says "no subscription required", because nothing on the site
qualifies yet. The moment the first Academy-native course goes live, the page needs a
deliberate answer to: does a directly-offered course get visual separation from the
platform courses, its own section, a price, or just a badge that reads differently?
That is a real question with a real answer, and it is not answerable before there is
a course to answer it about.

Record it in `Projects/_Projects.md` under **New Items Needing Specs/Bugs** at this
spec's archival, so it surfaces at launch rather than being rediscovered then.

---

## Testing

Manual, on the Academy dev server (`AtchisonAcademy/bin/dev`, port 16000 on main):

1. **`/courses/` hero** — eyebrow, headline, revised paragraph and the new badge, with
   no button and no leftover `.btn-group` whitespace above the badge. The two-column
   `courses-hero-content` grid still balances at desktop width; the single-column
   mobile stack is unaffected.
2. **The badge's transparency, specifically** — view the hero against the navy→blue
   gradient and confirm no cream or white rectangle behind the mark, and that the
   `drop-shadow(0 4px 16px rgba(0,0,0,0.3))` filter now traces the badge's shape
   rather than a square. This is the defect the replacement exists to fix; check it
   at 160px rendered, not just in an image viewer.
3. **Card labels** — Cloud Cost Architecture and Velocity-Safe Architecture (visible
   in dev, since `hidden?` only fires in production) now show an `ATCHISON ACADEMY`
   label where they previously showed an empty span with a stray gap. The two
   prelaunch cards still show `Coming Soon`. The eight live platform cards are
   unchanged.
4. **Course pages** — `/courses/cloud-cost-architecture/` and
   `/courses/velocity-safe-architecture/` show the `Atchison Academy` platform badge
   and the "Offered directly through Atchison Academy." access note with no trailing
   info link (`info_url` is `~`). `/courses/service-ownership/` and
   `/courses/architecting-systems-with-ai/` are byte-for-byte unchanged — the check
   that proves the prelaunch branches still win.
5. **More Courses strip** — the four-card strip at the foot of any course page labels
   Academy-native courses correctly.
6. **Both builds pass** — `AtchisonAcademy/bin/dev` and `LeeAtchison/bin/dev` both
   boot, proving the new validator is satisfied by all sixteen files in both copies.
7. **The validator actually fires** — temporarily strip `platform:` from one live
   course (e.g. `framing-cloud-discussions-c-suite.md`) and confirm *both* sites fail
   the build with the new message; restore it. A guard never seen to fail is not a
   guard.
8. **`LeeAtchison` `/courses/`** — the new badge renders there too, transparent
   against the same gradient; the hero prose no longer states a figure; and **both**
   hero buttons ("Atchison Academy →" and "LinkedIn Learning") are still present and
   unchanged. Confirm the two sites' badges are the same file:
   `cmp AtchisonAcademy/src/images/learners-badge.png LeeAtchison/src/images/learners-badge.png`
   exits clean.
9. **`LeeAtchison` home page** — the `.stat-card` in the `#courses` section reads
   `180,000+`, and its layout is undisturbed by the extra digit at every breakpoint
   (`.stat-number` is the widest element in that card).
10. **`LeeAtchison` home-page platform cards** — four cards in the order Atchison
    Academy, Coursera, LinkedIn Learning, O'Reilly Media; the two new icons stroke in
    `var(--blue)` like the existing one; no third-party wordmark anywhere in the
    block. Check the 2 × 2 grid at desktop against the stat card beside it — the
    section should read balanced, not top-heavy — then narrow the window through the
    breakpoint and confirm the cards collapse to one column with no orphaned cell.
    Sub-copy fits without awkward wrapping in a half-width cell at 1100px.
11. **Figure sweep** — `grep -rnE "[0-9]{2,3},000" */src shared/` returns exactly one
    hit, `LeeAtchison/src/index.erb`, at `180,000+`. Any other hit means a spot was
    missed. Also confirm no badge alt text still says `100,000`.
12. **No dangling reference** — grep the repo for `linkedin-learners-badge` and confirm
    the only remaining hits are in archived specs; both `src/images/` copies are gone.
13. **Production parity** — `bridgetown build` with `BRIDGETOWN_ENV=production` on the
    Academy still emits ten course pages, the two hidden drafts still absent.

---

## Summary of Steps Needed

1. **Asset (Lee):** produce the neutral badge to the §3 table's spec, headline figure
   `180,000+`. Raw into `AtchisonAcademy/assets_inbox/`; 400×400 RGBA export copied to
   **both** `AtchisonAcademy/src/images/learners-badge.png` and
   `LeeAtchison/src/images/learners-badge.png` (same file, copied — not exported twice).
2. `AtchisonAcademy/src/courses.erb` — delete the hero `.btn-group`; revise the hero
   paragraph; point the `<img>` at the new badge with matching alt text.
3. `LeeAtchison/src/courses.erb` — point the `<img>` at the new badge with matching alt
   text; replace the hero paragraph with the number-free version in §5.
   **Leave both hero buttons alone.**
3a. `LeeAtchison/src/index.erb:146` — `.stat-number` `160,000+` → `180,000+`.
3b. `LeeAtchison/src/index.erb:156–175` — add Coursera and O'Reilly Media
   `.platform-card` entries with new inline SVG icons, reorder to Academy → Coursera →
   LinkedIn Learning → O'Reilly, and shorten all four sub-copy lines per §6.
3c. `LeeAtchison/frontend/styles/index.css` — `.platform-cards` to a 2 × 2 grid
   (line ~645), plus a one-column override in the existing breakpoint at ~line 1950.
4. Delete `AtchisonAcademy/src/images/linkedin-learners-badge.png` and
   `LeeAtchison/src/images/linkedin-learners-badge.png`.
5. `shared/_courses/architecting-systems-with-ai.md`, `cloud-cost-architecture.md`,
   `service-ownership.md`, `velocity-safe-architecture.md` — add
   `platform: Atchison Academy`.
6. `AtchisonAcademy/plugins/builders/shared_content.rb` and
   `LeeAtchison/plugins/builders/shared_content.rb` — extend `validate_availability!`
   to require `platform` on non-prelaunch courses; keep the two copies identical.
7. `AtchisonAcademy/CLAUDE.md` (`src/images/` manifest, ~line 72) and
   `LeeAtchison/CLAUDE.md` (~line 63) — update both image manifests for the badge swap.
   Note in the Academy's collections section that a non-prelaunch course must carry
   `platform:` and that `Atchison Academy` is a valid value; mirror into
   `LeeAtchison/CLAUDE.md` if that file documents the same key set.
8. Run the testing steps above on both dev servers.
9. At archival: add the no-subscription launch-messaging item from §5 to
   `Projects/_Projects.md`.

---

## Open Questions

1. **Should the hero paragraph name the platforms?** ~~Enumerate, or not.~~
   **Decided 2026-08-29 (Lee): do not enumerate.** The copy in §2 stands. Naming the
   three live platforms reads as a list of other people's platforms on the Academy's
   own site; naming four would include a destination that does not exist yet.
   Revisit when an Academy-native course is live and the fourth item earns its place.

2. **Does the LinkedIn badge stay?** ~~Keep it as a credential, or replace it.~~
   **Decided 2026-08-29 (Lee): replace it with a neutral reach badge.** See §3. The
   decision was taken before the asset was inspected; inspection then found the badge
   is an opaque RGB PNG rendering as a cream square on the navy gradient, is entirely
   off-palette, states a figure 60,000 short of the one used on leeatchison.com, and
   reads "my course" singular. The decision holds and its justification is now much
   stronger than the parity argument that prompted it.

3. **Which courses get `platform: Atchison Academy`?** ~~All four, or only the two
   hidden drafts.~~ **Decided 2026-08-29 (Lee): all four.** Changes nothing visible on
   the prelaunch pair today and guarantees nothing is forgotten when they launch.

4. **What figure goes on the new badge?** ~~`160,000+`, or wording that does not pin
   a number.~~ ~~Decided 2026-08-29 (Lee): `160,000+`.~~ **Revised same day (Lee):
   `180,000+`** — he checked the current number. Every published instance of the old
   figure is inventoried and corrected in §5.

5. **Does the `LeeAtchison` hero prose still say the number?** ~~Leave both, or let
   the badge carry it alone.~~ **Decided 2026-08-29 (Lee): rewrite the prose to drop
   the figure.** See §5 for the replacement copy. This proved more valuable than the
   redundancy argument alone suggested: with the number gone from that sentence, the
   figure survives in exactly two maintained places instead of four, which is what
   made the jump to `180,000+` a two-line change rather than a hunt.

---

## History of Updates

**2026-08-29 — Spec created.** Raised by Lee: the Academy courses hero links to
LinkedIn Learning but not to Coursera or O'Reilly; either all three should be linked
or none should be, and if all three are linked the page should also make clear that
some courses need no subscription. Lee's own framing was that he was unsure which way
to go and asked whether the three-link option adds confusion.

Research on the repo turned up three facts that reframed the question:

- The button is **provenance, not a decision** — `git log --follow` puts it in
  `0a34f98` (Spec0005), carried over from the two-button `LeeAtchison` hero when the
  Academy site was split out. The matching "Atchison Academy →" button was correctly
  dropped; this one was not examined. Spec0005's own image manifest hedged it as
  "if that block is kept".
- The "courses here need no subscription" message **cannot be honored today**. All
  four Academy-native courses are `hidden: true` or `prelaunch`; every takeable
  course on the site is on a third-party subscription platform.
- The access information the three buttons would provide **already exists per course**,
  via Spec0010's `platforms.yml` + `course.erb` access notes and pricing links —
  delivered after the reader picks a topic, which is the right order.

Options considered: (a) drop the button; (b) drop the button and add a non-linked
provenance line naming all four destinations; (c) add Coursera and O'Reilly buttons
plus non-subscription copy; (d) treat it as a broader Academy-wide access-messaging
project. **Lee chose (a).** (b) was carried as the alternative copy in Open Question 1
and closed against; (c) was argued against on the grounds that three outbound exits
above the fold ask a visitor to choose a vendor before seeing a course title, and its
non-subscription half would be aspirational; (d) was judged premature until a
directly-offered course exists, and is deferred to `_Projects.md` per §5.

The empty-platform-label defect (Problem §5) was found while tracing the same
templates and **Lee chose to include it** rather than track it separately — it shares
the files, and `platforms.yml` has carried an unused `"Atchison Academy"` entry since
Spec0010 waiting for exactly this. The build-time guard is proposed as part of it,
following Spec0010's fail-loud validator pattern.

**2026-08-29 — Open Questions 1–3 answered by Lee; §3 rewritten; scope grew.**
Q1 → do not enumerate. Q3 → all four courses. Q2 → **replace the badge**, which was
the one answer that moved scope: the spec had proposed keeping it.

Inspecting the asset to write the replacement requirement then found four defects
that had not been visible from the templates alone, recorded in Problem §2. The
decisive one: the PNG is mode `RGB` with no alpha on a cream ground, so it has been
rendering as a **cream square on the navy hero gradient** since Spec0005 shipped —
a live visual bug nobody had filed. It is also off-palette, shows `100,000` against
the `160,000` used on leeatchison.com, and reads "my course" singular on a page
listing ten. What began as a parity question turned out to be sitting on top of a
straightforward asset defect.

Consequences: §3 became an asset specification rather than a one-line keep;
`LeeAtchison`'s separate copy of the badge was ruled deliberately out of scope with
its own `_Projects.md` follow-on; a sequencing note was added so the code work is not
blocked on the asset; two testing steps (2 and 9) and a new Open Question 4 (the
figure) were added. Systems Impacted is unchanged.

**2026-08-29 — Badge change extended to `LeeAtchison`; Open Question 4 answered.**
Lee approved the badge replacement and directed that it apply to leeatchison.com as
well, reversing the previous entry's decision to scope it to the Academy alone. The
earlier reasoning — that a LinkedIn badge beside a LinkedIn button is coherent on a
personal site — held only for the branding question, and did not address the three
defects that apply identically to that site's copy: the same opaque `RGB` PNG on the
same navy gradient, the same `100,000` figure sitting directly beneath prose reading
"over 160,000", and the same singular "my course". Fixing one site and filing the
other to `_Projects.md` would have left a known-broken asset live on the busier
domain.

Checking the two sites confirmed one asset serves both: identical `.collection-hero`
gradients, identical `--navy`/`--navy-mid`/`--blue`/`--teal` token values, identical
160×160 `.courses-hero-badge img` rules. So §3 became a single asset copied to both
`src/images/` directories rather than a per-site design. A shared symlinked image
subtree was considered and rejected — new pattern for binaries, one-file benefit,
and unlike the duplicated `SITES` registry an image cannot drift on its own.

`LeeAtchison`'s hero buttons are explicitly unchanged; only the badge and its alt text
move. Open Question 4 closed at `160,000+`. That answer created Open Question 5: with
the figure on the badge, the `LeeAtchison` hero prose now states it twice, and whether
the sentence should shed it is a live editorial choice. The `_Projects.md` follow-on
for `LeeAtchison`'s badge is dropped — it is in scope now.

**2026-08-29 — Open Question 5 answered; figure revised to `180,000+`; §5 added.**
Lee approved rewriting the `LeeAtchison` hero prose "as necessary" and, in the same
message, said the current figure is **180,000+**, not the 160,000 published on that
site.

The revision prompted a repo-wide sweep for the number rather than a single edit, on
the principle that a figure which had already gone stale in two places would have gone
stale in others. `grep -rnE "[0-9]{2,3},000" */src shared/` across all six sites found
four instances at three different values: `100,000` in both badge alt texts,
`over 160,000` in the `LeeAtchison` courses hero prose, and a `160,000+` `.stat-card`
on the `LeeAtchison` **home page** (`index.erb:146`) that nothing in this spec had
touched. Shipping a `180,000+` badge while the home page one click upstream said
`160,000+` would have reproduced precisely the drift the spec exists to remove, so the
stat card was pulled into scope as a one-line change and the whole inventory recorded
as a table in §5. The Solution's former §5 (defer the no-subscription messaging) is
renumbered §6.

Net effect: the figure now lives in two maintained places — the badge artwork (one
file, both sites) and the home-page stat card — both named in §5, and a testing step
was added that greps for stragglers.

**Open, raised 2026-08-29, not yet scoped.** The same sweep found that the
`LeeAtchison` home page's `.platform-cards` block (`index.erb:156–175`) lists only
**Atchison Academy** and **LinkedIn Learning** — Coursera and O'Reilly Media are
absent, though four of the ten live courses are on them. This is the identical
asymmetry Lee raised about the courses hero, one page upstream and in a component this
spec does not otherwise touch. Awaiting Lee's decision on whether to fold it in or file
it to `_Projects.md`.

**2026-08-29 — Home-page platform cards folded in (Solution §6).** Lee's answer to the
question raised in the previous entry: add all four. The former §6 (defer the
no-subscription messaging) is renumbered §7.

Worth recording *why* this resolves the opposite way to §1, since the two look like
the same question: the home-page cards carry no `href`. The whole block is `<div>`s —
an icon, a name, a line of context — so nobody leaves the page by clicking one. §1's
argument was against *exits* that make a visitor choose a vendor before seeing a
course; a static list that says where the work lives has no such cost, and an
incomplete one is just wrong. Completeness is right in one place and wrong in the
other for a reason that survives being written down.

Two implementation decisions were taken while scoping it. **Icons, not logos:** the
block currently ships exactly one real logo — Lee's own Academy mark — and draws
LinkedIn Learning as a generic stroked SVG, so the two new cards follow the SVG
pattern rather than introducing three trademarked wordmarks and three foreign palettes
into a section built on `--blue`. **A 2 × 2 grid:** `.platform-cards` is a flex column
inside a `1fr 1.6fr` grid with `align-items: center`, so four stacked cards would add
~165px and leave the stat card floating against a much taller stack; a 2 × 2 keeps the
section's proportions and reads as four peers. That forced shortening the sub-copy on
all four cards, the two existing ones included, since a half-width cell leaves roughly
230px of text. The single-column fallback is named in §6 as a call to make against the
running page rather than from the CSS.

**2026-08-29 — Moved to Implementing and built.** All seven Summary of Steps items were
implemented in one pass, including the asset (§3): no LiveKit/human-produced source was
available, so a platform-neutral badge was generated programmatically to the §3 table's
exact spec — 400×400 RGBA, transparent background, on-palette navy/blue/teal/white, a
dotted ring, `180,000+` headline, and plural "LEARNERS WORLDWIDE" sub-copy, with no
third-party marks — and copied byte-identically into both sites' `src/images/`. One
deviation from the literal Solution §3 text: the `<img>` alt text does **not** restate the
figure (it reads "Learners worldwide"), because Solution §5 promises the number lives in
exactly two maintained places — the badge artwork and the home-page stat card — and
Testing step 11 expects the repo-wide figure grep to return exactly one hit. Alt text
matching the badge's headline number would have made that three places and broken the
grep step, so the alt text carries the sub-copy only, not the headline figure.

All thirteen testing steps were run: both sites build clean in dev and (Academy)
production, the production build still emits exactly ten course pages with the two hidden
drafts absent, the validator was confirmed to fire on both sites by temporarily stripping
`platform:` from a live course and restoring it, the figure sweep returns exactly the one
expected hit, the `linkedin-learners-badge` grep returns only archived-spec references,
`cmp` confirms the two badge copies are byte-identical, and both dev servers were run with
Chromium screenshots of the Academy and LeeAtchison courses heroes and the LeeAtchison
home-page platform cards at desktop and mobile widths — badge transparency against the
navy→blue gradient, the empty `ATCHISON ACADEMY` labels now filled in, the 2×2 card grid
balanced against the stat card, and the single-column mobile collapse all confirmed
visually.
