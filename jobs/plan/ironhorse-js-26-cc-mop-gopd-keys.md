---
gate: go-ahead
priority: normal
role: mentor
tier: mentor
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-15T00:43:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-15T00:43:03Z
---

---
role: mentor
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T00:01:18Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 2/7: `getOwnPropertyDescriptor` coercion and index keys

Nested child of `ironhorse-js-26-cc-object-mop-exotic-closure`; build on every earlier child on the shared serial branch. Repository and PR: `endojs/endo-but-for-bots`, existing open draft endojs/endo-but-for-bots#970, branch `feat/ironhorse-262-language-completion`. Use an isolated project worktree keyed by this child, fetch/rebase before work and before CAS push, keep the PR open, and do not create or merge another PR.

Implement ECMA-262 `Object.getOwnPropertyDescriptor` receiver conversion and property-key conversion for primitive receivers, symbols, and canonical/non-canonical index strings. Route descriptor lookup through the common `[[GetOwnProperty]]` MOP instead of the ordinary-slot-only fast path. Cover absent and present descriptors and preserve exact data/accessor descriptor shapes and abrupt-completion order. Eliminate the in-scope `getOwnPropertyDescriptor:non-object` and index-key unsupported outcomes by real execution.

Use test262 pin `be13516fb6441b950ba8a3df97eb34062c186972` and XS pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Add focused differential Rust tests under `rust/engine/ironhorse-262/tests/`; run affected official slices, `cargo test --workspace --release`, and the complete `ironhorse-xst --gate-meter-exact` corpus. Preserve baseline/earlier-child coverage, introduce no failure or infrastructure result, and do not alter proprietary exact-meter expectations. Report commands, before/after totals, reason changes, pushed SHA, and PR URL. A genuinely finished child that misses a gate must emit the exact orchestration-failure signal before completion.
