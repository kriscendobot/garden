---
role: builder
---
# Build the accepted token-cost ledger (unum's pattern) — the fleet has no cost data at all

Maintainer directive (2026-07-28): *"investigate how Josh Corbin's Unum does token
cost accounting and apply that here."*

**The investigation is already done and accepted — this job is the "apply" half.**
Do not re-run the research; do not write another design. Unum's approach was ingested
into the library and two designs were commissioned, reviewed, and **Accepted**. What
never happened is the build.

## Read first (all on `journal2` unless noted)

- [`designs/token-cost-ledger.md`](../../designs/token-cost-ledger.md) — **Accepted**
  2026-07-10, "builder follow-up expected", explicitly built on "unum's proven
  pattern", adapting unum's `CostRecord`. **This document GOVERNS** where the two
  designs differ (file format, row schema, capture primary).
- [`designs/tada-token-accounting.md`](../../designs/tada-token-accounting.md) —
  **Accepted** 2026-07-09, "builder follow-up expected". Settled the hard mechanics;
  every one of its decisions and invariants is kept wholesale.
- `library/sections/unum--token-cost-ledger.md` (the record and capture) and
  `library/sections/unum--cost-attribution-and-aggregation.md` (grouping and the
  three surfaces) — the ingested source material.

The token-cost-ledger design is explicit that, since neither design was built,
**the builder implements the merged shape once**: one ledger, one footer, one capture
ladder. Follow that instruction rather than building two things.

## Why this is now urgent — measured 2026-07-28T07:30Z

The absence of this build is not a missing nicety; it has silently disabled the
entire reputation/bid-auction subsystem:

- **All 1377 reputation events carry `agentic_dollars: censored`.** Zero measured
  cost events in the garden's entire history.
- **All 73 arms under `reputation/arms/` sit at `attempts: 0`.**
- **`usage/` on `journal2` contains 0 entries.**

The chain: no handler writes `usage/<base>.jsonl` → `complete-job.sh` fails open to
`censored` → `reputation-reduce.sh` skips censored events before `att++`/`acc++` →
every arm stays at its prior forever → `auction.sh`'s Thompson draw has never learned
anything from any completed job, on any provider. **The auction is inert.** This build
is the head of that chain.

## Provider coverage is a first-class requirement, not an afterthought

The designs were written when the anthropic/`claude` lane was the fleet's centre.
**Today no lane writes a ledger** — anthropic (`gardener-claude.sh`), openai
(`cleric-codex.sh`, shared by the `fireworker`/fireworks lane), and moonshot
(`mystic-kimi.sh`) are all fully censored. Verify the design's capture ladder (the
per-base session-transcript delta with its two-layer fallback) against **each**
harness, and state per lane whether it yields real numbers or needs a lane-specific
capture. A ledger that only works for anthropic leaves the other lanes exactly as
frozen as they are now — and the fleet is actively adding lanes (open jobs
`validate-fireworks-job-end-to-end`, `investigate-opencode-alternate-harness`).

## Coordinate with the two open reputation jobs

- **`fix-censored-events-frozen-reputation-arm`** — complementary, still needed. Even
  with a ledger, some events will be censored (a capture that fails, a lane not yet
  covered); those should still count toward `attempts`/`accepts` and be excluded only
  from the cost estimators. Do not close it as fixed by this build.
- **`wallclock-cost-proxy-for-censored-arms`** — this build **supersedes it as the
  primary path**; the wallclock proxy becomes the *fallback* for lanes the ledger
  cannot yet measure. That job's rate card was specified to carry `source:` and
  `measured_at:` per entry precisely so real measurement replaces an estimate
  cleanly. Make sure the two do not both claim the cost field: a real ledger row must
  win over a wallclock estimate, and the record must say which it is.

## Invariants to preserve (from the accepted designs)

- **Capture is code-driven, never the agent.** No LLM anywhere in the capture,
  storage, or annotation path; the agent can neither author nor destroy the record.
- **Engagement boundary**: one ledger row per `$GARDEN_JOB_HANDLER` invocation, for
  **every** outcome (`tada`, `requeue`, `fail`), accumulating across requeues,
  gardeners, and hosts.
- **The ledger measures; the gate caps.** `scripts/jobs/usage-meter.sh` (the
  fleet-wide weekly quota gate) works and **stays**. The ledger may feed it
  (§ Feeding the gate) but never replaces it.
- Storage is one JSON line per engagement appended to `usage/<base>.jsonl` on
  `journal2`.

## Definition of done

- `usage/<base>.jsonl` rows are written for real jobs, by code, on every outcome.
- A freshly completed job's reputation event carries a **real** `agentic_dollars`
  rather than `censored` — quote one in the report.
- After a reducer pass, at least one arm shows `attempts > 0` — the first time in the
  garden's history. Quote it. This is the acceptance test that the chain is unblocked
  end to end, not just that a file appeared.
- Per-lane status stated explicitly for anthropic, openai/codex, and moonshot/kimi:
  measured, or still censored and why.
- `usage-meter.sh` behavior is unchanged; show the check.
- Pushed to `main2` per the garden's own-repo convention (direct push, no PR).
