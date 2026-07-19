In `scripts/jobs/triager.sh` around line 117, the project bare-clone fetch is a bare, unbounded `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`. It has no `timeout` wrapper, so on a very large repo (kriscendobot-agoric-sdk) a full fetch runs past the reaper's `GARDEN_FETCH_REAP_AGE` (120s) stuck-fetch janitor in `scripts/jobs/reaper.sh`, which SIGTERM/SIGKILLs the fetch subtree — bash prints `Terminated`, git returns rc 143, and `die` escalates it to `exit 1`, marking the unit Failed and tripping self-heal every slow tick. Failure signature: log tail `Terminated\n<3>… FATAL: fetch failed for kriscendobot-agoric-sdk`.

Fix, mirroring the journal-fetch discipline already in `scripts/jobs/common.sh` (`_journal_git_fetch` / `journal_fetch`, `GARDEN_FETCH_TIMEOUT` + `GARDEN_FETCH_KILL_AFTER`):
1. Bound the fetch deterministically inside triager.sh with `timeout --kill-after=<grace> <bound>` so it self-limits instead of being externally reaped. Use a bound generous enough for a large monorepo yet comfortably under the reaper's `GARDEN_FETCH_REAP_AGE` (120s) — e.g. a dedicated `GARDEN_TRIAGE_FETCH_TIMEOUT` (~90s) with `--kill-after=$GARDEN_FETCH_KILL_AFTER`. Consider dropping `--all` in favor of `origin` since a bare clone normally has a single origin remote, cutting fetch cost.
2. Classify a timeout/reap kill (rc 124/137/143) as a **transient skip-this-tick**, not a FATAL: on those codes, `log "WARN: fetch for $slug timed out (>Ns); skipping this tick, retrying next"` and `exit 0` (matching how the self-provision path at lines ~96-103 treats a transient clone failure), reserving `die`/exit 1 for a genuine fetch error (bad ref, real repo corruption). A slow-but-progressing large-repo fetch must not mark the unit Failed and trip self-heal.
3. Ensure the chosen bound sits below `GARDEN_FETCH_REAP_AGE` so triager.sh's own `timeout` — not the reaper — is what bounds the fetch, keeping the reaper as pure backstop.
Verify: shellcheck triager.sh, and confirm rc 124/137/143 now yield `exit 0` with a WARN while a real fetch failure still exits non-zero.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-19T08:25:16Z
