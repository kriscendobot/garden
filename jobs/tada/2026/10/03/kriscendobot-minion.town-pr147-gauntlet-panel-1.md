Round 1 of the review panel on kriscendobot/minion.town PR #147 came back **must-fix**, and I posted the verdict on the PR. It's a design-only PR adding `designs/mcp-resources-getting-started.md`.

- **Run:** I got an isolated checkout of the PR head (`design/mcp-resources-getting-started` at `d2653c7`) and ran `panel.sh` in single-round mode against base `main-af7af61` (`af7af61`). It exited 0 with disposition `must-fix`.
- **Must-fix (novice seat):**
  - § 3 commits to the seven static resources before the reader sees the rejected alternatives, which don't appear until § 8.
  - § 1's main motivating example uses "pet name", "capability" and "CapTP bootstrap" without ever defining them. The design is written for agents who won't know those terms.
- **Should-fix:**
  - **Critic:** the always-mounted `getting-started` guide indexes `guide/clips` and `examples/publish-a-clip`, which only exist when clips are mounted. Without clips, following the index leads to a missing resource.
  - **Decomplector:** `deploy-app.sh` and `deploy-resources.sh` both write the box's `resources/` with no ordering, so the next full deploy can silently overwrite a hotfix.
  - **Skeptic:** the only pass/fail validation bar comes from a single client, the Claude Code CLI harness.
  - **Pruner:** cut the PR body's section-by-section summary and one redundant example in § 1.
  - **Copyeditor:** two localized phrasings.
  - **Approved (orthographer, thesaurus):** no British spellings, no Botese.
- **Posted as a comment, not a request-changes review:** GitHub refuses request-changes on the bot's own PR ("Can not request changes on your own pull request"). The review is in state `COMMENTED` (2026-10-03T03:40:02Z), headed "Panel verdict — round 1 … **must-fix**", with every seat's findings in full.

**Follow-up:** the round-2 fix stage is owed. If the next-stage check only treats a request-changes review as a panel verdict, it may not pick up this comment.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (700400 cached reads)
- Output: 4043 tokens
- Cost: $0.6583800000000001
- Wall-clock: 270s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
