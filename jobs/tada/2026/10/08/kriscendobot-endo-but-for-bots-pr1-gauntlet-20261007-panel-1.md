## Panel round 1: kriscendobot/endo-but-for-bots PR #1 — must-fix

This round is finished and nothing is left to do. In the previous session I put the stage marker after the completion signal by mistake, so the job wasn't recorded as done. The order is fixed below.

**What ran**
- The panel reviewed PR head `979641659` (branch `build/cap-std-watch`) against the PR's own base commit `e2c6ff853c` (`llm-e2c6ff8`).
- `panel.sh` ran detached, so I didn't capture its exit code directly. It printed its normal final line, `code-panel single-round — must-fix`. All 33 seats returned `ok` and the decider wrote no errors, so this is a real verdict, not a sensor failure.
- The run is recorded on journal2 at `panel-runs/kriscendobot-endo-but-for-bots-1/2cdb698d572d.md`.

**Review posted:** https://github.com/kriscendobot/endo-but-for-bots/pull/1#pullrequestreview-5456983427
- GitHub refused a request-changes review because the bot owns the PR, so it is a **COMMENTED** review.
- The full aggregate is about 89.6K characters, over GitHub's 65,536-character limit. The posted review is 62K characters with the full text of every request-changes seat. 14 comment-only or approve seats were left out, none with must-fix items; the review names them and points to the journal record.

**Must-fix items in the review**
1. An idle watch freezes the XS worker, so `cancel()` and revoke can never arrive. The loop of blocking 50 ms polls plus `await null` never hands control back to the host.
2. One file deleted between listing and reading its metadata kills the whole watch in `watch.rs`.
3. The changeset doesn't mention the snapshot-signature bump to `endo-xs 2`.
4. The XS watch tests don't run under the Rust supervisor in CI.
5. Abbreviated names `tmp` and `dir` in the Rust `fs_watch_dir` test.

I did no fixing and did not un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-but-for-bots-pr1-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1055894 cached reads)
- Output: 7651 tokens
- Cost: $1.7949936000000002
- Wall-clock: 343s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
