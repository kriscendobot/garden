CI is green (`test` passed in 41s). The deliverable is complete: implementation, tests, docs, e2e regression, and a migration path, with PR #82 open, mergeable, and CI-green.

## Completion report

**Job:** `minion-town-oauth-guest-facet-default` — eliminate the client-side `mcp/guest` scope ceremony for the MCP guest surface (kriscendobot/minion.town).

**What I did**
Made a standard MCP `mcp/tools` OAuth login sufficient to reach the caller's **own** guest facet, with no separate `mcp/guest` selection, while preserving least authority.

**Core mechanism** — `mcp/guest` is now *implied* by `mcp/tools` at the admission layer:
- `src/auth/scopes.ts`: added `expandImpliedScopes()` — a token carrying `mcp/tools` is treated as also carrying `mcp/guest` (idempotent; explicit-guest tokens are a no-op).
- `src/auth/accounts.ts`: `resolveEffectiveScopes` runs the token through `expandImpliedScopes` **before** the grant intersection. Because effective = `(static policy ∪ active role) ∩ presented`, the implication is a *token-layer widening only* — a route-only identity (grant = `mcp/tools` alone) has the implied `mcp/guest` intersected back out, so least authority holds. Suspension still zeroes the dynamic grant; the facet is still composed from the caller's own identity (no host/admin or cross-guest power).
- `src/server.ts`: documented the implication at the per-call admission gate (unchanged logic).

**Client behavior**
- `dev/client.ts`: now requests `mcp/tools` only (`SCOPE=` env override exercises the legacy explicit-scope path).

**Tests**
- **New e2e regression** `test/oauth-guest-default-scope.test.ts` (real mock AS + real middleware): a `mcp/tools`-only login lists the guest + clip tools, calls `status`, and publishes a minimal clip with no second scope-selection step; a companion case proves an explicit `mcp/tools mcp/guest` token behaves identically.
- `test/accounts.test.ts`: replaced the obsolete "tools-only stays route-only" assertion with the new implication behavior, and added a least-authority case (route-only grant strips implied guest).
- `test/endo-guest-tools.test.ts`: updated the admission test to admit a tools-only token, plus a genuine denial case (a non-guest is still denied even with a full token).

**Migration / compatibility path** (documented + tested): legacy `mcp/tools`-only tokens are now admitted to guest; explicit `mcp/tools mcp/guest` tokens are unchanged; Cognito may keep granting `mcp/guest` (harmless) or drop it from client requests at leisure.

**Docs**: `README.md` (quickstart flow + admission section), `DEPLOYMENT.md` (Cognito resource-server note + resolution algebra), `designs/mcp-daemon-guest-tools.md` (§ Admission).

**Verification**: `npm run typecheck` clean; `npm test` = 304 passed / 5 skipped (CI = typecheck + vitest). Pushed to `feat/oauth-guest-facet-default`; **PR #82** opened (draft, mergeable), and its `test` CI check is **green**.

**Follow-ups**: PR #82 is draft pending the review gauntlet (`run the gauntlet #82`) and maintainer merge — the normal post-build state; no code work remains.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-oauth-guest-facet-default.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 172 tokens (9590663 cached reads)
- Output: 42237 tokens
- Cost: $7.373816500000002
- Wall-clock: 639s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
