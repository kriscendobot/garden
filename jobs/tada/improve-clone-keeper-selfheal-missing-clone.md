The work this job requests has already been fully implemented and merged to `origin/main2`. All 40 tests pass. No further work is needed.

---

**Completion report**

The job asked to fix `clone-keeper.sh`'s `keep_clone()` so a missing tracked bare clone is re-cloned (with the tracked-clone spec extended to carry a clone URL), or else escalated / dropped, rather than being silently WARN-skipped.

**Finding: the requested work is already complete on `origin/main2`.** The job spec references the old line 78–81 WARN-skip behavior, but that behavior no longer exists. A prior sequence of five commits (all ancestors of the current `origin/main2` tip `510161529`) already implements everything the job asks for — and more than the minimum:

- `88a025089` — extends the `GARDEN_TRACKED_CLONES` spec to a fourth field: `<dir>|<remote>|<branch>|<url>`, and the default row now carries `https://github.com/endojs/endo.git`.
- `1bfbc1087` / `05a261e5e` — `keep_clone()` re-clones a genuinely-missing bare clone via a bounded (timeout+retry) `bounded_clone`, choosing the source by precedence: explicit `<clone-url>` → `<remote>` when it is a URL/path → URL derived from the `<owner>-<name>.git` basename.
- `c46fdfe5e` — when nothing can auto-recreate the clone (bare-name remote, no URL, underivable basename), it **escalates to the maintainer inbox** via throttled `alert_maintainer` with a per-clone dedup key instead of a silent WARN.
- `7cf55fc46` — the re-clone stages into a sibling temp path and is atomically `mv -T`'d into place, so a partial/racing clone never half-populates the tracked path.

A present-but-corrupt dir is surfaced as `STALE` (never clobbered), and every failure path returns 0 so one bad clone never aborts the rest.

**Verification:** ran `scripts/jobs/test/clone-keeper-test.sh` — **40 passed, 0 failed**, covering re-clone from bare-name/derived URL, re-clone from explicit fourth field, corrupt-dir STALE, missing+unreachable skip, basename-derived provision, and the missing+no-URL maintainer escalation.

**Changes made this run:** none — no code change was necessary; the working tree is clean and nothing to commit/push.

**Follow-ups:** none. This job was a duplicate of already-landed work (likely posted before/while those commits merged). It can be recorded as done.
