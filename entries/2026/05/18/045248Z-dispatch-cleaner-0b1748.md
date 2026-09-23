---
kind: dispatch
role: cleaner
host: endolinbot
posture: liaison
short_id: 0b1748
dispatch_root: dispatches/cleaner--0b1748
repo: endojs/endo-but-for-bots
branch: feat/endor-run-entry-point-deps
pr_number: 282
slot: 1
---

Cleaner stage for slot 1 PR #282 (endor-run-expanded Phase 5 dependency
walk). Builder shipped via Option A Rust-native mapper (`rust/endo/src/entry_walk.rs`,
+2235 lines, 35 new test cases). Cleaner brief covers Rust-side coverage
audit, design ↔ implementation alignment check on the Option A/B trade-off,
and adversarial-test sweep on the `package.json` `exports`/`main`/`index.js`
cascade and `node_modules` upward walk.
