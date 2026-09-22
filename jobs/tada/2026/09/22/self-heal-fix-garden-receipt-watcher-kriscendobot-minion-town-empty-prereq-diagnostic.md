Pushed cleanly to `main2`. Both fixes are landed and verified.

## Completion report

**Job:** Guard the receipt-watcher's misleading "see prerequisite stderr above" die() when the captured stderr is empty — and audit the underlying silent-exit root cause.

**What I did:**

1. **Guarded the die() message** (`scripts/jobs/receipt-watcher.sh`, ~line 89). The prerequisite-failure path now branches on `[ -s "$PREREQ_ERR" ]`:
   - **Non-empty capture** → unchanged behavior (`sed`-prefix the diagnostic, then die with "see prerequisite stderr above").
   - **Empty capture** → logs a distinct fallback line `  prerequisite: (no diagnostic captured — subshell exited rc=N with empty stderr; likely an unclassified set -e exit in ensure_clone/sync_clone/journal_fetch)` and dies with a message that references *that* line instead of falsely claiming text exists above. The next occurrence is now triageable from the self-heal capture instead of reproducing today's dead end.

2. **Found and fixed the actual root cause** (`scripts/jobs/common.sh`, `clone_lock`, line 3842). The flock-timeout branch ran `exec {fd}>&- 2>/dev/null || true`. An `exec` carrying only redirections applies them **permanently** to the (sub)shell — so the `2>/dev/null` silenced stderr for the rest of the run. On the lock-contention path, the subsequent `die` at line 3848 (and the interim `log`s) then wrote to nowhere, yielding rc=1 with an **empty** `$PREREQ_ERR` under the watcher's `( ensure_clone; sync_clone ) 2>"$PREREQ_ERR"` capture — exactly the production symptom. Dropped the `2>/dev/null` (matching the explicit NOTE comments already carried by `clone_unlock` / `cursor_io_lock` / `cursor_io_unlock` warning against precisely this hazard); the fd was just opened successfully at line 3835, so closing it is clean and needs no suppression.

**Verification:**
- `bash -n` clean on both files.
- `receipt-watcher-test.sh`: 10/10 pass (incl. "structural journal failure stays loud with its diagnostic").
- `clone-keeper-test.sh`: 47/47 pass.
- `stale-lock-test.sh`: 8/9 — the single SUBTEST 5 failure ("cursor-set remained wedged on stale ref lock") **pre-exists on baseline HEAD**, confirmed by re-running the unmodified `common.sh`; not a regression from this change.

**Commit:** `06690f63fa` pushed to `main2`.

**Follow-ups:** The `stale-lock-test.sh` SUBTEST 5 pre-existing failure is unrelated to this job but worth a separate look. No other follow-ups; the specific silent-exit class this job worried about is now both diagnosable (the guard) and, in the one concrete instance identified, eliminated (the exec fix).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-minion-town-empty-prereq-diagnostic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (955750 cached reads)
- Output: 10476 tokens
- Cost: $1.282205
- Wall-clock: 196s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
