---
role: designer
---
# The gauntlet does not fit one claim-scoped handler — split it into stages

Nine jobs poisoned on `deadline-overrun` on 2026-07-28 alone. Raising the budget has
been tried and has now demonstrably failed. **Deliverable: a design plus the
implementation of a staged gauntlet** — if the design work is large, land the design
and post the build as a child.

## The evidence

Poisoned on deadline overrun, 2026-07-28:

`ebfb-reconcile-xsnap-pending-jobs-861-864`, `endo-sturdyref-agent-surface-build-gauntlet`,
`endojs-endo-but-for-bots-form-data-advisory`, `endojs-endo-but-for-bots-pr705-fixer-changes-requested`,
`endojs-endo-but-for-bots-pr755-review-a0778b2e`, `endojs-endo-but-for-bots-pr867-dependabot`,
`finbot-pr5-panel-20260727`, `finbot-progress-20260728-065010`,
`fu-endojs-endo-but-for-bots-pr825-8840fcdb-2`.

The decisive one: **`endo-sturdyref-agent-surface-build-gauntlet` declared
`handler-timeout: 14000` and poisoned anyway.** Raising the number is not the answer.

## Why raising the budget cannot be the answer — it is structurally capped

`reaper.sh` documents the invariant that makes a stale claim safe to reap:

```
GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL
```

with `GARDEN_CLAIM_TTL` defaulting to **14400s**. So a handler budget of 14000s is
already pressed against the ceiling — there is no headroom left without also raising
the claim TTL, and raising *that* degrades the reaper's ability to recover genuinely
dead claims (exactly the failure that stranded 62 jobs on a broken host earlier the
same day). **The budget ladder is exhausted. Splitting is the only remaining move.**

Note also the reaper poisons a deadline overrun after **1** cycle, not the usual 5
(`GARDEN_REAP_OVERRUN_THRESHOLD`), precisely because a job that exceeds its budget
"would be killed identically on every requeue." The system is already telling us the
work does not fit.

## What to design

Decompose the gauntlet ([pr-creation-flow](../../skills/pr-creation-flow/SKILL.md):
**clean → panel review → fix-loop → un-draft**) into **claim-sized stages** using the
standing decomposition (CLAUDE.md § *Orchestrating a multi-part job*;
[orchestration](../../skills/orchestration/SKILL.md),
[roles/orchestrator](../../roles/orchestrator/AGENT.md)): parked children promoted in
sequence by an orchestration job, each child fitting comfortably inside the default
2400s.

**The hard part is the fix-loop, and it is the point of this job.** Clean, panel, and
un-draft are naturally bounded, but the fix-loop is *iterative* — panel findings
produce fixes, which require a re-panel, an unknown number of times. A fixed child
list cannot express that. Address it explicitly. Options worth weighing:

- a child that **re-posts itself** (or a successor) while findings remain, with a
  bounded iteration cap and a clear give-up path to the maintainer;
- an orchestration that **re-promotes** the panel/fix pair until a panel comes back
  clean, using the existing `blocked_on` / `orchestrate.sh` substrate;
- a per-iteration child minted by the previous iteration's report.

State the trade-offs and pick one. Whatever you choose must **not** rely on a single
handler spanning the whole loop, which is the defect being fixed.

## Constraints

- **Preserve session continuity.** Basenames are the spine: a requeued job derives the
  same deterministic session id and `--resume`s its transcript
  (`handlers/gardener-claude.sh` § session continuity). Staging must not discard an
  interrupted stage's context.
- **Preserve the auto-gauntlet invariant.** A build's draft PR auto-runs the gauntlet
  (CLAUDE.md § Orchestrator vocabulary); the staged form must still be what a build
  triggers, with no separate maintainer step. A **probe** still stays draft.
- **Idempotence.** Re-running a completed stage must be a no-op, so a requeue mid-chain
  does not redo merged work or double-post comments.
- **Failure policy.** A stage that genuinely fails should halt the chain and surface
  (`--on-child-failure halt`), not silently strand the PR mid-gauntlet.

## Migration

Say what happens to the nine already-poisoned jobs. They are parked, held, in
`jobs/plan/` and preserved. Most should become staged runs rather than being promoted
as-is — promoting them unchanged just reproduces the overrun. **`endojs-endo-but-for-bots-pr755-gauntlet`
is a live special case**: as of 15:30Z it is mid-flight with a 14000s budget, its head
advanced to `b595e017`, and all checks green — if it completes, only the un-draft
remains; if it overruns, the remaining work is small and should be picked up as a
narrow stage rather than a fresh full gauntlet.

## Definition of done

- A design under `designs/` covering the stage decomposition and, specifically, the
  fix-loop iteration answer with its trade-offs.
- A working staged gauntlet, or the design landed plus a build child posted.
- Demonstrated on one real PR: each stage completes inside the default budget, and the
  chain reaches un-draft.
- A stated migration path for the nine poisoned jobs.
- Pushed to `main2` (direct push, no PR).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T16:00:24Z
