The work this job specifies is already fully implemented and landed on `main2` — nothing remains to do.

## Completion report

**Finding: the job's work is already complete on `main2`.**

The spec asked to harden `clone-keeper.sh` `keep_clone` so a missing/non-repo tracked clone is restored rather than warn-and-skipped forever, deriving the re-clone URL from the `<owner>-<repo>.git` dir-name convention, setting the explicit fetch refspec, falling through to the normal fast-forward, keeping every failure path returning 0, and escalating once on a hard failure — plus a missing-clone-gets-restored subtest.

Every one of those requirements is already present in `scripts/jobs/clone-keeper.sh` at HEAD (`90ec62613`), landed by a peer series of commits `1bfbc1087`→`7cf55fc46`:

- **`1bfbc1087`** — repair a genuinely-missing tracked bare clone by re-cloning
- **`05a261e5e`** — self-heal by deriving the URL from the dir basename (`derive_clone_url`, `endojs-endo.git` → `https://github.com/endojs/endo.git`)
- **`88a025089`** — explicit fourth `<clone-url>` field to disambiguate the re-clone source (the default `GARDEN_TRACKED_CLONES` now carries `…|https://github.com/endojs/endo.git`)
- **`c46fdfe5e`** — escalate an un-recreatable missing clone to the maintainer inbox once (`alert_maintainer`), instead of a silent per-tick WARN
- **`7cf55fc46`** — stage the re-clone into a sibling temp path + atomic `mv -T` so a partial/racing clone never half-populates the tracked path

The explicit refspec (`+refs/heads/*:refs/remotes/origin/*`) is set on every re-clone (line 251), honoring the endo no-fetch-refspec special case, and control falls through to the existing fetch + fast-forward. All failure paths return 0.

The test file `scripts/jobs/test/clone-keeper-test.sh` already carries the requested coverage and then some — `RECLONE`, `CLONE-URL FIELD`, `PROVISION`, `MISSING+UNREACHABLE`, `MISSING+NO-URL`. I ran it: **40 passed, 0 failed.**

**Changes made:** none — no commit or push, because the repository already satisfies the spec in full and adding anything would be redundant. This job was evidently posted before (or concurrently with) the peer commits that resolved it, and those commits already merged to `origin/main2`.

**Follow-ups:** none for the code. The one real-world condition the spec cites — the endo bare clone being absent on endolinbot2 — will now be repaired automatically on the next `garden-clone-keeper.timer` tick (~30m) by the landed self-heal path; no manual restore is needed.
