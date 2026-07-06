Pushed to `main2` on the first attempt. The work is complete and verified.

## Completion report

**Job:** `improve-scholar-staging-clone` — add a sanctioned helper that provisions a scholar's (or any library-writeback role's) staging area against a fresh, commit-capable tree.

**What I did**

1. **Created `scripts/jobs/scholar-staging-clone.sh`** (sources `common.sh`, executable). It:
   - Takes a destination dir positionally, else `$GARDEN_SCHOLAR_STAGING_CLONE`, else the default `$GARDEN_STATE/scholar-staging/journal`.
   - Calls the existing `ensure_clone` (clone/reuse the single-branch journal2 clone **and** seed `user.name`/`user.email` from the garden bot config — `common.sh:1159`) then `sync_clone` (fetch + hard-reset to the real `origin/journal2` tip, never the deployed worktree's lagging local branch).
   - Mirrors `land-journal-edit.sh`'s **live-worktree refusal** (exit 2) so an operator can't point staging at `$GARDEN_ROOT/journal`.
   - Emits the ready absolute staging path as the only stdout line and exits 0; a transient outage propagates `sync_clone`'s EX_TEMPFAIL (75).

2. **Updated `roles/scholar/AGENT.md`**: per-job procedure step 1 now provisions the staging tree with the helper (`<staging>/library` = the library dir), and the "Land content edits through the lander" operating norm replaces the old "author in a `scratch_dir`/`mktemp`" hand-rolled staging instruction with a directive to call the helper — memorializing the 2026-07-06 failure (false "indexes unwritten" investigation + identity-less commit failure).

**Verification**
- `bash -n` clean; `--help` renders; live-worktree refusal returns exit 2.
- End-to-end: provisioned a throwaway clone → confirmed it sat on the exact `origin/journal2` tip, carried `endolinbot` identity, and accepted a probe commit.
- shellcheck: only the two benign warnings `land-journal-edit.sh` also has (unfollowable `common.sh` source; `GARDEN_TAG` consumed across the source boundary by `log()`, which the output confirmed).

**Changed:** `scripts/jobs/scholar-staging-clone.sh` (new), `roles/scholar/AGENT.md`. Committed and pushed to `main2` (`98e19acbe`).

**Follow-ups:** none required. I confirmed the librarian role and `library-lookup` skill land *single-file* writebacks directly through the lander (which already provisions its own isolated clone) and do not stage multi-file edits in a working tree, so the scholar was the only library-writeback procedure needing the redirect.
