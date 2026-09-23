Done. Job complete.

## Completion report

**What the job asked:** Recurring scheduled fan-out drivers (e.g. hourly `endo-sturdyref-press`) structurally dead-letter every sub-job reply, because each tick is a fresh short-lived doer with a timestamped base whose inbox is torn down at completion. The old `deadmail.sh` salvaged these by promoting a *generic* gardener that could only restate the report unverified and hope the next tick found the standalone entry. Harden this into a mechanical hand-off to the true reader.

**What I did:**

- **`scripts/jobs/common.sh`** — added `schedule_carry_forward_dir` (the shared path convention `carry-forward/<schedule-stem>/`), deliberately kept *out* of `schedules/` so the scheduler's `list_jobs … schedules` iteration never mistakes it for a schedule file.

- **`scripts/jobs/deadmail.sh`** — new routing branch. Added `strip_tick_suffix` (removes a dispatched `-YYYYMMDD-HHMMSS` suffix) and `match_recurring_schedule` (matches the stripped base against an **active recurring** schedule's `job_basename_prefix`, requiring a `cadence:` so `once:` schedules never match). When a dead-mail's `to:` matches, it deposits the whole original message into the schedule's per-name mailbox and retires the dead-mail in **one atomic CAS commit** (no separate `verify_posted` needed, since deposit+retire land together). Non-schedule recipients keep the unchanged generic-gardener promotion path.

- **`scripts/jobs/scheduler.sh`** — the recurring dispatch path now drains any pending carry-forward reports for the schedule (read inside the CAS loop after sync), injects them into the dispatched tick body as a labelled block that **precedes** the existing `anchored_window` context block (mirroring that context-injection, and working for interval cadences too), and `git rm`s the drained files in the **same** CAS commit as the dispatch + stamp — so each report is consumed exactly once and reaches the next tick as the addressed reader deterministically.

- **Tests** — new hermetic `scripts/jobs/test/deadmail-schedule-carry-forward-test.sh` (11 assertions, all pass): schedule-tick reply → mailbox (not a generic job); non-schedule control still promotes generically; deadmail idempotent on re-scan; scheduler drains the mailbox into the next tick body exactly once.

- **Docs** — `skills/schedule/SKILL.md` and `designs/inbox-discipline-audit.md` (Part B item 4 + Tests) document the new route.

**Verification:** New test 11/11. Existing scheduler tests pass unchanged (anchored-cadence 13/13, preflight-typo 11/11, preflight-deploy-lag 14/14). `bash -n` + shellcheck clean (only pre-existing benign infos). The full `run-test.sh` harness aborts at SUBTEST 6 (maintainer-channel `maintainer-reply` FATAL) — I confirmed this is **pre-existing**: it fails identically on clean `origin/main2` with my changes stashed, and it's in a path my change doesn't touch. Deadmail SUBTEST 16 sits after SUBTEST 6 so it's unreached on both base and branch.

**Committed & pushed** to `main2` as `64b27bcf87`.

**Follow-up (not blocking):** The `run-test.sh` SUBTEST 6 maintainer-channel flake (a stray unread maintainer message without `reply_to`, likely concurrent-fleet leakage through the env scrub) predates this work and aborts the whole `set -e` harness before later subtests run — worth a separate fix so the suite can complete end-to-end.
