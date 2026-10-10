Panel round 5 on kriscendobot/minion.town PR #174 came back **must-fix**. I ran one round only: no fixes, PR left in draft.

**What I did**
- Ran the panel in single-round mode on the PR head `39a12d0` (branch `build/credit-metering-no-ertp`) against base `origin/main-39867df`, in a separate checkout for this job. `panel.sh` exited 0 with disposition `must-fix`.
- The panel saved its record to `panel-runs/kriscendobot-minion.town-174/67ffd2c8c609.md` in the journal.
- The repeated-mechanism check fired: the two previous rounds both flagged `appendFile`, `charge`, `clip-payment.ts` and `credit-ledger.ts`. So the decomplector was seated and asked whether this machinery is needed at all.
- Posted the verdict as review 5477477759 (a 49 KB comment). GitHub won't let the bot request changes on its own PR, so it went in as a comment, the same way rounds 1–4 did.
  - The full panel output was 90 KB, over GitHub's review size limit. The four request-changes seats are posted in full; the other seats are cut down to about 1.5 KB each.
  - The garden's `gh` wrapper refused the first attempt because of bare `#45` links. They mean minion.town PR #45, so I wrote them as `kriscendobot/minion.town#45` and reposted.

**Verdict: 34 seats** — 4 request-changes, 9 approve, 21 comment-only.
- **decomplector:**
  - Must-fix: `ledger.jsonl` is a third credit store with no reconciliation against the Stripe-backed `accounts.credits` balance.
  - Must-fix: the charge-then-refund settlement machinery keeps growing round after round. A reserve-then-commit/release design would replace it.
  - Should-fix: a refund changes the meaning of earlier records ("un-settles" a charge), which makes the ledger history harder to read.
  - Should-fix: the price schedule is hard-coded instead of passed in as data.
- **breaker:**
  - Should-fix: a refund racing with a new publish of the same content lets that publish go out free.
  - Should-fix: the settlement id doesn't include the price-schedule version, so a price change makes re-publishing old content fail.
  - Should-fix: running the CLI `grant` against a live gateway can cut off a record the gateway is still writing.
- **archivist:** must-fix — the design doc says `CLIP_METERING=on`, but the code and deploy files use `CLIP_METERING=1`.
- **pruner:** asks for shorter comments in `clip-payment.ts` and `http.ts`.

**Follow-ups**
- The decomplector's must-fixes question the design itself (charge-then-refund, and a separate file ledger), not just a bug. Another fix pass that adds more machinery will likely get flagged again; the maintainer may want to decide whether to switch to reserve-then-commit or bridge to the existing credits store.
- The decomplector also couldn't verify the 2026-10-09 "build without ERTP first" decision that the PR's design doc section 6a records. The PR body should link to where that decision was made.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (880622 cached reads)
- Output: 5538 tokens
- Cost: $0.7921244000000002
- Wall-clock: 201s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
