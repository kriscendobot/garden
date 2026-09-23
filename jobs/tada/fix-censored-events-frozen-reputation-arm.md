Pushed to `main2` as `357c43f475`.

## What was wrong

`recompute_arms`'s per-arm fold `next`ed on a censored event **before** incrementing `att`/`acc`, so an event carrying `accepted: true` contributed nothing. `censored` is not "withheld" — it is the fail-open when `usage/<base>.jsonl` is absent, a missing **cost** measurement that says nothing about acceptance. Design §4.5 already required the fold this restores.

**The blast radius is the whole market, not just kimi-k3.** On the live journal: **1412 of 1418 events are censored**, and **all 74 arms** read `attempts: 0, accepts: 0`. Only the `claude -p` handler captures a provider-computed `total_cost_usd` — `cleric-codex.sh` deliberately stays unpriced ("a measured row must never masquerade as an invoice"), `mystic-kimi.sh` and the Ollama path capture nothing. So three of four worker kinds could never produce a cost sample, and therefore never accumulated *any* statistic at all.

## What changed

- **`reputation-reduce.sh`** — acceptance terms fold **every** event; cost terms (`mean_dollars`, `m2`) fold only the `attempts - censored` cost samples. `mean_dollars` stays cost-per-accepted by dividing the cost-observed per-attempt mean by the full-population acceptance rate. When nothing is censored the code takes an `n == att` branch computing the historical `sumd/acc` **by that exact expression**, so an uncensored arm's file is byte-identical — no churn, idempotence preserved.
- **`reputation.sh`** — `rep_thompson_draw` gains an optional 6th arg, the cost-sample count (`rep_cost_samples` = attempts − censored, clamped, derived not stored). New `rep_cost_samples` helper.
- **`auction.sh`** — stops discarding the censored count and passes it through.
- **Tests** — new `CENSORED` subtest; suite is 43/43 (was 33/33, all pre-existing assertions unchanged).
- **Docs** — design §4.5 and `skills/bid-auction/SKILL.md` now state the cost/acceptance split and the cold gate's basis.

## The cost-side decision (item 2) and why

**Chosen: the configured prior (`GARDEN_REP_COLD_MEAN`/`_SD`), gated on cost samples rather than attempts, and amortized by the arm's measured acceptance rate.**

The warm branch and its variance divisor now key on **cost** samples, never `attempts`. This matters because unfreezing acceptance alone would have created the inverse defect: the kimi arm would soon pass `cold_n` on attempts with `acc >= 1`, enter the warm branch, and read `mean_dollars: 0.000000` as "merges for $0" — bidding the `$0.01` floor and winning *every* auction on price. The new test asserts both sides: the guarded draw spans the wide prior (mean ~$11, range $0.01–$56), and a control call reading the same arm without the split returns exactly `$0.010000`.

I rejected an explicit cost-unknown *penalty*: bidding a never-priced provider above the prior would suppress exploration of exactly the arm we are trying to measure. I rejected a rate-card lookup because `reputation/rate-card.md` and `config/auction.md` **do not exist** in the journal — there is no rate card to read, and inventing one here would be the same "guess a rate" the codex handler refuses.

The amortization is what makes the newly-unfrozen acceptance data *do* something under total cost censoring: the prior is a prior over cost-per-*attempt*, so cost-per-accepted is `prior / rate` (the same delta-method relation the warm branch uses). An all-censored arm can therefore never bid **below** the prior on missing data, but a rejection-prone one bids **above** it. It engages only with real acceptance evidence (`>= cold_n` attempts, `>= 1` accept); a brand-new arm draws exactly the prior as before.

## Verification

Hermetic fixture built from the **real** journal snapshot (1418 events, 74 arms), running the `origin/main2` reducer and the new one over the identical event set:

- **Cost estimators untouched:** all 74 arms have byte-identical `mean_dollars` and `m2`.
- **No-regression before/after** on the one live arm with real dollars (`gardener/anthropic/claude-default/medium/other-m@main2`): `mean_dollars: 4.300401`, `m2: 14.001289` unchanged; only `attempts: 4 -> 205`, `accepts: 4 -> 205` (201 censored siblings now counted).
- **Bids unchanged today:** per-arm Thompson draw at a fixed seed is identical for all 74 arms — every arm has fewer than `cold_n` cost samples, so all were and remain cold. The change is behaviour-neutral for the current auction while making acceptance learnable.
- **Idempotent:** second pass is a no-op commit, with and without censored events.
- Suite 43/43; `shellcheck -S error` clean.

The corrected mystic arm, from a reducer pass over the existing events:

```
kind: mystic          provider: moonshot     model: kimi-k3
thoughtfulness: medium  work_class: gardener:s  target: main2
attempts: 3           accepts: 3             censored: 3
mean_dollars: 0.000000  m2: 0.000000         acceptance_rate: 1.0000
```

(was `attempts: 0, accepts: 0, acceptance_rate: 0.0000`). The **live** `journal2` arms are unchanged — I deliberately did not push arms computed by undeployed code, since the deployed leader-only reducer would immediately revert them. They correct themselves on the first `garden-reputation-reducer` tick after this lands in the deployed root.

## Item 3 — closing the gap at the source (out of scope, reported)

Feasible but a design-level follow-up, not a handler tweak. `kimi 0.29.x` offers `--output-format stream-json` (the handler currently uses `text` and writes nothing to `GARDEN_USAGE_FILE`), so token capture is likely available on the codex pattern — but **that alone would not unfreeze cost**: `rep_agentic_dollars` reads only `total_cost_usd`/`dollars`, and Moonshot's CLI, like codex, is unlikely to emit provider-computed dollars. Pricing tokens requires the missing rate card plus a priced-from-tokens path in the reducer. I did not verify the stream-json event shape against the live CLI (that costs a Moonshot call). Recommended follow-up job: *"price token-only usage rows from a journal rate card"*, with kimi/codex/ollama token capture as its first consumers.

## Follow-ups

1. The above rate-card work — until it lands, every non-Claude arm learns acceptance only, which is now at least correct rather than frozen.
2. `tests/checks/run.sh` reports two failing suites in this worktree, both pre-existing and unrelated: `test_maintainer_inbox_information_hiding.sh` flags `skills/review-retrospective/SKILL.md` and `skills/schedule/SKILL.md` as off-allowlist maintainer-inbox references (library drift on `main2`, files I did not touch), and `test_run_all.sh` fails two assertions that require invoking `claude`. Worth a small cleanup job for the first.
