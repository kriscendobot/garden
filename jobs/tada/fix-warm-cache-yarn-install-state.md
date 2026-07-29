Landed on `main2` as `20bd365bef`.

## Report

**Root cause was already fixed.** Commit `08bf7864e9` (2026-07-28 22:03, a peer) landed **option 2** from the job spec — a warm-cache HIT now runs `dep_reconcile_cmd` to reconcile the package manager's link state against the hardlinked trees. It also appended the dated field note the job's "Finally" item asked for. This job had been reaped 3 times and outlived its own fix. I verified `08bf7864e9` is an ancestor of `main2` rather than assuming it, and did not redo that work.

**What was left, and what I did (commit `20bd365bef`):**

*The regression check.* The reconcile was covered only from the provisioner's side (`project-worktree-isolation-test.sh` asserts the link state gets written). Nothing asserted the property that actually failed — that `local-verify.sh` verifies anything on a warm-cache worktree. `local-verify-test.sh` now drives the **real** `ensure-project-worktree.sh` through a cold build and then a warm HIT (throwaway fork + bare clone + a stubbed package manager reproducing yarn 4's defining behavior: refuse every `run` without link state) and asserts the gate exercises its steps in the HIT worktree — silent, exit 0. A negative control re-creates the pre-fix shape with `GARDEN_SKIP_DEP_RECONCILE=1`.

*The diagnosis* (the job's "also consider"). `local-verify.sh` now distinguishes a broken runner from a failed check: when two or more failing steps that ran **different** commands produce **byte-identical** output, a trailing `ENVIRONMENT FAULT` line names the shared blob and exonerates the change, with a cause hint for recognizable signatures. Blob-SHA identity is the signal — the capture path already content-addresses each step's output, so "the same failure six times" is an exact match, not fuzzy text comparison. Two guards against false positives: distinct *commands* is required (`codegen` and `docs` both match `build:types` where a project has no dedicated generator, and that failing twice is honest), and it fires only when *every* failing step shares the blob. Verdict and exit code are unchanged; only the diagnosis is.

**Evidence.** `local-verify-test.sh` 42 passed / 0 failed (was 24); `project-worktree-isolation-test.sh` 35/0 unchanged; `library-link-check-test.sh` 42/0; `shellcheck` and `bash -n` clean. I ran the pre-fix shape directly and observed six `STEP ... FAILED` blocks all carrying blob `b814cd4414`, followed by the new `ENVIRONMENT FAULT` line naming the not-installed cause — the reported symptom, now diagnosed. Skill doc updated in § Procedure, § Output, § Tests, the matching pitfall, and a dated field note.

**Follow-up — host health, flagged to the maintainer, not touched.** The shared root repo has a stale `/home/kris/garden2/.git/gc.log` (`unable to read 9ad05cc3…` → `failed to run repack`), plus copies under 6 worktrees including `journal/` — the exact condition CLAUDE.md § root-repo-guard says permanently disables git's automatic cleanup. Two things look wrong with the guard itself: it fires every 30m but has never logged an `OBJSTORE-*` line despite `count_gc_logs()` seeing that file, and every tick since ~19:52 logs `fetch of origin/main2 failed (offline?)` while my own push to the same remote succeeded. I deliberately ran no git repair in the root repo and messaged the maintainer suggesting a diagnostic job — a manual `gc` would clear the evidence without fixing the guard.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-warm-cache-yarn-install-state.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 89 tokens (4941342 cached reads)
- Output: 35955 tokens
- Cost: $4.5594470000000005
- Wall-clock: 533s

<!-- garden-usage-end -->
