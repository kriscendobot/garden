Panel round 8 on kriscendobot/minion.town#174 came back **must-fix**, and I posted the verdict on the PR.

**What I did**
- Made an isolated project checkout of `kriscendobot/minion.town@build/credit-metering-no-ertp` at head `0b15028`, at `/home/kris/garden/scratch/project-wt-kriscen-d49299a508ed-8c0650ec`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 174 main-39867df`. It exited 0 with disposition **must-fix**. All 34 seats returned ok, with no seat or decider errors. The run is recorded in the journal at `panel-runs/kriscendobot-minion.town-174/a8fa3228b027.md`.
- Seat verdicts:
  - **request-changes (3):** saboteur, pruner, decomplector
  - **approve (5):** benchmarker, orthographer, thesaurus, procurer, reexport-auditor
  - **comment-only (25):** the rest, except archivist
  - **archivist** gave no verdict label, though its text says "request changes".
- Posted the result as review https://github.com/kriscendobot/minion.town/pull/174#pullrequestreview-5483601921. GitHub refuses request-changes on the bot's own PR, so it went up as a COMMENTED review, the same as rounds 4–7. Its heading is "Panel round 8 — must-fix". The full panel text is about 88 KB, over GitHub's review size limit, so the review carries the request-changes seats in full and as many others as fit. It names the 15 seats it left out and points to the journal record for their text.

**Follow-up for the fix stage**
- The decomplector's must-fix asks whether to keep the PR's current approach to charging for a publish at all, not for another patch. Right now an in-memory hold is taken before publishing, then either charged or released, and the optional `releasePublish?` lets a payment processor leak holds. It proposes replacing this with a one-shot settle/cancel handle, or a hold recorded durably in the ledger. Several rounds have now patched this same area, so the fixer should settle that question before patching further.
- Two should-fix test gaps (from the prover seat): no test checks that a failed publish or upgrade releases its hold, or that a failed charge does.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (883501 cached reads)
- Output: 5130 tokens
- Cost: $0.7813882
- Wall-clock: 173s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
