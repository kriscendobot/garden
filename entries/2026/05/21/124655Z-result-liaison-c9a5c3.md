---
ts: 2026-05-21T12:46:55Z
kind: result
role: liaison
project: endo
to: maintainer
refs:
  - entries/2026/05/21/123142Z-dispatch-liaison-c9a5c3.md
  - entries/2026/05/21/124300Z-result-shepherd-c9a5c3.md
  - entries/2026/05/21/124154Z-dispatch-liaison-7d3f15.md
  - entries/2026/05/21/124509Z-result-fixer-7d3f15.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 79
    role: source
  - repo: endojs/endo
    pr: 3231
    role: target
---

# Result: shepherd → retcon on endo-but-for-bots#79 (mirror of endo#3231); ferry needed

Maintainer directive (2026-05-21T12:31Z): *"CI failed on https://github.com/endojs/endo/pull/3231. Please revisit our mirror of that PR, dispatching a shepherd and then retcon any necessary fixups."*

Both stages complete on mirror #79. Mirror CI is propagating on the retconned head. **Boatman ferry is the next step** — requires `kmkmbp2021` (kriskowal credentials). I am on `endolinbot`; cannot originate the ferry.

## Failure shape

Upstream endo#3231 lint failed on 2026-05-21T06:33Z (run [26209518474](https://github.com/endojs/endo/actions/runs/26209518474/job/77116860556)):

```
packages/ses/test/_namespace-mutation/b.js:23:28 - error TS18046: 'e' is of type 'unknown'.
   23   result.assignErrorName = e.name;
```

The mirror PR #79 reported green on 2026-05-01; the upstream lint diverged because the refreshed base + newer toolchain converge on a stricter `tsc` typecheck (effectively `useUnknownInCatchVariables: true` in the typedoc/JSDoc-check pipeline).

## Shepherd c9a5c3

Reproduced locally on the mirror branch by extending `packages/ses/tsconfig.json` with `useUnknownInCatchVariables: true` (local-only experiment; not committed). Applied the project's documented JSDoc-cast convention from CLAUDE.md:

```diff
-  result.assignErrorName = e.name;
+  result.assignErrorName = /** @type {Error} */ (e).name;
```

Single commit `4611ac9b7` pushed to `ses-namespace-mutation-test`. Local verification: `packages/ses` `yarn lint` 0 errors, `yarn ava test/namespace-mutation.test.js` 1 test passed. Dispatch root torn down.

## Fixer (retcon) 7d3f15

Collapsed 4 commits (`d70b91ea1` test + `cb3fb042e` prettier + `10800c7bc` lint+tsc + `4611ac9b7` JSDoc cast) into 1 canonical commit `40143c4d1` `test(ses): pin namespace mutation parity with Node.js` on top of merge-base `551418633` (Merge llm branches).

- **Net-diff invariant**: confirmed byte-identical via `git diff 551418633..pre-retcon` vs `git diff 551418633..post-retcon`.
- **Net diff scope**: 6 files, 177 insertions, all under `packages/ses/test/_namespace-mutation/` and `packages/ses/test/namespace-mutation.test.js`. No yarn.lock, no tsconfig contamination from the shepherd's local experiment.
- **Base correction note**: dispatch prompt said "merge-base against master" but the actual PR base is `llm`; the fixer used the correct merge-base. Worth recording for future retcons against non-master-based PRs.
- **Force-push-with-lease**: `4611ac9b7` → `40143c4d1` honored cleanly.
- **Local verification**: `yarn lint` 0 errors, `yarn ava test/namespace-mutation.test.js` 1 pass.

Dispatch root torn down.

## Mirror CI status at end of dispatch

Run [26226730406](https://github.com/endojs/endo-but-for-bots/actions/runs/26226730406) on head `40143c4d1`: most jobs queued / pending; `build`, `familiar-bundle`, `build-wasm` already pass. `zizmor` failed (workflow-files security audit; pre-existing, unrelated to this PR's content — workflows in `.github/` are not touched). All other relevant jobs queued and propagating.

## Ferry blocked on host

The upstream PR endo#3231 currently sits at `c6a779d0c` (the 2026-05-21T06:32Z re-ferry that *did not* contain the JSDoc cast). The mirror is now ahead with the fix. The boatman needs to re-ferry to upstream — single-commit shape `40143c4d1 test(ses): pin namespace mutation parity with Node.js`, force-push-with-lease against `c6a779d0c`. **Requires `kmkmbp2021` host (kriskowal credentials).** Standard rule (CLAUDE.md § Boatman dispatches): a liaison on `endolinbot` refuses to originate boatman dispatch and asks the maintainer to re-issue from the credentialed host.

When ready to ferry: *"Ferry #79"* from a `kmkmbp2021` liaison session.

## Status summary

| Stage | Status |
|---|---|
| Shepherd: diagnose + fix lint TS18046 | ✅ complete (commit `4611ac9b7`) |
| Retcon: collapse to canonical net-diff-invariant shape | ✅ complete (head `40143c4d1`) |
| Mirror CI converges to green | ⏳ propagating |
| Boatman: re-ferry to upstream endo#3231 | 🚫 blocked on host (needs `kmkmbp2021`) |
