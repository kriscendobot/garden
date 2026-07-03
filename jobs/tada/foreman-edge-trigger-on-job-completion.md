Inbox empty. The work is complete.

---

## Completion report

**Job:** Foreman edge-trigger on gardener job completion (`kriskowal/garden`, `main2`).

**What I did**

1. **`scripts/jobs/common.sh` — added `foreman_kick()`** (right after `unit_ctl_bounded`). It routes through the existing `unit_ctl` indirection with `unit_ctl start --no-block garden-foreman.service`, so the call is non-blocking and `GARDEN_UNIT_CTL` mocks it in tests. All errors are swallowed (`|| true` + `>/dev/null 2>&1`) so a missing unit, absent systemd, or a follower host never fails or delays the completion; safe under `set -euo pipefail`. Honors `GARDEN_FOREMAN_EDGE_KICK` (default `1`; `0` disables). Commented the rationale for why frequent kicks are safe (leader-only `ExecCondition` skips a follower's tick cleanly; the foreman's own idle-detection + settle debounce + weekly token gate make a not-yet-due kick a cheap no-op).

2. **`scripts/jobs/complete-job.sh` — call it on success.** Added `foreman_kick` right after `log "completed '$base'"` and before `exit 0`, on the successful `commit_and_push` branch — the exact doin→tada→push completion edge.

3. **Kept the 5-minute timer backstop** (untouched) for the two cases the local edge can't cover: a follower gardener's completion (kicks only its own skipped foreman, not the leader's) and the last, board-draining completion whose post-settle pump has no further edge to re-fire.

4. **Tests:** new `scripts/jobs/test/foreman-edge-kick-test.sh` + `unit-ctl-log-stub.sh` (a logging `GARDEN_UNIT_CTL` mock). Asserts: (1) a successful completion invokes `unit_ctl start --no-block garden-foreman.service`; (2) `GARDEN_FOREMAN_EDGE_KICK=0` suppresses the kick entirely; (3) a failing `unit_ctl` (mock exits 1) does not fail the completion — the job still lands in `tada/` and `complete-job.sh` exits 0.

**Verification:** new test 7/7 green; `completion-signal-test.sh` 17/17 green; full `run-test.sh` suite exited 0; `bash -n` clean on all four touched/added files. (shellcheck isn't installed on this host, but the new test files are outside CI's shellcheck scope; CI's `bash -n` sweep covers them.)

**Optional §4 (pure-edge settle) — DEFERRED.** I did not add the one-shot `systemd-run --on-active=<remaining>s` self-arm. The task flagged it as touching the token-spending pump's control flow and to include it only if cleanly testable without expanding scope. The timer backstop already fires the delayed post-settle pump correctly; the tradeoff is only residual latency (up to one timer period) on the fully-idle post-settle case, which the maintainer directive explicitly accepted as backstop-covered. Left as a clean follow-up if that residual latency proves worth eliminating.

**Go-live note:** this ships to each host only at its next `deploy-garden.sh`. The current leader host (endolinbot2) is ~50 commits behind `main2`, so the edge trigger is inert there until it's next deployed.

**Push:** `24ed703ee` on `origin/main2` (first-attempt CAS, no PR per garden convention).
