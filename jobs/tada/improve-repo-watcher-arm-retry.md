Done. Work complete and pushed to `main2` (commit landed on attempt 1).

## Completion report

**Job:** `improve-repo-watcher-arm-retry` — make `repo-watcher.sh`'s timer-arming robust against transient `systemctl`/`XDG_RUNTIME_DIR` hiccups instead of swallowing the failure into a bare per-tick WARN.

**What changed**
- `scripts/jobs/repo-watcher.sh`: Added `arm_timer()`, replacing the inline `unit_ctl enable --now … || log "WARN: could not arm …"`. It now:
  - Captures the `systemctl` **rc and stderr** (`2>&1 >/dev/null` into `$err`; `&& return 0` preserves the failed rc, which an `if …; then` would have reset to the if's own 0).
  - **Retries a bounded number of times within the tick** (`GARDEN_ARM_RETRIES=3`) with a short backoff (`GARDEN_ARM_RETRY_DELAY=2s`), so a one-off hiccup self-heals in the same cycle rather than leaving the ci-watcher/comment-watcher disarmed until the next full tick.
  - WARNs **once, with the rc+stderr**, only when the failure persists across every attempt.
- `scripts/jobs/test/mock-systemctl.sh`: Added `GARDEN_MOCK_FAIL_ENABLE_UNIT` / `_COUNT` / `_STATE` injection so the mock can fail `enable` for the first N attempts (transient) or every attempt (persistent), emitting a systemctl-shaped stderr diagnostic.
- `scripts/jobs/test/run-test.sh`: Added two case groups to SUBTEST 3 — transient failure retried-and-armed within the tick (asserts armed, rc+stderr logged, no persistent WARN), and persistent failure WARNs once after exhausting retries (asserts WARN with attempt count + rc/stderr, and that the arm was actually retried the bounded number of times).

**Bug caught in passing:** the first draft used `local prefix="$1" slug="$2" unit="$prefix@…"` — a single-`local` statement expands `$prefix` before it is assigned, which under `set -u` silently read the caller's `prefix` by dynamic scope. Split into two `local` lines.

**Verification:** Built a focused harness (real `repo-watcher.sh` + real mock against a throwaway `journal2` bare repo) — all 7 assertions pass: baseline arm, transient retried+armed, rc+stderr logged, no WARN on retry success, persistent WARN after retries, WARN carries rc+stderr, bounded attempt count. `shellcheck -x` clean on the added lines (remaining warnings are all pre-existing).

**Follow-ups:** none. The retry counts/delay are env-tunable (`GARDEN_ARM_RETRIES`/`GARDEN_ARM_RETRY_DELAY`) if a host needs a different bound. Note: the poison-postmortem's separate `endolinbot2` host-identity drift (`/home/kris/.garden` = `endolinbot2` vs. leader marker `endolinbot`) is out of scope for this job and left untouched.
