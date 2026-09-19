All work complete, inbox clear, no stray processes. Here's my report.

---

## Completion report — `fix-endo-daemon-test-process-leak-20260919`

Fixed both defects in `packages/daemon` on `endojs/endo-but-for-bots`, opened **draft PR endojs/endo-but-for-bots#1309** (head `bot/fix-daemon-test-process-leak`, base pinned at frozen `llm-dc05c16`).

### Defect 1 — serial guarantee was bypassable
- Root cause confirmed: `--serial` lived only in the `test` package script, so any caller invoking `ava` directly lost it and ava fanned test files across every CPU (each spawning a daemon). The observed `ava --config test/_ava-ses.config.js` is the `cover` script; that config file **does not exist anywhere in the repo**.
- Made serial the *resolved configuration*: added `"serial": true` + `"concurrency": 1` to the `ava` config in `package.json`. Empirically verified a directly-invoked `ava` now runs one test file at a time.
- Removed the dangling `--config test/_ava-ses.config.js` from `cover` (now shares the `test` config).

### Defect 2 — teardown / SIGTERM / respawn
New shared `src/shutdown-signals.js`, wired into `manager-node`, `worker-node`, `worker-node-with-shims`, and the rust-path `bus-manager-node` / `bus-worker-node-raw`:
- **Graceful-then-forced exit**: keeps the cancel, but force-exits after a bounded grace, so SIGTERM/SIGINT can no longer hang (the "ignored TERM" was the manager awaiting services that never stop). On force-exit the manager SIGKILLs its worker children so none reparent to init.
- **Workers now handle SIGTERM** (previously SIGINT-only).
- **Orphan-exit** under `ENDO_EXIT_WHEN_ORPHANED=1` (set in the ava config `environmentVariables`, propagating to every spawned daemon/worker): shuts down once reparented — stopping the self-sustaining orphan-respawn loop. The orphan signal is *parent-id changed from the launcher* (not `ppid==1`), because the incident's leaked daemons reparented to `systemd --user`, not pid 1. Production daemons don't set the flag, so their survival across launcher exit is unchanged.

### Verification
- New `test/daemon-teardown.test.js` (+ `_orphan-daemon-launcher.js` fixture), asserting on the exact pids spawned: `stop()` leaves nothing alive; a single SIGTERM tears the whole tree down without SIGKILL; an orphaned daemon self-terminates. **All 3 pass.**
- Confirmed the orphan test has teeth: it **fails when the orphan-exit fix is reverted**.
- `eslint` clean (0 errors); `tsc` (`lint:types`) passes. `@endo/daemon` is `private`, so no changeset.

### Follow-ups / notes
- The full existing suite was **not** run end-to-end here: this deep scratch-worktree path pushes the Unix-domain socket past the ~104-byte `sun_path` cap (environment artifact, unrelated to the change). The new tests use short sockets and exercise the full start/stop/restart/purge/`provideWorker`/SIGTERM/orphan lifecycle. Running the gauntlet (`run the gauntlet #1309`) on a normal-length checkout will exercise the whole suite.
- The dangling `--config test/_ava-ses.config.js` also appears in **many other packages'** `cover` scripts (ses-ava, compartment-mapper, module-source, where, trampoline, cjs-module-analyzer, …). I fixed only `daemon`'s per scope; a repo-wide `cover` cleanup is a reasonable separate follow-up.
- PR is draft per manual-gauntlet-trigger; maintainer promotes with **run the gauntlet #1309**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-daemon-test-process-leak-20260919.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 216 tokens (13808252 cached reads)
- Output: 91997 tokens
- Cost: $11.134455000000008
- Wall-clock: 1409s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
