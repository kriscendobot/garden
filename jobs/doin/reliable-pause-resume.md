# Make liaison "pause" and "resume" reliable (codify scripts + role), from recent experience

Wear the **mentor** role. The liaison paused and resumed the fleet today; it worked
but was fragile in specific, observed ways. Turn pause/resume into **deterministic
scripts** the liaison invokes, and document them in the role. Infrastructure on
`main2` (bot identity; isolated worktree off `origin/main2`).

## What went wrong (fix each)

1. **Resume blocked ~2 minutes, twice.** `install-units.sh enable-services` (and a
   plain `systemctl start`) **hung on the long-running `garden-bulletin.service`**
   (a continuous loop, currently stuck "activating"). Resume must never block on a
   long-running service.
2. **A bash-ism broke pause under zsh.** The interactive shell is **zsh**, where
   `mapfile` does not exist — enumerating units that way failed. Scripts must not
   assume bash builtins in the operator's interactive shell; the scripts themselves
   should be portable `#!/bin/bash` and not rely on the caller's shell.
3. **Killed in-flight jobs were stranded as stale `doin` claims.** Pausing kills all
   local doers, but their claims sat in `jobs/doin/` until the reaper's **1h TTL**
   requeued them — so directives were silently "missed" for up to an hour (the #57
   comment-watcher build and the #57 port both stranded). Pause/resume must requeue
   **this host's** dead claims immediately, not wait for the reaper.
4. **Incomplete restore + no verification.** After resume, `mentor.timer` was
   inactive and the bulletin sat "activating"; nothing verified the end state.

## Build `scripts/jobs/pause.sh` and `scripts/jobs/resume.sh`

**`pause.sh`** — quiesce this host deterministically:
- Engage the killswitch (`touch "$GARDEN_KILLSWITCH"`) FIRST (so any tick that starts
  no-ops).
- Stop all `garden-*.timer` then all `garden-*.service` (gardeners, bulletin, etc.)
  — enumerate portably (no `mapfile`; use `systemctl --user list-units` piped to a
  `while read`, or glob patterns that the timer-stop already proved work). Tolerate a
  service that is slow to stop; do not hang.
- **Requeue this host's in-flight claims**: for each `jobs/doin/<base>.md` whose
  `host:` is this host, move it back to `jobs/todo/` (the reaper's requeue logic,
  applied immediately and scoped to this host so other hosts' claims are untouched).
- Verify: 0 active garden units, no stray `gardener.sh`/`claude -p`/`gh` processes;
  report the count of claims requeued.

**`resume.sh`** — bring this host back, in the right order, non-blocking:
- Remove the killswitch.
- **Requeue any remaining stale this-host `doin` claims** immediately (belt-and-
  suspenders; do not wait for the reaper TTL).
- Enable+start the supervisory **timers** (scheduler, repo-watcher, watchman, mentor,
  reaper, gardener-scaler) — confirm each reaches `active`.
- Start **long-running services** (the bulletin loop, gardeners) with
  **`systemctl --user start --no-block`** so resume never hangs on a loop that does
  not signal readiness.
- Restore the gardener pool to the host's declared count (`hosts/<host>` →
  `install-units.sh scale <N>` or the scaler) — non-blocking.
- **Verify the end state**: all expected timers active, gardener count == declared,
  bulletin process running, **no failed units**, and warn on any unit stuck
  `activating`. Report a concise health summary.

Both scripts: `killswitch`-aware, idempotent (re-running is safe), portable bash,
quiet on success, and they **scope claim requeues to this host**.

## Update the liaison role

In `roles/liaison/AGENT.md` (Operating norms / Operate local services), make
`scripts/jobs/pause.sh` and `scripts/jobs/resume.sh` the **canonical** pause/resume
procedure — "pause the garden" / "resume" map to these, not ad-hoc `systemctl`. Note
the multi-host scoping (a pause quiesces and requeues only the local host) and that
resume is non-blocking by design.

## Tests & verification

- A unit/integration test (mock `systemctl` via the existing `unit_ctl` indirection):
  pause engages the killswitch, stops units, and requeues this-host doin claims but
  not another host's; resume removes the killswitch, requeues, and reports health.
- `shellcheck`/`bash -n` clean. If feasible, dry-run pause+resume on this host and
  confirm no hang and a clean health summary.

## Definition of done

`pause.sh` + `resume.sh` built (deterministic, portable, non-blocking, this-host-
scoped claim requeue), the liaison role updated to reference them as canonical, tests
added — committed and pushed to `origin/main2` (bot identity). Report the SHA and the
dry-run health summary. Complements the separately-posted `fix-bulletin-unit-type`
(resume's `--no-block` makes it robust even before that lands). If blocked, report the
diagnosis and ready-to-apply content rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 44
  claimed_at: 2026-06-24T22:21:08Z
