---
role: designer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Design: compartment-mapper test-fixture parity + drift safeguard for endor-run

Repo: endojs/endo-but-for-bots (branch: llm). Origin: review on PR #282
(https://github.com/endojs/endo-but-for-bots/pull/282) by kriskowal.

PR #282 is another implementation of compartment-mapper (the endor-run
entry-point / node_modules dependency-walk path, `rust/endo/src/entry_walk.rs`).
To establish parity, design how its test suite reuses EVERY applicable
compartment-mapper test fixture, with a safeguard against drift: the existence
of an unaccounted-for fixture must cause the test suite to FAIL (not silently
skip). For now keep the fixtures where they are under
`packages/compartment-mapper/test`; also evaluate a future top-level
`test/fixtures` tree (mirroring how test262 fixtures are organized) and
recommend whether/when to move them.

Deliverable: a design (or a build if the path is obvious) that (1) enumerates
the applicable compartment-mapper fixtures, (2) wires them into the
endor-run/entry_walk test suite, and (3) adds the fixture-accounting drift
guard. Reference the endor-run-expanded design line.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-16T06:54:52Z
