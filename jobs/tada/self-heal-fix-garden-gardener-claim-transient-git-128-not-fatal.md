Inbox empty, worktree cleaned up, change pushed. Job complete.

---

**Completion report: `self-heal-fix-garden-gardener-claim-transient-git-128-not-fatal`**

Made the long-running gardener claim loop absorb transient connectivity outages instead of dying (exit 1 → systemd restart). Landed on `main2` as commit `bd65630d1` (pushed `f26a5e7a1..bd65630d1`).

**What changed (3 files):**
- `scripts/jobs/common.sh` `sync_clone()` — the offline classification previously guarded only `journal_fetch`'s rc; the subsequent `git reset --hard origin/journal2` ran bare under `set -e` and could exit 128 on a momentary network/ref blip, escaping classification. Wrapped the reset: on failure it re-fetches once and, if the re-fetch trips an offline signature (`_fetch_stderr_is_offline`), exits `GARDEN_OFFLINE_RC` (75) exactly like the fetch path; otherwise it re-attempts the reset (a genuine reset fault still surfaces).
- `scripts/jobs/gardener.sh` — added a transient-skip branch before `die "claim failed"`: `rc == GARDEN_OFFLINE_RC` (75) **or** `rc == 128` logs `claim transiently offline (rc=$rc); sleeping and retrying` and `sleep; continue`, mirroring the rc=3 idle branch. Only a genuinely unexpected rc still dies.
- `scripts/jobs/test/fetch-timeout-test.sh` — two new regression subtests: one drives a transient-128 from the **reset** path (stateful fake `git`) and asserts `sync_clone` exits 75; one runs the gardener loop end-to-end against an offline claim and asserts it does **not** exit 1. Whole suite: 10/10 pass. I separately verified each new test fails without its corresponding fix (true regression guards).

**Merge note (important):** While I worked, a peer agent (also endolinbot) landed a *complementary* fix `f26a5e7a1` — it wrapped the `journal_fetch`/`sync_clone` `rc=$?` assignments in `if` so the offline classification is reachable from bare `set -e` callers, and added its own gardener rc==75 skip branch + a "bare set -e caller" subtest. The rebase conflicted in `gardener.sh` and the test file. I reconciled rather than clobbered:
- `common.sh` auto-merged cleanly and now carries **both** fixes (their set-e wrappers + my reset-path guard).
- `gardener.sh`: kept their richer comment, **broadened their condition from `rc==75` only to `rc==75 || rc==128`** (the spec's belt-and-suspenders against a 128 that escapes classification), unified the log line.
- Test file: kept their "bare set -e caller" test as SUBTEST 5 and renumbered mine to SUBTEST 6 (reset path) and SUBTEST 7 (gardener loop).

**Follow-ups:** None required — the two fixes compose. Worth noting the fleet currently has multiple gardeners independently self-healing the same connectivity-outage class (this job, the peer's commit, and the recent `GARDEN_OFFLINE_SIGNATURES` factor-out); the territory is now well covered, but de-duplicating these near-simultaneous self-heal jobs at triage time would save redundant effort.
