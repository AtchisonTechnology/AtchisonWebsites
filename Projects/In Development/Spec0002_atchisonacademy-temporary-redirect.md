# Change the atchisonacademy.com alias redirect from permanent to temporary

* **ID:** Spec0002
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-08-28
* **Date Implemented:** (pending)
* **Systems Impacted:** LeeAtchison

---

## Problem/Requirement

`atchisonacademy.com` is currently an alias domain on the leeatchison.com
Netlify site. Two rules in `LeeAtchison/netlify.toml` send every path on that
domain (and its www variant) to `https://leeatchison.com/academy/` with
**status 301, force = true**.

A 301 tells browsers and search engines that the move is permanent and that
`atchisonacademy.com` should stop being treated as a destination in its own
right. Neither is true. Atchison Academy is planned to become its own site at
its own domain in the near future, which makes this redirect temporary by
definition. It is currently declared as the opposite.

This is not a cosmetic distinction. It causes two concrete problems on the day
the standalone Academy site launches.

### Problem 1: browsers cache 301s aggressively and for a long time

A 301 with no explicit cache directive is treated by browsers as cacheable
more or less indefinitely. Chrome, Safari, and Firefox all persist permanent
redirects in an on-disk cache that survives restarts, and there is no
server-side way to purge them. Every visitor who lands on atchisonacademy.com
between now and the cutover is being handed a durable instruction to never ask
for that domain again.

When the standalone site goes live, those visitors will keep being sent to
leeatchison.com/academy/ from their own cache, without a request reaching
Netlify at all. Their browser will not learn about the change until the user
clears their cache or the entry is evicted. For the audience most likely to
have visited early (readers who follow Lee's work, and Lee himself while
testing), the broken experience lands on exactly the wrong people.

A 302 is not persistently cached by default and is re-validated on the next
request, so a cutover takes effect immediately.

### Problem 2: search engines are being told to drop the domain

With a 301, Google consolidates atchisonacademy.com into
leeatchison.com/academy/, transfers link signals to the target, and over time
drops the alias from its index as a distinct URL. That is the correct behavior
for a domain being retired. It is the wrong behavior for a domain being
promoted to its own site, which then has to be re-established from a standing
start.

A 302 keeps atchisonacademy.com indexed as itself while the content
temporarily lives elsewhere, which is precisely the situation today.

This matters more here than it would on most sites, because
`LeeAtchison/src/_partials/_head.erb` emits **no canonical link tag** on any
page. The redirect status code is therefore the only canonicalization signal
search engines receive for this domain. There is no `rel="canonical"` doing
quiet corrective work behind it.

### Why now

The 301 keeps working correctly right up until the moment it doesn't, and the
damage it does (cached redirects sitting in visitors' browsers, deindexing of
the alias) accumulates the whole time it is in place and cannot be undone
retroactively. Every week it stays is a larger population of browsers holding a
permanent redirect that will need to be manually cleared. Changing it early is
strictly cheaper than changing it late, and the change itself is two characters.

---

## Solution/Fix/Change

In `LeeAtchison/netlify.toml`, change `status = 301` to `status = 302` on the
two atchisonacademy.com redirect rules, and update the explanatory comment
above them to record why the status is temporary.

**Current:**

```toml
# Domain redirects must come first — netlify.toml rules are evaluated in order,
# and these should win over any path rule below.
#
# atchisonacademy.com is an alias domain on this site. Without these rules it
# serves the whole leeatchison.com site under a second domain name (duplicate
# content). Send every path on it to the Academy page instead.
[[redirects]]
  from = "https://atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 301
  force = true

[[redirects]]
  from = "https://www.atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 301
  force = true
```

**Proposed:**

```toml
# Domain redirects must come first — netlify.toml rules are evaluated in order,
# and these should win over any path rule below.
#
# atchisonacademy.com is an alias domain on this site. Without these rules it
# serves the whole leeatchison.com site under a second domain name (duplicate
# content). Send every path on it to the Academy page instead.
#
# These are 302 (temporary), deliberately. Atchison Academy is planned to
# become its own site at atchisonacademy.com. A 301 would be cached
# indefinitely by browsers and would deindex the domain in search, both of
# which would have to be undone by hand at cutover. Keep these temporary until
# the standalone site exists, at which point these rules are deleted, not
# changed.
[[redirects]]
  from = "https://atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 302
  force = true

[[redirects]]
  from = "https://www.atchisonacademy.com/*"
  to = "https://leeatchison.com/academy/"
  status = 302
  force = true
```

Note that Netlify defaults to 301 when `status` is omitted, so the value must
stay explicit.

### Explicitly out of scope

The two `/ai-native` path redirects further down the same file stay at **301**.
Those are a genuine permanent path rename within leeatchison.com, which is
exactly what a 301 is for. Only the alias-domain rules change.

No other site in the monorepo has redirect rules; all four other
`netlify.toml` files contain build config and headers only. This change is
confined to one file.

### Known limitation, stated plainly

This change stops the problem growing. It does not fix it retroactively.

Any browser that has already followed the 301 may still hold it cached, and
nothing done on the server can evict that entry. Those visitors will need to
clear their cache, or wait for eviction, after the standalone site launches.
The size of that population is unknown but grows every day the 301 remains,
which is the argument for making the change now rather than at cutover.

---

## Testing

1. **Local verification of the file.** Confirm both alias rules read
   `status = 302`, both `/ai-native` rules still read `status = 301`, and the
   comment block is updated.
2. **Deploy preview.** Netlify applies redirect rules to deploy previews.
   Confirm the build succeeds and the rules parse (a malformed `[[redirects]]`
   block fails the deploy loudly, which is the desired failure mode).
3. **Verify the live status code after deploy:**

   ```bash
   curl -sSI https://atchisonacademy.com/ | head -5
   curl -sSI https://www.atchisonacademy.com/ | head -5
   curl -sSI https://atchisonacademy.com/some/deep/path | head -5
   ```

   Each should report `HTTP/2 302` and
   `location: https://leeatchison.com/academy/`.

4. **Verify the /ai-native redirects still report 301:**

   ```bash
   curl -sSI https://leeatchison.com/ai-native | head -5
   ```

5. **Check the cache headers on the redirect response.** The site sets a
   global `Cache-Control: public, max-age=604800` header for `for = "*"`. If
   that header is being applied to redirect responses, a 302 would still be
   cached for seven days, which would partly defeat the purpose. Inspect the
   `cache-control` line in the curl output above. If the redirect response
   carries a week-long max-age, add an explicit short or no-store cache header
   scoped to these redirects. See Open Questions.
6. **Functional check.** Visit atchisonacademy.com in a browser that has never
   visited it before (a fresh private window is sufficient) and confirm it
   still lands on the Academy page. The user-visible behavior must be
   unchanged; only the status code differs.

---

## Summary of Steps Needed

1. Resolve the Open Questions below.
2. Edit the two alias redirect rules in `LeeAtchison/netlify.toml` to
   `status = 302` and update the comment block.
3. Verify the `/ai-native` rules were not touched.
4. Deploy and run the curl verifications above.
5. Check the cache-control header on the redirect response and add a scoped
   header rule if needed.
6. Request permission to commit; create a PR on request.

---

## Open Questions

1. **302 or 307?** Both are temporary. 302 is universally understood and is the
   conventional choice for this case. 307 additionally guarantees the request
   method is preserved, which only matters for non-GET requests, and this is a
   static marketing site that receives none. *Recommendation: 302.*
2. **Cache headers on the redirect response.** If test step 5 shows the global
   seven-day `Cache-Control` header being applied to the redirect, should this
   spec also add a scoped short-lived or `no-store` cache header for the alias
   domain? *Recommendation: yes, if the test shows it is needed. It would make
   the temporary redirect actually behave temporarily. Deferred until the
   header behavior is confirmed rather than assumed.*
3. **Timing relative to the standalone site.** Is the Academy site close enough
   that it would be simpler to wait and delete these rules outright? *
   Recommendation: no, make the change now. The cached-301 population grows
   daily and the change is two characters, so there is no benefit to waiting
   and a real cost to it.*
4. **Branching mode.** Implement on `main` (a two-character config change) or
   in a `spec0002` worktree? *Recommendation: main, given the size, though the
   change cannot be verified end to end until it is deployed.*

---

## History of Updates

* **2026-08-28** Spec created at Lee's request, arising from Spec0001. While
  specifying the Atchison Academy hero on stosa.org, the atchisonacademy.com
  301 redirect was documented as background. Lee identified that a permanent
  redirect is the wrong declaration for a domain he plans to change soon, and
  asked for the analysis and a separate spec.
* **2026-08-28** Analysis performed and agreed: 301 is incorrect here on two
  independent grounds (indefinite browser caching of permanent redirects, and
  search-engine deindexing of a domain that is about to be promoted rather than
  retired). Both problems land at cutover and neither is fixable retroactively.
* **2026-08-28** Audited redirect rules across all five sites. Only
  `LeeAtchison/netlify.toml` contains any. Established that the two
  `/ai-native` rules in the same file are a genuine permanent path rename and
  must stay 301, scoping this spec to the two alias-domain rules only.
* **2026-08-28** Established that `LeeAtchison/src/_partials/_head.erb` emits no
  canonical link tag, so the redirect status is the only canonicalization
  signal search engines receive for the alias domain. Recorded as
  reinforcing the case.
* **2026-08-28** Recorded the limitation that this change is not retroactive
  for browsers already holding the cached 301, and noted the global seven-day
  `Cache-Control` header as a thing to verify against the redirect response
  (Open Question 2).
