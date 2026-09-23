---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-26T17:28:35Z
---
# SturdyRef press tick — bridge stack CI-complete but for one macOS flake (rerunning); bar-2 builder job POSTED (endo-sturdyref-press-20260726-172007)

CI verdict on the 11:44 tick's restacked heads (verified via `gh pr view … statusCheckRollup`):

- **#702 (cut 4) GREEN** at `137673219` — 21/21; the typedoc TS2339 fix held.
- **#704 (cut 6) GREEN** at `e32b01f2a` — 22/22, including `test (24.x)` — the prior Node-24 marshal-timeout was runner flake as suspected; no arbitrary-trimming needed.
- **#703 (cut 5)** at `bb3906aad` — 21/22; sole red is `test (22.x, macos-15)`, failing test `component › token-autocomplete › @-prefixed names match when typed without @` (a chat-UI component test, rejected promise amid daemon RemoteError noise — no sturdyref surface). #704's tree is a strict superset of #703's and passed the same matrix cell, so this is a runner flake. **Reran the failed job** (`gh run rerun 30200670400 --failed`); in progress at tick end — next tick confirms.

**Press action — the bar-2 frontier is now armed:** posted builder job
`endo-sturdyref-agent-surface-build` (role: builder) for design #695's phases 2–3 —
the daemon method audit admitting `SturdyRef` inputs per the authority table (with a
confinement test per admitted method) and the tool-layer escrow in
`@endo/agent-tools` shared by Lal/Fae/Genie. The job stacks on
`build/sturdyref-bridge-6-three-party-roundtrip`, stays DRAFT, and carries a HARD
GATE excluding phase 4 (cross-turn retention — the design forbids shipping it before
the retention/revocation investigation). Design #695 was revised 2026-07-15 to the
maintainer's review (SturdyRefToken removed; one representation, the first-class
pass-style value); no objections outstanding, and the 2026-07-11 press directive
covers advancing this bar as a draft.

**Confinement:** no code pushed this tick (CI-watch + rerun + job post), so the
invariants stand as last exercised on every green head: no-location (sturdyref is
passStyleOf-opaque, leaks no locator; enliven rejects secret-free), no-identification
(same locator mints distinct, unlinkable sturdyrefs), opaque-and-unforgeable
(resolution binding unforgeable). The posted builder job makes all three load-bearing
test requirements for the new surface.

**Next tick:** (1) confirm #703's macOS rerun went green — if it reproduces, treat as
real and debug the token-autocomplete/daemon interaction; (2) watch
`endo-sturdyref-agent-surface-build` (don't collide — it may be claimed and building);
(3) once #703 is green, bar 1 (OCapN sturdyref support, bridge cuts 1–6) is
CI-complete end to end — remaining finish-line work is bar 2 (the posted build) and
then the "throughout" sweep of the agent packages.
