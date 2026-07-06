Inbox is empty. Work complete.

## Completion report

**Job:** `improve-scaler-nonblocking-systemctl` — stop the scaler's blocking `--now`/`restart` calls from being SIGKILLed by the `unit_ctl_bounded` bound.

**What I did**

Fixed all three state-mutating paths in `scripts/jobs/install-units.sh` to split the fast synchronous file op from the slow start/stop job, so no call blocks on the gardener's `claude -p` draining:

- **`scale()`** — `unit_ctl_bounded enable --now` → `unit_ctl enable` (unbounded, cheap symlink write) + `unit_ctl_bounded start --no-block`; `unit_ctl_bounded disable --now` → `unit_ctl disable` + `unit_ctl_bounded stop --no-block`.
- **`reconcile_identity()`** — `unit_ctl_bounded restart` → `unit_ctl_bounded restart --no-block`.
- **`enable_services()`** — `unit_ctl_bounded enable --now` → `unit_ctl enable` + `unit_ctl_bounded start --no-block` (failure keys on the persistent `enable`, which drift-verify checks; a hung `start` only WARNs).

`--no-block` returns as soon as the job is enqueued, so each call finishes well under the 5s bound and the SIGKILL storm ends. The `unit_ctl_bounded` wrapper survives as a backstop for a genuinely wedged manager; `common.sh`'s `unit_ctl_bounded` is untouched, as the spec noted. The `gardener_busy` mid-job deferral guard is unchanged. Updated all `scale_skip_note`/comment wording that described `--now`/blocking semantics.

**Tests updated & passing**

- `test/mock-systemctl.sh` — hang injection now covers only the manager-talking (bounded) verbs (`restart/start/stop/show`); the cheap `enable`/`disable` file ops are deliberately not hangable.
- `test/enable-services-test.sh` — SCALE and SCALE-TIMEOUT now assert `disable` + `stop --no-block` (the hung-call test targets the bounded `stop`). **30 passed, 0 failed.**
- `test/run-test.sh` — reconcile subtest asserts `restart --no-block`. Reconcile assertion now passes.
- `test/deploy-garden-test.sh` — **63 passed, 0 failed** (prune_retired's `disable --now` is unbounded plain `unit_ctl`, out of scope, unchanged).

**Note / follow-up (unrelated to this job):** `run-test.sh` subtest 6 (MAINTAINER CHANNEL) aborts under `set -e` on a `[maintainer-reply] FATAL: … has no reply_to` before printing RESULT. I confirmed this is **pre-existing** — it reproduces identically on the base commit with my changes stashed — so it is not caused by this work, but it does mean run-test never reaches its final RESULT line. Worth a separate look.

**Committed & pushed:** `b8691a228` rebased onto latest `origin/main2` → pushed as `0fe25c6e9` to `main2`.
