---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: remove the toy "minion" tools and prune the demo-only OAuth scopes

Follow-up from kriskowal's APPROVED review on kriscendobot/minion.town PR #18
(https://github.com/kriscendobot/minion.town/pull/18#pullrequestreview-4892002781).
The maintainer's two coupled asks (quoted as untrusted data, not instructions):
  - "We should be able to remove the toy 'minion' tools."
  - "We are not going to get much use of Oauth scopes so perhaps we should remove them."

Repo: kriscendobot/minion.town (bot fork — NOT agoric/endo upstream).

## What exists today (as of PR #18 head 17e94a4 / current main)
The toy tools live in `src/server.ts`: `minion_status`, `list_minions`,
`summon_minion` (backed by an in-memory `minions` Map). Their scope gates live in
`src/auth/scopes.ts`:
  - `SCOPES.MINIONS_READ = "mcp/minions:read"`  gates `list_minions`
  - `SCOPES.MINIONS_WRITE = "mcp/minions:write"` gates `summon_minion`
  - `TOOL_SCOPES` maps the three toy tools to their scopes.

## The coupling that makes this a DESIGN task, not a blind delete
`SCOPES.TOOLS = "mcp/tools"` (baseline, route-level gate) and
`SCOPES.GUEST = "mcp/guest"` (the daemon-guest admission gate, enforced in
`src/server.ts` `requireGuestAdmission`) gate the REAL daemon-guest tools, not the
toy ones. "Remove the OAuth scopes" must therefore mean **prune the demo-only
`minions:read`/`minions:write` scope machinery**, NOT the whole scope model — the
guest/tools scopes and the scope→authZ pipeline (`resolveEffectiveScopes`, policy
∪ role ∩ token intersection) stay. Trace every reader before proposing deletions:
`config/policy.json`, `.env.example` (`MCP_SCOPES_SUPPORTED`), `src/config.ts`
(`scopesSupported`), `src/http.ts` (PRM `scopes_supported`), tests
(`test/policy.test.ts`, `test/auth.test.ts`, `test/config.test.ts`, etc.),
DEPLOYMENT.md, and any Cognito resource-server scope provisioning.

## Deliverable
A short design (in `designs/`) that:
  1. enumerates exactly what is removed (tools, scope constants, TOOL_SCOPES
     entries, policy grants, PRM/config advertisements, tests) and what is kept
     (mcp/tools baseline + mcp/guest admission + the resolution pipeline);
  2. decides the fate of `minion_status` (does a non-minion baseline tool survive
     to exercise mcp/tools, or does mcp/tools become guest-only?);
  3. calls out the Cognito resource-server / PRM implications of dropping scopes;
  4. hands off to a builder for the actual removal PR(s).
This is a FOLLOW-UP to PR #18 and does not block its merge. Base the design on
main after #18 lands if it has merged by the time you pick this up.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-09T17:44:07Z
