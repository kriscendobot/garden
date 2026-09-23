Inbox empty. Work complete.

---

## Completion report

**Job:** `improve-follow-up-bound-retry-quarantine-wedged-digest` — bound the unbounded handler-failure retry loop in `scripts/jobs/follow-up.sh`.

**What I did**

Worked in an isolated worktree off `origin/main2` (per garden-infra discipline, since the shared `/home/kris` tree is concurrently mutated), committed explicit pathspecs, and pushed `HEAD:main2`. Landed as `3ef7d9bfc` on `origin/main2`.

**What changed**

`scripts/jobs/follow-up.sh`:
- Added `GARDEN_FOLLOWUP_MAX_RETRIES` (default `5`) and a `$GARDEN_STATE/follow-up/fail-count` state file beside `SEEN`, holding `<count> <sha-of-new-list>`.
- Keyed a consecutive-failure counter off a `git hash-object` content hash of the sorted set of new tada-report rel-paths. It increments on each failed tick whose pending set is unchanged, and resets to 0 on handler success **or** when the pending set changes (a new report arrives / set clears).
- The handler's combined output is now captured so the escalation can carry a real failure signature.
- **At the ceiling:** escalate once to the maintainer inbox (digest + quarantined-report list + last failure signature, via `inbox-send.sh maintainer`), advance the seen-marker to **quarantine** those reports, clear the streak, and `exit 0` — so a wedged digest stops re-running `claude -p` every cadence and stops re-triggering the self-heal responder (the 07:53–08:44 episode).
- **Below the ceiling:** unchanged leave-marker-and-`die`-to-retry behavior, so a transient rate-limit/usage-cap window still self-resolves.
- Refactored the three seen-marking loops into a shared `mark_new_seen` helper; the no-actionable path also clears any stale fail-count.

`scripts/jobs/test/run-test.sh`:
- Added **SUBTEST 13c** (4 assertions): below-ceiling streak growth (1→2, marker not advanced), at-ceiling quarantine + maintainer escalation + streak clear + `exit 0`, the post-quarantine quiet no-op, and streak reset on a changed pending set.

**Verification**

Full suite green: **178 passed, 0 failed** (174 prior + 4 new). `bash -n` and `shellcheck -S error` clean on both files.

**Follow-ups**

None. The threshold is overridable via `GARDEN_FOLLOWUP_MAX_RETRIES` if the default of 5 proves too tight or loose in production.
