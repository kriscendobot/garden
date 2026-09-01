---
created: 2026-09-01
author: liaison
---

# Skill: minion-town-clip-publishing

Known constraints and gotchas — and, as of writing, an open platform bug —
when building and publishing a "clip" (a static site published via
`mcp__minion-town__publish`) through the Endo-daemon guest MCP surface. Read
this before spending a cycle rediscovering these facts. Distinct from
[minion-town-mcp-playwright-login](../minion-town-mcp-playwright-login/SKILL.md),
which authenticates a browser to the MCP endpoint itself, not to a published
clip's normal public URL — a visitor to a clip needs no login at all.

## What a clip actually is

- Fully static, immutable, content-addressed files served from
  `<hash>.ocap.site`. The response carries `cache-control: public,
  max-age=31536000, immutable` and a stable ETag regardless of method (GET/
  HEAD), query string, or `Accept` header — verified with `curl -i` plus two
  independent Playwright navigations to the same URL, comparing status, ETag,
  and body (the cheapest way to prove "genuinely static" rather than
  "coincidentally identical").
- `upgrade` cannot rewrite live content today; both its own tool description
  and its actual runtime behavior say so ("not yet supported when publishing
  is served live").
- There is **no per-request dynamic execution surface** exposed to a clip's
  *visitors* through the documented MCP tools. A "live" server-computed value
  (an auto-incrementing visit counter, say) is not achievable today. The best
  a clip can do is bake in a value current as of publish time (e.g. read from
  the guest's own `writeText`/`readText` store at build time) — and the page
  should say so honestly, rather than presenting a build-time snapshot as a
  live tally.
- The clip's fixed CSP: `script-src`/`style-src`/`connect-src 'self'`,
  `img-src 'self' data:`. Ship all JS/CSS as separate same-origin files, never
  inline; no cross-origin fetch or image load is possible.
- The `gateway/` and `.well-known/` path prefixes are reserved and `publish`
  rejects content there; as of writing they simply 404, with no documented
  purpose disclosed.

## `publish` gotchas

- `powers` must name a pet name in your guest holding a sites capability; in
  practice pass `"sites"` (the literal name a guest is provisioned with).
- **`Invalid pet name "@main"` on publish — diagnosed and FIXED, deployed
  2026-09-01.** Symptom: a `publish` call failed unconditionally with
  `Invalid pet name "@main"`, regardless of the `powers` value or the
  `content` payload. Root cause was **not** guest provisioning: the app
  probed `guest.has("@main")` to choose between the intended `@main` worker
  and the legacy `MAIN` worker, but the production-pinned Endo daemon does not
  endow `@main` — its `has` delegates the unknown `@`-prefixed name to the
  ordinary pet-name store, whose grammar *rejects* names containing `@` (it
  throws instead of returning `false`), so the error propagated before the
  guest evaluation ever ran. `status`/`list` on such a guest show the seeded
  reserved names (`@agent`, `@host`, `@mail`, `@nets`, `@planes`, `@self`,
  plus `MAIN`) but never `@main`.
  - **Fix**: kriscendobot/minion.town#71 (merged to `main` as `975a035`,
    commit `79c0430`) treats a *rejection* of the `has("@main")` probe as
    "not endowed" and falls back to the legacy `MAIN` worker, with a
    regression test that makes `has("@main")` throw the pinned daemon's error
    and asserts evaluation proceeds on `MAIN`. Once Endo endows `@main` the
    app will select it without another migration.
  - **Deploy**: the merge auto-triggered minion.town's CD workflow
    (`deploy.yml`, push-to-`main`), which redeployed the app to production
    (run `33551873310`, success 2026-09-01T19:53Z).
  - **Affected guest scope & repair**: the fallback is a client-side
    compatibility shim that **repairs legacy guests in place** — no
    per-guest provisioning or manual repair is required. Any guest holding
    `MAIN` (rather than `@main`) is served by the fallback automatically.
  - **Verification evidence (post-deploy, 2026-09-01)**: the exact failing
    call — `publish` with `powers: "sites"` and one `index.html` whose base64
    bytes are `dGVzdA==` — now returns a hash/URL with `serving: true`
    instead of the error; fetching the returned `<hash>.ocap.site` URL gave
    HTTP 200 with body `test` and ETag = `sha256("test")`. Smoke clip cleaned
    up with `unpublish`.

## `evaluate` gotchas

- The tool description reads as literal-value binding ("for `2 + 2`, pass
  `source: \"2 + 2\"`"), and the schema types `values` as `{}` (any) — but in
  practice each `values` entry must be the **name of an existing pet name** in
  your guest, not a literal. A literal number errors `Must match one of (a
  string)`; an arbitrary non-pet-name string errors `Unknown pet name`; and
  even a valid pet name created via `writeText` binds inside the evaluated
  source as an opaque object, not the plain string you wrote. Treat `names`/
  `values` as capability-passing, not literal-argument binding.

## Verification pattern that worked

- `curl -i <clip-url>` to confirm static/immutable serving.
- No `playwright` package is preinstalled anywhere in the garden containers;
  `npm install playwright` locally into a scratch directory works fine
  (network access is available). Route all such local files through
  `/home/kris/garden/scratch/<eval-name>/`, never the garden tree root.

Provenance: written from an evaluation session (2026-09-01) whose subagent
attempted to build and publish a new odometer-styled visitor-counter clip,
verified the built page locally with Playwright, and could not publish it due
to the bug above.
