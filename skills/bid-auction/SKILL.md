# Skill: bid-auction

The decentralized bid auction and dollar-normalized reputation the worker fleet
(gardeners + clerics) uses to select who runs an opted-in job. Full architecture:
[`designs/cleric-worker-bid-auction-reputation.md`](../../designs/cleric-worker-bid-auction-reputation.md)
§3–§5. Rides the untouched job-board push-CAS ([`job-board`](../job-board/SKILL.md)).

## Purpose

Let every eligible worker compute a **bid** for a job from its own reputation for
that job's `(kind, provider, model, thoughtfulness) × work_class × target` arm, and
resolve the auction **deterministically, CAS-safely, with no central auctioneer** —
selecting the combination cheapest-to-merge in true aggregate dollars (measured
agentic + inferred human), not cheapest per token. Degrades to the plain race when
zero or one worker bids.

## Inputs / state (journal, on `journal2`)

- `jobs/bids/<base>/<bidder>.md` — one per-bidder bid file (never contend with each
  other; swept by `complete-job.sh` at completion). Carries the committed arm and
  the arm's posterior at bid time.
- `reputation/events/<base>.md` — one event per completed base, written by
  `complete-job.sh` on the completion push (single-writer: its own basename).
- `reputation/pending/<base>.md` — completed-but-acceptance-unknown (a PR still in
  review); finalized by the reducer.
- `reputation/arms/<kind>/<provider>/<model>/<thoughtfulness>/<wc>@<target>.md` —
  the derived projection (`attempts accepts mean_dollars m2 censored`), recomputed
  **only** by the reducer. `attempts`/`accepts` count **every** event; the dollar
  estimators summarize only the `attempts - censored` cost samples.
- `reputation/rate-card.md`, `config/auction.md` — optional journal config layered
  over the env-var defaults baked into `reputation.sh` / `auction.sh`.
- `reputation/verdicts/<base>` — optional acceptance override (a maintainer/PR
  signal drop). `reputation/reviews/<base>` — optional review observables
  (`rounds`/`comment_words`) for the inferred human-review dollars.

## Procedure

- **Opt in**: a producer stamps `market: bid` (and optionally `bid_window: <secs>`,
  default 120; and `posted_at:` for a shared deadline) on a job. Anything else is
  the race.
- **Bid** (in `claim-job.sh`, LLM-free): while `now < posted_at + bid_window` an
  eligible worker writes its own `jobs/bids/<base>/<kind>-<host>-<id>.md` (a seeded
  Thompson draw over the arm it would run) and pushes, then moves on WITHOUT
  claiming.
- **Award** (`auction_award_order`, a pure function of the journal): at window
  close every worker ranks the committed bids by a deterministic Thompson draw
  seeded on `hash(base‖bidder‖arm)` — reproducible on every host — ascending by
  drawn aggregate dollars, ties broken by `hash(base‖bidder)` (which also spreads
  identical-arm load uniformly). The bid's self-reported posterior is **verified,
  not trusted**: the draw is recomputed from the current committed projection.
- **Claim** (staged liveness): the rank-1 bidder claims at close via the ordinary
  todo→doin push, stamping `awarded_bid` + the committed arm. Eligibility widens by
  `grace` (default 30s) steps — ranks 1–2, then 1–3, then anyone at 3·grace — so a
  dead winner never strands the job. The **push CAS is the only serialization
  point**: exactly one claim lands; a mis-timed push is a mis-award, never a
  double-award or lost job. The reaper is untouched (an awarded-then-orphaned claim
  is an ordinary stale doin entry).
- **Record** (`complete-job.sh`): write the reputation event keyed to the ran arm;
  agentic dollars from `usage/<base>.jsonl` (fail-open → `censored` when the ledger
  is absent), acceptance = `true` for an internal `main2` job, else `pending`.
- **Reduce** (`reputation-reduce.sh`, leader-only `garden-reputation-reducer`
  timer): finalize pending events (verdict override > internal-tada > leave), fold
  every event — censored included — into the arm projections (Welford over the cost
  samples; cost-per-accepted amortizes failed attempts by the full-population
  acceptance rate), the SOLE writer of `arms/`. Deterministic, no LLM (reviewer text is
  only COUNTED). Idempotent — an unchanged event set is a no-op.

## Notes

- **Cold start / no starvation**: an arm with `< cold_n` (default 5) COST samples,
  or never yet accepted, draws from a WIDE cold prior so it still occasionally wins
  a measuring job (Thompson exploration); a confidently-cheap arm draws low and wins
  the majority (exploitation). New clerics start cold and are explored, not starved.
- **Censoring splits cost from acceptance.** `censored` means the cost ledger was
  absent (fail-open), never that the run was withheld, so a censored event still
  moves `attempts`/`accepts` and is excluded only from the dollar estimators — a
  missing COST measurement must not discard the independent ACCEPTANCE measurement.
  The cold gate counts COST samples (`attempts - censored`), so an arm that is never
  priced draws the configured prior — amortized by its measured acceptance rate, so
  a rejection-prone arm bids above it and no arm can ever bid below it on missing
  data. Reading a zeroed `mean_dollars` as a posterior would bid the `$0.01` floor
  and win every auction on price; that is the inverse failure and is guarded. Today
  only the `claude -p` handler reports a provider-computed `total_cost_usd`, so
  codex/Kimi/Ollama arms are censored on every run and learn acceptance only.
- **Thoughtfulness (§5)**: today a worker commits to the arm it would actually run
  (executed == committed), so the auction competes arms ACROSS workers/kinds.
  Enumerating a thoughtfulness LADDER per unpinned job so the market learns the
  cheapest adequate level is a clean follow-up, gated on the handlers reading the
  awarded arm.
- **Determinism**: all randomness is `sha1sum`-derived and all math is POSIX awk —
  byte-identical across hosts (never `Math.random`/`awk rand()`), so any award is
  reproducible and auditable from the journal alone.
- **Rollout**: additive and race-preserving. Shadow phase — events + projections
  accrue with no behavioral effect until producers stamp `market: bid`. `race`
  stays permanent for urgent/mechanical work and as every auction's degradation
  floor.

## Tests

`scripts/jobs/test/auction-reputation-test.sh` — deterministic math, work-class,
event-on-completion, reducer projections + idempotency, race degeneration,
open-window bidding, deterministic award, no-double-claim under concurrency,
cold-start + starvation guard.
