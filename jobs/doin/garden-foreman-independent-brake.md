---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Give the foreman its own brake, independent of the fleet drain

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR.
Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

## Maintainer directive (2026-08-05)

> Decouple the foreman such that it has a separate throttle / threshold / brake
> from other worker activities. The garden-wide drain should remain in place for
> foreman, but it should be possible to resume work from gardener services
> without resuming the foreman.

So the required truth table is:

| fleet drain | foreman brake | gardeners claim? | foreman pumps? |
|---|---|---|---|
| on  | either | **no**  | **no** |
| off | on     | **yes** | **no** |
| off | off    | yes     | yes    |

The fleet drain keeps its current meaning and keeps stopping the foreman. The
new brake stops **only** the foreman.

## Why this is wanted

The foreman promotes `gate: deferred` plan jobs to a 5-active target every 5
minutes, and the maintainer's standing objection is that it *"generates work
that consumes from the budget without direction"* — it sets the garden's
priority order by queue position. `designs/omega-task-rank-and-foreman-retirement.md`
(Status: Proposed) plans its eventual split into a generative pump (to be
retired) and a deterministic rank-ordered promoter (to be kept).

Today the only lever is the fleet drain, which is all-or-nothing: silencing the
foreman also stops every gardener. That has actively blocked work — the
`garden-budget-attribution` chain had to be promoted **by hand, child by child**,
because the orchestrate watcher is leader-only and the leader had to stay drained
purely to keep the foreman quiet.

This job is the small mechanical step that unblocks that. It is **not** the
retirement; change no promotion logic, no rank ordering, no target.

## Current mechanism

- `fleet_draining()` — `common.sh:434` — `[ -e "$GARDEN_DRAINING_MARKER" ] || [ -e "$GARDEN_KILLSWITCH" ]`
- `foreman.sh:95` — `fleet_draining && exit 0`
- ~25 other call sites (watchers, `claim-job.sh`, `gardener.sh:279`, `orchestrate.sh:66`, `unblock.sh:50`, …) share the same predicate. **Leave every one of them alone.**
- `scripts/jobs/drain-fleet.sh on|off|status` manages the drain marker; the sysop
  carries a `drain` op so a remote host can be drained over the bus.

## The design question you must answer — host-local or journal-backed?

**The foreman is a leader-only singleton** (`ExecCondition=is-main-host.sh`). It
runs on whichever host the journal's `leader` marker names — currently
`endolin-garden2-5bcdff64`. That makes the storage choice load-bearing, not
cosmetic:

- **Host-local marker** (mirroring the drain, under `$GARDEN_STATE`): consistent
  with existing practice, needs a new sysop op to set remotely — and **if the
  leader marker moves, the brake is left behind on the old host and the new
  leader's foreman starts pumping immediately.**
- **Journal-backed flag** (e.g. `config/foreman-brake` on `journal2`): fleet
  policy expressed in fleet state, reachable by any issuer without a new op,
  follows the leader across a handoff, and is auditable in git history. Costs a
  journal read on the foreman's tick and must fail **safe** (an unreadable
  journal must not silently unbrake).

Pick one, implement it, and **state the reasoning in the design note and the
`tada/` report**. I lean journal-backed for the leader-handoff reason above, but
that is a lean, not an instruction — if the fail-safe semantics or the read cost
argue the other way, say so and choose differently.

## What to build

1. A predicate — e.g. `foreman_braked()` — that is true when the fleet drain is
   on **or** the foreman brake is set. `foreman.sh` calls that instead of
   `fleet_draining`. Nothing else changes its guard.
2. An operator CLI to set / clear / report the brake, mirroring `drain-fleet.sh`'s
   `on|off|status` shape and its habit of writing a human-readable reason into
   the marker.
3. If host-local: the corresponding **sysop op**, so the brake can be set on the
   leader from another host. It belongs in the **non-destructive** tier
   (`set-workers`/`drain`/`reset-failed`/`restore`), not the attested tier — it
   is reversible and cannot destroy state. If journal-backed: no new op needed;
   say so.
4. Documentation: a short section in `CLAUDE.md` § Job system or the operations
   context, and a line in `designs/omega-task-rank-and-foreman-retirement.md`
   recording that this landed as the mechanical precursor.

## Hazards

- **Do not widen the blast radius.** Exactly one call site changes
  (`foreman.sh:95`). Resist the temptation to generalize this into a per-service
  brake framework for all 25 sites — that is a bigger design and nobody asked
  for it.
- **Fail safe, both ways.** An unreadable brake state must not silently *unbrake*
  the foreman; and a brake that cannot be cleared is a wedge. Say which way you
  chose to fail and why.
- **The drain must keep working unchanged.** A drained fleet still stops the
  foreman even with no brake set — that is the first row of the table and the
  maintainer named it explicitly.
- **`is-main-host` gating is orthogonal.** Do not entangle the brake with leader
  election; a braked non-leader is simply a no-op.

## Regression coverage

Under `scripts/jobs/test/`, pin all four rows of the truth table — in particular:

- drain **off**, brake **on** → foreman exits, **and a gardener still claims**
  (this is the whole point; a test that only checks the foreman proves nothing)
- drain **on**, brake **off** → foreman still exits (no regression)
- brake set then cleared → foreman resumes
- brake state unreadable/corrupt → fails safe in the direction you documented

Follow the fleet's established stub patterns; do not write to the real journal
or the real `$GARDEN_STATE` from a test.

## Definition of done

Landed on `main2`; four truth-table cases green; existing suites still green; the
storage decision documented with its reasoning; and a `tada/` report naming what
takes effect on a deploy versus a units reconcile, and whether the leader host
needs anything beyond a normal deploy.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-05T14:56:10Z
