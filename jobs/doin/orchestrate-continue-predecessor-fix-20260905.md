---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix a permanent-stall bug in `scripts/jobs/orchestrate.sh`'s serial promotion
logic under `on-child-failure: continue`.

## The bug

When a serial orchestration's child fails/dooms and its policy is `continue`,
`orchestrate.sh` correctly logs `child N/total '<c>' failed; continuing
(policy=continue)` — but the actual promotion of the NEXT child still calls
`promote-plan.sh --require-tada <every predecessor>` for **every** prior index
(the `for ((k=0; k<i; k++)); do promotion_args+=(--require-tada "${kids[$k]}");
done` loop feeding `promote-plan.sh`). A predecessor that failed under `continue`
never reaches `jobs/tada/` by definition — it's parked in `plan/` with
`doomed: true`/`gate: go-ahead`, not completed — so `--require-tada` on that
index can never be satisfied. `promote-plan.sh` returns 3, and the tick logs
`NOT promoting child N/total '<c>': fresh promotion snapshot did not confirm
every predecessor in tada/` and gives up for that tick.

This repeats **every tick, forever**: the orchestration re-detects the same
failed child as "failed; continuing," re-attempts the same doomed-to-fail
promotion, and never advances — a silent permanent stall that still reports
`state: running`. Reproduced live: `minion-town-eval-campaign` (child 1/8,
`minion-town-eval-static-publish`, doomed 2026-09-04T07:45:50Z) sat stuck this
way for ~20 hours across dozens of `garden-orchestrate` ticks (see its own
`journalctl --user -u garden-orchestrate.service` history repeating the same
two log lines every ~3 minutes from 2026-09-04T07:45Z through
2026-09-05T04:13Z) before a human manually ran
`promote-plan.sh minion-town-eval-namestore-durability` to unstick it. That
manual workaround is NOT a fix — the next serial orchestration with a
continue-policy failure will hit the identical stall.

## The fix

The `--require-tada` predecessor set passed to `promote-plan.sh` when promoting
child `i+1` should include only predecessors whose *policy outcome* was
completion, not every raw index `0..i-1`. For a `continue`-policy orchestration,
a predecessor recorded as `failed` (per `child_state`'s own classification —
doomed/poisoned-and-parked, or a `orchestration-failed: true` tada report) must
be **excluded** from the `--require-tada` list rather than silently defeating
every future promotion. A `halt`-policy orchestration is unaffected by this fix
by construction (a halt policy never reaches this code path for a later child —
it stops the whole run at the first failure), so this is a `continue`-only
change.

Consider whether `promote-plan.sh`'s `--require-tada` primitive itself should
grow a way to say "or provably failed/terminal," versus `orchestrate.sh`
computing the filtered predecessor list itself before calling it — pick
whichever keeps the CAS-safety invariant intact (the comment above the call site
explains why the predecessor set must be re-validated in the same critical
section as the promotion, not just watcher-side).

## Verification

Extend `scripts/jobs/test/orchestrate-test.sh` with a case: a 3+ child serial
orchestration, `on-child-failure: continue`, where child 1 is doomed/parked
(not completed) — assert child 2 DOES get promoted on the next tick (today it
does not), and that a subsequent completion of child 2 correctly promotes child
3 with `--require-tada` covering child 2 but not the still-failed child 1.
Confirm the existing halt-policy tests still pass unchanged.

## Landing

This is the garden's own repo (`scripts/jobs/orchestrate.sh`) — land directly to
`main2` per the garden's own conventions (no PR for the garden's own repo; see
CLAUDE.md § Conventions), with tests proving the fix.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-05T11:44:31Z
