import type { Config } from "@netlify/functions"

// Fires the production build hook every Tuesday, so that week's article
// (already sitting in src/_articles/ with a Tuesday date, copied at the
// article's 🚀 Ready per Spec0024 Part 7) goes live just after the Kit
// send. Netlify's own native "scheduled builds" UI feature is what
// Spec0024 originally specified for this (Open Question 17); Lee asked
// 2026-09-03 to switch to this build-hook + scheduled-function pattern
// instead, so this function and the build hook it calls are now the
// mechanism.
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
// 15:05 UTC is exact for PST (winter) and runs ~1 hour late, 8:05 am, during
// PDT (spring through fall) -- deliberately biased late rather than early:
// the future-date filter in plugins/builders/sai_content.rb is what
// actually gates an article from appearing before its date, so a late
// trigger just delays that week's publish by up to an hour; an early one
// risks the article (and the site picking it up) appearing before the Kit
// send it's timed to follow. Swap to "5 14 * * 2" instead if the reverse
// trade-off (on-time in summer, an hour early in winter) is preferred.
export default async (req: Request) => {
  const { next_run } = await req.json()

  const hookUrl = Netlify.env.get("BUILD_HOOK_URL")
  if (!hookUrl) {
    console.error("weekly-publish: BUILD_HOOK_URL is not set — see this file's header for setup.")
    return
  }

  const res = await fetch(hookUrl, { method: "POST" })
  console.log(`weekly-publish: triggered build hook (status ${res.status}). Next scheduled run: ${next_run}`)
}

export const config: Config = {
  schedule: "5 15 * * 2",
}
