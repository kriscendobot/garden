No changes are needed — the job's intent has already been implemented on main2 by a superior design that landed after this job was posted. Making the literal change now would regress a deliberate decision.

## Completion report

**Job:** make a *missing* tracked clone in `scripts/jobs/clone-keeper.sh` self-heal instead of being logged-and-skipped forever.

**Finding: already done — by a superset design, no changes needed.**

The job was written against an older `clone-keeper.sh` that only re-warned `missing … skipping` each tick. Since it was posted, two commits landed on `origin/main2` that fully satisfy (and exceed) its intent:

- `1bfbc1087` — repair a genuinely-missing tracked bare clone by re-cloning.
- `05a261e5e` — self-heal a missing clone by deriving its URL from the dir basename.

What the current `clone-keeper.sh` already does at the missing-repo branch (`keep_clone`, lines 176-214), exactly matching the job's requested behavior:
- **Re-clones a missing dir** via `bounded_clone` (timeout `$GARDEN_FETCH_TIMEOUT` + backoff, mirroring `bounded_fetch`), then **sets the fetch refspec** `git -C <abs> config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` — the identical remediation `ensure-project-worktree.sh` prescribes — then **falls through to the normal fast-forward**.
- **WARN-and-skips only** when no source is available (bare-name remote with an underivable basename) or the clone itself fails.
- **STALE (not clobbered)** for a present-but-corrupt dir.

The design difference from the job's literal ask is an improvement, not a gap. Rather than a redundant optional 4th `<clone-url>` field, the source is either the 2nd `<remote>` field when it's a URL/path (`is_remote_location`) **or** deterministically derived from the `worktrees/<owner>-<name>.git` basename (`derive_clone_url`) — so even a clone tracked by a bare remote name self-heals, which a 4th-field-only design would not cover. The `GARDEN_TRACKED_CLONES` default (line 71) is already `worktrees/endojs-endo.git|https://github.com/endojs/endo.git|master`, so a missing endo clone re-provisions from that URL.

The test suite already asserts every path the job asked for and more: **RECLONE** (`REPAIRED` from an explicit URL source), **PROVISION** (basename-derived URL + fetch-refspec assertion), **MISSING+UNREACHABLE**, **MISSING+UNDERIVABLE**, and **CORRUPT**.

**Verification:** `bash scripts/jobs/test/clone-keeper-test.sh` → **31 passed, 0 failed**.

**Changes committed/pushed:** none. Re-implementing the literal 4-field format would duplicate existing functionality and regress a deliberate, well-documented design choice.

**Follow-ups:** none. This job can be closed as already-satisfied.
