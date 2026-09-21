Implemented systemd socket activation for `@endo/daemon` and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1325 at commit `3e08f01888`.

- Added strict `LISTEN_PID`/`LISTEN_FDS` validation, fd 3 listening, environment cleanup, and in-process `endo run-daemon` startup.
- Preserved socket locking, stale-path recovery, binding, and cleanup for non-activated launches.
- Added systemd user-unit documentation and a minor changeset.
- Added a real `systemd-socket-activate` integration test that launches `endo run-daemon`, accepts a connection through fd 3, and verifies PID mismatch fallback.
- Verification: all 8 socket-lifecycle tests passed, including 7 existing tests; daemon lint/types and deterministic pre-push probes passed. Deliberately changing fd 3 to fd 4 made the activation test fail with `EINVAL`, confirming regression coverage.
- The full daemon suite was not verified because unrelated daemon-backed tests exceed the Unix socket path limit in this long worktree and fail their existing post-bind check.
- PR remains draft; the current manual-trigger policy requires an explicit gauntlet request.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-daemon-systemd-socket-activation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4712s

<!-- garden-usage-end -->
