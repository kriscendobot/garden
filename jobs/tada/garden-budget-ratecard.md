Everything is committed, pushed, and verified. Both remaining test failures are pre-existing on unmodified main2 (identical set, unrelated to this work).

---

## Completion report — `garden-budget-ratecard` (Budget 1/5)

**What I did.** Two landings — code to `main2`, data to `journal2`.

### 1. Implemented the attempt cap (code → `main2`, commit `7ebe53e6d0`)
`GARDEN_REP_ATTEMPT_CAP_SECS` was documented but existed nowhere in code, so `rep_wallclock_index` billed the entire first-claim-to-tada span — swallowing idle queue time between a reap and the next claim (the 72x Fireworks inflation). Rewrote the index awk to sum **the final attempt (uncapped)** plus **`min(interval, cap)` for each earlier reaped attempt**, and to **exclude the reap→reclaim idle gap entirely** (it deferred-resolves each `doin` delete as reap-vs-completion at the next event, so within-commit ordering of the `tada`-add/`doin`-delete pair is handled). Default cap **2490 s** = the default reap floor (`GARDEN_HANDLER_TIMEOUT`+kill-after+slack), matching `reaper.sh`. Passed `cap` into the awk via `-v`; updated the `reputation-reduce.sh` comments.

**Regression coverage** (`test/auction-reputation-test.sh`): 3 new asserts — earlier attempts clamped to the cap (100+100+30=230 vs a naive 18040 span), final attempt uncapped (9050), cap-off bills full attempt spans but still excludes idle gaps (18030). Updated the existing multi-attempt canary from the old idle-inclusive 25 s to the corrected 20 s. Suite: **71 passed, 2 failed** — both failures pre-exist identically on unmodified `main2` (`gardener arm wrong`, `reducer churned a wallclock-estimated event set`) and are unrelated.

### 2. Re-based the rate card on true cost (data → `journal2`, commit `211de0db97`)
Measured **all** paid rows on **one basis — the capped proxy wallclock the reducer actually applies** — from the real journal, and retired the `[duration basis]` exception.

**The new Anthropic figure and how I derived it.** The flat subscription is **$400/mo** (two accounts × $200 Max 20x, confirmed over the bus) → **$13.33/day** → **$66.67** over the 5-day 07-28→08-02 window. I amortized that over the summed **capped-proxy wallclock** of the 262 Anthropic events completed in the window (**970 566 s**): **`66.67 / 970566 = 0.000069 $/s`**, one pooled row (a flat plan does not price per model — removed the four per-model rows).

Crucially I did **not** copy the arming note's `0.000707`. That figure divides $66.67 by the usage ledger's `elapsed_s` (94 240 s of pure model-call time). But the reducer multiplies the **capped-proxy** span (≈10.3× larger — a job's handler runs git/tests around the model call, plus capped requeues), so pricing at `0.000707` while the reducer applies the 10.3×-larger denominator would over-attribute Anthropic ~10×. The `$/s` shape is kept but documented as **an amortization of a fixed cost, not a marginal price** (marginal cost is ~0 until the plan limit).

**Kimi and Fireworks**, same maintainer totals, re-measured on the capped basis: kimi-k3 `50/37381 = 0.001338` (was 0.002772 on raw duration); fireworks `57/111908 = 0.000509` (was 0.001883). Verified the event populations still match the documented figures (kimi 27 completed engagements / 18036 duration; fireworks 42 / 30271).

**Ordering reversal — CONFIRMED.** The card previously implied Anthropic was the *most expensive* paid arm (0.005154) and Kimi cheaper (0.002772). True-costed, Anthropic is now the **cheapest** paid arm (0.000069) — ~19× below Kimi and ~7× below Fireworks. Reducer rate-resolution verified: anthropic(any model)→0.000069, kimi→0.001338, fireworks→0.000509, openai/unknown→0.005154.

**Follow-ups I recorded in the card (Open follow-ups).**
- **Highest-value / likely the next child:** the reversal is realized in the card but **not yet in the auction posterior** — 217 of 1109 Anthropic events still carry a numeric `agentic_dollars` copied from the notional usage ledger, which the reducer prefers over the proxy; the card only governs the 892 *censored* Anthropic events. Making true-cost bite end-to-end means treating subscription `total_cost_usd` as censored (a reducer/`complete-job` change, out of scope here).
- `duration_secs` still clocks only the final attempt on the fallback path.
- The `local` row remains an independent hardware amortization (not on the proxy basis, noted as such); the `* * *`/`openai` fleet default kept at 0.005154 but re-documented as a deliberately-high ceiling (its old "pooled measured Anthropic rate" source was the notional row now removed).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-budget-ratecard.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5645192 cached reads)
- Output: 82089 tokens
- Cost: $6.353715
- Wall-clock: 1350s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
