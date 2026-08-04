# Hermit-failure capability demerit — measure the local tier's fitness per job class

Status: Proposed (the measurement half is Built; the routing half is the open
follow-up). Maintainer directive 2026-07-27.

## Problem

The garden runs a **local inference tier** — the **hermit** worker kind, a codex
harness pointed at an on-box Ollama `/v1` endpoint (provider `local`, e.g.
`qwen3.6` / `qwen3.6`; see `common.sh` § local inference and
`worker_kind_field hermit`). Local inference is nearly free, so where it is
*adequate* it should carry the work; where it is *unfit* it wastes a claim,
requeues, and eventually dooms the job. We do not today know **which job
classes local inference is fit for** — so hermits are currently disabled
fleet-wide (`hermits:0`) pending exactly this evidence.

Guessing per job class is fragile. What we want is a **measurement**: whenever a
hermit genuinely fails a job, ask the counterfactual — *would a capable model
(claude/codex) have succeeded on the same job?* — and let the accumulated
answers, keyed by job class, drive routing.

## Relation to `gnome-backend-verified-autotune.md`

That sibling design (same 2026-07-27 directive) governs whether a host can *back*
a worker kind at all: a per-backend **credential + software probe** and an
**effective-vs-declared count** that ramps a kind toward 0 while its backend is
unauthenticated/unavailable. That is a **capability/auth** axis — *can this gnome
run a hermit?*

This design is the orthogonal **quality/fitness** axis — *given that it can run a
hermit, is local inference good enough for THIS job class?* A hermit can be fully
authenticated and healthy and still be the wrong tool for a hard build. The two
compose: the autotune design decides provisioning and capacity; the verified
demerit here supplies the per-(work-class) fitness signal that future routing
reads to decide *which classes* to send to a healthy local tier. Neither
subsumes the other, and this design changes none of the autotune surface.

## The signal: a verified demerit

This adds a **verified demerit** to the existing dollar-normalized reputation
system (`reputation.sh`, design
[`cleric-worker-bid-auction-reputation.md`](cleric-worker-bid-auction-reputation.md)).
A reputation is a distribution, per **arm** × **work-class** × **target**, over
merge-worthiness achieved; a bid is a Thompson draw over it. A demerit is one
**un-accepted attempt** recorded against the local arm when — and only when — a
capable reference model demonstrably could do the job the hermit could not.

"Verified" is the point: a bare hermit failure is ambiguous (the *job* might be
impossible, underspecified, or environment-broken — none of which is the local
model's fault). Blaming local inference for those would teach the router the
wrong thing. Confirming that a **capable** model completes the same work removes
that ambiguity: now the failure is attributable to the *arm*, not the *task*.

## Mechanism (built)

1. **Trigger — real hermit failure only.** `gardener.sh`'s handler-failure
   classifier already separates a **transient** outage (external signal-kill,
   wall-clock timeout, environmental/offline rc, or a transient-provider
   signature — none of which indict the model) from a **real, deterministic**
   failure. The probe fires **only** on the real-failure branch, **only** for
   `KIND=hermit`. A capable gardener's own real failure says nothing about local
   inference and is never probed.

2. **Bounded capability probe** — `scripts/jobs/hermit-capability-probe.sh`,
   invoked inline (best-effort, subshell-isolated) from that branch. It
   re-attempts the **same job's work** on a capable reference agent (`claude`
   today; `codex` is a wired-in extension point via
   `GARDEN_HERMIT_PROBE_AGENTS`) in an **isolated throwaway worktree**, under a
   **measurement-only** prompt that forbids every side effect — no push, no
   PR/issue/board mutation, no ferry, no messaging. Success is the deterministic
   completion marker (`report_has_completion_marker`), exactly as the live spine
   judges a genuine completion. This is a **counterfactual measurement**, not a
   second live attempt: it never touches the failed job's board entry (the reaper
   requeues that independently) and never pushes live work, so it cannot
   double-run live work.

3. **Cost + loop guards.**
   - **Once per base** — a committed `reputation/probes/<base>.md` record (and
     the demerit event itself) dedups across reaper requeues; a second probe of
     the same base is a no-op.
   - **Bounded** — a single `timeout`-wrapped attempt per capable agent; no
     retry loop.
   - **Budget freeze** — skipped while the fleet brake is engaged
     (`fleet_brake_engaged`): the probe spends capable-model tokens, so a quota
     storm must never be fed by it.
   - **Kill switch** — `GARDEN_HERMIT_PROBE=0` disables it wholesale.

4. **The demerit event** — on capable-succeeds-where-hermit-failed,
   `rep_record_demerit` (`reputation.sh`) writes an ordinary reputation event
   with `accepted: false` and a **non-censored** `aggregate_dollars`, keyed to the
   local arm resolved by the same `rep_resolve_arm` the claim used — the tuple
   **(model = local/qwen…, harness = hermit, context = the job's work-class ×
   target)**. It is written under a demerit-suffixed base
   (`reputation/events/<base>.hermit-demerit.md`) so it never collides with the
   capable arm's own completion event if the requeued job later lands. The
   probe record and demerit ride one single-writer CAS push.

5. **Reduction** — `reputation-reduce.sh` folds the demerit like any event:
   `attempts++` **without** `accepts++`, so the local arm's `acceptance_rate` for
   that work-class × target falls. (A censored aggregate would be dropped by the
   reducer — hence the demerit carries a positive figure; the failed local
   attempt's own agentic dollars when the ledger has them, else a nominal.)

## Routing (the open follow-up)

The measurement lands the evidence; **consuming** it is the next child. Options,
cheapest first:

- **Bid-time (automatic)** — the auction already draws from `acceptance_rate`; a
  local arm whose rate has collapsed for a work-class simply stops winning those
  jobs once the ledger warms the arm past the cold prior. No new code — it is the
  reason the demerit is modeled as an un-accepted attempt rather than a bespoke
  counter.
- **Routing gate** — a hard `model_routing` rule that removes `local` from
  eligibility for a work-class once its demerit-confirmed unfitness crosses a
  threshold (a per-class floor on attempts + a rate ceiling), so a known-unfit
  class is never even offered to a hermit. This is the natural join with
  `gnome-backend-verified-autotune.md`: that design gates a kind by *backend
  auth/capacity*, this one would gate a kind by *per-class fitness*.
- **Autotune re-admission** — periodically re-admit a demoted class on a small
  exploration budget (the cold prior already does this stochastically), so a model
  upgrade that fixes a class is re-discovered rather than permanently excluded.

## Why this justifies re-enabling or retiring the local tier

Hermits are off pending evidence. This design **is** that evidence: per job class
it accumulates a verified, auditable count of "local failed where capable
succeeded." A class with no demerits and adequate throughput is a class worth
running locally (nearly free); a class with a high verified-demerit rate is one
to route away from `local`. The decision to re-enable the tier — and for which
classes — becomes a reading of the arm projections rather than a guess.

## Files

- `scripts/jobs/reputation.sh` — `rep_record_demerit`,
  `rep_demerit_event_relpath`, `GARDEN_REP_DEMERIT_SUFFIX`.
- `scripts/jobs/hermit-capability-probe.sh` — the bounded, measurement-only probe.
- `scripts/jobs/gardener.sh` — the hermit real-failure hook that invokes it.
- `scripts/jobs/test/hermit-capability-probe-test.sh` — hermetic coverage
  (success→demerit, fail→no-demerit, dedup, guards, reducer fold).

## Tunables

- `GARDEN_HERMIT_PROBE` (default 1) — master enable.
- `GARDEN_HERMIT_PROBE_AGENTS` (default `claude`) — capable reference agents to try.
- `GARDEN_HERMIT_PROBE_TIMEOUT` (default 1200s) — per-attempt wall-clock bound.
- `GARDEN_REP_DEMERIT_SUFFIX` (default `hermit-demerit`) — demerit event basename suffix.
