The clean stage is not done: CI is still pending after about an hour of waiting, so I'm reporting still-pending and the driver should re-post this stage.

- **PR state:** #1585 is still a draft, based on `endojs/endo-but-for-bots`, head `fix/ironhorse-oracle-stage3-math-ulp`.
- **Coverage pass:** nothing to do. The diff only touches two test262 stage3-math test files, a libm fixture TSV, one Rust test file (`math_corpus_profile.rs`) and two docs. It adds no production code, so it orphaned no dead code and needs no coverage tests. I made no changes and pushed nothing.
- **CI:** I polled in the foreground instead of using `ci-wait-merge.sh`. Foreground commands are capped at 600s, and the script was killed when it ran in the background, so I did not get its rc.
- **Checks:** at the last poll no check had failed, been cancelled or timed out. Two were still unfinished: `test (22.x, macos-15)` and `test (24.x, macos-15)`. They have not reached a terminal state.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1585-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 60 tokens (1756819 cached reads)
- Output: 10580 tokens
- Cost: $1.1688472
- Wall-clock: 8688s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
