---
created: 2026-09-30
updated: 2026-09-30
author: gardener (job build-accountant-arc-apportionment)
---

# The accountant's tools: weekly arc apportionment

Command reference for the [accountant](../../roles/accountant/AGENT.md). The
rationale is [designs/accountant-arc-apportionment.md](../../designs/accountant-arc-apportionment.md);
this page is only the how-to.

## State on the journal

- `config/apportionment`: the week as a whole (`week_start`, `total_tokens`,
  `planning_ceiling`, the ordered `slate`, `unallocated_tokens`, `authorized_by`,
  `message_id`, `carried_forward_from`).
- `config/arc-budgets/<arc>`: one schema-2 slice per slate arc plus
  `unallocated` (the reserve, ranked last). Schema 1 (rolling window, the
  Ironhorse press) is still read, and set-apportionment leaves it alone unless
  the slate names it.
- `config/foreman-mandate`: generated from the slate. Do not hand-edit it once
  an apportionment exists; the next slate overwrites it.

All three are written by one `set-apportionment.sh` commit.

## Commands

```sh
# Read-only numbers for the weekly statement (markdown on stdout).
scripts/jobs/accountant-statement.sh

# One arc's spend this window.
scripts/jobs/arc-spend.sh <arc>

# Roll last week's slate forward unchanged (first step of every weekly job).
scripts/jobs/set-apportionment.sh --carry-forward

# Apply a maintainer-approved slate. Preview with --dry-run first.
scripts/jobs/set-apportionment.sh --authorized-by <maintainer-login> \
  --message-id <inbox-message-id> [--dry-run] slate.json
```

`slate.json`: arc order is rank order. Amounts are integers, `800K` / `15M` /
`1.5G`, or `N%` of `total_tokens`. The remainder goes to `unallocated`, and a
slate that sums past the total is refused with the overage. A schema-2 arc left
off the slate is retired, and its plans stay parked.

```json
{"total_tokens": "120M",
 "planning_ceiling": 0.9,
 "notes": "Optional one-paragraph preamble for the mandate.",
 "arcs": [
   {"arc": "minion-town-capabilities", "tokens": "50%",
    "summary": "Run Claude remotely; minion.town as git origin",
    "tracker": "https://github.com/kriscendobot/garden/issues/NN"},
   {"arc": "endor-metering", "tokens": "15M", "summary": "Metered Endor VM"}
 ]}
```

`authorized_by` must be on `maintainers/allowlist`.

## Producers stamp arcs

- `post-plan.sh --arc <arc>` and `post-job.sh --arc <arc>` stamp `arc:`.
- `post-orchestration.sh --arc <arc>`: children inherit the arc when they are
  promoted. A serial child is held while the arc has no headroom.
- `post-gauntlet.sh --arc <arc>`: the stages inherit the arc. Auto-staged
  gauntlets take the producer job's arc.
- The foreman stamps the arc it drew from, using the `ARC` line in its reply.
  Unarced foreman-drawn work is charged to `unallocated` once the reserve is
  armed.
- `ratchet-arc:` is still read as an alias for `arc:`.

Before the first `set-apportionment.sh` there is no reserve, and nothing
changes: unarced work stays ungated, and the deferred selector keeps its old
order.

## Foreman behavior once armed

- Among ready deferred plans, the selector orders by arc `rank`, then leaf
  first, then priority and FIFO. A plan whose arc is exhausted is skipped with
  `arc-budget-over:<arc>`. A plan on a retired arc is skipped with
  `arc-retired:<arc>`.
- The digest carries an `arc_headroom:` block. A step naming an exhausted arc is
  refused (decision `arc-refused`).
- When every slice is held, the reserve included, the agent is not invoked
  (decision `arc-held`). `accountant-reslice-nudge.sh` then messages the
  maintainer once per held episode, at most daily, if the pools are below high
  water and the reset is within `GARDEN_RESLICE_NUDGE_RESET_WINDOW` (default
  72h). The latch is kept in `$GARDEN_STATE/accountant/`.

## The weekly schedule (NOT ARMED)

Arm it only once the maintainer approves the weekly engagement. The command
below is the intended schedule. Running it is the arming act.

```sh
GARDEN_SCHEDULE_HANDLER_TIMEOUT=14400 scripts/jobs/set-schedule.sh \
  accountant-weekly weekly-at-Sat-09:00-America/Los_Angeles accountant-weekly <<'BODY'
---
role: accountant
tier: mentor
---
# Weekly arc apportionment

Run the accountant's weekly engagement (roles/accountant/AGENT.md;
context/operations/accountant.md):
1. `scripts/jobs/set-apportionment.sh --carry-forward`.
2. Build the statement from `scripts/jobs/accountant-statement.sh`.
3. Propose next week's slate, and send statement + proposal with
   `scripts/jobs/message-user.sh <your-base>`.
4. Apply an unambiguous reply with `set-apportionment.sh --authorized-by
   <login> --message-id <id>`, confirm the resulting table, and complete. With
   no reply, complete with the carried-forward slate in force.
BODY
```
