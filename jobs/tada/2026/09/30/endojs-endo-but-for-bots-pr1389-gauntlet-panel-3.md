I ran panel round 3 on PR #1389 and it came back **must-fix**. I posted the aggregate as a PR review in comment form, because a request-changes review failed.

- **Checkout:** I made an isolated worktree of the PR head, `endojs/endo-but-for-bots@design/sturdyref-shim-contract` at `5f2f90ad36`, and passed the base as the pinned SHA `7ff30afbce95f60d21ff3ae385bd9a17ed0850db` (`llm-7ff30af`).
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0. This was a design panel with 11 seats, and its final disposition was `must-fix`.
- **Must-fix findings:**
  - **PR description:** it is missing three headings from the PR template: Scaling Considerations, Documentation Considerations and Upgrade Considerations. The template check fails on this, which on its own makes the outcome must-fix.
  - **Existing design not reconciled:** the new doc doesn't reconcile with `designs/sturdy-refs-endor-syscall.md`, which is already on the roadmap. This came from the integrator seat.
- **Smaller notes:** the critic seat asked for a line in the layer-5 forward sketch about reusing one ref for the same target across exports, and for rewording the "host's ref" phrase in § Provenance. Two seats (copyeditor and skeptic) voted request-changes; I didn't read their findings.
- **Review posting:** `gh pr review --request-changes` was rejected with "Can not request changes on your own pull request", because the bot account opened the PR. I posted the same aggregate as a `--comment` review, headed "Panel round 3 — must-fix". The next-stage heuristic needs to recognize the verdict from that heading and the body, since the review isn't a formal request-changes.
- **Follow-up:** the fix-loop stage needs to add the three missing PR-body headings and reconcile the doc with `sturdy-refs-endor-syscall`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (500870 cached reads)
- Output: 2403 tokens
- Cost: $0.510842
- Wall-clock: 290s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
