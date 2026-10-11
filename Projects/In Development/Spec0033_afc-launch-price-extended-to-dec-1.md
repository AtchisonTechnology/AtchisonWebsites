# Architecting for Cost launch price: extend the end date to Tue Dec 1

* **ID:** Spec0033
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-10-11
* **Date Implemented:**
* **Systems Impacted:** AtchisonAcademy

---

## Problem/Requirement

The Architecting for Cost launch offer (`src/_offers/architecting-for-cost-launch.md`, Spec0031)
advertises $495 through Sun Nov 22, with the page redirecting away Wed Nov 25.

**Decided (Lee, 2026-10-11):** the launch price now runs through **Tue Dec 1**, so Black Friday week
becomes the launch's final push rather than a separate sale. A separate 30%-off Black Friday sale
would have undercut the launch price two days after it "ended."

The offer page must say Dec 1 and stay up through the new grace period.

---

## Solution/Fix/Change

Edit `AtchisonAcademy/src/_offers/architecting-for-cost-launch.md` only:

| Field | Now | Change to |
|---|---|---|
| `intro` | "…it's $495 through Sunday, November 22." | "…it's $495 through Tuesday, December 1." |
| `ends_at` | `2026-11-22T23:59:59-08:00` | `2026-12-01T23:59:59-08:00` |
| `end_line` | "Launch price ends Sunday, November 22, at midnight Pacific." | "Launch price ends Tuesday, December 1, at midnight Pacific." |
| `redirect_at` | `2026-11-25T23:59:59-08:00` | `2026-12-04T23:59:59-08:00` |
| comment above `ends_at` | "Advertised end: Sun Nov 22 … until Wed Nov 25" | "Advertised end: Tue Dec 1 … coupon keeps working quietly until Fri Dec 4, midnight Pacific (Lee, 2026-10-11)" |

**Decided (Lee, 2026-10-11):** keep the 3-day quiet grace period, so the page and the LAUNCH coupon
work through **Fri Dec 4**, midnight Pacific.

Out of scope (handled outside this repo):
- The Kit LAUNCH coupon's expiry (Lee, in Kit).
- Scheduled social posts (rebuilt in ContentStudio 2026-10-11) and scheduled Kit broadcasts (Lee, in Kit's editor).
- `AtchisonAcademy/assets_inbox/webinar-architecting-for-cost-page-copy.md` still says Nov 22. It is
  an inbox copy file, not rendered; leave it as historical unless Lee says otherwise.

---

## Testing

- Build AtchisonAcademy; `plugins/builders/offers.rb` passes (the offer is still cheaper than the standard price).
- `/courses/architecting-for-cost/launch/` shows "$495 through Tuesday, December 1" and the new end line.
- The generated end date and the redirect date read correctly (Dec 1 advertised, Dec 4 redirect).

---

## Summary of Steps Needed

1. Edit the five fields above.
2. Build and check the launch page.
3. Deploy before the first launch post goes out (Wed Oct 28) so the page and the posts agree.

---

## Open Questions

None. Both decisions above are Lee's (2026-10-11).

---

## History of Updates

* **2026-10-11** — Spec created from the Paid Growth project. Lee chose to extend the launch price to
  Dec 1 instead of running a separate Black Friday sale, and to keep the 3-day grace period
  (through Dec 4). Researched the offer file and `AtchisonAcademy/CLAUDE.md` (offer fields).
  Ready for implementation once Lee moves it to Implementing.
