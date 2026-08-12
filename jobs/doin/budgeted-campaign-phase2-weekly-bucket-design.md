---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: designer

Garden-infra design edit: amend `designs/budgeted-campaign-dispatch.md`
(landed `main2` commit `67e6b0d88246`) directly on `main2` from an isolated
per-job worktree off `origin/main2` — no branch, no PR. Read the landed
document in full first; this is an addition to it, not a rewrite.

## Task — Phase 2: recurring capacity calibration + a persistent token bucket

Phase 1 (already landed/being built) gives one orchestration a fixed
`--budget-tokens N` the maintainer supplies by hand each time — this week's
N (2,080,000) came from a one-off manual back-calculation against a
maintainer-reported quota percentage. That doesn't scale to "just keep
campaigns running with good accounting." Design the recurring mechanism
that replaces the manual step:

1. **A weekly, deterministic (no-LLM), scheduled job.** Cadence
   `weekly-at-Fri-21:00-America/Los_Angeles` via `scripts/jobs/set-schedule.sh`
   (`skills/schedule/SKILL.md` — this exact anchored-cadence form already
   exists and is DST-aware/drift-free; use it, don't invent scheduling).
   On each fire it:
   - Sums the prior week's token usage (all four classes) per account —
     "account" today means per-host (`usage/*.jsonl`'s `host` field; the
     fleet's two Claude subscriptions map 1:1 to its two hosts as
     established this session) — over the window since the prior anchor.
   - Computes that week's notional cost and the notional-to-real calibration
     ratio, using the garden's **currently configured** subscription costs —
     make this real journal-backed config (e.g. `config/claude-subscriptions`,
     one row per host/account naming its real monthly cost), not a hardcoded
     `$200 x 2` constant, so it stays correct if accounts are added, removed,
     or repriced. Follow the existing `config/*` precedent (`config/fork-owners`,
     `config/sysop-issuers`) for shape and CAS-write discipline.
   - Appends (never rewrite-in-place — the whole point is keeping history for
     the trailing-window statistic below) one record per account per week to
     a journal-shared ledger, e.g. `budget/weekly-capacity/<host>.jsonl`,
     following the same per-key append-only JSONL shape `usage/<base>.jsonl`
     already proved out (`token-cost-ledger.md`).

2. **A derived "token bucket" capacity estimate: max, not average, over the
   trailing 4 weekly records.** Maintainer's explicit rationale (record it in
   the design, don't silently pick a different statistic): the fleet can
   under-spend a week not because quota ran out but because there wasn't
   enough queued work to spend it on — averaging in quiet weeks would bias
   the estimated true capacity downward. Taking the max of the last 4 weekly
   totals is a better (if still imperfect — say so) gauge of the real
   ceiling. Design the derivation as a plain read-time computation over the
   ledger (same "derived, not a new write path" principle the fleet-telemetry
   design already established for this codebase) — not a separately
   maintained running counter that could drift from its source.

3. **How the bucket is drawn down.** Today's Phase 1 `--budget-tokens N` is
   scoped entirely to one orchestration, supplied fresh each time. Design
   whether/how it should instead draw from a **persistent, shared,
   journal-backed balance** — refilled weekly to the freshly computed
   max-over-4-weeks figure, decremented as campaigns actually spend (derived
   from `usage/*.jsonl` the same way Phase 1 already aggregates per-campaign
   spend), so a maintainer stops having to hand-supply a number per campaign.
   Recommend a concrete shape (e.g. `budget/bucket.json`, rewrite-in-place:
   `capacity`, `refilled_at`, plus spend derived fresh at read time rather
   than stored) and how it composes with Phase 1's existing flag — does
   `--budget-tokens` become optional, defaulting to "draw from the bucket
   until empty" when omitted? Justify the choice.

4. **Recovering unspent budget** (Phase 1 already made unspent-per-campaign
   visible and non-swept) — with a persistent bucket, unspent tokens from an
   under-run campaign simply remain in the bucket's balance rather than
   needing an explicit recovery step; confirm this is sufficient or name why
   it isn't.

## Deliverable

An addition to `designs/budgeted-campaign-dispatch.md` (a new "## Phase 2:
recurring calibration and the token bucket" section, or a sibling document if
the amendment would make the existing one exceed the 1-3 screen norm — your
call, cite the reason). Any open question goes in the document's own "Open
questions," not guessed past. This is design only — no build in this job.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T01:24:24Z
