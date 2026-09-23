Done. The fix is committed and pushed to `main2`.

## Completion report

**Job:** Fix the wrong bare-clone directory default causing `garden-triager@*` instances to fail the bare-clone check every tick.

**Root cause confirmed:** `scripts/jobs/triager.sh` (and `comment-watcher.sh`) defaulted `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, but the garden's standing bare clones live in `$GARDEN_ROOT/worktrees/<slug>.git` (maintained by `clone-keeper.sh`, read by `ensure-project-worktree.sh`, per CLAUDE.md § Layout). No `repos/` directory exists (verified: `ls /home/kris/garden2/repos` → No such file or directory), so the default never resolved.

**Changes (in `scripts/jobs/`):**
- `triager.sh`: default `GARDEN_REPOS` → `$GARDEN_ROOT/worktrees`; updated the header comment to name the `worktrees/<slug>.git` location and cite CLAUDE.md § Layout.
- `comment-watcher.sh`: same default fix for consistency (it only logs a note, so it wasn't crashing, but was masking the same wrong default).

Note: the current `main2` `triager.sh` had already been hardened to *skip* gracefully (`log … exit 0`) instead of `die` on a missing clone — so the symptom on newer instances was silent no-op (never triaging) rather than the crash-loop `die`; the wrong directory default was still the live defect, and this fixes it so clones actually resolve.

**Verification:** Ran `GARDEN_ROOT=/home/kris/garden2 GARDEN_TRIAGE_HANDLER=/bin/true scripts/jobs/triager.sh kriscendobot-minion.town` from the worktree — it fetched and triaged (`no change on kriscendobot-minion.town:main (a3dfdee…)`, exit 0) instead of failing the bare-clone check. The other repos with a `worktrees/*.git` clone (endo, agoric-sdk, finbot, vattr97) resolve identically.

**Out of scope (as specified):** repos with no bare clone yet (cosgov, ocapn, agoric-3-proposals) will still no-op/skip with the pre-existing "clone the repo first" signal — correct behavior, not touched.

**Landed:** committed with explicit pathspecs and pushed to `origin/main2` via a rebase-CAS loop (PUSHED on first attempt). It reaches instances on the next deliberate `deploy-garden.sh`.

**Follow-ups:** none.
