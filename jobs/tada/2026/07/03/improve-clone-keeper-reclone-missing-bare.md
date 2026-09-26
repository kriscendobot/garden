All 40 tests pass. This job's work is already fully present in `origin/main2`.

## Completion report

**Finding: the job was already complete in main2 before I started — no new work was required.**

The spec asks to harden `scripts/jobs/clone-keeper.sh` so a missing tracked bare clone is re-created rather than abandoned. Every requirement it lists is already implemented and merged, across five commits reachable from HEAD (`origin/main2`):

- `1bfbc1087` clone-keeper: repair a genuinely-missing tracked bare clone by re-cloning
- `05a261e5e` self-heal by deriving URL from the dir basename
- `88a025089` add explicit fourth clone-url field to disambiguate the re-clone source
- `c46fdfe5e` escalate an un-recreatable missing clone to the maintainer inbox
- `7cf55fc46` stage a missing-clone re-clone into a temp path + atomic mv

Verification against the spec's explicit asks:
- **4th field parsing** — `<dir>|<remote>|<branch>|<url>` is parsed in the `while IFS='|' read -r dir remote branch clone_url` loop (line 301) and threaded through `keep_clone` as `clone_url="${4:-}"` (line 203). ✅
- **Re-clone when absent + url present** — `bounded_clone` runs `timeout "$GARDEN_FETCH_TIMEOUT" git clone -q --bare`, logs failures self-containedly, `return 0`, and falls through to the normal fetch/fast-forward (lines 244–258). ✅
- **Default endo url** — `: "${GARDEN_TRACKED_CLONES:=worktrees/endojs-endo.git|origin|master|https://github.com/endojs/endo.git}"` (line 84). ✅
- **Escalate when no url available** — the no-source path now calls `alert_maintainer` with a per-clone dedup key instead of a bare WARN (lines 239–242). ✅

The implementation actually exceeds the spec (adds basename-derived URL fallback as a last resort, atomic temp-staging of the re-clone, and CAS ref updates). I ran the existing hermetic test suite `scripts/jobs/test/clone-keeper-test.sh`: **40 passed, 0 failed**, covering fresh/fast-forward/diverged/offline/reclone/clone-url-field/corrupt/unreachable/provision/no-url-escalate paths. `bash -n` is clean.

**Changes:** none — nothing to commit or push; the working tree is unmodified and identical to `origin/main2`.

**Follow-ups:** none. If this job was posted before those commits landed, it was superseded by them; it can be closed as already-done.
