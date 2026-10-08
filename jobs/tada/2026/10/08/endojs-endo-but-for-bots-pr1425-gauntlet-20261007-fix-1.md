# Gauntlet fix round 1: endojs/endo-but-for-bots#1425

I applied the round-1 panel's must-fix items to #1425 and pushed them. CI is green at the new head, `68129dd726`.

**Main must-fix (raised by breaker, wire-watcher, saboteur and spec-keeper):** on XS, compartments made after `lockdown()` still got the untamed `Date` and `Math`, so guest code had a working `Date.now()` and `Math.random()`. The PR's approach of re-reading the start compartment's global after lockdown didn't fix this. That global holds the powerful `%Initial*%` intrinsics, and `getGlobalIntrinsics` filed them under the `%Shared*%` names.
- `src/lockdown.js`: `repairIntrinsics(options, onIntrinsics?)` now takes an optional internal callback. It receives the lockdown `intrinsics` record and the native-function marker. The public `lockdown`/`repairIntrinsics` globals don't pass it.
- `src-xs/lockdown-shim.js`: the shim start `Compartment` is now built from that intrinsics record with `makeCompartmentConstructor`, the same way other engines build it.
- `src-xs/compartment.js`: I reverted the `makeShimStartCompartment` factory, which also removes the JSDoc the pruner flagged. I added a two-line comment saying the import-time constructor holds untamed globals.
- `test/_xs.js`: new checks that a compartment's `Date` differs from the start compartment's, and that `Date.now()` and `Math.random()` throw "secure mode" errors.
  - With the old lockdown shim, the test fails on the `Date` check; with the fix, the XS test passes.
  - `tsc`, eslint, prettier and the `lockdown*`/`compartment*` ava tests (20) pass.
- **Changeset:** reworded so it no longer claims more than the code delivers.

**CI repin (packager, gateway):** I kept the separate `ci: repin paths-filter to v3.0.4` commit, because this PR's CI can't pass without it. Without it, the `Workflow security audit` (zizmor) check fails: the version comment on the base's `dorny/paths-filter@d1c1ffe… # v3` pin doesn't match the commit the `v3` tag points to. I confirmed that failure in the audit run on the PR's fix commit before the repin (`2d7e3bbcc9`). `master` has the same pin, so it likely fails the same check. I rewrote the PR body to give this reason and say the repin could also land on its own. I also tightened the rest of the body, which the panel asked for.

**Commits pushed** (both via `safe-push-pr-head.sh`):
- `99e15702f8`: the fix.
- `68129dd726`: formatting for `_xs.js`. The first push failed the CI lint job on prettier, so I restructured the check and pushed again.

**Not fixed (pre-existing, noted in the PR body):** on XS, calling `new compartment.globalThis.Compartment()` from inside a shim compartment throws `TypeError: Class constructor Compartment cannot be invoked without 'new'`.

**CI:** `ci-wait-merge` exited with rc 0, all 15 checks green, at head `68129dd726`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2992358 cached reads)
- Output: 16716 tokens
- Cost: $1.6608396
- Wall-clock: 1211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
