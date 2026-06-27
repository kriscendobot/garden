Inbox empty. Work is complete.

---

## Completion report — `improve-warn-fatal-syslog-priority-prefix`

**What I did**

Fixed `scripts/jobs/common.sh`'s `log()` (and therefore `die()`, which routes through it) to emit a leading systemd syslog-level prefix on the stderr line so journald classifies each line at the right priority and a `journalctl -p warning` failure-tail capture stops dropping the very lines that diagnose an outage.

**What changed**

- `scripts/jobs/common.sh` — `log()` now prefixes the stderr line by message class: `<3>` (err) for `FATAL`, `<4>` (warning) for a line beginning `WARN`, `<6>` (info) otherwise. systemd's `SyslogLevelPrefix` honors `<N>` by default for `Type=exec`/`simple` units, so warnings/errors now survive a priority-filtered capture. The prefix is **stripped when stderr is a TTY** (`[ -t 2 ]`) so interactive runs stay clean; it only appears when stderr is the journal or a pipe. `die()` is unchanged in behavior — still `log "FATAL: …"; exit 1`.
- `scripts/jobs/test/log-syslog-prefix-test.sh` (new) — regression guard asserting the three non-TTY prefix classes, `die()`'s `<3>` line + exit 1, and the TTY-strip (via a `script`-allocated pty, skipped cleanly if `script` is absent). 6/6 pass.

**Verification**

- Test passes both in-place and replayed on the clean base (6 passed, 0 failed).
- `bash -n` clean; sources cleanly; `shellcheck` shows no new findings (the pre-existing notes are in unrelated functions).
- Confirmed no consumer parses `log()` output expecting a leading timestamp, so the prefix can't break a downstream string-match.

**Landed**

Committed on a fresh worktree off `origin/main2` (per the concurrent-fleet-tree discipline), explicit pathspecs, pushed as `d12849df0` → `main2`. Worktree torn down; the shared `/home/kris` tree restored to clean HEAD so the watchman fast-forward isn't wedged by a stale local edit.

**Follow-ups**

- None required. Optional: the same priority-prefix idea could later be extended to any other fleet logger that writes raw stderr, but `common.sh`'s `log()`/`die()` is the single shared path the job board uses, so this covers the diagnostic surface the job targeted.
