## Panel round 5 for endojs/endo-but-for-bots#1408: must-fix

I ran one single-round panel. `panel.sh` exited 0 and returned **must-fix**.

- **Where it ran:** head `3d02782072` on `bot/build/claude-sandbox-bwrap-slice`, against base `llm-d4124e6` (I passed the merge-base SHA `d4124e6e40`). The checkout was an isolated per-job worktree.
- **Seats:** all 33 ran and none errored. 2 asked for changes, 11 left comments only, and 20 approved. The durable record is `panel-runs/endojs-endo-but-for-bots-1408/4ae6a73911b9.md`.
- **Must-fix items:**
  - **changeset-auditor:** `.changeset/add-endo-claude.md` has four new sentences that are single lines of 150–213 characters. The repo's markdown style wants lines wrapped at 80–100 columns, with each sentence starting on a new line.
  - **surfacer:** the bwrap-slice section of `packages/claude/README.md` describes how the slice behaves. It never says that the package now exports six new functions and constants plus the `SliceMount` type, or that they can be imported from `@endo/claude`.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1408#pullrequestreview-5387888095. It went up as a COMMENT review with the `garden-panel-verdict: must-fix` marker, because GitHub won't let the PR's author request changes on it. The per-seat detail was cut at about 56KB to fit GitHub's size limit; the full text is in the durable record.

I made no fixes and left the PR as a draft. Fixing these two items is the job of the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (732152 cached reads)
- Output: 4132 tokens
- Cost: $0.7338464000000001
- Wall-clock: 598s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
