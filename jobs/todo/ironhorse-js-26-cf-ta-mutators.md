---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:55:20Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Continue endojs/endo-but-for-bots PR #970 on shared branch feat/ironhorse-262-language-completion after commit 409b20029a. Use ensure-project-worktree.sh with this child base; preserve and rebase prior commits; push serially with a fetch/rebase CAS loop. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d. Implement TypedArray copyWithin, fill, set, and reverse standards-faithfully, including receiver validation, coercion, overlap, typed and array-like sources, BigInt mismatch, and detached-buffer errors. Add dual-run Rust regressions. Run the affected pinned Test262 subtree against XS, the exact-meter gate, and cargo test workspace release before every push. Do not relabel, suppress, or skip cases. Keep PR draft/open.
