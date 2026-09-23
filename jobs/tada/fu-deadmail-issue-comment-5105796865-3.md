Both commits are on `origin/main2`; working tree clean; inbox drained.

## Report

**Job:** fix `run-test.sh`'s shared test root; triage the ~30 failures that made the suite red by default on `main2`.

**Result: `bash scripts/jobs/test/run-test.sh` → RESULT: 367 passed, 0 failed (exit 0).** Baseline on a clean checkout was 336 passed / **30 failed**.

### 1. Private per-invocation test root (`scripts/jobs/test/run-test.sh`)
`TR=/home/kris/.garden-test` was one fixed path per host and the harness's first act is `rm -rf "$TR"` — two concurrent runs (two gardeners on a `run-…` job, or a maintainer beside one) deleted each other's bare journal, clones and state mid-flight. Each run now gets its own `mktemp -d` root; the leaf stays literally `.garden-test` so common.sh's `_in_test_context` (`*/.garden-test/*`) heuristic still fires. `GARDEN_TEST_ROOT` pins a fixed path, `GARDEN_TEST_KEEP=1` keeps a passing run's root (a failing run always keeps it and prints where) — both read before the `GARDEN_*` scrub that would strip them. The base is **exec-probed** (this container's `/tmp` is `noexec`, which makes `[ -x fixture ]` false and broke the preflight-gate subtests), falling back through `/var/tmp` → `$HOME`; the temp name is dot-prefixed so a `$HOME` fallback stays inside the root's `/.[!.]*` ignore rule.

### 2. Root cause of 22 of the 30: a stale-base clobber, still live in production
`a0cd3eae13` (2026-07-21) rewrote `common.sh` from a stale base and deleted 264 lines of unrelated landed work — **seven helpers, four still called by live scripts**, broken for a week:
- `bounded_fetch` → called by `clone-keeper.sh:203`, `root-repo-guard.sh:248` (`command not found` — those fetches simply failed)
- `tada_failed` → `orchestrate.sh:77`, `unblock.sh:148`: a **declined blocker silently satisfied its dependents** instead of holding them
- `is_explicit_cap_signature` → `gardener.sh:943`: an explicit session-cap lost its exemption from the elapsed floor (the 2026-07-17 misclassification shape)
- `clone_is_corrupt` / `reclone_clone` / `_fetch_stderr_is_corrupt` / `_fetch_stderr_corrupt_signature`: the corrupt-clone self-heal — `sync_clone` died every tick instead of re-cloning

All restored verbatim, with `ensure_clone`'s inlined temp-clone folded back into `reclone_clone`. a0cd3eae13's own feature is intact (`journal-remote-origin-rewrite-guard-test` 24/24).

### 3. The remaining 8, each repaired at its real cause
- **3** — SUBTEST 14d asserted the foreman target default of 3; kriskowal raised it to 5 on 2026-07-03 (`90ec626131`). Fill arithmetic now runs against a pinned target; the shipped default is asserted separately.
- **2** — SUBTEST 26 fixtures were one column short (`closed_at` was added to the source TSV contract), so the issue **body** landed in the `url` field. Widened + arity guard.
- **2** — SUBTEST 26 case G pinned gh-stub payloads to literal 2026-06-27 dates; `issue-source-gh.sh` clamps to a 24h window, so the handler emitted nothing. Timestamps are now relative.
- **1** — the `gh` wrapper tripped SC2016 on a backticked operator hint; annotated as literal prose.

Also fixed: SUBTEST 22 ended with `unset JOURNAL_REMOTE`, so SUBTEST 24's corruption cases let `ensure_clone` resolve the **real** kriskowal/garden journal and re-clone ~20s of production history over the fixture. Restored to the throwaway `$BARE`.

### Two adjacent suites reconciled (both were red)
- `fetch-timeout-test.sh` asserted a superseded **two-tier** heal; the implementation was deliberately simplified to always-re-clone the same day (`6f8501d8db`) and `run-test.sh` SUBTEST 24 was written against that. Rewritten, history recorded → **16/16**.
- `elapsed-constancy-classifier-test.sh` case (g) ran `git log | grep -q` under `set -o pipefail` — grep exits at the first hit, git dies of SIGPIPE, pipefail calls it a failure, so it reported "commit reason missing" while printing the log containing it → **35/35**.

**Evidence (real runs, this host):** run-test 367/0; fetch-timeout 16/16; elapsed-constancy 35/35; clone-keeper, root-repo-guard, orchestrate, claude-session-limit-classifier, journal-remote-origin-rewrite-guard, journal-worktree-keeper, stale-lock, producer-arg-guard, project-worktree-isolation, `tests/checks/run.sh` — all PASS (several were red before).

**Commits pushed to `main2`:** `da2572a260` (common.sh restore + suite reconciliation), `2ec833e546` (private root + the 30-failure triage).

### Follow-ups (not done)
1. **The fleet is still running the clobbered `common.sh`** — the deployed root only advances via the deliberate `deploy-garden.sh`. Until then `clone-keeper`/`root-repo-guard` fetches fail, declined blockers auto-promote dependents, and corrupt journal clones don't self-heal.
2. **~30 sibling test scripts still hardcode shared roots** (`/home/kris/.garden-<name>-test`) — same collision class as the bug just fixed, for any two workers running the same script. Mechanical, but out of this job's scope.
3. **The shared `/home/kris/garden2/.git` is unhealthy** on this host: `fatal: unable to read 9ad05cc3563a…`, `failed to run repack`, plus a dozen `tmp_pack_*` leftovers from interrupted repacks. My commits landed, but auto-gc is wedged. I did not touch the root repo (per the standing rule) — this looks like root-repo-guard / sysop work.
4. A stale `/home/kris/garden2/.garden-test` from 2026-07-03 is still on disk (gitignored); left in place.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-deadmail-issue-comment-5105796865-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 313 tokens (25686340 cached reads)
- Output: 78246 tokens
- Cost: $17.07762
- Wall-clock: 1446s

<!-- garden-usage-end -->
