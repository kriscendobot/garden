---
ts: 2026-05-22T04:11:29Z
kind: result
role: shepherd
worktree: dispatches/shepherd--793512/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/352
---

Shepherded PR #352 (`fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)`, head `edbc8f8f7`) to green. Per maintainer directive 2026-05-22T03:59Z: "Please sync master, rebase, and shepherd." Master sync confirmed no-op (bot-master == endo-upstream/master at `6804b7dc8`); branch already at master so rebase no-op.

Initial CI state: 17/18 SUCCESS, 1 FAILURE on `cover` (CI workflow, run 26265133657, job 77306679543, attempt 1). All other 17 checks green.

**Failure cluster diagnosis: pre-existing fast-check flake in `@endo/patterns`**

Failure was a property-based test in `packages/patterns/test/copySet.test.js:140` (`setIsSuperset`, lockdown config) that exercised fast-check's seed-driven 100-sample property assertion. Specific failing seed reported as `{ seed: -1714351193, path: "98:2:10:9:8:4:10:17:15:15:22:20:19", endOnFailure: true }` after `Shrunk 12 time(s)`. Counterexample triggered `setIsSuperset(makeCopySet(arr), makeCopySet(sub))` returning false on `[[[[object Alleged: bob]],[object Alleged: alice],[object ImmutableArrayBuffer],[[object Alleged: alice]],-0,[[object Alleged: bob],{}]],Stream(true,true,true,false,false,true…)]`. The PR-introduced commits touch only `.changeset/harden-exports-destructuring.md`, `packages/eslint-plugin/lib/rules/harden-exports.js`, and `packages/eslint-plugin/test/harden-exports.test.js`. Zero changes in `packages/patterns/`. The same `cover` job passed on master at the same parent SHA (`6804b7dc8`, master run 26264835659). 5/5 local reruns of `packages/patterns/test/copySet.test.js` succeeded. Diagnosed as a pre-existing, seed-driven property-based-test flake; not gating on PR #352.

**Disposition: re-run, no commit.** `gh run rerun 26265133656 --failed`. Cover passed on attempt 2 (job 77314876142, completed 04:11:15Z, success). No commits authored.

Post-fix CI snapshot: **18/18 SUCCESS, mergeStateStatus CLEAN**. Final state checked via `gh pr view 352 --json mergeStateStatus,statusCheckRollup`: `{fail_or_pending:[], success_count:18, total:18, mergeStateStatus:"CLEAN"}`.

The setIsSuperset fast-check property is a candidate for a follow-up upstream issue (per-seed flake in `@endo/patterns`); not in scope for this shepherd dispatch. The infra-flake categories named in the dispatch brief (`makeClient`, `SECURITY.md` uniformity, `zizmor`) were not relevant on this run (none of those CI surfaces were red); `zizmor` passed first try.

Self-improvement: nothing this time. The operational-flake re-run discipline in `roles/shepherd/AGENT.md` § "Operational-flake retirement" plus the COMMON.md monitoring affordance covered the cycle cleanly. The fast-check seed flake is a category not yet broadcast as a shepherd-ignore signature; if it recurs in subsequent shepherd dispatches across different PRs, an operational-flake broadcast or upstream issue would be the right follow-up, but a single observation does not warrant either yet.
