This job is already fully satisfied by work merged on `main2`; no new changes were needed.

## Completion report

**Job:** Harden `clone-keeper.sh`'s missing-clone path to self-heal (derive upstream URL from the `<owner>-<repo>.git` dir basename, bounded `git clone --bare`, WARN-fallback on failure, guard to `GARDEN_TRACKED_CLONES` rows) and add a reclone test case.

**Finding:** Every requirement is **already implemented and merged** on `origin/main2`, which is exactly where my worktree HEAD sits (`0d1909e84`, 0 commits ahead/behind). The job spec describes an old state of the file (`worktrees/endojs-endo.git` phantom, bare "WARN … skipping" at line ~79); that has since been superseded by a chain of commits:

- `1bfbc1087` / `05a261e5e` — repair a genuinely-missing tracked bare clone by re-cloning, deriving the URL from the dir basename (`derive_clone_url`).
- `88a025089` — explicit fourth `<clone-url>` field to disambiguate the re-clone source.
- `7cf55fc46` — stage the re-clone into a sibling temp path + atomic `mv -T` (`bounded_clone`, mirroring `bounded_fetch`'s timeout/retry discipline).
- `c46fdfe5e` / `5c919e8f6` — escalate an un-recreatable / persistently-unreachable missing clone to the maintainer inbox instead of a forever-WARN.
- `f8fdc05c4` — repoint the tracked default at the real fork clone.

All requested behavior is present in `scripts/jobs/clone-keeper.sh`:
- Missing-clone self-heal with basename-derived URL, explicit-`clone-url` and URL/path-`remote` precedence.
- `git clone --bare` under the same bounded timeout+retry+backoff discipline as `bounded_fetch`.
- Fallback to skip+WARN (and escalation) when the clone fails.
- The guard is structural: only rows read from `GARDEN_TRACKED_CLONES` are processed.

**Test:** `scripts/jobs/test/clone-keeper-test.sh` already covers the missing-clone reclone path — cases `RECLONE`, `CLONE-URL FIELD`, `PROVISION` (basename-derived), `MISSING+UNREACHABLE`, `MISSING+NO-URL`, and `CORRUPT`. Ran it: **45 passed, 0 failed**.

**Changes made:** None — no code change was warranted, and pushing a no-op would only add noise. Nothing to commit or push.

**Follow-ups:** None. This job was a stale/duplicate re-post of work already delivered; it can be recorded complete.
