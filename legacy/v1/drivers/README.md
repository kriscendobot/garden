# Drivers

Per-host, per-lane state files for the script-orchestrated drivers introduced by [`<garden-root>/designs/driver.md`](../<garden-root>/designs/driver.md).

Each driver is a bash process bound to one lane on one host.
The state file is the canonical record of where the lane currently is in the state machine.
A driver that crashes and is restarted reads the state file to resume.

The driver script that owns these files lives under [`<garden-root>/scripts/driver/driver.sh`](../<garden-root>/scripts/driver/driver.sh).

## Layout

```
journal/drivers/<host>/<lane>.md                # per-lane state file
journal/drivers/<host>/<lane>.subscriptions     # per-lane event-subscription manifest
journal/drivers/<host>/<lane>.improvements.md   # per-lane self-improvement log
```

- `<host>` is `hostname -s` of the host running the driver.
- `<lane>` is the lane identifier: either a bare positive integer (legacy PR-work lanes, treated as `builder-<n>` for backward compatibility) or `<role>-<N>` (role-prefixed lanes per `designs/driver.md` § Role-prefixed lanes, recommended for new lanes). Examples: `gardener-1`, `librarian-1`, `librarian-2`, `builder-1`, `builder-2`, `fixer-1`.

The state files are runtime artifacts, written by the driver on every transition.
No empty state file is committed; the host-named directory below this README is created on demand.

## State file: `<lane>.md`

YAML frontmatter plus a short, overwritten body.
The body is a live status, not a log; the journal's commit history is the audit trail.

```yaml
---
lane: builder-1                          # the supervisor's handle (bare integer or <role>-<N>)
role: builder                            # the role prefix parsed from the lane name
host: kmkmbp2021                         # hostname -s of the running driver's host
pr: kriskowal/garden#3                   # owner/name#N when bound to a PR; otherwise null
design: designs/driver.md                # design doc path (garden-relative) or null
state: panel                             # the state-machine state from the workflow skill
role_awaited: barrister                  # which role's worker the state awaits (null if none)
cadence_seconds: 30                      # per-lane adjustable pace; null falls through to the role default
paused: false                            # true skips the tick body without exiting the loop
paused_at: null                          # ISO UTC of the most recent pause; null if not paused
updated_at: 2026-05-29T18:42:11Z         # ISO UTC of the most recent transition
---

driver lane builder-1 on kmkmbp2021
role: builder
state: panel
bound to: kriskowal/garden#3
```

Fields:

- `lane`: matches the supervisor's positional argument exactly. Bare integer or `<role>-<N>`.
- `role`: the role prefix parsed from the lane name. For a bare-integer lane the role is `builder` (backward compatibility). For a `<role>-<N>` lane the role matches the prefix. Drives which workflow skill the driver loads (`skills/driver-<role>-workflow/SKILL.md` for non-PR lanes; `skills/driver-<kind>-state-machine/SKILL.md` for PR-work lanes per the claimed job's `kind:` field).
- `host`: identifies which host's supervisor owns the lane; cross-host coordination is the supervisor's job.
- `pr`: `owner/name#N`. Null when the lane is unbound (idle, waiting for the supervisor to bind it) or when the role is not PR-shaped (gardener, librarian).
- `design`: the design document the lane's PR descends from, relative to the garden root. Null for source-touching PRs without a design and for non-PR lanes.
- `state`: the most recent state the driver's state-machine ticked through. Names match `designs/driver.md` § The driver state machine for PR-work lanes; for gardener / librarian lanes the names match the workflow skill's state list (idle, draining-inbox, scanning-board, classifying, engaging, reporting, parked).
- `role_awaited`: when the state has dispatched a worker via the role-specific job board, the role of the worker. Null when no worker is in flight or the workflow does not dispatch subworkers.
- `cadence_seconds`: per-lane adjustable poll cadence in seconds. Null falls through to the role's default per `designs/driver.md` § Role-prefixed lanes (30s for PR-work; 180s for gardener; 300s for librarian). Editing this field on the state file changes the cadence at the next tick.
- `paused`: when true, the lane's tick body short-circuits without exiting the systemd service. Use this to quiesce a lane during an interactive engagement of the same role on the same host (the maintainer's standing practice when entering the gardener or librarian posture in an interactive `claude` session). Clear the flag (set to false) to resume; the next tick picks up where the lane left off.
- `paused_at`: ISO UTC of the most recent transition from `paused: false` to `paused: true`. Null when not paused.
- `updated_at`: UTC ISO 8601; updated on every transition so an observer can spot stuck lanes by `find . -mtime +1`.

The body's prose is duplicate human-readable context.
It exists so a maintainer who opens the file in a browser sees the gist without parsing frontmatter.

### Writers

- The driver script (`<garden-root>/scripts/driver/driver.sh`) rewrites the file on every state transition.
- A future supervisor may also write the file at bind time (`pr:` populated, `state:` set to `initial`) before launching the driver process for the first time.

### Readers

- The driver itself reads the file on startup to recover state after a crash.
- A maintainer or steward inspecting "what is lane 1 doing" reads the file.
- A future bulletin-board summarizer aggregates open state files into a section of `journal/README.md`.

## Subscriptions file: `<lane>.subscriptions`

The driver's event subscriptions: which GitHub webhooks, which standing-monitor daemon log lines, which scheduled re-checks the driver listens to.
The format is one line per subscription, with a short prefix naming the source.

```
gh-webhook pull_request:closed kriskowal/garden#3
gh-webhook pull_request_review:submitted kriskowal/garden#3
monitor-log /tmp/garden-monitor-garden.log "PR #3"
periodic 5m re-check
```

The subscriptions file is the driver's input contract.
A change of subscriptions (new event source, retired source, cadence change) is the supervisor's responsibility.

### Writers

- The supervisor writes the subscriptions file when launching the driver for the first time on a given PR.
- A re-bind (lane retired, new PR assigned) rewrites the subscriptions file.

### Readers

- The driver itself, on startup, to know which event sources to attach to.
- A future supervisor-side observer that aggregates "what each lane is listening for" into the bulletin board.

## Lifecycle

A lane goes through four broad phases over its lifetime:

1. **Unbound.** No state file yet. The supervisor decides the lane should bind to a PR.
2. **Bound, in flight.** The supervisor writes the state file with `pr:` set and launches the driver. The driver rewrites the state file on every transition until terminal.
3. **Terminal.** The state is `merged` (or a deliberate stop). The state file persists as the last-state record; the supervisor may retire the lane (re-bind to a new PR by overwriting the state file) or leave it dormant.
4. **Crash-recovery.** On any non-zero driver exit a section appears in `journal/inboxes/<host>/gardener.md` naming the lane, the state, and the transcript SHA. The gardener decides whether the next tick continues from the state file or whether a fix is needed before re-launch.

## Phase 1 boundary

Phase 1 lands the **schema** (this document) plus the driver's read/write contract.
No `journal/drivers/<host>/<lane>.md` files are committed: they are runtime artifacts.
The empty `<host>/` directories below this README are created on demand by the driver, not committed in advance.

Phase 2 lands the design-only driver flow; phase 3 the source-touching flow; phase 4 retires the steward's PR-creation-flow scan.
See `<garden-root>/designs/driver.md` § Migration plan.
