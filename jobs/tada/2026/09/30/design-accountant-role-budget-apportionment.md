I've written the accountant design, added the role brief, trimmed the other roles and pushed it all to `main2` as commit `649f5cdd617`. I didn't open a PR: I settled every design choice in the doc and left no open questions, so the garden's rule says it lands directly. The design is still Proposed, and none of the scripts it describes exist yet.

**What I found already in place**
- **Metering and admission:** `usage-meter.sh`, `config/budget-pools`, worker leveling, the weekly capacity calibration and quota checkpoints.
- **Pacing brakes:** the foreman's active target, the token-backoff fraction, `brake-foreman.sh`, and the `--budget-hold` gate.
- **Existing budget caps:** the orchestration `--budget-tokens` cap, and an existing per-arc budget (`set-arc-budget.sh`, `arc-spend.sh`, the `ratchet-arc:` job field). Only `ironhorse-test262-ratchet` uses the per-arc budget, and none is currently set on the journal.
- **Priorities:** `config/foreman-mandate` is free text with no quantities, written by hand.
- **The liaison** has only the "unknown quota is depleted" rule, plus hand-handling budget watchdog notices at muster. The foreman and mentor role files and the gauntlet have no budget logic of their own.
- **The July "review arcs"** (press schedule + tracker issue + `arc-status-daily`) are retired. Only the `claude-on-minion-town` presses are left. So the design reuses the existing per-arc budget rather than inventing a second meaning of "arc".

**The design** (`designs/accountant-arc-apportionment.md`)
- **Arcs:** an arc is the existing `config/arc-budgets/<arc>` record, extended with a rank, a one-line summary, an optional tracker link, and a fixed weekly window starting at the subscription reset. Jobs join an arc through an `arc:` field; `ratchet-arc:` still works as the old name.
- **The unallocated remainder:** foreman work with no arc is charged to a pseudo-arc called `unallocated`, so the slices always add up to the foreman's weekly total.
- **What the foreman does:** it ranks ready plans by arc, only generates a step for an arc with budget left, and tags it with that arc. Only work the foreman draws is gated. Jobs you ask for directly, triagers, watchers and schedules sit outside the budget split.
- **When a slice runs out, it holds.** That arc's plans stay parked until next week or until you re-slice. There is no borrowing and in-flight work is never cancelled. If every slice is held while subscription quota would go unused, the accountant sends you one "re-slice?" message, at most daily.
- **Campaign caps** from `--budget-tokens` sit inside an arc's slice. A campaign needs budget left on both its own cap and its arc, and its spend counts once against both.
- **Weekly engagement:** a schedule posts a dated accountant job on Saturdays at 09:00 Pacific, 12 hours after the weekly reset. The job:
  1. Carries last week's split forward, so the fleet is never without a budget.
  2. Builds a statement from a script: pool pace, and per-arc slice, spend, held plans and overshoot.
  3. Proposes a new split and sends it to your inbox.
  4. Applies your reply. The reply format is simple lines like `total 120M`, `<arc> 50%`, `new …`, `retire …` or `keep`. With no reply, last week's split stays in force.

  Mid-week, saying **apportion** or **re-slice** to the liaison gets your words to the accountant.
- **Scope:** this only adds a layer on top of the existing admission and pacing controls, and it can only narrow what those allow. Metering and the pool configuration are unchanged.

**Role changes**
- **New `roles/accountant/AGENT.md`:** it is the only writer of `config/apportionment`, `config/arc-budgets/*` and `config/foreman-mandate`, always in one commit, and it takes over the unknown-quota rule.
- **Liaison:** those responsibilities now point to the accountant. It still never throttles up an unknown quota, it routes apportion/re-slice to the accountant, and at muster it archives budget notices as covered by the weekly statement.
- **Foreman:** a new rule to draw only from arcs with budget left. It does nothing until the build lands.
- I also added `accountant` to the role list in `CLAUDE.md` and a short "Allocation (proposed)" section to `context/operations/cybernetics.md`.

**Next step**
I parked `build-accountant-arc-apportionment` in the plan queue behind a go-ahead gate, so it waits for your approval of the design. It covers everything in the design's build plan: the script changes, the `arc:` field, ranking, the weekly statement, the re-slice nudge, the schedule (not switched on until you approve) and tests.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-accountant-role-budget-apportionment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1466927 cached reads)
- Output: 19742 tokens
- Cost: $1.3597134
- Wall-clock: 251s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
