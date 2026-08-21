---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-21T22:18:52Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (base branch `main`, bot-owned, commits carry the
bot identity — no ferry).

**Task: port just the `whoami` baseline tool forward onto `main`.**

Context: PR #36 ("feat: remove toy minion tools and prune demo-only minion
scopes") is being closed as superseded by PR #20 ("feat: retire toy MCP tools for
daemon guests"), which lands the same toy-tool / `mcp:minions:*` removal coupled
with the B5 daemon-guest feature. But #20 does **not** carry #36's one independent
addition: the `whoami` baseline tool. In #20's merged state the only tool surface
is the daemon-guest surface (`guest_*` + weblet tools); none of those report the
caller's OAuth-resolved identity/role/effective scopes (`guest_status` only probes
the guest's pet-name count). So closing #36 would silently drop `whoami` — this job
ports it forward as a small standalone addition.

What to add (source of truth: PR #36's diff to `src/server.ts`,
`src/auth/scopes.ts`, tests, and the `whoami` docs in `deploy/aws/www/*.html`):

- A non-mutating first-party tool `whoami`, gated by `SCOPES.TOOLS` (add
  `whoami: SCOPES.TOOLS` to `TOOL_SCOPES` in `src/auth/scopes.ts`).
- It reports the caller's resolved identity, role, and **effective** scopes,
  recomputing `resolveEffectiveScopes(policy, store, caller, tokenScopes, ...)`
  and deriving the display role the same way #36 does (store role, else `admin`
  for a statically-listed identity, else null).
- Register it in `createMcpServer` alongside the always-mounted `guest_*` surface
  #20 introduced (NOT as a "pre-Endo only" tool — #20 removed the empty-server
  case; `whoami` is simply an additional baseline diagnostic). A token missing
  `mcp/tools` must be denied `whoami` with `insufficient_scope`.
- Carry #36's tests for `whoami` (admin sees identity+scopes; a fresh verified
  principal is admitted as `guest` and `whoami` reports it; missing `mcp/tools`
  is denied), adapted to #20's server shape.
- If cheap, carry the small `whoami` doc blurb in `deploy/aws/www/connect.html`
  (and `index.html`) that #36 added.

Do NOT re-remove anything #20 already removed; this is a pure additive port of the
`whoami` tool only. Land it as a PR against `main` (the fork is watched, so it
draws review), typecheck + `npm test` green before opening. This job is blocked on
the #20 merge so it runs against the merged base.
