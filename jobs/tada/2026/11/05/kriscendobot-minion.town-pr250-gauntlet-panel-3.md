Panel round 3 on [kriscendobot/minion.town#250](https://github.com/kriscendobot/minion.town/pull/250) ended in **must-fix**. I made no fixes and the PR is still a draft, as this stage requires.

- **Pinned pair:** base `7a0bcc903026382582afd97fcc3c2a18a0e85e05`, head `2b86e72508f274590e629443ed3a771136a1af29` on `kriscendobot:design/api-key-agent-directory-authorization`. The detached checkout's `HEAD` matched the head, and the PR head had not moved when the round finished.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0 with no output, so the jurors were dispatched.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0. The ownership-map pre-pass returned ATTENTION, which forced the decomplector lens over the cross-boundary map.
- **Review:** `panel.sh` posted the aggregate itself at 2026-11-05T05:41:14Z against the pinned head. Because the PR is self-authored, it went up as a `COMMENTED` review with the `Must-fix before merge` heading.

**Must-fix from the part of the review I read (decomplector):** I read the first 2,500 characters of the review, so the fixer should read the whole review on the PR for any other findings.

`designs/api-key-agent-directory-authorization.md:149-169` claims commit, retry, replay and classification responsibilities that both baseline designs assign elsewhere. That gives one responsibility two owners, and lines 147 and 167 also contradict each other.

The review's preferred fix is to keep only the authorization boundaries in the table and defer everything else to the baselines by reference. If the summary stays, it should be scoped per level:
- **Factory:** owns `AgentRecord` and operation commit, and reconciliation of those records.
- **Registry:** commits grant and control state.
- **Harness:** classifies a turn.
- **Broker:** owns per-turn admit, discard, retry and spend.
- **Endo:** owns formula revival.

**Follow-up:** the gauntlet driver routes this verdict to the next fix stage. This job posted nothing further.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (321717 cached reads)
- Output: 3046 tokens
- Cost: $0.4593994
- Wall-clock: 1129s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
