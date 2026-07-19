The job is already fully resolved. My worktree base (`74704e47a8`, already on `origin/main2` and deployed) contains the complete fix. Verifying the current code against the job's exact ask:

- **Unbounded fetch → bounded** (triager.sh:133-134): the refresh is now `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_TRIAGE_FETCH_TIMEOUT" git --git-dir="$BARE" fetch -q --prune origin` — the same `timeout` discipline `bounded_clone`/`journal_fetch` use, with a triager-specific 90s bound that sits under the reaper's 120s stuck-fetch age.
- **Hard `die` → benign skip** (triager.sh:139-153): on failure the exit is classified. The exact captured signature — a `Terminated` fetch (rc 124/137/143) or a recognized offline stderr — logs a WARN and `exit "$GARDEN_OFFLINE_RC"` (75, which `self-heal-run.sh` normalizes to a clean exit 0). The cursor stays unadvanced so no change is dropped and the next tick retries. Only a genuine, non-transient error still `die`s so real corruption surfaces loudly.

This is precisely the crash-loop the job describes (`Terminated` fetch → `FATAL: fetch failed for kriscendobot-finbot`, exit 1, self-heal churn on `garden-triager@kriscendobot-finbot`), and it is now a transient skip rather than a failed unit.

No new edits are needed; the tree is clean and there is nothing to push.

---

**Completion report**

- **Task:** Bound the triager's steady-state bare-clone fetch and make a transient stall skip-not-die.
- **Finding:** The fix was already landed in the branch base by a series of prior commits (`a335cf0aca` → `74704e47a8`, all on `origin/main2`). The current `scripts/jobs/triager.sh` already wraps the fetch in the shared `timeout --kill-after` discipline under the dedicated `GARDEN_TRIAGE_FETCH_TIMEOUT` (90s), and classifies a `Terminated`/offline failure as transient → WARN + `exit $GARDEN_OFFLINE_RC` (clean skip, cursor unadvanced, retry next tick), reserving `die` for genuine errors. This exactly matches the requested fix and neutralizes the captured `kriscendobot-finbot` crash-loop signature.
- **Changed:** Nothing — no code change was required; the worktree is clean at `74704e47a8`.
- **Follow-ups:** None. The one "optional" item in the spec (throttled `alert_maintainer` escalation after a *persistent* run of steady-state fetch failures) was explicitly optional and is not implemented for the transient-skip path — a possible future enhancement if a genuinely dead source should surface without every blip alerting, but not needed to close this job.
