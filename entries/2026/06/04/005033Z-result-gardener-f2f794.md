---
ts: 2026-06-04T00:50:33Z
kind: result
role: gardener
host: endolinbot
to: liaison
---

# Result: driver lanes generalized to role-prefixed; gardener + librarian workflows landed

## Maintainer directive (2026-06-04)

> Currently, the driver is focused on building, designing, and fixing
> PRs. We have a number of other roles that would benefit from
> deterministic dispatch and message queue handling. These include the
> gardener and librarian. ... Let's take the next steps in driver
> design, multiplexing the inboxes and journal worktrees, so we have
> room to grow. Concretely, let's add one lane for a gardner and one
> lane for a librarian. These should have an adjustable pace and
> respond to messages. We can continue to have one-off versions of
> these in interactive mode, but always one ready to respond, to
> receive messages from other lanes, and to be dispatched from a
> steward.

## What landed on origin/main (commit f3f0e325, 6 files, +247/-12)

- designs/driver.md: new "Role-prefixed lanes" section under
  Architecture; multi-job-kind list extended with gardener-task /
  librarian-task; workflow list extended with the two new lane
  workflows.
- skills/driver-gardener-workflow/SKILL.md (new): gardener lane state
  machine; five engagement shapes (encode-proposed-rule, library-gap,
  role-file-scrub, inventory-drift, routine-meta-edit); per-engagement
  budget 1-5 minutes.
- skills/driver-librarian-workflow/SKILL.md (new): librarian lane
  state machine; five engagement shapes (ingest-source, grow-shortcut,
  prune-concept, draft-missing-concept, library-audit); per-engagement
  budget 2-10 minutes, library-audit budget 1 hour with checkpoint
  discipline.
- scripts/daemons/config.sh.example: GARDEN_DRIVER_LANES default
  extended to (gardener-1 librarian-1 builder-1 builder-2).
- scripts/driver/README.md: lane identifier generalized; lane caps
  documented.
- CLAUDE.md: skills inventory extended.

## What landed on origin/journal (this commit)

- journal/drivers/README.md: state file schema extended with role:,
  cadence_seconds:, paused:, paused_at: fields and field semantics.
  Stale roles/driver/ path link corrected to scripts/driver/.

## Out of scope (queued for builder dispatch)

- scripts/driver/driver.sh role-prefix parsing, workflow-skill load by
  role, per-lane cadence_seconds reading, paused: flag short-circuit.
- scripts/daemons/start.sh lane-cap enforcement (gardener=1,
  librarian=2 initially).

The skills are the contracts; the implementation is the next builder
dispatch. The builder reads designs/driver.md § Role-prefixed lanes,
the two workflow skills, journal/drivers/README.md, the existing
scripts/driver/driver.sh, and scripts/daemons/start.sh, then extends
the script to honor the role prefix and the new state-file fields.

Self-improvement: skills/driver-gardener-workflow/SKILL.md (new),
skills/driver-librarian-workflow/SKILL.md (new), designs/driver.md,
scripts/daemons/config.sh.example, scripts/driver/README.md,
CLAUDE.md, journal/drivers/README.md. The driver design now admits
non-PR roles via role-prefixed lanes; the gardener and librarian
lane contracts are landed; the daemon-script + driver-script
implementation is the next builder dispatch.
