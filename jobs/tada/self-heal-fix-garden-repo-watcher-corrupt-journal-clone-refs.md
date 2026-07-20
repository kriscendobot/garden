Worktree is clean and at `origin/main2` (6f8501d8db). Nothing to push — the work is already landed.

## Completion report

**Job:** Handle local journal-clone corruption in `sync_clone` (self-heal by re-cloning) the way `ensure_clone` handles a poisoned partial clone, instead of `die`-ing every tick in an unbreakable loop.

**Finding:** The work was **already fully implemented and merged to `origin/main2`** — by commit `6f8501d8db "fix(jobs): reclone on corrupt journal fetch"`, which landed while I was working (a peer/earlier run of this reaped job). It implements exactly the spec:
- `GARDEN_CORRUPT_CLONE_SIGNATURES` — a corruption-signature set distinct from `GARDEN_OFFLINE_SIGNATURES` (`bad object`, `did not send all necessary objects`, `bad ref for`, `invalid sha1 pointer`, `unable to read`, `loose object … is corrupt`, `object file … is empty`, `failed to run repack`, `gc.log`, `fsck`, …).
- `_fetch_stderr_is_corrupt` / `_fetch_stderr_corrupt_signature` classifiers (`common.sh:1804`).
- In `sync_clone` (`common.sh:2628`): the offline classifier runs first; on a corrupt signature (or a stale `.git/gc.log`) it logs a WARN, `rm -rf`s the clone, re-provisions atomically via `( ensure_clone "$dir" )` (the same sibling-temp clone + `mv`-into-place path), retries the fetch **once**, and `die`s only if the freshly-cloned copy still fails — bounded to one re-clone so an upstream problem can't spin a reclone loop.
- `run-test.sh` SUBTEST 24 cases A–D inject the `bad object refs/heads/journal2` / `did not send all necessary objects` stderr and assert re-clone-and-recover (A/B), bounded-once-then-die-loud (C), and the real repo-watcher zeroed-`refs/heads/journal2` + stale `gc.log.lock` shape (D).

**Verification I ran:** In isolation against the current `origin/main2` tree, all four corrupt-clone scenarios pass (re-clones and recovers; refs restored; sentinel + `gc.log.lock` cleared; dies loud only on unhealable corruption), and the 14 `_fetch_stderr_is_corrupt` classifier assertions pass. (The full `run-test.sh` runner bails at SUBTEST 4 on a systemd/gardener-scaler env dependency unrelated to this change, so I validated SUBTEST 24 via an extracted harness with an exec-capable `$TR` — `/tmp` is noexec here.)

**What I did / changed:** I had prepared a one-line test-assertion fix against the older *two-tier* heal that HEAD pointed at when I claimed the job, but `origin/main2` has since replaced that whole region with the single-stage atomic re-clone above (matching the spec and its own tests). Pushing my commit would have regressed it, so I discarded it and reset the worktree to `origin/main2`. **No net change to push.**

**Follow-ups:** None for this job. Tangential (out of scope): `run-test.sh` aborts at SUBTEST 4 in a bare worktree lacking systemd/scaler fixtures — worth making that subtest skip gracefully off-host so the suite can reach later subtests, but that's a separate hygiene item.
