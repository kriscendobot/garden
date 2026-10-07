---
handed-off: improve-journal-deepen-retry-split
deliverable-complete: false
---
I've parked a single child job and recorded the orchestration that will run it. The post-orchestration script confirmed it recorded the orchestration after one lost push race. Writing the report now.

I've handed this job off to `improve-journal-deepen-retry-split`. I didn't implement anything in this claim: the split protocol asks for decomposition only. The successor holds a single child job, because the work doesn't divide into independent pieces.

**Why it's one child, not several:** the change is confined to `journal_deepen_from_root` in `scripts/jobs/common.sh` (around line 5086). It also needs `_journal_root_seed_fetch` to pass git's error output through, and tests in the one test file `scripts/jobs/test/journal-clone-seed-from-root-test.sh`. Those three parts depend on each other, so any split leaves either code without tests or tests without code. My guess is that the earlier 2400s overrun came from running the full test suite, so the child brief says to run only that one test.

**What's now on the journal:**
- **Child job `improve-journal-deepen-retry-expanded-window`:** parked in `plan/`, run by the orchestration, with the indivisible reason recorded and a 5400s time limit. Its brief asks for:
  - up to 3 retries of the local `--unshallow` fetch, with short randomized waits, only when git fails on a root-repo lock or contention error;
  - the final git error message added to the existing warning line;
  - the existing shallow fallback and return codes unchanged;
  - three targeted tests (lock error then success, lock error every time, non-lock error with no retry) with the wait set to zero so they run fast.
- **Orchestration `improve-journal-deepen-retry-split`:** serial, one child, halts if the child fails. Its description records the same reason and the 5400s limit.

I took both records from the scripts' own success messages. I didn't separately read the parked files back from the journal.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-deepen-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 12 tokens (274647 cached reads)
- Output: 3352 tokens
- Cost: $0.47139339999999996 (1 engagement(s) unpriced)
- Wall-clock: 2465s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
