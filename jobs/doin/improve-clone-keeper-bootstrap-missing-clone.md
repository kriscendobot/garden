In `scripts/jobs/clone-keeper.sh`, make a missing tracked bare clone self-heal instead of warning-and-skipping every tick forever. Currently `keep_clone()` (lines 78-81) logs `WARN: tracked clone … is missing or not a git repo … skipping` and returns whenever `git rev-parse --git-dir` fails; on a host where the clone was never bootstrapped (observed now on endolinbot2 for `worktrees/endojs-endo.git`) this repeats every ~30m and the clone never re-forms, silently blocking upstream-drift re-ingestion — the exact six-week stall the keeper header says it exists to prevent. Fix: extend the `GARDEN_TRACKED_CLONES` line format (currently `<dir>|<remote>|<branch>`) with an optional 4th field `<clone-url>` (default derivable/`https://github.com/endojs/endo.git` for the built-in entry), and when the clone dir is absent, do a bounded `git clone --bare <clone-url> <abs>` (wrapped in `timeout GARDEN_FETCH_TIMEOUT` with the same backoff/retry as `bounded_fetch`, logging success/failure, returning 0 on failure so one clone never aborts the loop) before proceeding to the fetch+fast-forward. Keep the WARN path only for the "exists but not a git repo" corruption case, which genuinely needs a human.

---
claim:
  host: endolinbot2
  gardener: 12
  claimed_at: 2026-07-02T23:51:00Z
