The design PR has been reviewed, approved, and merged. Here's a summary:

**Design PR:** https://github.com/kriscendobot/minion.town/pull/13 — `design: real daemon-guest-backed MCP tools (retiring the toy server)`

**Review findings:**
- Grounding verified against the live tree at `e82651d` — all references to `src/server.ts`, `root-ctl.ts`, `src/http.ts`, and `src/endo/identity.ts` are accurate
- Gate re-ordering is correct: Gate 1 (Claude OAuth testing) no longer blocks daemon work; every increment validates via the repo's PKCE client
- B0–B6 build decomposition is well-ordered with concrete, testable validation hooks for each phase
- Authority boundary correctly stated: app is the membrane, bootstrap yields host powers spanning all tenants, per-user enforcement in the app
- Failure policy (halt) appropriate for a deployment path

**Action taken:** PR marked ready → merged via squash. Branch `design/mcp-daemon-guest-tools` deleted. Build phases B0–B5 are now actionable; B6 (`@endo/mcp` extraction) remains maintainer-gated as noted in the design.

**Issue reply posted on kriskowal/garden#58** confirming the merge and outlining next steps.
