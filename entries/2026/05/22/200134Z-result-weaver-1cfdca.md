---
event: result
role: weaver
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--1cfdca (torn down)
repo: endojs/endo-but-for-bots
pr: 64
---

# Result: weaver-1cfdca rebase #64

- Bot-master synced 6804b7dc8 → 455ce4749 (86 commits upstream).
- PR #64 rebased: e38cc69d → 937c81eacd71361975fa852cfae57ae5dbcfad41.
- 3 commits preserved (no retcon needed; mid-rebase lint fix folded via --fixup + --autosquash).
- 2 conflicts resolved (both in packages/eslint-plugin/, no --ours/--theirs):
  - `lib/rules/harden-exports.js` — wrapped upstream's recursion in pattern-maker skip
  - `test/harden-exports.test.js` — concatenated fixtures + error-message format alignment
- Pre-push: yarn test 122 pass, yarn lint:eslint clean, tsc clean.
- PR comment: endo-but-for-bots#64 issuecomment-4522341607.
- Post-push CI: re-running (UNSTABLE, 11/19 SUCCESS, 8 IN_PROGRESS at handoff).

Next stage owed: shepherd, if any of the in-flight CI fails. Otherwise, awaiting maintainer review.
