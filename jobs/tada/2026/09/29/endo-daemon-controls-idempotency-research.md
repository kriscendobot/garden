I wrote the research note, opened it as a draft design PR, posted follow-up build jobs, and commented on minion.town#130 with the findings.

**The note:** `designs/daemon-lifecycle-idempotency.md` in endojs/endo-but-for-bots, opened as draft PR https://github.com/endojs/endo-but-for-bots/pull/1383. The PR goes from branch `design/daemon-lifecycle-idempotency` into a frozen base, `llm-7ff30af`, which I created. It also adds a row to the `designs/README.md` index. Nothing was built or tested; it is documentation only (Prettier passes).

**What causes the two workarounds, from reading the code on `llm`:**
- **`endo start` damages a daemon that is still booting.** It runs `clean()` without checking whether a daemon is live, which deletes the booting daemon's socket, lock marker and `endo.pid`, then spawns a second daemon. That second daemon hits `EADDRINUSE` on `:8920`. Client commands that auto-start after a failed connect go through the same path.
- **A duplicate daemon kills the running one's workers.** At startup, the daemon SIGKILLs every pid in the worker pid files before it claims the single-instance lock.
- **`endo run-daemon` does not run the daemon in-process.** It runs it as a child process and does not pass signals on. The existing check that makes a process exit when its parent dies is only switched on in tests.
- **Exit codes don't reach the shell.** `bin/endo.cjs` throws away the exit code that `main()` returns.
- **Likely cause of the `:8920` orphan (minion.town#137):** the deploy script's `endo list` probe auto-starts a daemon inside the `sudo` session rather than the systemd unit, so `systemctl stop` never kills it. This is unconfirmed; checking `/proc/<pid>/cgroup` the next time it happens would settle it.
- **Usable today with no upstream change:** `endo ping` does not auto-start and exits non-zero when the daemon is down. Using it as the health probe makes minion.town's `[ -S endo.sock ]` guard unnecessary.

**Proposed changes, ranked:**
1. `start` does nothing when a daemon is already live.
2. The single-instance lock is claimed before any destructive startup step, and a losing duplicate exits 69.
3. An `ENDO_NO_AUTOSTART` setting for client commands.
4. Processes exit when their parent dies by default, and `run-daemon` passes signals on.
5. `stop` finds every recorded process and exits 0 when nothing is running.
6. A documented set of exit codes.
7. Optionally, `Type=notify` readiness for systemd.

The note includes a table showing which change lets minion.town delete each workaround, and three open questions for the maintainer.

**Follow-up jobs:**
- Posted to the board: `endo-daemon-idempotent-start-build`, a builder job for changes 1–2.
- Parked until the maintainer answers the open questions on #1383:
  - `endo-cli-no-autostart-exit-codes-build` (changes 3 and 6)
  - `endo-daemon-orphan-safe-stop-build` (changes 4–5)

**Report-back:** https://github.com/kriscendobot/minion.town/pull/130#issuecomment-5900543531

**Suggested follow-up:** minion.town could switch its health probe from `endo list` to `endo ping` right away. I mentioned this in the comment but did not post a job for it; that is the maintainer's call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-controls-idempotency-research.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2421944 cached reads)
- Output: 22934 tokens
- Cost: $1.7450448000000003
- Wall-clock: 318s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
