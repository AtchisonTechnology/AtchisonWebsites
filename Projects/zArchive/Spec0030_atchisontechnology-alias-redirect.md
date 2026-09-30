# Redirect the atchisontechnology.com alias domain to leeatchison.com

* **ID:** Spec0030
* **Status:** Closed
* **Date Created:** 2026-09-30
* **Date Implemented:** 2026-09-30
* **Date Completed:** 2026-09-30
* **Systems Impacted:** LeeAtchison
* **Pull Request:** None (committed directly to main)

---

## Problem/Requirement

`atchisontechnology.com` and `www.atchisontechnology.com` are alias domains on
the leeatchison.com Netlify site. With no redirect rules for them, they served
the full leeatchison.com site under their own hostname, returning `200` for
every path rather than redirecting.

That is duplicate content at a second domain. Search engines see two copies of
every page and have to guess which one is the original, splitting ranking
signals between them. `LeeAtchison` pages carry no general-purpose canonical
tag (the Spec0009 cross-domain canonicals cover only shared books and
courses), so nothing on the page itself resolves the ambiguity.

Requirement: every URL on `*.atchisontechnology.com` redirects to the
equivalent URL on `leeatchison.com`.

---

## Solution/Fix/Change

Four domain-level rules added to `LeeAtchison/netlify.toml`, placed ahead of
every existing path rule so they match first:

```toml
[[redirects]]
  from = "https://atchisontechnology.com/*"
  to = "https://leeatchison.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "http://atchisontechnology.com/*"
  to = "https://leeatchison.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "https://www.atchisontechnology.com/*"
  to = "https://leeatchison.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "http://www.atchisontechnology.com/*"
  to = "https://leeatchison.com/:splat"
  status = 301
  force = true
```

Design decisions, each recorded in the comment above the rules:

- **Path-preserving.** `:splat` carries the path across, so a deep link lands
  on the same page on leeatchison.com rather than the home page. Netlify
  carries query strings over by default.
- **301, permanent.** Unlike the atchisonacademy.com alias in Spec0002 (302,
  because that domain was going to become its own site), this alias is never
  going to be a destination of its own. A permanent redirect is what
  consolidates its search ranking onto leeatchison.com.
- **Both schemes listed.** Netlify matches domain-level rules on the exact
  scheme, so `http` and `https` each need a rule.
- **Ordered first.** A path that has its own redirect on leeatchison.com
  (`/academy`, `/ai-native`) takes a second hop from there. That is harmless
  and keeps the domain rules simple.

### Out of scope

Netlify domain configuration is unchanged. Both domains must remain aliases
on the leeatchison.com Netlify site with valid certificates for these rules
to apply.

---

## Testing

1. **File validity.** `netlify.toml` parses as TOML; the redirect list reads
   the four alias rules first, followed by the unchanged `/academy` and
   `/ai-native` rules. Done 2026-09-30.
2. **Pre-change baseline.** `curl -sI https://www.atchisontechnology.com/`
   returned `HTTP/2 200` from Netlify, confirming the domain is served by
   this site. Done 2026-09-30.
3. **After deploy,** each of these should report `301` with the
   matching `location: https://leeatchison.com/...`:

   ```bash
   curl -sI https://atchisontechnology.com/ | grep -iE "^(HTTP|location)"
   curl -sI https://www.atchisontechnology.com/books/ | grep -iE "^(HTTP|location)"
   curl -sI http://atchisontechnology.com/ainative/ | grep -iE "^(HTTP|location)"
   ```

---

## Summary of Steps Needed

1. Add the four alias redirect rules to `LeeAtchison/netlify.toml`. Done.
2. Commit and push to main (Lee).
3. Run the post-deploy curl checks above.
