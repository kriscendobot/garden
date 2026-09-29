I fixed all three must-fix items from the round-3 panel on kriscendobot/minion.town PR #68. The fix is pushed and CI is green (3 of 3 checks passed).

**What I changed** (commit `0ce8955`, pushed on top of `d6d05b4` with `safe-push-pr-head.sh`):
- **spec-keeper:** `resolveNamedContent` no longer pastes `JSON.stringify(contentValue)` into the code it evaluates. It now passes the named value in as an input: `evaluate(worker, source, ["value"], [contentValue])`. That means no text the guest chose is ever run as code. It also removes the dependence on newer JavaScript engines accepting pet names that contain U+2028/U+2029, and the evaluation no longer needs the `@agent` capability. I also took the pet name out of the worker-side error message, because that message was also spliced into the source.
- **Tests:** in `test/endo-clip-tools.test.ts` I updated the fake evaluator and the in-worker test to match. The tests now check that the only input is `["value"] = [CONTENT_VALUE]` and that the pet name never appears in the evaluated source.
- **pruner:** I removed the sentence about `TextEncoder`, the part of the `ContentFiles` comment that just restated the schema, and the long comment block over the size-limit constants. Each constant now has a one-line comment, and the explanation of the limits moved into `resolveNamedContent`'s doc comment.
- **scribe:** I posted the missing summary comment covering rounds 2 and 3 (https://github.com/kriscendobot/minion.town/pull/68#issuecomment-5900581614).

**Checks:** locally, `npm test` passed (579 passed, 8 skipped), and `tsc --noEmit` reported no errors. `ci-wait-merge.sh --no-merge` exited with rc 0.

**Not done this round (none were blocking):**
- The extra edge-case tests corner-prober suggested (empty entries, a total of exactly 16 MiB, duplicate paths, an unknown pet name).
- curator's suggestion to share one schema for a file entry across the three tools.
- saboteur's note about the bare `catch` in `resolveGuestMainWorker`, which was there before this PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20260929-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1332834 cached reads)
- Output: 9937 tokens
- Cost: $1.0679068
- Wall-clock: 357s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
