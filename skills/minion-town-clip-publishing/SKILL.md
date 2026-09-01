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
- **Known bug, unresolved as of 2026-09-01**: a `publish` call can fail
  unconditionally with `Invalid pet name "@main"`, regardless of the `powers`
  value (tried `sites` and three other held-capability pet names — 13 total
  attempts) or the `content` payload (tried a 1-file trivial payload through a
  full real page). `status`/`list` on the same guest already showed several
  `@`-prefixed reserved names (`@agent`, `@host`, `@mail`, `@nets`, `@planes`,
  `@self`) — evidently seeded by the platform through a path the ordinary MCP
  tool surface doesn't expose — but not `@main` specifically. `has`'s own
  validator rejects any pet name containing `@`, so there is no documented,
  tool-reachable way for a guest to provision or repair this client-side. If
  you hit this, don't keep varying `powers`/`content` hunting for a fix on
  your side — it isn't there; report it instead. Filed as
  `minion-town-fix-publish-invalid-main-pet-name` on the garden job board
  (`kriscendobot/minion.town`) — check whether it has since landed before
  re-diagnosing from scratch.

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
