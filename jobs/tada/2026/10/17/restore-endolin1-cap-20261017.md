## restore-endolin1-cap-20261017: report

The `claude-endolin1` cap is back at 271,000,000 now that the weekly window has reset.

1. **Window reset confirmed.** `budget/live/claude-endolin1` shows a `window_start_epoch` of 1792206000, which is 2026-10-17T03:00:00Z. Spend was 14,630,259 (5%) at 04:01:52Z, so the new week has started.
2. **Cap restored.** I ran `scripts/jobs/set-budget-pool.sh claude-endolin1 271000000 manual-implied-301M-90pct-20261006-maintainer 2026-10-06`. It exited 0, and `origin/journal2` `config/budget-pools` now shows the 271M row (journal commit `d2cdb7c3587`).
   - **Before:** 430,000,000 (`temp-raise-endolin2-login-headroom-20261016-maintainer`, 2026-10-16)
   - **After:** 271,000,000 (`manual-implied-301M-90pct-20261006-maintainer`, 2026-10-06)
3. **Login question sent to the maintainer inbox** (`msg-restore-endolin1-cap-20261017-01c510f7239c`). `claude auth status` on this host shows an active claude.ai Max login. Nothing on the host or in the journal says whether that is the endolin1 or the endolin2 account, so I asked. The message says plainly that if endolin2 is still logged in here, the ledger will again charge its spend to `claude-endolin1`. That spend will reach the 271M cap and the claim gate will refuse work again. It asks the maintainer to either log this host back in as endolin1 or decide on another cap raise.
4. **Monk counts:** this host (endolin-garden-ece02cb4) had 4 `garden-monk@` units running before and after. Worker-leveling is unchanged: monk-fleet-ceiling is 8, this host's row is 4 monks and 4 clerics, and oros-studio is 4 monks and 0 clerics.

I didn't touch `claude-endolin2`'s retirement record or make any garden code changes, so there was nothing to commit to main2.

**Follow-up:** the maintainer needs to confirm which login this host is on and, if it's endolin2, log it back in as endolin1 before spend reaches 271M.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/restore-endolin1-cap-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (571181 cached reads)
- Output: 2869 tokens
- Cost: $0.5474082
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
