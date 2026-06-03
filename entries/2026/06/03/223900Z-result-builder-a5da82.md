---
ts: 2026-06-03T22:39:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: a5da82
prs:
  - { repo: endojs/endo-but-for-bots, pr: 420, role: new }
refs:
  - entries/2026/06/03/222309Z-dispatch-builder-a5da82.md
  - entries/2026/06/03/222030Z-result-researcher-895d06.md
  - https://github.com/endojs/endo-but-for-bots/pull/420
---

# result: builder — PR #420 gateway phase 11b CAS-fetch for Host-header weblets

- PR #420 DRAFT, base design/gateway-package-phase-11
  (PR #413 head), head design/gateway-package-phase-12.
- 503 gateway tests pass (471 → 503, +32 new: 22 weblet-fetch
  unit + 10 http-listener integration).
- First researcher-precedence-honoring dispatch this session;
  inlined refinement from researcher 895d06.

Files:
- `src/weblet-fetch.js` (new): CAS-walk + streaming;
  `{formula, pathSuffix}` → response shape.
- `src/http-listener.js`: Host-header branch routes to new
  module when `serveWeblet` power wired; preserves 501
  fallback when absent.
- `src/types.d.ts`: ServeWeblet* typedefs +
  `GatewayPowers.serveWeblet`.
- `index.js`: wires power, re-exports helpers.
- `test/weblet-fetch.test.js` (new, 22 tests).
- `test/http-listener.test.js`: 10 new Phase-11b integration
  tests.

Cache-Control: `public, max-age=31536000, immutable` per
content-addressed semantics.

## Researcher Open Question 3 resolution

`UserDaemon.fetchContentTree` does NOT exist on daemon today.
Phase 11b explicitly scoped to gateway-side `serveWeblet`
composite power (formula resolve + tree walk + CAS-blob stream
behind a single `{webletFormulaId, pathSuffix}` → result call).
Daemon-side adapter is a separate stacked PR.

When `serveWeblet` power is absent (no daemon-side wiring),
listener falls back to Phase-11a 501 + `X-Endo-Weblet-Formula`
placeholder for back-compat.

## Liaison disposition

Dispatch root torn down. **Gateway stack substantively
complete**: 12 stack PRs (#343, #388, #389, #392, #393, #394,
#395, #396, #397, #409, #413, #420) + 2 sibling PRs (#410
CLI/systemd, #412 distribution recipes). The daemon-side
`fetchContentTree` adapter is the named remaining gap; that's
a daemon-side PR, not a gateway-stack continuation.

Library-side gaps the researcher surfaced (designs/gateway-
package.md not ingested; WebletFormula / fetchContentTree /
content-tree-walk semantics absent from keywords.md) are
seed material for the next librarian / scholar cycle.

Self-improvement: this dispatch executed cleanly because the
researcher precedence grounded the prompt in 6 library
sections + 3 project entries + 3 design-file references the
builder could read in one pass; no mid-engagement "wait, is
this the right shape?" detours. Confirms the role's value.
