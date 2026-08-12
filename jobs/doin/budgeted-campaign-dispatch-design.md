---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: designer

Garden-infra design, not a fork/PR design: land the deliverable as
`designs/<slug>.md` committed straight onto `main2` from an isolated per-job
worktree off `origin/main2` (`roles/COMMON.md` § the one correct shape for a
garden-infra job) — no branch, no PR.

**Urgency: needed working this week**, against a resetting Friday-9pm-Pacific
quota window. Phase this the way `fleet-telemetry-and-anomaly-response.md`
phased itself: a minimal, shippable phase 1 that's actually useful alone,
not a big-bang design that delays real dispatch. If the full mechanism can't
land today, the phase-1 cut must.

## Task

Design a **budget-bounded campaign dispatch** mechanism: a way to allocate a
token/notional-dollar budget to a body of work, dispatch tasks against it,
track cumulative *actual* spend as it accrues, stop dispatching new tasks
once the budget is exhausted, and make whatever's unspent visibly available
again rather than silently absorbed — this is new: nothing in the garden
currently caps or tracks spend at the *campaign* granularity (only the
fleet-wide weekly `usage-meter.sh` gate exists, and it's off on this host;
`cost.sh` reports after the fact, it doesn't gate dispatch).

**First real consumer, motivating and validating the design:** the halted
29-child orchestration `ironhorse-test262-implementation-completion`
(6 children done, 23 recovered/re-staged by a companion job,
`ironhorse-test262-completion-recover-children`) is waiting to resume under
exactly this mechanism, with a real number: **~2.08M billable tokens / ~$63
notional, combined across the fleet's two Claude accounts**, calibrated
2026-08-12 from `usage/*.jsonl` since the last Friday-9pm-Pacific reset
against the maintainer-reported 48%/53% quota-used figures (show your own
recomputation of this from the ledger rather than trusting the number
verbatim — it may have moved).

## Decisions this design must make (derive from existing substrate, per the
## fleet-telemetry design's own precedent — no new parallel ledger)

1. **Where cumulative spend is read from.** `usage/<base>.jsonl` is already
   the per-engagement CostRecord ledger (`token-cost-ledger.md`). A
   campaign's spend is the sum over its children's usage rows — an
   orchestration's children already share a discoverable naming/ownership
   relationship (`orchestrated-by:` in the parked plan frontmatter, and
   `jobs/orch/<base>.md` while running). Design how "which usage rows belong
   to this campaign" is computed cheaply (a glob over known child basenames
   is simplest; consider whether a campaign needs a stable ledger-side tag
   for children spawned mid-campaign that weren't enumerable up front).
2. **Where the promotion-gate check happens.** The natural hook is
   `orchestrate.sh`'s serial-advance step (`advance_serial`, the `parked` ->
   `promote-plan.sh` call) — before promoting the next child, check
   cumulative campaign spend against the campaign's declared budget; if at
   or over budget, do not promote, and record why (mirrors the existing
   halt-on-failure path's shape: a terminal state with a clear reason, not a
   silent stall). Two flat token quantities are all that should be needed:
   a declared budget and the derived cumulative spend — no new persistent
   counter to keep in sync (compute cumulative spend fresh each check, the
   fleet-telemetry design's "derived, not a new write path" principle).
3. **Recovery of unspent budget.** When a campaign stops (budget exhausted,
   or all children done under budget), the difference between declared
   budget and actual cumulative spend is simply never consumed elsewhere —
   design what "recovering it to the pool" means concretely: is it just
   that the campaign's remaining children stay cleanly parked (not swept)
   for a future, separately-budgeted resume, or does "the pool" mean
   something more active (e.g., surfaced on the bulletin, or folded into
   the next campaign's budget)? Recommend one; don't invent unneeded
   machinery.
4. **Where the budget number itself is declared and by whom.** Given
   `usage-meter.sh`'s fleet-wide quota gate is a proven precedent
   (`GARDEN_TOKEN_WEEKLY_QUOTA`), a per-campaign budget is narrower in scope
   but the same shape — a declared cap, checked against real accrued spend.
   Decide whether it's a `post-orchestration.sh` flag (e.g.
   `--budget-tokens N` / `--budget-usd N`), a journal-backed campaign
   record, or something else, and justify it against the existing
   orchestration mechanics (`skills/orchestration/SKILL.md`,
   `designs/orchestration-jobs.md`) rather than inventing a parallel system.
5. **Notional-dollar vs. token accounting, and the two-account reality.**
   The garden's fleet spans two separate Claude subscriptions (one per host,
   confirmed via `usage/*.jsonl`'s two distinct `host` values), each with its
   own independent weekly quota window. State plainly whether a campaign
   budget should be a single combined number (simpler, what this week's
   first use needs) or split per-account (more correct, since a job claimed
   by one host only spends that host's quota) — recommend a phase-1 scope
   and name the other as a phase-2 open item rather than blocking on it.
   Note also the standing finding that notional dollars on a flat
   subscription are a calibration index, not real invoiced money
   ([true-cost-vs-notional-ledger], if such a design/library note exists —
   cite it via library-lookup) — the budget number is real in *tokens*;
   the dollar figure is a convenient, consistently-priced proxy for sizing
   it, not itself the enforced quantity.

## Deliverable

`designs/budgeted-campaign-dispatch.md` (or a better slug), committed
directly to `main2`. Phase 1 must be scoped so a same-day or next-day build
can apply it to the waiting ironhorse campaign before the week's usefulness
window closes. Open questions this job cannot resolve go in the document's
own "Open questions" section.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T00:53:06Z
