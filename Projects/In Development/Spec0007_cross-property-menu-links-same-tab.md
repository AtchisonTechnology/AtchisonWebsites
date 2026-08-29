# Cross-property menu links should not open a new window

* **ID:** Spec0007
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-08-29
* **Date Implemented:** —
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`

---

## Problem/Requirement

leeatchison.com and atchisonacademy.com are two sites, but they are one
person's body of work, and each links to the other from its main menu:

* `LeeAtchison`'s navbar has **Academy** &rarr; `https://atchisonacademy.com`
* `AtchisonAcademy`'s navbar has **Lee Atchison** &rarr; `https://leeatchison.com`

Both currently open in a new window. Both should not. Moving back and forth
between the two properties is navigation within Lee's own material, and it
should feel continuous — one tab, with the back button working — rather than
spawning a tab every time someone crosses the boundary. The current behavior
also has an accumulating cost an ordinary outbound link does not: someone who
goes Lee &rarr; Academy &rarr; Lee &rarr; Academy ends up with four tabs of the
same two sites.

### This deliberately reverses a decision

Spec0006's Open Question 1 asked exactly this and landed on new-tab, on the
reasoning that one convention for all cross-property links was simpler than
distinguishing them. Lee has since seen it in use and wants the opposite for
these two links. The reversal is the point of this spec, not an oversight in
Spec0006 — recorded here so the next reader of Spec0006's resolved OQ1 knows it
was superseded rather than forgotten.

### Where the behavior comes from

Neither menu link sets `target="_blank"` in its own definition. Both inherit it
from the `external` branch of the navbar template, which is byte-identical in
the two sites (Spec0005 wrote it for `AtchisonAcademy`; Spec0006 copied it
verbatim into `LeeAtchison` specifically so the two would not drift):

`LeeAtchison/src/_components/shared/navbar.erb` and
`AtchisonAcademy/src/_components/shared/navbar.erb`, lines 14–17:

```erb
<% if link[:external] %>
  <a href="<%= link[:path] %>"
     class="<%= link_classes(link) %>"
     target="_blank" rel="noopener noreferrer"><%= link[:label] %></a>
<% else %>
```

The `external:` flag in `navbar.rb` is doing two jobs at once: "this path is
already absolute, don't wrap it in `relative_url`" and "open this in a new
window". Only the first is essential.

---

## Solution/Fix/Change

Split the two behaviors apart. `external:` keeps its URL job; a new `new_tab:`
flag takes over the window job, and neither of the two cross-property links
sets it.

**Both `navbar.erb` files** — make the new-window attributes conditional:

```erb
<% if link[:external] %>
  <a href="<%= link[:path] %>"
     class="<%= link_classes(link) %>"
     <% if link[:new_tab] %>target="_blank" rel="noopener noreferrer"<% end %>><%= link[:label] %></a>
<% else %>
```

**Neither `navbar.rb` changes.** No entry in either `LINKS` list gains
`new_tab: true`, so both cross-property links become same-tab by simply not
opting in. That is the whole behavior change: two files, one line each.

**The default is same-tab, and new-tab is opt-in** — not the reverse. A menu
entry that wants a new window says so; one that says nothing gets ordinary
navigation. Defaulting the other way would mean every future menu item had to
remember to opt *out* of a behavior that is wrong for most of them.

After this the two flags each mean exactly one thing:

| Flag | Means |
|---|---|
| `external: true` | The path is already absolute — do not wrap it in `relative_url`. |
| `new_tab: true` | Open in a new window (`target="_blank" rel="noopener noreferrer"`). |

`target` and `rel` stay paired inside the conditional rather than being split.
`noopener` exists to stop a new browsing context from reaching back through
`window.opener`, so it is meaningful exactly when `target="_blank"` is present
and inert otherwise; `noreferrer` likewise only matters on a link that opens a
new context. Keeping them together means a same-tab link emits neither — which
is what is wanted between Lee's own two properties, where a stripped `Referer`
would suppress the signal that makes the cross-property traffic legible in
analytics.

Nothing else moves: no change to `active?` or `link_classes`, and an absolute
URL still never matches a `relative_url`-shaped resource URL, so external
entries still never take `is-active` or `aria-current`.

**On the ERB style.** The inline `<% if %>` attribute sits on its own line
inside the tag, so an entry without the flag renders a little trailing
whitespace before the `>`. That is exactly the pattern the non-external branch
directly below already uses for its conditional `aria-current`, so this matches
the file's existing shape rather than introducing a new one.

**The flag ships with no user, deliberately.** No link on either site sets
`new_tab: true` after this change, so the branch is unexercised in the built
output — which means the build cannot prove it works. Testing step 8 exercises
it explicitly rather than trusting it. See Open Question 1.

### What this spec does not touch

Third-party outbound links keep `target="_blank"` everywhere — LinkedIn,
LinkedIn Learning, Amazon, the course platform URLs,
softwarearchitectureinsights.com, and the three book sites linked from
`LeeAtchison/src/index.erb`. Those leave Lee's material entirely and the
new-tab convention is right for them.

Two *cross-property* links are also deliberately left alone, both decided by
Lee: the two `courses.erb` Academy buttons on leeatchison.com (Open Question 2)
and `stosa.org`'s "Visit Atchison Academy" button (Open Question 3). Both keep
`target="_blank"`. This spec is exactly the two menu entries and nothing else.

One case needs no change and confirms the direction: `AtchisonAcademy`'s footer
already links to `https://leeatchison.com/contact` with no `target`, so that
crossing is same-tab today. This spec makes the menu match the footer.

---

## Testing

1. **Build both sites.** `LeeAtchison` and `AtchisonAcademy` build clean, with
   no change in page count.
2. **The two menu links.** In `LeeAtchison`'s built HTML, the navbar's Academy
   `<a>` has `href="https://atchisonacademy.com"` — bare and absolute, *not*
   `relative_url`-mangled to `/https://atchisonacademy.com` — and carries
   neither `target` nor `rel`. Same for `AtchisonAcademy`'s "Lee Atchison"
   entry pointing at `https://leeatchison.com`.
3. **Check the root page specifically.** On `/` of each site `relative_url` is
   a no-op, so a regression in the external branch would hide there. Check `/`,
   a section page (`/books/`), and a detail page
   (`/books/the-software-conductor/`).
4. **Nothing else in the nav moved.** Every other nav item still resolves
   relatively; `/ainative` still takes `nav-featured`; `Books` still takes
   `is-active` and `aria-current` on the books pages.
5. **The sibling files still match.** `diff` of the two `navbar.erb` files
   shows only the `nav-brand` line — the invariant Spec0006 established and
   tested. Both files change identically here, so it must still hold.
6. **Third-party links unaffected.** Grep each built site for `target="_blank"`
   — the remaining hits are all genuinely third-party (LinkedIn, Amazon, course
   platforms, the book sites, softwarearchitectureinsights.com) and none is a
   leeatchison.com or atchisonacademy.com URL, **except** the two `courses.erb`
   Academy buttons on `/courses/`, which keep it by decision (Open Question 2).
   `stosa` is not built or touched by this spec.
7. **Click through, in a browser, on both dev servers.** From leeatchison.com's
   menu, Academy loads in the same tab and the back button returns to where it
   started; from atchisonacademy.com's menu, Lee Atchison does the same. Then
   round-trip Lee &rarr; Academy &rarr; Lee and confirm exactly one tab exists
   at the end. This is the actual requirement; steps 2–6 only check the markup
   that produces it.
8. **Prove the `new_tab:` flag actually works.** Nothing sets it, so the build
   cannot exercise it. Temporarily add `new_tab: true` to one external entry in
   one `navbar.rb`, rebuild, and confirm that link renders
   `target="_blank" rel="noopener noreferrer"` while the other site's link still
   renders neither — then revert the temporary change and rebuild. A flag that
   ships untested is a flag that is discovered to be broken by whoever first
   needs it.

---

## Summary of Steps Needed

1. Set up the Claude Code remote session branch (Open Question 5).
2. In `LeeAtchison/src/_components/shared/navbar.erb` and
   `AtchisonAcademy/src/_components/shared/navbar.erb`, wrap the external
   branch's `target="_blank" rel="noopener noreferrer"` in
   `<% if link[:new_tab] %>`. Neither `navbar.rb` changes.
3. Run Testing steps 1–8 locally against both dev servers, including the
   temporary flag check in step 8.
4. Request permission to commit; create a PR on request.
5. Check the deploy preview before merge.

---

## Open Questions

All resolved as of 2026-08-29.

1. **Remove the new-window behavior from the `external` branch outright, or add
   a per-link `new_tab:` flag?**
   *Recommendation: outright. Every `external: true` entry that exists on either
   site is a cross-property link that this spec wants same-tab, so a flag would
   have no second value to take. Adding one now means writing and maintaining a
   branch that is dead on arrival; adding it later, when a third-party nav entry
   actually needs it, costs the same and is justified by a real case.*

   **Decided 2026-08-29 (Lee): add the second flag** — `new_tab:`, against the
   recommendation. It does ship with no link setting it, which is the cost the
   recommendation was weighing, but it buys two things the blunt removal does
   not. It keeps `external:` honest: after the split each flag names one
   behavior, instead of one flag quietly carrying two. And a menu is the most
   likely place on either site to eventually gain a genuinely third-party link,
   where a new window *is* right; the flag makes that day a one-key edit to a
   `LINKS` entry rather than a template change that has to re-derive this whole
   distinction from scratch. The dead-on-arrival objection is answered by
   Testing step 8, which exercises the flag explicitly instead of letting it
   ship unproven.

2. **Do the two `courses.erb` Academy buttons on leeatchison.com count as
   "menu links"?** `LeeAtchison/src/courses.erb` line ~15 (hero, "Atchison
   Academy &rarr;") and line ~83 (closing CTA band, "Explore the Academy
   &rarr;") both point at `https://atchisonacademy.com` with
   `target="_blank" rel="noopener noreferrer"`. Spec0006 gave them new-tab in
   the same decision it gave the navbar entry.
   *Recommendation: yes, change them too. They are buttons rather than menu
   items, but they are the same crossing to the same destination, and the
   argument for continuity does not weaken because the link is styled as a
   button.*

   **Decided 2026-08-29 (Lee): no — both buttons keep `target="_blank"`.** The
   recommendation treated menu item and button as the same crossing; Lee's read
   is that they are not. A menu entry is navigation: the reader is choosing
   where to go next, and continuity is the point. These two are a pitch — the
   hero button and the closing promo band sell the Academy to someone who came
   to `/courses` to read about courses, and a new tab leaves the page they were
   reading intact behind it. The difference on `/courses/` is deliberate, not an
   inconsistency for a later spec to tidy up.

3. **And `stosa.org`'s "Visit Atchison Academy" button?**
   `stosa/src/index.erb` line ~289 carries `target="_blank" rel="noopener"`
   (note: `noopener` only, not the `noopener noreferrer` pair used elsewhere).
   It is a cross-property link, but stosa.org &rarr; atchisonacademy.com is not
   the crossing Lee named.
   *Recommendation: change it too, if and only if OQ2 lands on yes.*

   **Decided 2026-08-29 (Lee): no — leave it as it is.** This spec is only about
   leeatchison.com and atchisonacademy.com. `stosa/src/index.erb` keeps
   `target="_blank" rel="noopener"` and `stosa` stays out of Systems Impacted.
   Same-tab is therefore a rule about the leeatchison &harr; atchisonacademy
   menu pair, not a repo-wide convention for every cross-property link.

4. **Is there a fourth cross-property link anywhere else?**
   Audited at spec time and the answer is no: `AtchisonAcademy`'s footer Contact
   link is already same-tab, and `TheSoftwareConductor`,
   `BusinessBreakthrough30`, and `ArchitectingForScale` contain no
   `atchisonacademy.com` or cross-property `leeatchison.com` links at all.
   *No decision needed — recorded so the audit is not repeated.*

5. **Branching mode: `main`, a `spec0007` worktree, or a Claude Code remote
   session branch?**
   *Recommendation: a Claude Code remote session branch, as Spec0002, Spec0003,
   Spec0005, and Spec0006 used. As scoped this is two one-line edits, but it
   needs both dev servers running to verify the click-through in Testing step 7,
   and it should get a deploy preview before merge.*

   **Decided 2026-08-29 (Lee): as recommended** — a Claude Code remote session
   branch. No worktree, so no worktree cleanup at close, and no port derivation
   beyond the two sites' `main` ports (3000 and 16000).

---

## History of Updates

* **2026-08-29** Created at Lee's request: the menu links between
  leeatchison.com and atchisonacademy.com should not open a new window.
* **2026-08-29** Traced the behavior before proposing a fix. Neither menu link
  sets `target="_blank"` itself — both inherit it from the `external` branch
  shared byte-for-byte by the two `navbar.erb` files, so the change is one line
  in each rather than an edit to either `LINKS` list. That shared branch is an
  invariant Spec0006 deliberately created and tested (its Testing step 5), so
  both files must change identically; folded that assertion into the testing.
* **2026-08-29** Recorded that this reverses Spec0006's Open Question 1, which
  resolved to new-tab for all three outbound Academy links on 2026-08-29 — the
  same day. The reversal is deliberate and comes from seeing the behavior in
  use. Noted so the archived Spec0006 decision reads as superseded rather than
  as a standing convention.
* **2026-08-29** Audited every cross-property link in the repo rather than
  trusting the request's framing. Five exist: the two menu links, the two
  `courses.erb` buttons on leeatchison.com, and stosa.org's Academy button.
  `AtchisonAcademy`'s footer Contact link is already same-tab. The other three
  sites have none. Raised the three beyond the menu pair as Open Questions
  rather than folding them in, since Lee's instruction named menu links
  specifically.
* **2026-08-29** OQ3 decided by Lee: stosa.org's button stays a new-tab link and
  `stosa` is out of Systems Impacted. Scope is the leeatchison.com &harr;
  atchisonacademy.com pair specifically, not cross-property links in general —
  which narrowed what OQ2 turned on: the `courses.erb` buttons were in or out on
  their own merits, not because a repo-wide convention forced them.
* **2026-08-29** OQ2 decided by Lee: the two `courses.erb` Academy buttons keep
  `target="_blank"`. The recommendation had argued they were the same crossing
  in different clothes; the decision draws the line at navigation versus
  promotion instead — a menu item moves you, a CTA sells you, and only the first
  wants continuity. That distinction is recorded because it is what makes the
  mixed behavior on `/courses/` intentional rather than an oversight.
* **2026-08-29** OQ1 decided by Lee against the recommendation: add a `new_tab:`
  flag rather than stripping the behavior from the `external` branch. Reworked
  the Solution around the split — `external:` for the URL, `new_tab:` for the
  window, same-tab as the default and new-tab opt-in, with neither `navbar.rb`
  gaining the key. The behavior change is still two files, one line each. Added
  Testing step 8 to exercise the flag by temporarily setting it: with OQ2 also
  decided, no link on either site sets it, so the branch would otherwise ship
  with the build unable to prove it works.
* **2026-08-29** OQ5 (branching mode) decided by Lee as recommended: a Claude
  Code remote session branch, no worktree.
* **2026-08-29** Narrowed from a collecting spec to a single-purpose one at
  Lee's request, and renamed from `Spec0007_misc-site-improvements.md`. It was
  drafted as a container for miscellaneous cross-site improvements, with this
  change as its first item and room to append more; Lee does not expect other
  misc items in the short term, so the container framing was removed rather than
  left as an empty structure inviting scope creep. The one Open Question that
  existed only to serve the container — when the item list freezes — went with
  it, and the remaining questions were renumbered 1–5. No decision, scope, or
  test changed in the narrowing.
