My commit `4a2d6748a` is the tip of `origin/main2`, inbox is empty, and the leaked WIP is preserved in the stash. The job is complete.

---

## Completion report: `run-test-isolate-shared-clone-flake`

**Root cause (broader than first scoped).** `run-test.sh` is run *by* a live gardener (here, gardener 18), whose process **exports** the fleet's own `GARDEN_GARDENER_CLONE`, `GARDEN_STATE`, `GARDEN_ROOT=/home/kris`, etc. Those ambient values leaked **through** each subtest's per-case `env`/`export` overrides into the scripts under test: `claim-job`/`gardener` honor `GARDEN_GARDENER_CLONE`, and `ensure_clone`/`capture_blob` derive the remote from `GARDEN_ROOT/journal` (the live, fleet-busy journal2) whenever a subtest leaves `JOURNAL_REMOTE` unset. SUBTEST 21 had the extra gap that SUBTEST 20 unsets `JOURNAL_REMOTE`, so its self-heal capture path derived/raced the live journal → the reported `rc=1 calls=0`. I reproduced both symptoms directly on this host (the run aborted at SUBTEST 5 with exit 3 after `claim-job.sh` claimed a *real* board job).

**Fix (`scripts/jobs/test/run-test.sh`, isolation only — no assertion changes):**
1. **Hermetic env baseline** at the top: scrub every inherited `GARDEN_*`/`JOURNAL_*`/`SELF_HEAL_*` so only the test's throwaway `$TR` settings are authoritative and concurrent fleet activity is invisible. This protects *every* subtest, not just 21.
2. **SUBTEST 21 dedicated throwaway bare** (`SHBARE`), seeded with the `journal2` branch, exported as `JOURNAL_REMOTE` for the subtest and unset at its end — so `ensure_clone`/`capture_blob` hash into a clone of our bare, never one derived from (or racing) the live journal.

**Before/after, on this live host with the fleet active and the gardener-18 env present:**
- Before: exit 3, aborted at SUBTEST 5 (claimed live job `self-heal-fix-…-git-128-not-fatal`); SUBTEST 21 never reached.
- After: **144 passed / 0 failed**, with SUBTEST 21 hermetic **10/10 across 4 repeated runs** under load.

**Tracked follow-on (posted as job `harden-run-test-scheduler-cadence-determinism`):** one repeat run showed a lone SUBTEST 8 failure (`re-run dispatched (tick 1→2)`) — a *clock-determinism* flake (the 1s-cadence assertion crosses real wall-clock when two `scheduler.sh` calls are >1s apart under load), not a shared-clone issue. Fix direction noted: add a `GARDEN_SCHEDULER_NOW` hook (mirroring `GARDEN_FOREMAN_NOW`) or widen the test cadence.

**Housekeeping note.** A concurrent gardener's self-heal "signalled-shutdown → exit 0 / `SuccessExitStatus`" WIP leaked into my isolation worktree via a shared rebase autostash. I committed **only** my file (explicit pathspec), preserved that unrelated WIP durably in `stash@{0}` ("recovered: self-heal signalled-shutdown…"), then removed the worktree — no other agent's work was committed or destroyed. Pushed to `origin/main2` as `4a2d6748a` (rebase-CAS, landed attempt 1).
