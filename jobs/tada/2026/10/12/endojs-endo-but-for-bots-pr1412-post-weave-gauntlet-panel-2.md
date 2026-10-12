Panel round 2 on endojs/endo-but-for-bots PR #1412 returned **must-fix**. The review is posted on the PR, and I checked again just now that it is the PR's latest review.

- **Run:** I used an isolated checkout of `build/endo-claude-backends-1357` at head `2467b3a2de`. The panel ran in single-round mode against frozen base `llm-dc96042` (`dc960427fe`). `panel.sh` exited 0, and all 34 seats returned ok. The record is at `panel-runs/endojs-endo-but-for-bots-1412/aea5fcfffd2c.md`.
- **Seats requesting changes:**
  - **archivist:** the README says every subpath export is listed, but `confinedAllowList` is missing from the list.
  - **curator:**
    - The new subpath exports have no `types` condition.
    - `makeClaudeCliBackend` and `makeClaudeSdkBackend` are not re-exported from `index.js`.
    - Internal helpers are exposed on the public subpaths.
  - **pruner:** the PR body's Scaling, Documentation and Upgrade "Considerations" sections only repeat what is said elsewhere.
- **Posting:** GitHub refused a request-changes review because the bot cannot request changes on its own PR. So it is a COMMENTED review headed "## Panel round 2: must-fix", posted the same way as round 1: https://github.com/endojs/endo-but-for-bots/pull/1412#pullrequestreview-5486377772
- **Not done:** I made no fixes and did not un-draft the PR. Nothing in the garden repo changed. The fix stage is next.

The previous session already finished this work. It ended with the stage marker after the completion signal instead of before it, so this report puts the completion signal last.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1153292 cached reads)
- Output: 5487 tokens
- Cost: $1.7601731999999999
- Wall-clock: 231s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
