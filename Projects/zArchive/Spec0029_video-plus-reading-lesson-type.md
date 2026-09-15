# Video-plus-reading lesson type on AtchisonAcademyCourses

**PR:** https://github.com/AtchisonTechnology/AtchisonWebsites/pull/34

* **ID:** Spec0029
* **Status:** Closed
* **Date Created:** 2026-09-15
* **Date Implemented:** 2026-09-15
* **Systems Impacted:** AtchisonAcademyCourses (the Spec0021 site) only.
  No `shared/` changes, no Netlify/DNS changes, no URL changes.

---

## Problem/Requirement

Most Atchison Academy lessons will have two parts: a video, then a reading
that is watched/read in that order. The reading carries **new** material, not
a recap of the video.

Today every lesson has exactly one `content_type` (`video`, `text`, or
`resources`). A `video` lesson's body does print under the player, but
`lesson.erb` renders it in the `.lesson-notes` box, with no heading, as
optional notes (timestamps, a summary). That presentation tells a student the
text is skippable, which is the opposite of what these lessons need.

Lee's direction (2026-09-15): **one page per lesson**, video on top, reading
below, and the page must make it obvious the reading is required, new
material.

Ordering is not a problem: `course_lessons` sorts by front-matter
`(module, lesson)`, and filenames play no part in order.

---

## Solution/Fix/Change

*Decided by Lee 2026-09-15 (all Open Questions resolved).*

1. **New `content_type: video_reading`** for a lesson with both parts. Plain `video` keeps its current "notes" behavior.
2. **Validation** (`plugins/builders/course_content.rb`): add the type to
   `CONTENT_TYPES`. For it, require a numeric `vimeo_id` (same check as
   `video`) a non-empty body, and both `video_minutes` and `reading_minutes`. Fail the
   build loud otherwise.
3. **New optional front-matter keys:**
   * `video_minutes`, `reading_minutes` — **required** on `video_reading`
     lessons; positive integers, shown beside each part.
   * `reading_title` — optional — heading over the reading, e.g. "Going deeper: what
     the video didn't cover." Falls back to "Going deeper: what the video didn't cover." if absent.
4. **`src/_layouts/lesson.erb`**, new branch for the type:
   * "Part 1: Watch (N min)" label above the existing Vimeo embed.
   * A visible divider.
   * "Part 2: Read (N min)" label, then `reading_title` as a heading, then
     the body in `.lesson-document` styling (the `text` lesson's full
     reading styling), not `.lesson-notes`.
   * Top prev/next nav: on `video_reading` lessons, **drop the top Next
     link** and keep the top Previous link. The bottom nav is unchanged, so
     Next appears only after the reading. Other lesson types unchanged.
5. **Type labels**: show "video + reading" rather than the raw type string.
   Today `course.erb` prints `content_type` verbatim, so add a display-name
   helper. Use it in `src/_layouts/course.erb` (course index) **and add type
   labels for every lesson type to `_lesson_outline.erb`** (the sidebar and
   mobile course-contents list, which show none today).
6. **CSS** (`frontend/styles/index.css`): part labels, divider, and a
   `.lesson-type--video_reading` badge style.
7. **Sample course**: add one `video_reading` lesson to
   `src/_lessons/sample-course/` so the type is built and validated.
8. **Docs**: update the Content model and Validation builder sections of
   `AtchisonAcademyCourses/CLAUDE.md`.

---

## Testing

* `bin/dev` builds cleanly with the new sample lesson.
* The sample lesson shows Part 1 / divider / Part 2, the times, the reading
  heading, and the reading in document styling.
* Existing `video`, `text`, `resources` sample lessons render unchanged.
* Course index shows "video + reading" for the new lesson; the sidebar and
  mobile course-contents list show type labels for every lesson.
* On the new lesson, the top nav has Previous but no Next; the bottom nav has
  both. Other lesson types keep both top links.
* Build fails with a clear message for: `video_reading` with no/non-numeric
  `vimeo_id`; `video_reading` with an empty body; `video_reading` with a missing or
  non-positive-integer `video_minutes`/`reading_minutes`.
* Check at phone width (~400px).

---

## Summary of Steps Needed

1. Builder: new type, required fields, minutes validation, display-name
   helper for the type label.
2. `lesson.erb` new branch; drop top Next on this type.
3. Type labels in `course.erb` and `_lesson_outline.erb` (all types).
4. CSS.
5. Sample lesson.
6. Update `AtchisonAcademyCourses/CLAUDE.md`.
7. Test per above.

---

## Open Questions

All resolved by Lee, 2026-09-15:

1. ~~Type name~~ — **Decided: new type `video_reading`** (not a flag on
   `video`).
2. ~~Top-of-page Next link~~ — **Decided: drop top Next on `video_reading`
   lessons; keep top Previous.**
3. ~~Are the minutes required?~~ — **Decided: required.**
4. ~~Default reading heading~~ — **Decided: optional `reading_title`,
   default "Going deeper: what the video didn't cover."**
5. ~~Outline sidebar badge~~ — **Decided: type labels for all lesson types.**

Note, not a question: if Spec0022 (student progress tracking, on hold)
ships, "lesson complete" for this type should mean the reading was reached,
not just the video played.

---

## History of Updates

* **2026-09-15** — Created. Lee decided on one page per lesson (video on top,
  reading below) in conversation. Everything under Solution is proposed and
  awaiting his answers to the Open Questions.
* **2026-09-15** — Lee answered all five Open Questions: type
  `video_reading`; drop top Next on this type; minutes required; default
  reading heading; type labels for all types in the sidebar. Solution,
  Testing, and Steps updated to match.
* **2026-09-15** — Moved to Implementing.
* **2026-09-15** — Implementation complete, verified in-browser (desktop +
  phone width) and via build-failure checks. Moved to Verifying; PR created.
* **2026-09-15** — PR merged. Moved to Closed and archived.
