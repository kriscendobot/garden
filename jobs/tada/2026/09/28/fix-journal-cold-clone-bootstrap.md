Pushed to `main2` as `2976de78eb4`. Job complete.

## Completion report

**Problem:** `journal2` regrew to ~322 MiB / 29k commits, so a fresh single-branch clone over SSH couldn't finish inside the 45s `GARDEN_FETCH_TIMEOUT` cap (rc=124). Any worker with a missing clone dir (newly-scaled, or one the journal-contention watch rebuilt) logged `offline; skipping tick (rc=75)` forever and never claimed — the fleet ran a handful of jobs while dozens sat in `todo`.

**What I changed** (`scripts/jobs/common.sh`, `scripts/jobs/journal-contention-watch.sh`, `scripts/jobs/test/fetch-timeout-test.sh`):

1. **Local-object bootstrap** — `reclone_clone` now passes `--reference-if-able "$GARDEN_ROOT/.git" --dissociate` to the journal clone. The deployed root shares journal2's object store with the `journal/` worktree, so the borrow is a seconds-long local copy instead of a full network transfer; `--dissociate` copies the objects in so no dangling alternate remains. `-if-able` degrades to a plain network clone if the root is unusable, and the flag is guarded on a real `.git` **directory** (a linked worktree's `.git` file — and the test harness — exercise the plain path). The reference is read-only; git is never run *in* `$GARDEN_ROOT`.

2. **Separate cold-clone cap** — added `GARDEN_CLONE_TIMEOUT` (default 300s). `bounded_clone` uses it; `journal_fetch`/`bounded_fetch` keep the 45s fetch cap. A cold clone has no stale ref to protect, so it gets time to finish while a stale *fetch* still fails fast.

3. **Contention-watch rebuild** — already routes through `ensure_clone → reclone_clone`, so it inherits the reference path automatically; I updated its tick-budget math to size a rebuild by the clone cap.

4. **Tests** — added three subtests to `fetch-timeout-test.sh`: missing clone bootstrapped via `--reference-if-able` and dissociated within budget (+ worktree-file guard skips the flag and still clones); a cold clone exceeding the old 45s cap but within the new one succeeds; an incremental fetch still fast-fails at the fetch cap.

**Verification:** `fetch-timeout-test.sh` → 28 passed / 0 failed; `journal-contention-watch-test.sh` → PASS; `bash -n` + `shellcheck` clean on both scripts. Committed and CAS-pushed to `main2` (`2976de78eb4`).

**Follow-ups:** none required. Note `bounded_clone`'s other callers (triager, clone-keeper bare project clones) now also get the larger cold-clone timeout — intended, since those first clones are likewise cold.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-journal-cold-clone-bootstrap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2658233 cached reads)
- Output: 27244 tokens
- Cost: $3.0954364999999995
- Wall-clock: 537s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
