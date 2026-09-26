The job is complete.

## Completion report

**Job:** `improve-mentor-empty-output-transient-classification` — fix `scripts/jobs/mentor.sh`'s improve-handler branch mis-classifying an empty-output handler kill as a real defect.

**Root cause confirmed:** The failure arm classified transient only via `is_transient_claude_signature`/`_fetch_stderr_is_offline`, both of which require *signature text*. An empty-output non-zero exit (a `claude -p` handler SIGKILLed/OOM-killed at rc=137/143, or cut mid-call by a quota/network blip) leaves `$capture` empty, matches neither, and fell through to `die` (exit 1) — marking `garden-mentor.service` Failed and firing `self-heal-run.sh` into a diagnosis that fails identically in the same outage (the observed 30-min FATAL loop on endolinbot, 2026-07-05 18:20/18:50/19:20).

**What I changed (`scripts/jobs/mentor.sh`):**
- Capture the handler's exit code immediately into `$rc` under a `set +e`/`set -e` bracket (mirroring `gardener.sh:376-381`) — the bare `if "$HANDLER"…` gave no `rc`, and a plain `; rc=$?` would trip `set -e` on the non-zero exit before the classifier ran; and `$?` would have been clobbered by the later `out="$(…)"` substitution anyway.
- Added an empty-capture-transient branch mirroring `gardener.sh:679-687`: when `[ ! -s "$capture" ] && is_transient_empty_failure "$rc"` (the shared `common.sh` helper: rc 143/130/137/offline-75), WARN + `exit 0`, leaving `$SEEN`/`$JSINCE` unadvanced so the next tick retries — instead of die. The `die → self-heal` path is now reserved for a non-empty or non-transient real defect.

**Tests (`scripts/jobs/test/run-test.sh`, SUBTEST 11):** Added a regression case — an rc=137 empty-output kill must yield exit 0 with markers unadvanced — alongside the existing transient/real cases.

**Verification:** `bash -n` + shellcheck clean (only pre-existing unrelated notes). Ran a focused harness reproducing SUBTEST 11's setup on an exec-capable filesystem (the suite's `/tmp` is `noexec` here, so I hosted fixtures under `/home/kris`): all four scenarios pass — error→improvement-job, transient-signature→exit 0, real-defect→die, and the new empty-kill rc=137→exit 0.

**Commit/push:** `abdcbb867`, pushed cleanly to `origin/main2` on the first attempt.

**Follow-ups:** None. The fix reuses the existing `is_transient_empty_failure` helper, so the mentor and gardener handlers now share one transient-vs-real classification and won't drift.
