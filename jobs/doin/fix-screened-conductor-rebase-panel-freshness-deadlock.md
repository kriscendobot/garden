---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Screened conductor deadlocks itself: its own trunk rebase invalidates the exact panel head

Garden pipeline defect (main2). Observed on https://github.com/kriscendobot/minion.town/pull/218, 2026-10-24:

1. The gauntlet completed at head `e01c988`; the panel-run record covers exactly that head.
2. The proxy screen posted `screen-minion-town-pr218-e01c988-conduct`. `ci-wait-merge.sh
   --screened-delegated-merge` refused to merge onto the frozen snapshot base `main-68c3960`
   (5058262e17e), retargeted to `main`, rebased cleanly, force-pushed `5e2b623`, exited 4.
3. The screen re-screened `5e2b623` (`panel_match: rebase` in
   `journal/screenings/kriscendobot-minion.town/218/5e2b623….json`) and posted conductors
   `-conduct`, `-r2`, `-r3`. Each was refused by the exact-panel-head gate added today in
   65ed9070fc5 (`assert-panel-head-fresh.sh`: stale, review-required, exit 10).

Nothing in the pipeline posts the panel that the gate demands, so EVERY frozen-base minion.town PR
(nearly all of them) now deadlocks at merge, burning a conductor every tick. The screen already
judges rebase-equivalence; the conductor gate does not.

Fix one of these ways (pick the one consistent with the intent of 65ed9070fc5):
(a) when the gate reports `review-required` and the screen's `panel_match` is `rebase`, stage a
    single-round re-panel of the current head deterministically (once per head) instead of
    re-posting conductors; or (b) have the conductor do the trunk rebase BEFORE the panel's final
    round is required (rebase-then-panel order); or (c) let the freshness sensor accept a head
    whose `git range-diff` / patch-id set against the new base is identical to the reviewed
    head's (a pure clean rebase), recording why. Also stop the screen from re-posting conductors
    (`-rN`) that the gate is certain to refuse for the same head. Add a regression test.
The minion.town supervisor posted `kriscendobot-minion-town-pr218-fresh-panel-5e2b623` as a
one-off unblock for #218 itself; do not touch that PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-24T18:38:33Z
