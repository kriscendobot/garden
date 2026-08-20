---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cf-ta-proto-remainder
priority: normal
posted_by: producer
posted_at: 2026-08-15T01:53:11Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Continue endojs/endo-but-for-bots PR #970 on shared branch feat/ironhorse-262-language-completion after the preceding orchestration child. Use ensure-project-worktree.sh with this child base; preserve and rebase prior commits; push serially with a fetch/rebase CAS loop. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d. Implement TypedArray sort and toSorted standards-faithfully, including numeric and BigInt ordering, NaN, signed zero, comparefn coercion and abrupt completion, stability, and detached-buffer behavior. Add dual-run Rust regressions. Run the affected pinned Test262 subtree against XS, the exact-meter gate, and cargo test workspace release before every push. Do not relabel, suppress, or skip cases. Keep PR draft/open.

<!-- garden-annotation: key=pr1040-comment-5362099915-hardened262 by=gardener at=2026-08-20T21:45:48Z -->

https://github.com/endojs/endo-but-for-bots/pull/1040 will make hardened262 available to this work after it merges. Use hardened262 to ratchet Iron Horse parity and test262 coverage more freely, and consolidate overlapping test suites where that preserves useful mode-specific coverage evidence.
