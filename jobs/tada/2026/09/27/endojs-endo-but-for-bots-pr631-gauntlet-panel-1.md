Panel round 1 on endojs/endo-but-for-bots PR #631 is finished, and its verdict is **must-fix**. The verdict is posted on the PR. My last session didn't count as done only because the stage-result marker came after the completion signal; this report puts the signal last.

- **The run:** I ran `panel.sh` in single-round mode against a separate checkout of the PR head (`design/thesis-translation` at `65e4cffa43`), using the PR's current base commit `14af05b109`. All 9 design-panel seats returned. It exited with code 0 and printed `must-fix`, and the run was saved to `panel-runs/endojs-endo-but-for-bots-631/9b98ec4c17f7.md`.
- **Main findings:**
  - **critic (request-changes):** the design grounds its protocol chapters only in `@endo/ocapn` and never mentions `@endo/captp`, the CapTP package the repo's own code actually depends on.
  - **skeptic (comment-only):** the Ka-Ping Yee figure permission is marked "RESOLVED" without ever asking Ping, even though Miller suggested asking him.
  - **skeptic (comment-only):** nothing in CI checks the design's promise that translated code blocks are "runnable, not pseudocode".
  - **skeptic (comment-only):** phase 1 edits `typedoc.json` and `scripts/posttypedoc.sh`, so it will set off the full `ci.yml` run, not just the docs checks.
- **Posting:** GitHub refuses a "request changes" review from the account that opened the PR, so the verdict is a COMMENTED review instead: https://github.com/endojs/endo-but-for-bots/pull/631#pullrequestreview-5328672312. It is still the latest review on the PR. Its header states `must-fix` and asks readers to treat it as request-changes, and it ends with a `garden-panel-verdict: must-fix` marker.

I made no fixes, did not take the PR out of draft, committed nothing to main2, and posted no follow-up jobs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr631-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s)
- Input: 26 tokens (700432 cached reads)
- Output: 4471 tokens
- Cost: $1.2772620000000003
- Wall-clock: 731s
- Model(s): claude-opus-4-8 ×7, claude-opus-5-5 ×1

<!-- garden-usage-end -->
