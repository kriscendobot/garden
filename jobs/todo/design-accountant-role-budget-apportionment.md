---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: carve an accountant role out of budgeting responsibilities scattered across the liaison and other roles

Maintainer directive (kriskowal, 2026-09-30, liaison session): "It occurs to
me that we should probably carve an accountant role out of the liaison's and
other roles' skills and responsibilities regarding budgeting tokens. We are
becoming increasingly sophisticated with using a budget as a control
surface. We should have a weekly engagement, triggered by a scheduled
message to the maintainer, inviting the maintainer to adjust the token
budget for the foreman going forward, such that the pie gets sliced and
apportioned to various arcs the foreman can draw from to make progress on
prioritized work in the planned jobs."

## Survey first: what budget responsibility already exists, and where

Before proposing anything new, inventory what's already scattered across the
codebase so the carve-out is a genuine consolidation, not a duplicate
posture:

- `context/operations/cybernetics.md` (the current operator map) and its
  grounding designs `designs/cybernetics-audit.md` and
  `designs/cybernetics-economic-resilience.md`.
- `config/budget-pools` / `config/subscription-mapping` (journal-tracked
  budget configuration) and `scripts/jobs/usage-meter.sh`.
- `skills/model-selection/SKILL.md` (role-to-tier resolution, which is
  budget-adjacent).
- The foreman's own budget-awareness: `GARDEN_FOREMAN_ACTIVE_TARGET`,
  `GARDEN_TOKEN_BACKOFF_FRACTION`, `brake-foreman.sh`, and how
  `defer-doomed-plan.sh` / the `go-ahead` budget-hold gate
  (`--budget-hold`, `budget-refresh.sh`) already tie job promotion to budget
  state.
- The orchestration skill's `--budget-tokens` mechanism
  (`skills/orchestration/SKILL.md` § the budget accounting it already does
  per-campcampaign) — this is the closest existing precedent for "a bounded
  pie a scheduler draws down against," just scoped to one orchestration
  rather than the whole foreman.
- Where the **liaison** currently touches budget: `roles/liaison/AGENT.md`'s
  subscription/budget awareness (the "do not throttle it up or describe it
  as renewable" norm and its neighboring guidance), and any muster/dispose
  handling of `budget-level`/`budget-zone` watchdog notices (this session's
  own muster handled several of these by hand).
- Any other role that currently carries ad-hoc budget logic worth folding
  in (check `roles/foreman/AGENT.md` if one exists, `roles/mentor/AGENT.md`,
  and the scripted `scripts/jobs/gardening/` state machine for budget checks
  it performs inline).
- The **existing "arc" concept**, if it's still live: prior review work
  tracked named arcs via a press schedule + a `kriskowal/garden` tracker
  issue per arc, fed by a daily status job. Determine whether that concept
  is still active, retired, or worth reviving/generalizing as the unit this
  design apportions budget to — don't invent a competing "arc" vocabulary
  if a working one already exists nearby.

## What the design must specify

1. **The accountant role** (`roles/accountant/AGENT.md`, per `CLAUDE.md` §
   Adding a role: purpose, skills, operating norms, definition of done).
   Scope it narrowly around budget/token-economics responsibility — reading
   spend state, proposing allocations, running the weekly engagement — not
   as a dumping ground for every fleet-health concern. Name exactly which
   responsibilities move OUT of the liaison (and any other role) and into
   this new role, and update those roles' files to remove what moved.
2. **The weekly engagement.** A recurring cadence (via
   `skills/schedule/SKILL.md`, matching how other recurring garden work is
   scheduled) that sends the maintainer a message — not a board job, an
   inbox message the maintainer can act on interactively — inviting them to
   adjust the foreman's token budget for the coming week. Specify exactly
   what that message contains: current spend/pace against the prior
   allocation, the proposed slate of arcs competing for budget and their
   current draw, and a clear way for the maintainer to respond (reply
   format, or a liaison-mediated conversation like the muster pattern).
3. **The arc-apportionment model.** Define what an "arc" is precisely
   enough to be a real budget-allocation unit (a named priority thread of
   planned work — reconcile with the existing arc/tracker-issue concept if
   it's still live), how the foreman draws against a per-arc slice rather
   than one undifferentiated pool, what happens when an arc's slice is
   exhausted before the week ends (hold, borrow, or stop — pick one and
   justify it), and how this composes with the existing per-orchestration
   `--budget-tokens` mechanism rather than duplicating it.
4. **Interaction with existing budget machinery.** State plainly how this
   layers on `config/budget-pools`, the foreman's active-target brake, and
   the go-ahead budget-hold gate — this is a new allocation/priority layer
   on top of the existing admission/pacing layer, not a replacement for it.

## Non-goals

Do not redesign the underlying subscription-accounting/admission mechanics
(`usage-meter.sh`, the pool/mapping config) — those stay as-is; this design
is about who decides and communicates the allocation, and how it's sliced
across prioritized work, not how spend is metered.
