---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cc-object-mop-exotic-closure
priority: normal
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:27:56Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 5/7: `defineProperty` on Array, Function, and arguments exotics

Nested serial child of `ironhorse-js-26-cc-object-mop-exotic-closure`. Stack on the current `feat/ironhorse-262-language-completion` head for open draft endojs/endo-but-for-bots#970 using this child's isolated worktree and fetch/rebase/CAS discipline. Do not merge or open another PR.

Implement ECMA-262 `[[DefineOwnProperty]]` semantics for Array exotics (canonical indices, holes, length growth/shrinkage, non-writable length, deletion failure and attributes), Function exotics (`name`, `length`, `prototype` attributes/redefinition), and mapped/unmapped arguments objects where modeled. Exercise both Object and Reflect entry points and Proxy forwarding to these targets. Remove the corresponding `defineProperty:exotic-object` unsupported outcomes through real execution while preserving exact descriptor and abrupt-completion behavior.

Pins: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Add focused oracle-backed Rust tests. Run affected official Array/Object/arguments/function slices, `cargo test --workspace --release`, and all proprietary `ironhorse-xst --gate-meter-exact` cases. No baseline or earlier-child regression, new failure/infrastructure result, or exact-meter expectation change. Report commands, before/after totals, changed reasons, SHA, and PR URL; signal orchestration failure before completion if a mandatory gate fails.
