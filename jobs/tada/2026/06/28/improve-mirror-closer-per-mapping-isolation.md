Inbox is empty. Work complete.

---

## Completion report

**Job:** `improve-mirror-closer-per-mapping-isolation` — isolate per-mapping read failures in `scripts/jobs/mirror-closer.sh` so one bad mapping can't abort the whole tick.

**What I did**

Worked in an isolated worktree off `origin/main2` (per the garden-infra-jobs discipline — the shared main2 tree is concurrently mutated by the fleet), made the changes, ran the test suite, committed with explicit pathspecs, and pushed `HEAD:main2`. Commit `b9f09e4d6`; temporary worktree removed.

**What changed**

`scripts/jobs/mirror-closer.sh`:
- The three per-mapping `die` calls — upstream-state read failure, mirror-state read failure, and close-handler failure — now `log "WARN: … skipping this mapping; will retry next tick"` + `failed=$((failed+1))` + `continue` instead of killing the tick. The mapping is left unresolved (no `closed_at` stamp), so the next tick re-handles it — preserving the "never guess a state, never silently suppress a close" discipline, now per-mapping rather than per-tick.
- After the existing `tick complete` log, when `failed > 0` it emits a summary WARN line and `exit 1`, so the unit still reports unhealthy to systemd/journald and the failure stays visible — without starving the healthy mappings.
- Updated the header doc: kept the missing-tool loud-failure note and added a 2026-06-28 "PER-MAPPING ISOLATION" paragraph explaining the new shape.

`scripts/jobs/test/mirror-closer-test.sh`:
- Added a `FAILONE` state stub that fails only for a chosen `<repo>#<num>` (`MC_FAIL_REF`) and otherwise behaves like the normal stub.
- Added **test I**: two mappings on one journal — `up/repo#18` permanently unreadable, `up/repo#19` merged with an open mirror. Asserts the healthy mirror `garden/mir#29` is still closed and stamped, the bad mapping is left unresolved, and the tick exits nonzero so the failure stays visible.

**Verification**

`mirror-closer-test.sh --no-e2e`: **23 passed, 0 failed**. The pre-existing loud-failure tests H and H2 still pass — their `rc != 0` expectation is now satisfied by the tick-level `exit 1` rather than the removed `die`. `bash -n` clean on both files; `shellcheck` reports only two pre-existing `SC2034` warnings (`GARDEN_TAG`, `attempt`), none introduced by this change.

**Follow-ups**

None required. PART 2 (real-gh E2E) was skipped via `--no-e2e` as it needs a kriscendobot-authenticated `gh`; it is unaffected by this change (its single-mapping path still closes and stamps as before).
