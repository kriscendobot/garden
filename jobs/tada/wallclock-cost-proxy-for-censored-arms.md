Done. Pushed to `main2` as `05fa5c7df8`, rate card landed on `journal2`.

## What I did

**The mechanism.** `duration_secs` is on 100% of the 1514 reputation events and is measured *by the garden*, not reported by a provider — so unlike a dollar figure it can never be censored. The reducer now prices a cost-censored event at `duration_secs × the arm's rate-card dollars-per-second` and folds it into `mean_dollars`/`m2`.

Four invariants keep an estimate from impersonating a measurement:
1. **The ledger always wins** where it exists — the proxy only fills holes.
2. **The raw state survives.** The event keeps `agentic_dollars: censored` and gains `cost_source: ledger|wallclock|none` + `estimated_dollars:`; the projection keeps its `censored:` count — which never shrinks — beside a new `estimated:`.
3. **The Thompson draw widens** with the estimated fraction of the cost pool (`GARDEN_REP_ESTIMATE_SD_MULT`, ×2 at 100%).
4. **A non-positive/absent rate means *no proxy*, never `$0.00`** — the event stays censored and the arm bids the wide prior.

The reducer re-derives from the *current* card every tick rather than trusting the event's pinned `estimated_dollars`, so correcting a rate re-prices all history as a journal data edit — no deploy, no event rewritten.

**Rates.** `reputation/rate-card.md` (journal, landed) over `scripts/jobs/rate-card-defaults.md` (tracked seed) over `GARDEN_REP_DEFAULT_RATE_PER_SEC`. The Anthropic rows are **measured** from the 79 ledger-priced events ($335.56 over 46583s); kimi-k3 is derived from Moonshot's provisional list-price ratio (0.6 × opus); local is amortized (~$0.29/busy-hour); openai carries the fleet default because no published gpt-5.x price is recorded anywhere and its ChatGPT-plan `$0.00` is a missing measurement wearing a number's clothes.

## Verification against the live 1514-event set

**kimi-k3, before → after:**
```
attempts: 3     accepts: 3      censored: 3                    attempts: 3   accepts: 3   censored: 3   estimated: 3
mean_dollars: 0.000000   m2: 0.000000        →                 mean_dollars: 0.090510    m2: 0.001040
```
That's exactly (17+19+27)/3 × $0.004310. Fleet-wide, arms with a cost posterior went **17 → 82 of 82**. Ledger-only arms are byte-identical apart from the additive `estimated: 0` line. Second reducer pass: `no reputation changes this tick`.

## Two things you should know

**kimi-k3 can now accumulate auction-relevant evidence, but its *bid* has not moved yet.** With 3 cost samples it is still under `cold_n=5`, so it draws the prior (~$14.85 mean). It needs 2 more accepted canaries to cross the gate; at 6 samples it would bid ~$0.49 (range $0.01–$2.13) from its own posterior. Before this change it could *never* have crossed that gate, because censored events produced no cost samples at all.

**The no-evidence bid, stated plainly** (the fallback you flagged as most likely wrong): a draw from the wide cold prior amortized by acceptance rate — mean **~$14** — clamped at the `$0.01` floor. It is not `$0`, but the floor is hit **~30% of the time**, because `GARDEN_REP_COLD_SD=20` against a mean of 10 puts ~31% of the prior's mass below zero. That's pre-existing, not introduced here, and it is genuinely Thompson exploration rather than a constant $0 bid (the guarded failure bids the floor *every* time). Still, a log-normal or truncated prior would explore without piling up at the floor — worth a follow-up.

## Follow-ups

- **The `attempts > 1` refinement is worth doing** — 255 of 1514 events (~17%). But `duration_secs` records only the final attempt, and its own gap is larger than I expected: your 2026-07-25 canary showed 25s claim→tada against a recorded 19s. The claim→tada spans are in the journal commit log. Separate job.
- **Codex `$0.00` ledger dollars** are a distinct hole from `censored` — a *measured* zero that the proxy does not touch. Only 2 events today, but it grows if codex ever reports reliably.
- The cold prior's floor pile-up, above.
- `scripts/jobs/test/hermit-capability-probe-test.sh` has 2 pre-existing failures (`capable_succeeded not 1`); I confirmed they fail identically on `origin/main2` without my changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/wallclock-cost-proxy-for-censored-arms.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 154 tokens (11080872 cached reads)
- Output: 78004 tokens
- Cost: $9.248960999999998
- Wall-clock: 1336s

<!-- garden-usage-end -->
