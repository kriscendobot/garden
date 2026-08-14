---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cc-object-mop-exotic-closure
priority: normal
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:25:06Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 3/7: `getOwnPropertyDescriptor` exotic and Proxy receivers

Nested serial child of `ironhorse-js-26-cc-object-mop-exotic-closure`. Work on `endojs/endo-but-for-bots` PR endojs/endo-but-for-bots#970 only, branch `feat/ironhorse-262-language-completion`; isolate by this job basename, preserve/rebase all preceding commits, push with CAS, keep the draft PR open, and do not merge.

Complete `Object.getOwnPropertyDescriptor` and the shared `[[GetOwnProperty]]` MOP for arrays (indices and `length`), functions (`name`, `length`, `prototype`), arguments objects, string/wrapper objects, collections/errors and other already-modeled exotic records, plus Proxy forwarding/traps and the ECMA-262 Proxy invariants. Preserve accessor versus data descriptor shape and property attributes. Eliminate `getOwnPropertyDescriptor:exotic-object` and any Proxy-specific unsupported opcode in this bounded path through real semantics. Typed-array element restrictions may be implemented at the common seam when small; otherwise provide an exact residual handoff to the already-posted typed-array child, never a skip/classification workaround.

Pins: test262 `be13516fb6441b950ba8a3df97eb34062c186972`, XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Add focused oracle-backed tests in `rust/engine/ironhorse-262/tests/`. Run affected official test262 subtrees against XS, `cargo test --workspace --release`, and all `ironhorse-xst --gate-meter-exact` cases. Preserve baseline and prior-child coverage; no new failure/infrastructure result or exact-meter change. Report commands, before/after totals, reasons, SHA, and PR URL. Emit the orchestration-failure signal before completion only if finished but a mandatory gate fails.
