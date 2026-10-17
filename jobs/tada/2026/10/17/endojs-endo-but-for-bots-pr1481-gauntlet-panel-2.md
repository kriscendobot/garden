Panel round 2 on endojs/endo-but-for-bots #1481 came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not an infrastructure error.

- **What was reviewed:** the PR head `e2709d679f` from `endojs/endo-but-for-bots:build/ocapn-noise-session-reconnect-rekey`, compared against the frozen base SHA `2a16357eaacc` in an isolated project worktree. The run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1481/cba98bbf33de.md`.
- **Seat results (33 seats):** 5 requested changes (assessor, archivist, saboteur, integrator, pruner), 7 approved and 21 were comment-only. The pruner was forced to review the PR description because the PR-body concision check fired. The worst finding is the assessor's: if the resume reply is lost, the retry reuses the same epoch, the responder refuses it, and a session that could have recovered is killed (`network.js` around lines 1315, 1335 and 2139).
- **How it was posted:**
  - GitHub refused a request-changes review because the bot opened this PR, so I posted the verdict as a COMMENTED review (5555397697), headed "Panel round 2 — must-fix". Round 1 was posted the same way.
  - The full aggregate is about 89 KB, more than one GitHub review body can hold. The review carries all 5 request-changes reports in full plus 13 others. The remaining 15 reports are in the PR comment https://github.com/endojs/endo-but-for-bots/pull/1481#issuecomment-6228059082, and the review ends with a note pointing to it.
- **Not done, as the stage requires:** no fixes and no un-drafting; the PR is still a draft. The fix stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (829041 cached reads)
- Output: 4459 tokens
- Cost: $0.7427242000000001
- Wall-clock: 196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
