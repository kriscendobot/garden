Pushed to main2 (`62f8a89b4f..28123fe477`). The job is complete.

## Completion report

**What I did:** Added a deterministic **stale-shepherd re-validation sweep** to `scripts/jobs/ci-watcher.sh` that runs each tick after the existing red→post pass, closing the false-positive-wedge loop behind the `endojs-endo-but-for-bots-pr693` exit-0-unsatisfying escalation (journal 2026-07-11T18:34Z).

**What changed:**
- **`scripts/jobs/ci-watcher.sh`**
  - New `GARDEN_CI_RETIRE_CLONE` write clone (default `$GARDEN_STATE/ci-watcher/retire`), distinct from the read-only `$VERIFY` clone and post-job.sh's producer clone.
  - New `retire_stale_shepherd <base> <phrase>` helper: CAS loop that `sync_clone`s, re-checks the job is still **unclaimed in `todo/`** (returns early if it drained to `doin/`/`tada/` — never races an in-flight gardener), writes a `tada/` completion report carrying the `<<<GARDEN-JOB-COMPLETE>>>` marker, `git rm`s the `todo/` copy, and `commit_and_push`es — same push-race retry/backoff shape as the existing posts.
  - New sweep driver at end of tick: board-driven enumeration (via `git ls-tree` on the `$VERIFY` clone) of `^<slug>-pr<N>-shepherd$` bases in `todo/`; for each, re-reads `$GARDEN_CI_ROLLUP`; retires on a no-longer-RED verdict (green rc=10 / none rc=11 / pending rc=12), leaves it on RED (rc=0) or on an unreadable read (never guesses). Placed after the cascade-abort `exit 0`, so it never fires rollup reads at an already-throttled API. Leader-only comes free from the same `is-main-host.sh`-gated unit as the post path.
  - Header pipeline docstring updated to describe the second pass.
- **`scripts/jobs/test/ci-watcher-test.sh`**: 14 new assertions (cases M–Q) — retire-on-green (with completion-marker check), still-red-left-in-place, `doin/`-claim-untouched, retire-on-pending & on-none, unreadable-left. Added `in_lane`/`tada_has_marker`/`claim_in_bare` helpers.

**Verification:** `bash -n` clean; full suite **43/43 pass** (29 original + 14 new). shellcheck surfaced only pre-existing/benign items (a false-positive SC2016 on an intentional literal-backtick `printf %s`).

**Follow-up (out of scope for this script-level job, as the spec notes):** the durable complement is for the shepherd itself to emit a clean completion marker when it re-fetches and finds CI green/settled, so an in-flight (`doin/`) no-op records as done rather than exit-0-unsatisfying — an agent-instruction change in `roles/shepherd/AGENT.md`.
