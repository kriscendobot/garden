# Skill: pty-context-introspection

## Purpose

Read back the **live context-window figure** of a gardener session that is running under
the experimental **pty lane** (`lane: pty`). Claude Code hands a session's runtime a real
context-window measurement in exactly one place — the JSON it pipes to the `statusLine`
command — and that channel exists only in an interactive TUI, never under `claude -p`. The
pty lane encloses the session in a pseudo-terminal so the status line fires, and its
`statusLine` script persists the figure to a per-job state file. This skill is the
**consumer**: how a gardener (or a hook) reads *its own* lane's figure to reason about how
much context it has left.

This is a narrow, read-only capability. It does not start, configure, or require the lane —
it only reads what the lane wrote. If the lane is off (the common case — the lane is opt-in
and defaults off), the reader reports the figure ABSENT, which is the correct answer.

## Inputs

- `GARDEN_JOB_BASE` — the job base, exported through the worker spine; the lane discriminator
  that keys the per-job state file. A reader may also pass the base explicitly.
- `GARDEN_STATE` — where the state file lives (`$GARDEN_STATE/pty-context/<base>.env`).
- `GARDEN_PTY_CONTEXT_MAX_AGE` (optional, default 120s) — the freshness window.

## Procedure

Run the reader (`scripts/jobs/pty-context-read.sh`), which resolves the state file for this
job, proves it is fresh, and prints it:

```sh
# whole record (env lines), exit 0 if fresh
scripts/jobs/pty-context-read.sh                      # base from $GARDEN_JOB_BASE
scripts/jobs/pty-context-read.sh my-job-base          # explicit base
scripts/jobs/pty-context-read.sh --format percent     # just the used_percentage integer
scripts/jobs/pty-context-read.sh --format json        # one JSON object
```

Branch on the **exit code** — this is the whole contract:

| exit | meaning | what to do |
| --- | --- | --- |
| `0` | a FRESH figure was found | trust and use it |
| `2` | no state file | the lane is off, or the status line has not fired yet — treat the figure as **absent** |
| `3` | a state file exists but is STALE (older than the window) or owned by a different session | **do not trust it** — treat as absent |

The reader **refuses to hand back a figure it cannot prove is fresh** (requirement: a reader
that cannot prove freshness treats the figure as absent rather than trusting it). A leftover
file from a session that ended yesterday exits `3`, never `0`.

Example — a gardener nudging itself to wrap up when context runs high:

```sh
pct="$(scripts/jobs/pty-context-read.sh --format percent 2>/dev/null || true)"
if [ -n "$pct" ] && [ "$pct" -ge 80 ] 2>/dev/null; then
  echo "context at ${pct}% — checkpoint work and post a follow-up before compaction"
fi
```

## Output shape

The state file / `env` format carries at least:

```
job_base=<base>              # owner; must match the requester
session_id=<uuid>            # the Claude session that wrote it
epoch=<unix seconds>         # last status refresh — the freshness clock
iso=<UTC ISO-8601>           # human-readable timestamp
used_percentage=<n|blank>    # context window used; blank/null on a near-empty session
remaining_percentage=<n|blank>
input_tokens=<n>
output_tokens=<n>
context_window_size=<n>      # e.g. 1000000
model=<display name>
```

`--format percent` prints only `used_percentage`; `--format json` emits one object and adds
`age_seconds`.

## Notes / caveats

- `used_percentage` is blank/`null` on the first status refresh of a session (the status
  line fires at session start, before the turn's tokens are accounted). A high value only
  appears once the session has consumed real context — which is exactly when the figure is
  worth reading.
- The figure is only present for jobs that opted into `lane: pty`. This is experimental; see
  `designs/pty-context-introspection-lane.md` for the mechanism, the gates, and the honest
  limitations.
- The per-job file is pruned on job completion by the lane's handler; a reader must still
  treat an unexpectedly-present file as stale-until-proven-fresh (the exit-3 path), never as
  authoritative just because it exists.
