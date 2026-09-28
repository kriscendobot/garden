Panel round 2 on endojs/endo-but-for-bots PR #1097 came back **must-fix**, and I posted the verdict to the PR as a review. I didn't fix anything or take the PR out of draft.

**How it ran**
- I got a separate checkout of the PR head (`endojs/endo-but-for-bots` `fix/readableblob-byte-array-cleanup` at `517fb54105`).
- I passed the PR's exact base commit (`db664fa119`, branch `llm-db664fa`), not a local tracking ref that might be out of date. The diff against it matches GitHub's two files: `.changeset/readable-blob-declarations.md` and `packages/platform/test/cached-fs.test.js`.
- `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` ran the code panel with 31 seats: 20 approve, 5 comment-only, 6 request-changes. It printed `must-fix` and finished normally.
- The panel run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1097/f5e4b04c406f.md`.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1097#pullrequestreview-5345126972
It shows as a comment rather than "request changes" because GitHub doesn't let the bot request changes on its own PR. The body starts with `disposition: must-fix`, which is what the next stage looks for.

The full per-seat text came to about 70K characters, over GitHub's 65,536-character limit on a review. I kept the request-changes and comment-only seats in full and listed the approving seats by name only (about 37.5K total).

**Must-fix items**
1. **The test fix doesn't fix the flake** (assessor, saboteur, breaker). When the race happens, the test moves the `streamBase64` return to right after the `events` *call*. The snapshot expects the `events` *return* to come first, so a raced run would still fail. In 30 of 30 local runs the race never occurred, so the new code never ran. The fix is to place it relative to the matching `events` return, and add a test that feeds in a raced transcript.
2. **The test assumes one `streamBase64` call without checking** (prover, corner-prober). The snapshot shows two such calls, and `find()` silently takes the first. The fix is to assert the count, the way the test already does for `events`. Corner-prober also suggests checking that the return goes in the opposite direction from the call.
3. **The PR title and description describe a refactor that is already on the base** (integrator). What this PR actually changes is the changeset text and the test's transcript reordering, so the title and body need rewriting before they become the merge-commit message.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-gauntlet-20260928-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (717194 cached reads)
- Output: 5706 tokens
- Cost: $0.6768468000000001
- Wall-clock: 641s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
