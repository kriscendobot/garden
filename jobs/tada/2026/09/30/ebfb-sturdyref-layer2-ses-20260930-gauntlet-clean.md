Clean stage for endojs/endo-but-for-bots#1391 is done: coverage is adequate, I pushed no changes, and CI is effectively green at head `a0ef0c4320`. The CI wait script did exit rc=3 (red), but every check it flagged is a cancelled duplicate, not a real failure.

**Coverage and dead code**
- The PR touches `ses/src/global-object.js` and `ses/src/permits.js`, and adds or updates tests in `ses` and `sturdyref`.
- Every branch the change adds is tested:
  - The new "leave the shim's locked binding in place" path in `setGlobalObjectMutableProperties` is covered by `sturdyref-shimmed.test.js`, which checks that the binding is kept, that the constructor is frozen, and that child and grandchild compartments get the same constructor.
  - The normal path is covered by `sturdyref-absent.test.js` and the rest of the suite.
  - The new `SturdyRef` permit is exercised by the shimmed test and by the updated `sturdyref-prelockdown.test.js`.
- The change leaves no dead code behind.
- One case has no test: a locked global that holds a *different* value. That path is unchanged from before this PR, so I added no test for it.
- I did not run the tests locally; I relied on CI, including the `cover (22.x)` and `cover (24.x)` jobs, both of which passed.

**CI**
- The seven "red" checks are all CANCELLED, from earlier CI runs that a newer run superseded.
- Every one of those check names also has a SUCCESS or SKIPPED run at the current head: `build`, `zizmor`, `test-ocapn-guile-interop`, `Detect CI changes`, and `ironhorse-oracle-sanitizers`.
- Every other check is SUCCESS or SKIPPED: `lint`, `test` on 22.x and 24.x (ubuntu and macOS), `cover`, `test-xs`, `test-hermes`, `viable-release`, `sandbox-drivers`, and the rest.
- Since nothing actually failed, I'm treating this as green and reporting clean=done rather than failing the gauntlet.

**Follow-up:** `ci-wait-merge.sh` should ignore a CANCELLED run when the same check also has a SUCCESS or SKIPPED run at the same head. As written, the concurrency cancellations that GitHub creates when a newer run supersedes an older one can wrongly halt a gauntlet. I did not post a job for this fix.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (464364 cached reads)
- Output: 3785 tokens
- Cost: $0.5683007999999999
- Wall-clock: 2246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
