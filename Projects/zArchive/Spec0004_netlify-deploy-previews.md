# Configure Netlify Deploy Previews across all five sites

* **ID:** Spec0004
* **Status:** Closed
* **Date Created:** 2026-08-28
* **Date Implemented:** 2026-08-28
* **Date Completed:** 2026-08-28
* **Systems Impacted:** LeeAtchison, TheSoftwareConductor, stosa, BusinessBreakthrough30, ArchitectingForScale
* **Pull Request:** [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4)

---

## Problem/Requirement

Spec0003 added canonical tags, per page `og:url`, and sitemap entries to all
five sites. Every one of those values is derived from a single configured
string: `url` in each site's `config/initializers.rb`. That spec's own test
plan (steps 4, 6, and 7) calls for verifying trailing slash behavior, social
preview rendering, and `og:image` resolution **against a deploy preview**, and
its "Not verified here" section records that those steps were never run because
they need a deploy.

They cannot usefully be run against a preview as things stand. On a preview
build, `url` is still the production hostname, so a preview of leeatchison.com
emits `<link rel="canonical" href="https://leeatchison.com/academy/">` no matter
what the preview actually contains. Canonical, `og:url`, and every `<loc>` in
the sitemap describe production. Checking them on a preview confirms only that
the hardcoded string survived the build.

The purpose of this spec is to make a deploy preview describe itself, so that
the metadata Spec0003 introduced can be reviewed before it reaches production
rather than after.

### What research established

Four findings shaped the scope, two of which removed work that was originally
assumed to be part of it.

**1. Deploy Previews are a UI setting, not a file setting.** They are enabled by
default for any site linked to a Git repository, and the only toggle lives at
Project configuration > Build & deploy > Continuous deployment > Branches and
deploy contexts > Configure. There is no `netlify.toml` key that turns the
feature on or off. Whether they are currently on for all five sites has not been
checked (Open Question 1).

**2. `netlify.toml` context blocks are narrower than they look.** Only `[build]`
and `[[plugins]]` are context aware. Netlify's file based configuration
documentation states plainly that redirects and headers "are GLOBAL for all
builds and do not get scoped to contexts no matter where you define them in the
file." A `[[context.deploy-preview.headers]]` block is not valid configuration.
Inside a context block only `command`, `publish`, and `environment` apply.

**3. Netlify already sends `X-Robots-Tag: noindex` on deploy previews, and it
cannot be overridden.** Confirmed by Netlify staff in their support forum. The
original scope for this spec included adding a noindex header for previews; that
work is unnecessary and has been dropped. Note the boundary: **branch deploys do
not get the noindex header**, only Deploy Previews and deploy specific URLs do.
That gap is real but out of scope here (Open Question 3).

**4. Bridgetown does not read the site URL from the environment.** There is no
`BRIDGETOWN_URL` and Bridgetown ignores Netlify's `URL` variable, so the
`URL = "$DEPLOY_PRIME_URL"` approach that works for many static site generators
does nothing here. All five sites set `url` in `config/initializers.rb`, which
is plain Ruby and can read `ENV` directly. That is the only place this can be
fixed.

### Current state

| | |
|---|---|
| `netlify.toml` files | Five, byte identical except for LeeAtchison's redirect rules. None has any `[context.*]` block. |
| Site URL | Set in `config/initializers.rb` on all five sites as a literal string. LeeAtchison additionally has a redundant `url:` line in `bridgetown.config.yml`. |
| Consumers of `url` | `absolute_url` in each `_head.erb` (canonical, `og:url`, `twitter` tags, added by Spec0003) and `resource.absolute_url` in each `src/sitemap.xml.erb`. |
| Preview noindex | Already handled by Netlify. No repo change needed. |

---

## Solution/Fix/Change

Two changes per site, ten files total. No template, layout, or content changes.

### Change 1: context aware `url` in `config/initializers.rb`

Replace the literal `url` call in each site's initializer with a form that
yields the deploy's own hostname on non production builds:

```ruby
# On a Netlify Deploy Preview, build against the deploy's own hostname, so
# that canonical, og:url, and the sitemap describe the preview rather than
# production. Everywhere else the literal below is used unconditionally:
# local builds (CONTEXT unset), the production build (CONTEXT
# "production"), and branch deploys (CONTEXT "branch-deploy"). ...
preview_url = ENV["DEPLOY_PRIME_URL"].to_s
preview_build = ENV["CONTEXT"] == "deploy-preview" && !preview_url.empty?
url(preview_build ? preview_url : "https://leeatchison.com")
```

(The comment is abbreviated here; the shipped version also carries the
`CONTEXT`-versus-`DEPLOY_PRIME_URL` rationale below and the branch-deploy
note from Open Question 3.)

with the literal replaced per site (`thesoftwareconductor.com`, `stosa.org`,
`businessbreakthrough30.com`, `architectingforscale.com`).

The test is `CONTEXT == "deploy-preview"` rather than `CONTEXT != "production"`
per the decision on Open Question 3: branch deploys do not receive Netlify's
automatic noindex header, so they keep production canonicals as a
de-duplication signal.

**Why key on `CONTEXT` rather than just falling back on `DEPLOY_PRIME_URL`.**
On a production build Netlify sets `DEPLOY_PRIME_URL` equal to `URL`, which is
the custom domain when one is configured as primary and the `*.netlify.app`
subdomain otherwise. A naive `ENV.fetch("DEPLOY_PRIME_URL", "https://...")`
would therefore appear to work while silently making production canonical tags
depend on Netlify's domain configuration rather than on the repo. Reading
`CONTEXT` makes the production path unconditionally the literal string, which is
the property worth having: a domain misconfiguration in the Netlify UI can never
rewrite production canonicals.

The empty string guard matters because `ENV["DEPLOY_PRIME_URL"]` can be present
but blank in some build environments, and Bridgetown would accept `""` as the
site URL without complaint.

### Change 2: explicit `[context.deploy-preview]` block in `netlify.toml`

Added to all five files, immediately after `[build.environment]`:

```toml
# Deploy Previews build exactly like production, so the preview is
# representative. The site URL itself is made preview aware in
# config/initializers.rb, since Bridgetown does not read it from the
# environment. See Spec0004.
[context.deploy-preview]
  command = "bin/bridgetown deploy"

[context.deploy-preview.environment]
  NODE_ENV = "development"
  BRIDGETOWN_ENV = "production"
```

This duplicates what `[build]` already provides by inheritance and changes no
behavior. It is included as a documented hook and as the place a future reader
looks when they want to know how previews differ, which is precisely the
question this spec started from. Whether that justifies its existence is
Open Question 2.

### Also in scope: remove the redundant `url:` from LeeAtchison

`LeeAtchison/bridgetown.config.yml` line 1 sets `url: https://leeatchison.com`
while `LeeAtchison/config/initializers.rb` sets the same value. The other four
sites set it only in the initializer. If the YAML value wins, or wins under some
load order, Change 1 is silently defeated on the one site with the most metadata
riding on it. The line should be removed so there is one source of truth, and
the load order should be confirmed at implementation rather than assumed.

**Load order, confirmed at implementation (2026-08-28).** The initializer wins.
`Bridgetown::Configuration#run_initializers!` (bridgetown-core 2.1.2,
`lib/bridgetown-core/configuration.rb:158`) loads `config/initializers.rb`
*after* the YAML config has been merged, and its only rollback is
`cached_url = url&.include?("//localhost") ? url : nil`, which restores the URL
only when the pre-initializer value was a localhost address. A production
hostname in YAML is therefore overwritten, not preserved. Confirmed empirically
as well: LeeAtchison's production build output is byte-identical before and
after removing the YAML line. The redundancy was harmless but is removed
anyway, since a second source of truth for the one value this spec turns on is
exactly the thing a future reader would trip over.

### Scope boundary

This spec covers the site URL under preview builds and the `netlify.toml`
context block. It does not touch head partials, layouts, social images, or
sitemap templates. It does not change production output in any way, and any
change to production output during implementation is a defect in this spec, not
a feature of it.

---

## Testing

1. **Local simulation, before any deploy.** For each site, build twice and diff:

   ```bash
   BRIDGETOWN_ENV=production bin/bridgetown deploy
   CONTEXT=deploy-preview DEPLOY_PRIME_URL=https://deploy-preview-9--example.netlify.app \
     BRIDGETOWN_ENV=production bin/bridgetown deploy
   ```

   The second build's canonical, `og:url`, `twitter` tags, and `sitemap.xml`
   entries must all be on the preview host. Nothing else may differ.

2. **Production build unchanged.** Build with `CONTEXT=production` set and
   confirm the output tree is byte identical to a build with `CONTEXT` unset.
   This is the regression that matters, because it is the one that would ship.

3. **Local dev unaffected.** `make dev` with no `CONTEXT` in the environment.
   All five sites boot on their derived ports and emit production canonicals as
   they do today.

4. **On the actual preview**, once a PR is open:

   ```bash
   curl -sS https://deploy-preview-N--<site>.netlify.app/ | grep -iE "canonical|og:url"
   curl -sSI https://deploy-preview-N--<site>.netlify.app/ | grep -i x-robots
   ```

   The first must return preview host URLs. The second must show Netlify's
   automatic `noindex`, confirming finding 3 rather than trusting it.

5. **Retire Spec0003's outstanding steps.** With a working preview, run
   Spec0003 test steps 4, 6, and 7 against it: trailing slash behavior, a social
   preview debugger, and `og:image` returning 200 at 1200 x 630.

6. **`make test`** still passes at the repo root.

### Results, local half (2026-08-28)

Each of the five sites was built five times with `BRIDGETOWN_ENV=production`
and the output trees compared:

| Build | Result |
|---|---|
| `CONTEXT` unset (baseline) | — |
| `CONTEXT=production`, `DEPLOY_PRIME_URL` set | byte-identical to baseline, all five sites |
| `CONTEXT=branch-deploy`, `DEPLOY_PRIME_URL` set | byte-identical to baseline, all five sites |
| `CONTEXT=deploy-preview`, `DEPLOY_PRIME_URL` empty | byte-identical to baseline, all five sites (empty-string guard) |
| `CONTEXT=deploy-preview`, `DEPLOY_PRIME_URL` set | differs only in the metadata below |

On the preview build the only differences are `<link rel="canonical">`,
`og:url`, `og:image`, `twitter:image`, every `<loc>` in `sitemap.xml`, and —
on LeeAtchison and ArchitectingForScale, the two sites with a `robots.txt` —
the `Sitemap:` line, which is derived from the same `url` and correctly points
at the preview's own sitemap. Nothing else differs. No production hostname
survives anywhere in the preview output.

Stronger than test step 2 as written: the post-change production build was
also diffed against a build of the pre-change tree (via `git stash`), and is
byte-identical for all five sites. That covers the LeeAtchison YAML removal,
which step 2 alone would not have.

Test step 3: `bin/site-port --all` reports the unchanged main ports
(3000/8000/10000/12000/14000); stosa's dev server booted on 10000 and served
`<link rel="canonical" href="https://stosa.org/" />`, unchanged. Test step 6:
`make test` passes (9,995 port combinations checked).

### Results, deploy half (2026-08-28)

[PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) produced real deploy previews, which answers most of Open Question 1
without a UI visit. Netlify posted twelve check runs, three each for four
sites:

| Site | Deploy preview on PR #4 |
|---|---|
| `BusinessBreakthrough30` | ready — `https://deploy-preview-4--businessbreakthrough30.netlify.app` |
| `TheSoftwareConductor` | built |
| `LeeAtchison` | built |
| `ArchitectingForScale` | built (still in progress when the PR merged) |
| `stosa` | **never reported** |

So Deploy Previews are enabled and building on four of the five sites. stosa
is not confirmed either way: the PR merged twenty seconds after it opened, and
ArchitectingForScale's checks only started after the merge, so stosa may
simply have been slower rather than disabled.

**Test steps 4 and 5 were not run, and this spec closes without them.** Step 4
needs a request to the preview host, and the closing session's environment
denies outbound connections to `*.netlify.app` — `curl` gets a 403 on the
CONNECT tunnel, confirmed against the proxy's own status endpoint. The two
commands are recorded in step 4 above and can be run by hand against the
preview URL, which outlives the merge.

Step 5 is moot as written. It called for retiring Spec0003's outstanding test
steps 4, 6, and 7 against a working preview, but Spec0003 was closed before
this spec was implemented, with those steps resting on Lee's own check of the
deploy. What this spec delivers for them is standing capability rather than a
retirement: from now on any PR's preview describes itself, so that class of
check is runnable when it is next wanted.

---

## Summary of Steps Needed

1. ~~Resolve the Open Questions below, particularly 1 and 2.~~ Done 2026-08-28
   for 2 and 3; 1 is outstanding and is Lee's to check (see below).
2. **Partly answered by [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4), not by a UI visit.** Four of the five sites
   built a deploy preview on that PR; stosa did not report one. Only stosa is
   still unconfirmed, and it is carried into `_Projects.md` rather than left
   here.
3. ~~Confirm the `bridgetown.config.yml` versus `config/initializers.rb` load
   order for `url` on LeeAtchison.~~ Done 2026-08-28 — the initializer wins,
   confirmed in the gem source and empirically.
4. ~~Apply Change 1 to five `config/initializers.rb` files.~~ Done 2026-08-28
5. ~~Apply Change 2 to five `netlify.toml` files.~~ Done 2026-08-28
6. ~~Remove the redundant `url:` line from `LeeAtchison/bridgetown.config.yml`.~~
   Done 2026-08-28
7. ~~Run the local half of the test plan (steps 1 through 3 and 6).~~ Done
   2026-08-28 — see Results above. All passed.
8. ~~Request permission to commit; create a PR on request.~~ Done 2026-08-28 —
   committed and pushed to `claude/spec0004-implementation-1o1gfh`; Lee opened
   [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) from the Claude Code UI and merged it.
9. **Not done; see "Results, deploy half" above.** Step 4 was unreachable from
   the closing session's network, and step 5 was overtaken by Spec0003 closing
   first. Neither blocks this spec's change, which is verified locally and
   merged.

---

## Open Questions

1. **Are Deploy Previews currently enabled on all five Netlify sites?** They are
   on by default, but these sites predate this spec and may have been changed.
   This needs a look at each site's Branches and deploy contexts panel before
   implementation, since everything else here assumes previews build at all.
   *No recommendation; it is a fact to establish, not a decision.*

   **Mostly answered 2026-08-28, by [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) rather than by the UI.** Four of the
   five sites built a preview on that PR. stosa did not report one, which is
   suggestive but not conclusive given the PR merged twenty seconds after
   opening. Carried into `_Projects.md` at archival so the one unconfirmed
   site is not lost.

2. **Is the `[context.deploy-preview]` block worth adding, given it changes
   nothing?** It duplicates the inherited `[build]` settings exactly.
   *Recommendation: add it.* The cost is six lines per file and the benefit is
   that the next person asking "what is different about previews here" finds an
   answer in the file they will look in first. The alternative is a comment
   referencing this spec, or nothing.

   **Decided 2026-08-28 (Lee): add it.** Implemented in all five
   `netlify.toml` files, with the comment carrying the two findings a reader
   arriving at that file needs — that the URL is set in Ruby, and that headers
   and redirects cannot be scoped to a context.

3. **Branch deploys.** They are not covered by Netlify's automatic noindex, and
   Change 1 as written treats them like previews (any non production `CONTEXT`
   gets `DEPLOY_PRIME_URL`), which means a branch deploy would emit
   self referencing canonicals while remaining indexable. Options: disable branch
   deploys in the UI; leave them on and accept the exposure; or restrict Change 1
   to `CONTEXT == "deploy-preview"` so branch deploys keep production canonicals
   as a de duplication signal.
   *Recommendation: disable branch deploys in the UI if they are not being used,
   which removes the question entirely. If they are being used, restrict
   Change 1 to `deploy-preview`.*

   **Decided 2026-08-28 (Lee): restrict Change 1 to `deploy-preview`.** Branch
   deploys keep the production URL, so they stay indexable but emit production
   canonicals, which is the correct de-duplication signal for an indexable
   duplicate. This needs no Netlify UI change and is safe whether or not branch
   deploys are in use. Verified locally: a `CONTEXT=branch-deploy` build is
   byte-identical to a production build on all five sites.

4. **`NODE_ENV = "development"` in `[build.environment]` on all five sites.**
   Presumably deliberate, so that `npm install` brings in devDependencies that
   esbuild needs at build time. Change 2 copies it forward unexamined.
   *Recommendation: leave it alone in this spec and note it. Changing the
   production build's Node environment is not preview work and does not belong
   in a spec about previews.*

5. **Should `sitemap.xml` and `robots.txt` be suppressed on previews?** With
   Change 1 a preview publishes a complete sitemap of preview URLs and a
   `robots.txt` saying `Allow: /`. Netlify's noindex header makes this harmless
   for previews specifically.
   *Recommendation: no. It adds conditional logic to five templates to solve a
   problem the platform already solves, and it would make the preview less
   representative of production, which is the opposite of what previews are for.*

---

## History of Updates

* **2026-08-28** Spec created at Lee's request. Arose from a direct question:
  can Netlify be configured to deploy PRs, and can it be done from
  `netlify.toml` or must it be done in the UI.
* **2026-08-28** Answered: enabling Deploy Previews is UI only and on by
  default; `netlify.toml` shapes how previews build but cannot turn them on.
* **2026-08-28** Two corrections to the initial answer, both found while
  researching rather than assumed. Bridgetown does not read the site URL from
  any environment variable, so `URL = "$DEPLOY_PRIME_URL"` in `netlify.toml`
  would have been inert; the site URL is set in Ruby in
  `config/initializers.rb`, which is where this has to be fixed. And previews
  should build at `BRIDGETOWN_ENV=production`, not `development`, so that the
  preview is representative of what ships.
* **2026-08-28** Confirmed from Netlify's file based configuration
  documentation that headers and redirects are global and cannot be scoped to a
  deploy context. The planned `[[context.deploy-preview.headers]]` block is not
  valid configuration and was removed from the design.
* **2026-08-28** Confirmed from Netlify support, staff answered, that deploy
  previews already receive `X-Robots-Tag: noindex` automatically and that it
  cannot be overridden. The noindex work this spec was originally scoped to do
  was dropped as unnecessary. Recorded the branch deploy gap as Open Question 3.
* **2026-08-28** Established that the substantive value of this spec is
  unblocking Spec0003's test steps 4, 6, and 7, which that spec records as not
  run because they require a deploy. Without Change 1 those steps remain
  meaningless on a preview, because a preview currently emits production
  canonicals.
* **2026-08-28** Noticed that `LeeAtchison/bridgetown.config.yml` sets `url`
  redundantly alongside `config/initializers.rb`, uniquely among the five sites,
  and that this could silently defeat Change 1. Added its removal to scope.
* **2026-08-28** Spec written. No code changed; this item is in Refinement and
  the five `netlify.toml` files and five initializers are untouched.
* **2026-08-28** Lee asked for the spec to be implemented, which moved it from
  Refinement to Implementing. Open Questions 2 and 3 were put to him first,
  since 3 changes the code: he chose to add the `[context.deploy-preview]`
  block, and to restrict Change 1 to `CONTEXT == "deploy-preview"` so that
  branch deploys keep production canonicals. Both decisions are recorded
  against their questions above. Open Question 1 is untouched and remains his
  to check in the Netlify UI; it gates test steps 4 and 5, not the code.
* **2026-08-28** Implemented. Eleven files changed: five
  `config/initializers.rb`, five `netlify.toml`, and
  `LeeAtchison/bridgetown.config.yml`. The load-order question in "Also in
  scope" was answered before removing the YAML line rather than after: the
  initializer wins, from the gem source and from a byte-identical build.
* **2026-08-28** Local half of the test plan run and recorded under Testing.
  The scope boundary holds: production output is byte-identical to a build of
  the pre-change tree on all five sites, and branch deploys and an empty
  `DEPLOY_PRIME_URL` are byte-identical too. Only a deploy-preview build
  differs, and only in canonical, `og:url`, `og:image`, `twitter:image`,
  `sitemap.xml`, and the `Sitemap:` line of `robots.txt`. Test steps 4 and 5
  still require a deploy and remain outstanding, as does Open Question 1.
* **2026-08-28** Lee opened [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) from the Claude Code UI against
  `claude/spec0004-implementation-1o1gfh` and merged it about twenty seconds
  later, so the eleven code files are on `main`. Netlify built deploy previews
  for four of the five sites on that PR, which is the first real evidence for
  Open Question 1 and the first proof that the change reaches a preview build
  at all.
* **2026-08-28** **Closed at Lee's instruction.** Closing honestly: test steps
  4 and 5 were never run. Step 4 needs a request to the preview host and the
  closing session's network policy denies `*.netlify.app`; step 5 was
  overtaken by Spec0003 closing before this spec was implemented. Everything
  the spec set out to change is implemented and verified locally, including
  the regression that mattered — production output byte-identical to a build
  of the pre-change tree on all five sites. Status set to Closed and the file
  moved to `zArchive/`.
* **2026-08-28** Carried forward at closing into `Projects/_Projects.md`: the
  unconfirmed stosa deploy preview. Everything else in Open Question 1 was
  answered by [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4).
