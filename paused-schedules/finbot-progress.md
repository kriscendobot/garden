cadence: 6h
last_dispatched: 2026-08-01T15:05:02Z
job_basename_prefix: finbot-progress
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

# Push progress on kriscendobot/finbot (every 6h)

Recurring progress driver for the finbot design, which is ambitious and needs
**continuous iteration**. Each dispatch makes ONE concrete unit of forward progress
and hands off the rest; it does not try to land the whole design in a single
handler (it won't fit — that is why this is scheduled).

**Repo:** `kriscendobot/finbot` (our own fork).

## Each cycle

1. **Assess state.** Read the design doc(s), the open PRs and their CI, what has
   landed vs. what remains, and any existing `finbot-*` jobs already on the board
   or in flight. Do NOT duplicate in-flight work or open a competing PR — if the
   next increment is already being worked, advance/report on that one instead.
2. **Pick the single deepest UNBLOCKED next increment** toward the design.
3. **Advance it.** Implement the increment and push it on its branch/PR, driving
   toward green. **Do NOT merge it yourself** — every finbot change now lands only
   through the two gates in § Merge governance below. If the next step is not a
   build (it needs fresh design, a rebase, or CI shepherding), do that step or post
   the appropriate follow-up job (designer / weaver / fixer / shepherd) for it —
   the goal is **motion, one increment per cycle**.
4. **Report.** Message the maintainer inbox (`message-user.sh`) with a short note:
   what advanced this cycle, the next unblocked step, and anything that needs a
   maintainer decision.

## Merge governance (MANDATORY — maintainer directive 2026-07-22)

finbot increments are **no longer self-merged.** Every change lands only after it
clears BOTH gates below — even on our own fork. (Rationale: prior cycles
bot-merged PRs #1/#2/#3 with no panel; a later security review found the "real SES
attenuator" overstated what it did — exactly what a panel catches before landing.)

1. **Panel review.** Each increment is a PR that must **clear a panel** (the
   scripted gauntlet / panel review, `skills/panel`) before it can merge. A red or
   changes-requested panel means fix-loop, not merge.
2. **Orchestrator sign-off.** After the panel passes, an **orchestrator** (role
   `orchestrator`) must review the increment + panel outcome and **sign off**
   before the merge executes. Dispatch it as an ordinary automatic job — e.g. post
   `finbot-<increment>-signoff` with `role: orchestrator` — and let the choke point
   route it (`tier: mentor`). The merge is that orchestrator's authority (or a
   conductor it directs), **NOT** the press's.

   **Do NOT pin this to Fable/mentat.** This step formerly required
   `model: claude-fable-5`, dispatched via `post-manual-job.sh` — the one path that
   bypasses `automatic_route_body` and reaches the manual-only mentat tier. That
   pin was removed on 2026-08-01 (maintainer decision) to keep the gate while
   dropping the mentat spend. The gate itself is unchanged: sign-off is still
   required, and the press still never merges.

The press (this builder) **NEVER runs `gh pr merge`** on a finbot change. Build the
increment, open/advance the PR toward green, run the panel, hand off to the
orchestrator for sign-off + merge. If either gate is unmet at cycle end, report the
PR as "awaiting panel / orchestrator sign-off" and stop — that is a correct, complete
cycle, not a stall.

## Guardrails

- Our own fork — normal fork etiquette; leave the tree green. **Never self-merge**
  (see § Merge governance).
- One increment per dispatch. Consecutive cycles compound; a single cycle should
  not sprawl.
- If nothing is unblocked (everything waits on review/merge), say so in the report
  rather than manufacturing busywork.
