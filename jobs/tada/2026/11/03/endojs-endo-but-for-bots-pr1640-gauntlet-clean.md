---
orchestration-failed: true
---
The clean stage fails: CI is red at `24cd13406` (`ci-wait-merge.sh` rc 3), with two failing checks and no checks still pending. Neither failure looks caused by this PR, but I didn't rerun anything or change CI. The coverage pass found nothing to add, so I pushed nothing. The PR is still a draft.

**Failing checks**
- **`test-xs`:** this is the known Node 26 flip. `.node-version` is `lts/*`, the job log shows "Attempting to download 26", and `sesNode/module` now fails `test/intrinsics/ThrowTypeError/intrinsic-metadata.js`, so the baseline changed.
  - Six of the nine other recent failed CI runs I sampled also have `test-xs` red, though I didn't open their logs.
  - `origin/llm` has no commits past this PR's base and `.node-version` is still `lts/*`, so rebasing wouldn't help. The fix still waits on the maintainer's decision: pin Node, or change the assertion or baseline.
- **`test (24.x, macos-15)`:** only `@endo/daemon#test` failed. All 1612 tests passed, but `test/http-content-plane.test.js` exited non-zero on 2 unhandled rejections: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`.
  - The PR doesn't touch `packages/daemon`, its `yarn.lock` changes are workspace entries only, and `test (22.x, macos-15)` passed on the same head.
  - This is the only sighting so far, so calling it a flake is unproven. A rerun can't turn the stage green while `test-xs` is red.

**Coverage**
- **Existing tests:** the head already has the coverage commit `6e36c140f`, so this was a check rather than new work.
- **`packages/prompt-templates`:** 100% on statements, branches, functions and lines (35 tests pass).
- **`packages/spaces-util`:**
  - `prompt-template-catalog.js` has every line covered.
  - In `chat-bar-component.js`, `command-selector.js` and `inline-command-form.js`, every line this PR added is covered. I checked that by comparing raw V8 coverage to the diff, because c8 printed an empty table for these files.
  - In `command-registry.js`, four older lines far from this PR's change are uncovered. The chat tests I ran pass (75).
- **`packages/chat/setup-prompt-templates.js`:** not measured and no test imports it. The PR body says it ran against a real isolated daemon, and I didn't re-run that.
- **Dead code:** none orphaned. The lines this PR removed or replaced don't leave anything unused, for example `getCommand` is now the `resolveCommand` default.

**Follow-ups**
- The maintainer needs to decide the Node 26 `test-xs` fix; this gauntlet stays halted until then, then re-run this stage.
- If `test (24.x, macos-15)` is still red after that, check for the `ClientDestroyedError` rejection before looking at this PR's diff. I saved a memory note on it (`ebfb-daemon-http-content-plane-macos-rejection`).

I left out the `orchestration-failed: true` first line the job asks for, because the completion instructions say to use the failure signal below and the machinery stamps that field. I also left out a `clean=` marker, as the job requires for rc 3.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1640-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 106 tokens (5113641 cached reads)
- Output: 44034 tokens
- Cost: $3.6135361999999995
- Wall-clock: 7668s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
