---
ts: 2026-05-21T06:37:59Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/cleaner--de7860/project
---

Cleaner pass for PR #57 (feat(marshal,pass-style): admit immutable ArrayBuffer through codecs), the marshal half of the gamut on the kriskowal-marshal-binary branch.

Findings:

- Baseline coverage on `packages/pass-style` (`src/byteArray.js`): 93.19% stmts, 62.5% branch, 87.5% funcs. Baseline on `packages/marshal` aggregated across the four touched source files (`encodePassable.js`, `encodeToCapData.js`, `encodeToSmallcaps.js`, `marshal-justin.js`): 94.67% stmts, 82.58% branch, 81.25% funcs.
- The PR's `test/byteArray.test.js` and `test/byte-array.test.js` (in pass-style) already covered the happy paths for round-trip across smallcaps, capdata, encodePassable (both legacyOrdered and compactOrdered), shortlex ordering, and the rank-vs-lex agreement. The plumbing of the byteArray fixtures into `roundTripPairs`, `jsonJustinPairs`, `unsortedSample`, and `sortedSample` (from the fixup commit) gives broad coverage of the marshal-justin and capdata surfaces.
- Three decode-side fail-closed contracts introduced by this PR had no test pinning them, and the coverage report flagged the branches. New test cases added to `packages/marshal/test/byteArray.test.js`:
  1. `decodePassable rejects malformed byteArray body` (encodePassable.js line 513 regex-mismatch Fail).
  2. `decodePassable rejects byteArray length-vs-body mismatch` (encodePassable.js line 517 length-check Fail).
  3. `capdata unserialize rejects byteArray with non-string data` (encodeToCapData.js line 376 typeof Fail).
- Each new test was proven load-bearing via the regression-evidence procedure: the corresponding Fail was temporarily removed in source, exactly the matching test failed, and reverting restored green. The three commit-message reproduction recipes are in commit 44c576e6b's body.

Coverage delta after the additions (marshal, four touched source files):
- Branch coverage on `encodePassable.js` improved 87.43% → 88.46%.
- Branch coverage on `encodeToCapData.js` improved 81.08% → 82.43%.
- Statement coverage unchanged because the new tests exercise the negative branch of single-line throws.

Out-of-scope per the coverage-driven-testing skill (platform-conditional, not reachable from the runtime test platform under the `@endo/immutable-arraybuffer` shim):
- `pass-style/src/byteArray.js` lines 22-26: the `sliceToImmutable === undefined` fallback (no-immutable-platform path).
- `pass-style/src/byteArray.js` lines 65-67: `assertRestValid` own-properties failure path on a malformed candidate (requires forging an immutable-buffer subclass).
- `pass-style/src/byteArray.js` lines 88-89: `byteArrayToUint8Array` pristine-prototype zero-copy path (only reached under native immutable ArrayBuffer support, not under the shim).

No dead code identified for deletion: every new export and every new branch in `byteArray.js`, `encodePassable.js`, `encodeToCapData.js`, `encodeToSmallcaps.js`, and `marshal-justin.js` has at least one live caller in the touched packages (and a public-API entry-point reachable from `@endo/pass-style/index.js`).

No yarn.lock churn from the cleaner addition (no new test dependencies). The PR's existing yarn.lock commit (`65f1f2769 chore: Update yarn.lock`) is unchanged.

Commits:
- 44c576e6b `test(marshal): cover byteArray decode error paths`.

Push: `origin/kriskowal-marshal-binary` advanced 27bfccbe5 → 44c576e6b.

CI on cleaner's HEAD (44c576e6b):
- 26 jobs ran. 25 pass, 1 fail.
- The single failure is `lint` on the new `Check composite tsconfig files are up to date` step. This step did not exist on master at the time the PR branch was last rebased; master's `da5a9b48e chore: regenerate composite tsconfig files` (and the ci.yml step added with it) are not yet in the PR branch. The PR is `MERGEABLE` / `CLEAN` against master (no textual conflict), but the composite tsconfig drift will keep lint red until a weaver rebases.
- All actual test jobs are green: `cover`, `test (22.x, ubuntu-latest)`, `test (22.x, macos-15)`, `test (24.x, ubuntu-latest)`, `test (24.x, macos-15)`, `test-async-hooks (18, ubuntu-latest)`, `test-async-hooks (22, ubuntu-latest)`, `test-hermes`, `test-ocapn-python`, `test-xs`, `test262 (22.x, ubuntu-latest)`, `test262 (24.x, ubuntu-latest)`, `browser-tests`, `build`, `check-action-pins`, `viable-release`, `zizmor`.

Discipline note: PR #57 is **not in draft** (`isDraft: false`). The post-2026-05-14 flow requires draft for the cleaner / judge / fixer-loop chain, with the judge owning un-draft at the loop's end. The cleaner's contribution does not depend on draft state; pushing additional tests is safe. The orchestrator should be aware that the un-draft step is moot for this PR (someone or some earlier dispatch un-drafted before the cleaner arrived).

Judge-ready signal: **conditional**. The new lint red is rebase-required infra red, not a regression from the cleaner's push. Per cleaner norm "Verify CI on the cleaner's own HEAD before reporting done... watch CI converge to green (or only documented pre-existing infra red)", the lint failure is the latter: it predates this push in the sense that any push to this branch would hit the same red, and clears with a weaver pass. Recommendation: dispatch a **weaver** to rebase onto `origin/master` before dispatching the judge; the rebase pulls in the regenerated composite tsconfigs and clears the lint check.

Self-improvement: nothing this time. The cleaner's playbook (`coverage-driven-testing` + `regression-evidence` + the new-as-of-2026-05-20 `pre-push-gates` advisory) handled this PR cleanly; the only point of friction was the master-drift lint check, which is a weaver concern rather than a gap in the cleaner's procedure.
