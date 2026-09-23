## Completion report

**Outcome: no-op — the requested work was already landed by peer commits before this job ran.**

The job asked me to wire self-provisioning into `scripts/jobs/triager.sh`, replacing the hard `die` on a missing bare clone with derive-URL + bounded-atomic-clone logic mirroring `clone-keeper.sh`, plus a test case for a never-cloned slug. On inspecting the worktree (checked out at `origin/main2` = `4c0e275b0b`), all of this is **already present and merged**:

- **`triager.sh`** (lines 47–100): the hard `die` is gone. A missing clone now takes a self-provisioning path — `derive_clone_url` → `bounded_clone` (atomic sibling-temp + `mv -T`) → sets the `+refs/heads/*:refs/remotes/origin/*` fetch refspec → logs `provisioned missing bare clone …` → falls through to the normal fetch. Unrecoverable cases (underivable slug, persistently unreachable source) escalate to the maintainer inbox via throttled `alert_maintainer` and exit 0 rather than crash-looping. It is gated opt-in behind `GARDEN_TRIAGE_SELF_PROVISION=1` (default = benign skip, "the clone-holder triages"), a refinement added on top of the base fix.
- **`common.sh`** (§ standing bare-clone provisioning helpers, ~line 461): `is_own_git_repo`, `is_remote_location`, `derive_clone_url`, `bounded_clone`, and the `GARDEN_CLONE_URL_BASE` default are factored out and shared; `clone-keeper.sh` sources them (no logic copied).
- **`test/triager-test.sh`**: case H was rewritten into H1–H4 covering provision-succeeds-then-triages, default-skip, unreachable-source-escalates, and underivable-slug-escalates, with `GARDEN_CLONE_URL_BASE` overridden for offline runs.

This was delivered by commits `2c76c8cd92` ("self-provision a missing bare clone instead of never triaging") and `4c0e275b0b` ("make self-provision opt-in (default skip), reconcile case I").

**Verification:** ran `scripts/jobs/test/triager-test.sh` → **62 passed, 0 failed** (exit 0), including all H1–H4 and case I assertions.

**Changes made by me:** none — working tree is clean, nothing to commit. This self-healing job was outraced by peers.

**Follow-ups:** none.
