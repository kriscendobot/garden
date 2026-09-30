Round 4 of the panel on endojs/endo-but-for-bots PR #1383 came back **must-fix**. I posted the verdict on the PR as a review and stopped there: nothing was fixed or un-drafted.

- **Checkout:** I made an isolated checkout of `endojs/endo-but-for-bots` on `design/daemon-lifecycle-idempotency`, at head `5d546f3a71`. The PR is a docs change to `designs/daemon-lifecycle-idempotency.md` and `designs/README.md`.
- **Base:** I compared against the PR's own base commit `7ff30afbce` (`llm-7ff30af`) rather than a local branch ref that could be out of date. The diff was exactly those two files, so the panel used the smaller design-review seat set.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1383 7ff30afbce…` exited 0 with disposition `must-fix`. All 10 seats finished normally:
  - request changes: critic, decomplector, ergonomist, copyeditor, pedant
  - comment only: skeptic, novice
  - approve: orthographer, thesaurus, pruner
- **Review posted** at 2026-09-30T05:39:51Z, carrying the full combined panel output and a must-fix header. GitHub won't let the bot request changes on its own PR, so it went up as a comment, the same way rounds 1–3 were posted.
- **Main binding finding (critic):**
  - **Missing signal channel on the `engo` path.** Section 6 has a losing daemon send a "declined" message back over IPC. But `runEngo`, the code path used when `ENDO_BIN` is set, starts `engo` without any IPC channel. So the Node-vs-`engo` race that Phase 1's tests expect to exit 0 would instead fail with "Daemon failed to spawn" and exit 1. That brings back the crash-loop the design is meant to prevent.
  - **Incomplete `designs/README.md` entry.** The PR only adds a summary-table row. `designs/AGENTS.md` also requires a milestone, a place in the dependency graph, and a size estimate.

**Follow-up:** the gauntlet's fix loop picks up the next round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (430058 cached reads)
- Output: 2884 tokens
- Cost: $0.5235795999999999
- Wall-clock: 261s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
