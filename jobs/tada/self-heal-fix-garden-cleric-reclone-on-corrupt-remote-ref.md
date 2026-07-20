The work is complete and landed on `origin/main2`. Here is my completion report.

---

## Completion report

**Job:** Fix `sync_clone` in `scripts/jobs/common.sh` to self-heal a corrupt local journal clone (garden-cleric item 7: a null-sha `refs/remotes/origin/journal2` left by an interrupted ref update) instead of `die`-looping the worker and its systemd unit forever.

**What I found:** While I was implementing, two peers landed the core fix concurrently (`98e7f6229e` "heal corrupt local journal clones" and `e80d69e7b6` "reclone corrupt journal fetch clones"). Rather than clobber their work, I reset onto `origin/main2` and **augmented** their implementation to fully satisfy this job's spec, which their version fell short of in three concrete ways.

**What I changed (commit `38778e3919`):**
- **Missing spec-mandated signatures** — added `invalid sha1 pointer` (the incident's own `git fsck` output), `bad ref for`, and `broken ref` to `GARDEN_CORRUPT_CLONE_SIGNATURES`. A ref that surfaces only under these was otherwise misclassified and would still die-loop.
- **Cheap targeted repair first** — before a full re-clone, `update-ref -d refs/remotes/origin/$JOURNAL_BRANCH` + `remote prune origin` + one re-fetch. The item-7 null-sha ref heals this way for the price of one fetch (verified), so the fleet no longer re-clones the entire journal on every ref interruption. Full `rm -rf` + `ensure_clone` remains the fallback.
- **Lock-safety bug fix** — the peer's inline `ensure_clone "$dir"` call actually *released* the flock `sync_clone` holds for its whole sync→write→push critical section (its terminal `clone_unlock` closes the real fd), contradicting their own comment. Now runs `( ensure_clone "$dir" )` in a subshell exactly as `leader_host` does, so the parent's fd keeps the lock.
- **Post-heal re-classification** — a heal that races into a connectivity outage now takes the clean offline-skip path rather than `die`.
- **Test coverage** — the peer landed the fix with an end-to-end test but no classifier coverage; I added 11 classifier cases (incl. the null-sha / "did not send all necessary objects" / "invalid sha1 pointer" fixtures) and reconciled the end-to-end test into two cases: a **real** null-sha ref healed in place by the targeted repair (no re-clone), and a stub whose corruption outlasts the repair forcing the **full re-clone** — both asserting exit 0, not die.

**Verification:** `bash -n` clean on both files; all 13 new assertions pass in an isolated driver replicating the harness fixtures; real reproductions of both paths confirmed (WARN logged, ref restored, `REPAIRED` logged only on the re-clone path). The full `run-test.sh` aborts at SUBTEST 4 (gardener-scaler) in this environment on a clean baseline too — a pre-existing environment limitation unrelated to my change, so SUBTEST 24 couldn't be reached in-harness here.

**Note / correction:** Early on I mistakenly edited the deployed garden root (`/home/kris/garden2/scripts/jobs/common.sh`) instead of my worktree; I reverted it with `git checkout --` (deployed root confirmed clean) before doing all real work in the job worktree.

**Follow-ups:** None required. Inbox was empty at completion.
