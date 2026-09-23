---
ts: 2026-05-22T19:59:34Z
kind: result
role: weaver
worktree: dispatches/weaver--1cfdca/project
repo: endojs/endo-but-for-bots
project: endo
---

Rebased PR #64 (`design/issue-2632-harden-exports-pattern-makers`) onto a freshly synced bot-master.

**Pre-work, bot-master sync.** Before rebasing, force-pushed `endo-upstream/master` to `origin/master` per `feedback_bot_master_reset_to_actual.md`: bot-master moved from `6804b7dc8` (lease anchor) to `455ce4749` (current upstream tip). The sync brought in 86 upstream commits, the most relevant being `e153a5afa` (upstream PR #3274 / issue #2390) which substantially refactored `packages/eslint-plugin/lib/rules/harden-exports.js` and consolidated its error message format.

**Rebase.** 3 commits replayed onto `origin/master@455ce4749`. The first commit (`feat(eslint-plugin): harden-exports skips M.* pattern makers`) conflicted in 2 files; the remaining 2 commits replayed clean.

**Conflicts (2 files, both in `packages/eslint-plugin/`):**

1. `lib/rules/harden-exports.js` — upstream replaced the ad-hoc binding-pattern traversal with a recursive `pushDeclaredNames` helper and added `allRecognized` tracking with an `unknownBindingPattern` report. The PR commit added a Pattern-maker-call skip on the same per-declaration loop. Resolution: kept upstream's recursive traversal verbatim and wrapped it in `if (!isPatternMakerCall(declaration.init)) { ... }`. The `isPatternMakerCall` helper itself is unchanged from the PR. Both intents are honored: Pattern-maker initializers short-circuit before any name extraction; every other declaration goes through the new recursive helper.

2. `test/harden-exports.test.js` — both sides appended fixtures. Upstream added 9 valid + 11 invalid destructuring-pattern fixtures; the PR added 4 valid + 3 invalid Pattern-maker fixtures. Resolution: concatenated. The PR-side invalid fixtures' error messages were updated from the old `"Named export 'x'"` form to upstream's consolidated `"Named export(s) 'x'"` form (which upstream's commit established for the single-name case).

**Retcon shape.** No retcon. Post-rebase shape stayed clean: three discrete commits matching the original PR intent (the M.* skip, the new `no-harden-pattern-maker` rule, and the `UNNECESSARY-HARDENS.md` drop), no intermediate broken states, no lockfile churn.

**One mid-rebase fixup, autosquashed.** The initial conflict resolution used `continue` to skip Pattern-maker initializers, which trips the package's own `no-continue` lint rule. Inverted to `if (!isPatternMakerCall(...)) { ... }` (the existing recursion sits inside the predicate; net rule logic unchanged). Folded into the harden-exports commit via `git commit --fixup` + `git rebase --autosquash`, not left as a separate commit.

**Verification before push.**
- `yarn test` in `packages/eslint-plugin`: 122 passing (includes the new destructuring fixtures, the new Pattern-maker fixtures, and the existing `no-harden-pattern-maker` rule tests).
- `yarn lint:eslint` and `yarn lint:types` (tsc): clean.

**Push.** `git push --force-with-lease=design/issue-2632-harden-exports-pattern-makers:e38cc69d73d8bd03063c768420ac344503984ef7 origin HEAD:design/issue-2632-harden-exports-pattern-makers`. Old head `e38cc69d7`, new head `937c81eac`.

**Top-level PR comment** posted at `https://github.com/endojs/endo-but-for-bots/pull/64#issuecomment-4522341607` summarizing the conflict resolution shape and the no-retcon decision.

**CI re-run trigger.** The force-push re-triggered the full CI suite on `937c81eac`. As of post-push check: `build` and `zizmor` already SUCCESS; the rest (`lint`, `test` matrix, `cover`, `test262`, `test-xs`, `test-hermes`, `browser-tests`, `test-ocapn-python`, `test-async-hooks`, `check-action-pins`, `viable-release`) IN_PROGRESS. PR mergeStateStatus is UNSTABLE while CI runs.

Self-improvement: nothing this time. The dispatch prompt was complete, the conflict-resolution skill's guidance (read both sides, write a third state honoring both) applied cleanly, and the `feedback_bot_master_reset_to_actual.md` memory had the exact procedure for the bot-master sync.
