scripts/jobs/reputation-reduce.sh

# Censored-cost events freeze an arm's acceptance statistics forever

Found while validating **kimi-k3 job dispatch** (2026-07-28,
[context/operations/kimi-k3.md](../../context/operations/kimi-k3.md) § 4). Garden
change on `main2` (direct push, no PR). Everything else in the kimi-k3 validation
passed; this is the one thing blocking it from graduating past explicit pinning.

## The defect

In `reputation-reduce.sh`, the per-arm reduction is:

```awk
{ af=$1; d=$2;
  if (d=="CENSORED") { cen++; next }        # <-- returns before att++/acc++
  att++; delta=d-mean; mean+=delta/att; m2+=delta*(d-mean); sumd+=d;
  if (af=="true") acc++;
}
```

A censored event increments **only** `censored` and `next`s. So an event carrying
`accepted: true` contributes **nothing** to `attempts` or `accepts`, and
`acceptance_rate = (t>0)? a/t : 0` stays `0.0000`.

`censored` does not mean "deliberately withheld". Per
[skills/bid-auction/SKILL.md](../../skills/bid-auction/SKILL.md) it is a **fail-open
on a missing cost ledger**: *"agentic dollars from `usage/<base>.jsonl` (fail-open →
`censored` when the ledger is absent)"*. The same skill states the reducer should
*"fold **every** event into the arm projections"* — which this awk does not do. A
missing **cost** measurement is being allowed to discard the **acceptance**
measurement, and the two are independent.

## Why it blocks kimi-k3

Measured on `journal2` at 2026-07-28T06:35Z:

- **All 3 `kind: mystic` reputation events are `agentic_dollars: censored`** — the
  Kimi Code CLI writes no `usage/<base>.jsonl`, and the journal has no `usage/`
  entries for these runs at all. For this provider, censoring is not an edge case,
  it is **every single run**.
- The resulting arm
  `reputation/arms/mystic/moonshot/kimi-k3/medium/gardener-s@main2.md` reads
  `attempts: 0, accepts: 0, censored: 3, acceptance_rate: 0.0000` — **despite** the
  2026-07-25 canary having succeeded outright (`accepted: true`, real Moonshot tool
  use, exact marker readback, clean tree).

`auction.sh` then bids with `rep_thompson_draw "$att" "$mean" "$m2" "$acc" "$seed"`
and **explicitly discards the censored count** (`read -r att acc mean m2 _cen`). So
the mystic arm sits at its prior permanently: no number of successful kimi-k3 runs
can ever move it. **kimi-k3 can never win auction-based dispatch — only explicit
`model: kimi-k3` pinning.** Any provider whose CLI does not emit a usage ledger has
the same problem; mystic is just where it shows first.

## What to change

1. **Separate the cost terms from the acceptance terms.** A censored event should
   still increment `attempts`, and increment `accepts` when `accepted: true`; it
   should be excluded **only** from the cost estimators (`mean_dollars`, `m2`, and
   the cost-per-accepted amortization). Keep emitting `censored: N` so the arm still
   records how much of its cost evidence is missing.
2. **Check the Thompson draw's cost side.** With acceptance now updating but
   `mean`/`m2` still absent for an all-censored arm, confirm `rep_thompson_draw`
   behaves sanely — a bid of `$0` for an arm with no cost evidence would make it win
   every auction on price, which is the opposite failure. Decide deliberately: a
   configured prior cost, the rate-card value
   (`reputation/rate-card.md` / `config/auction.md`), or an explicit
   cost-unknown penalty. **State the choice and the reasoning in the `tada` report** —
   this is the judgement call in the job, not the awk edit.
3. **Consider closing the gap at the source (optional, report if out of scope).**
   If the Kimi Code CLI can report token/cost usage in its headless path, having
   `mystic-kimi.sh` write `usage/<base>.jsonl` would make these arms genuinely
   cost-aware instead of merely unfrozen. Do not let this block item 1.

## Constraints

- The reducer is **the sole writer of `arms/`** and must stay deterministic, no LLM,
  and idempotent — an unchanged event set must remain a no-op.
- It is leader-only (`garden-reputation-reducer`); do not change that.
- Arms are a **derived projection** — recomputed from events, never hand-edited. The
  corrected arms should appear from a normal reducer pass over the existing events,
  which is also the verification.

## Definition of done

- A censored event with `accepted: true` moves `attempts` and `accepts`; cost
  estimators still ignore it; `censored:` still reports the count.
- After a reducer pass, `arms/mystic/moonshot/kimi-k3/medium/gardener-s@main2.md`
  reflects the canary's real success instead of `acceptance_rate: 0.0000`.
- The cost-side decision from item 2 is implemented and justified in the report.
- Uncensored arms are numerically unchanged — show a before/after on one to prove
  no regression.
- Reducer remains deterministic and idempotent (run it twice; second pass is a
  no-op).
- Pushed to `main2`; `tada` report quotes the corrected mystic arm.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T12:16:40Z
