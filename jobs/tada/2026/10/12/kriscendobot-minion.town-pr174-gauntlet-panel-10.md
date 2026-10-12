Round 10 of the panel on kriscendobot/minion.town PR #174 (head `623d5c4`, base `main-39867df`) came back **must-fix**. I posted the verdict on the PR as a comment review, because GitHub doesn't allow request-changes on the bot's own PR. Nothing was fixed or un-drafted.

**The run:** `panel.sh` ran in single-round mode against an isolated checkout, with base SHA `39867df`. It exited 0 with disposition `must-fix` and saved the record to journal `panel-runs/kriscendobot-minion.town-174/ac2b58255eb9.md`.

**Seats:** 34 seats ran. 4 requested changes (typist, archivist, curator, decomplector), 21 were comment-only and 9 approved. The repeated-mechanism check fired: rounds 8, 9 and 10 all raised must-fix findings on the same thing (`AccountCharge`, "held"), so the panel added the decomplector seat to ask whether that code is needed at all.

**Must-fix items in the review:**
1. **Remove `AccountCharge.charge`** (curator, decomplector). Nothing in production calls it, and it is a second way to debit an account that can overdraw it.
2. **Breaking change to `PaymentProcessor`** (curator). `chargeForPublish` became `reservePublish` and `contentRoot` is now required on exported types. The fix is to note this in the PR body or keep a deprecated adapter.
3. **Unclear sentence at `DEPLOYMENT.md:60`** (archivist).

I also listed the should-fix items for the same fix pass:
- Simplify the in-memory reservation map.
- Unify `Reservation` and `PublishReservation`.
- Reword the sentence at `DEPLOYMENT.md:52`.
- Add a test that checks a failed site registration releases the hold, and a test that `CLIP_METERING` actually switches metering on.

**What's in the comment:** The full aggregate was about 88 KB, too big for one GitHub comment. The review has a summary plus the full text of 20 seats; the other 14 seats (all approve or comment-only) are named and their text is in the journal record. The bot's `gh` wrapper refused the first attempt because the seat text contained bare `#N` references, so I wrapped them in backticks.

**Follow-up:** This is the third round in a row with must-fix findings on the same mechanism. The next fix round should take the decomplector's question seriously: remove the surplus code rather than patch it again.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1008620 cached reads)
- Output: 5978 tokens
- Cost: $0.922396
- Wall-clock: 281s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
