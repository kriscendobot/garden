---
created: 2026-06-02
updated: 2026-06-04
author: builder, gardener
---

# scripts/driver

The driver is a bash script that drives a state machine and delegates
judgment-bearing substeps to ephemeral subagents. It is the
script-side counterpart to the agent-context library under `roles/`
and `skills/`; the driver is not a role, it is a program a human or a
systemd unit runs.

This directory holds the executable (`driver.sh`) plus this README.
The state machines the driver consults at runtime live as agent
context under `skills/driver-<kind>-state-machine/SKILL.md`; the
driver reads them on the LLM-substep paths only. Most of the
driver's loop is deterministic bash that does not consult a skill.

See [`designs/driver.md`](../../designs/driver.md) for the design
rationale and the full picture of how drivers, watchers, and the
job board fit together.

## Launching a lane manually

```sh
scripts/driver/driver.sh <lane>
```

`<lane>` is either a bare positive integer (legacy PR-work lane,
treated as `builder-<n>` for backward compatibility) or `<role>-<N>`
(role-prefixed lane per `designs/driver.md` § Role-prefixed lanes;
recommended). Two drivers on the same host must use different lane
identifiers. The lane identifier discriminates:

- the per-lane state file at
  `journal/drivers/<host>/<lane>.md` (carries `role:`,
  `cadence_seconds:`, and `paused:` fields in addition to the PR-
  state fields documented in `journal/drivers/README.md`);
- the per-lane subscription advertisement at
  `journal/drivers/<host>/<lane>.subscriptions`;
- the per-lane self-improvement log at
  `journal/drivers/<host>/<lane>.improvements.md`;
- the role-specific job board the lane scans
  (`journal/jobs/<role>/open/`);
- the role-specific inbox the lane drains
  (`journal/inboxes/<host>/<role>.md` via
  `skills/inbox-drain/inbox-drain.sh <role>`);
- the workflow skill the driver loads
  (`skills/driver-<role>-workflow/SKILL.md` for non-PR lanes;
  `skills/driver-<kind>-state-machine/SKILL.md` for PR-work lanes
  per the job's `kind:` field);
- gardener-inbox messages on unexpected failure (each message names
  the lane in its section header);
- journal entries the driver writes (so per-lane filtering by
  `grep '^lane: <lane>'` works).

Lane caps enforced by `scripts/daemons/start.sh`:
- `gardener-N`: at most 1 lane per host. Attempting to launch
  `gardener-2` is refused.
- `librarian-N`: at most 2 lanes per host initially. Editable in the
  daemons-script's lane registry.
- `builder-N`, `fixer-N`, `weaver-N`: no hard cap; host CPU governs.

The script behaves identically whether launched by hand or by
systemd; only the supervisor changes.

## Environment variables

| Name                 | Default                                       | Purpose                                                  |
| -------------------- | --------------------------------------------- | -------------------------------------------------------- |
| `GARDEN_ROOT`        | script-location-relative grandparent          | the garden checkout the driver operates against          |
| `GARDEN_JOURNAL`     | `$GARDEN_ROOT/journal`                        | the journal worktree                                     |
| `GARDEN_HOST`        | `$(hostname -s)`                              | the host's logical name for per-host paths               |
| `DRIVER_WORKFLOW`    | inferred from `DRIVER_PR` or the claimed job  | the workflow state machine to load                       |
| `DRIVER_PR`          | unset                                         | optional `<owner>/<repo>#<n>` the driver subscribes to   |
| `DRIVER_TICK_SECONDS`| `30`                                          | poll cadence in seconds                                  |
| `DRIVER_ONESHOT`     | `0`                                           | when `1`, the driver runs one tick and exits             |

Test-harness overrides (`GH_STUB`, `POST_JOB_STUB`, `UN_DRAFT_STUB`,
`CLAUDE_ESCALATE_STUB`, `SELF_IMPROVE_CLAUDE_STUB`, `SELF_IMPROVE_SYNC`)
are documented in `tests/driver/lib/mock-garden.sh`. They are not used
in production.

## Systemd integration

A maintainer who wants the driver supervised by systemd drops the
templated unit file at `scripts/systemd/garden-driver@.service` into
`~/.config/systemd/user/`, then enables and starts the desired
lanes:

```sh
systemctl --user daemon-reload
systemctl --user enable garden-driver@1.service garden-driver@2.service
systemctl --user start  garden-driver@1.service garden-driver@2.service
```

The unit's `WorkingDirectory=%h` points at the bot's home (the garden
root). The script is invoked as `%h/scripts/driver/driver.sh %i`,
where `%i` is the lane number from the unit instance.

`scripts/daemons/start.sh`, `stop.sh`, `status.sh`, and `logs.sh`
wrap the `systemctl --user` calls so the maintainer does not have
to remember unit names. See [`scripts/daemons/README.md`](../daemons/README.md).

## Per-lane state file

Every tick the driver re-writes
`journal/drivers/<host>/<lane>.md` so the maintainer (or the next
driver instance after a restart) can read the lane's current state:

```yaml
---
host: <hostname>
lane: <n>
workflow: <workflow-kind>
pr: <owner>/<repo>#<n>          # or (none) when unsubscribed
state: <state-name>
awaits: <role>:<job-slug>       # or null when none
last_tick: <ISO timestamp>
---

<one paragraph of human-readable context>
```

The per-lane subscription file at
`journal/drivers/<host>/<lane>.subscriptions` lists the PRs the lane
is subscribed to (one per line). The per-feed activity watcher (in
later phases) reads the union across all lanes' subscription files
to know which PRs to fan events to.

## Transcripts and failure capture

The driver's main loop wraps each tick in a `( set -x; run_once )`
subshell whose stdout+stderr lands in a per-tick capture file. After
each tick the driver:

1. Hashes the capture into the journal's git object database via
   `git -C "$GARDEN_JOURNAL" hash-object -w --stdin`. The blob is
   unreferenced; `git gc` collects it after the journal's grace
   window unless an agent or operator anchors it via
   `refs/captures/...`.
2. Invokes an agent (`claude -p`) with a four-slot brief that names
   the transcript SHA so the agent can read the transcript on demand
   via `git -C "$GARDEN_JOURNAL" cat-file blob <sha>`.
3. Appends the agent's analysis to the per-lane improvements file at
   `journal/drivers/<host>/<lane>.improvements.md`.

The analyzer runs in the background by default so it never blocks the
next tick. Test runs set `SELF_IMPROVE_SYNC=1` so assertions can
observe the file before the harness returns.

On an unexpected exit (non-zero return that was not the workflow
reaching a terminal state), the driver's `EXIT` trap:

1. Hashes the running transcript into the journal as a blob.
2. Appends a section to `journal/inboxes/<host>/gardener.md` naming
   the lane, the PR (if any), the state, the transcript SHA, and a
   one-paragraph context.
3. Exits non-zero. Under systemd the unit restarts after the backoff
   window. Under ad-hoc invocation the maintainer's shell sees the
   failure code.

The capture-by-SHA pattern means identical failure transcripts hash
to identical blobs; the gardener's triage can short-circuit on a
known SHA.

## What the driver does *not* do

- Push to a PR branch directly. Source pushes are the role-specific
  workers' job (builder, fixer, weaver, conductor). The driver
  dispatches them and watches for their result entries.
- Open a PR. The builder does that. The driver claims a
  `pr-creation` job after the builder lands the DRAFT.
- Switch identity. The driver runs as the bot identity, like every
  other non-boatman role. The boatman exception is unchanged.

See [`designs/driver.md`](../../designs/driver.md) § Non-goals for
the full list.
