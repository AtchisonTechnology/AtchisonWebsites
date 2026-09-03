// @ts-ignore
import type { Config } from "@netlify/functions"

// Fires the production build hook every Tuesday, so that week's article
// (already sitting in src/_articles/ with a Tuesday date, copied at the
// article's 🚀 Ready per Spec0024 Part 7) goes live *before* the Kit send
// (7:00 am Pacific) rather than after it — Lee's explicit preference
// (2026-09-03), reversing this function's original after-the-send design.
// Netlify's own native "scheduled builds" UI feature is what Spec0024
// originally specified before that (Open Question 17); this build-hook +
// scheduled-function pattern replaced it the same day.
//
// Setup this function depends on (Lee's side, Netlify UI — see the repo's
// CLAUDE.md Netlify/DNS boundary):
//   1. Site settings -> Build & deploy -> Build hooks -> add one (any name,
//      e.g. "Weekly Tuesday publish"), branch: main.
//   2. Site settings -> Environment variables -> add BUILD_HOOK_URL set to
//      that hook's URL. Scope: Functions (it only needs to be readable at
//      function runtime, not at build time).
//   3. Confirm the Netlify plan on this team supports Scheduled Functions.
//
// Cron is UTC and fixed, so it cannot itself track Pacific's DST switch.
// 13:00 UTC is exactly 6:00 am PDT (spring through fall, the more common
// state) -- one hour before the 7:00 am send, at the top of Lee's stated
// "a few minutes to an hour before" window. During PST (winter) the same
// 13:00 UTC lands at 5:00 am PST, two hours before the send: more lead time
// than requested, but deliberately kept on the early side of the window
// rather than drifting past it into "after," which is the one outcome Lee
// ruled out. The future-date filter in plugins/builders/sai_content.rb
// compares dates, not clock times, so any build that runs after midnight
// Pacific on the article's Tuesday already shows it — there's no risk of
// "too early" from the filter's side, only from how far ahead of the send
// this fires.
export default async (req: Request) => {
  const { next_run } = await req.json()

  // @ts-ignore
  const hookUrl = Netlify.env.get("BUILD_HOOK_URL")
  if (!hookUrl) {
    console.error("weekly-publish: BUILD_HOOK_URL is not set — see this file's header for setup.")
    return
  }

  const res = await fetch(hookUrl, { method: "POST" })
  console.log(`weekly-publish: triggered build hook (status ${res.status}). Next scheduled run: ${next_run}`)
}

export const config: Config = {
  schedule: "0 13 * * 2",
}
