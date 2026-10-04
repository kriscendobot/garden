## Completion report: refit-claude-caps-20261004

**Why the fitter rejected the rows.** The keys didn't match between the two scripts. `append-quota-checkpoint.sh` writes rows to `budget/manual-checkpoints/<subscription>.jsonl`, for example `claude-endolin2.jsonl`. `fit-quota-calibration.sh` asked for a `<host>` argument instead. When it was given `endolin-garden2-5bcdff64` or `endolin-garden-ece02cb4`, it read the old host-keyed logs from before the migration. Every row in those logs has `pairing_confidence: none` and null spend, which is why it said "no usable paired checkpoints". The fitter was the side in the wrong.

**Fix, landed on main2 as `9d271dcf2d0`:**
- `scripts/jobs/fit-quota-calibration.sh` now takes `<subscription>` as its argument. If it is given a host id that `config/subscription-mapping` lists, it stops with rc 2 and names the subscriptions to fit (for garden2: `claude-endolin2 codex-endolin`), instead of quietly fitting the stale log.
- The live-window check now uses the freshest per-host contribution under `budget/live/<subscription>/`, the same way the recorder does. Before, it used `$GARDEN`'s file or whichever file it found first.
- `scripts/jobs/test/quota-calibration-test.sh` has two new cases: a host id is refused with the subscriptions to fit, and a subscription fit pairs its rows and picks the freshest per-host live window. The test passes: 13 passed, 0 failed.
- Updated the `<host>` paths to `<subscription>` in `designs/manual-quota-calibration.md`.

**Fit results.** Verdicts are saved to journal `budget/quota-fit/` (commits `442be13bc5` and `b90d3eda76`).

| sub | grade | recommended cap (low / point / high) | governing segment | why not converged |
|---|---|---|---|---|
| claude-endolin1 | **provisional** | 147.7M / 148.8M / 149.9M | anchor 1788577200 (09-05 to 09-09), 8 points, spread 1.14 | not the live window |
| claude-endolin2 | **provisional** | 121.3M / 122.0M / 122.6M | anchor 1790391600 (09-28 to 10-02), 7 points, spread 1.28 | spread is over the 1.20 tolerance, and not the live window |

The current window (anchor 1790996400) has only 2 checkpoints for each subscription, and they disagree widely:
- claude-endolin2: 5% implies a cap of ~84.5M, 53% implies ~171.8M (spread 2.03).
- claude-endolin1: 3% implies ~105M, 31% implies ~283M (spread 2.69).

The fit needs at least 3 points in a window before it can call a result `converged`. The low-percent readings early in each window distort the implied cap heavily.

**Promotion:** none. Neither fit converged, so `config/budget-pools` is unchanged: claude-endolin2 stays at 121M and claude-endolin1 at 256M. I did not touch pacing policy, the 0.90 backoff fraction, or the codex/oros pools.

**Follow-ups:**
- To get a promotable claude2 fit, record 1–2 more checkpoints this week at higher percentages: `append-quota-checkpoint.sh claude-endolin2 <pct>`. Then re-run `fit-quota-calibration.sh claude-endolin2 --dry-run`.
- If the next points agree with the 53% reading, the fit should converge near ~170M. If not, raising the claude2 cap would be a manual maintainer override, not a fitted value.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/refit-claude-caps-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1015874 cached reads)
- Output: 9707 tokens
- Cost: $0.9768268000000001
- Wall-clock: 129s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
