The panel round 1 for endojs/endo-but-for-bots PR #551 ran to a decision: **must-fix**. The verdict is posted on the PR as a comment review, because GitHub won't let the bot request changes on its own PR.

- **Starting point:** No earlier review existed on the PR and nothing from the previous attempt survived, so I started from scratch.
- **Checkout:** I made an isolated checkout of `endojs/endo-but-for-bots` branch `design/parallel-sync-browser` at head `0ce44c6320`. The PR is a design doc only: `designs/parallel-sync-browser.md` plus a line in `designs/README.md`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 551 a1dcc7071f`, using the PR's `baseRefOid` as the base. All nine seats finished OK: critic, skeptic, decomplector, ergonomist, novice, pedant, copyeditor, orthographer and thesaurus. Its last line was "design-panel single-round — must-fix". I launched it detached, so its exit code wasn't captured; that line and the recorded decision are the evidence it decided.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/551#pullrequestreview-5328624822. It carries a header naming the disposition, the full `round-1.md`, and a `garden-panel-verdict: must-fix` marker. The request-changes attempt was rejected ("Can not request changes on your own pull request"), so it fell back to `--comment` and shows as COMMENTED.
- **Main must-fix findings:**
  - The design calls `E(cisHost).sync(plan, …)`, which doesn't exist, while also saying it adds no new daemon primitives. Nothing is named as responsible for running the plan, restarting it, or handling partial failure.
  - The plan is computed at dry-run time but applied later against live mounts. Entries have no preconditions, so changes made in between go undetected.
- **Should-fix findings:**
  - The design names `writeLocator` where the real method is `adoptFromLocator`.
  - A pull-only sync still hands the peer a full read-write mount; `readOnly()` should be applied.
  - Nothing tests the headline claim that no content bytes pass through the orchestrator.
  - The settings mix planning inputs with execution inputs, and the capabilities each layer holds are described inconsistently.

I did not fix anything or take the PR out of draft. Nothing was committed to the garden repo, and I deleted the scratch run directory. Next is the gauntlet's fix-1 stage, which should read this comment review as the round-1 verdict.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 66 tokens (1853619 cached reads)
- Output: 9883 tokens
- Cost: $1.9052096
- Wall-clock: 1539s
- Model(s): claude-opus-4-8 ×6, claude-opus-5-5 ×1

<!-- garden-usage-end -->
