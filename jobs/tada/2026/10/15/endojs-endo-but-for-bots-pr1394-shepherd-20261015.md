---
handed-off: endojs-endo-but-for-bots-pr1394-shepherd-20261015-split
deliverable-complete: false
---
**Completion report: `endojs-endo-but-for-bots-pr1394-shepherd-20261015` (overrun split)**

The original shepherd job ran past its 2400s time limit once, so this claim only split it. I made no changes to PR #1394.

**CI on #1394 right now** (head `6f3185b487`, base `build/sturdyref-marshal-representation-6976bb0`): 24 checks pass, 10 are skipped, and only **`test-thixotrope-ironhorse`** fails (20m17s, run 38766969048 / job 116533087683). The checks that failed earlier — viable-release smoke publish, test, cover, matrix.check, format-ironhorse and test-async-hooks — are no longer failing; each now passes or is skipped.

**Decision: the work can't be split into parts.** Shepherding is one CI loop on one head branch. Every fix or re-run has to wait for the ~20-minute failing check, one after another, so there is nothing to run in parallel.

**What's on the journal now** (checked against fresh `origin/journal2`):
- **Child job, parked:** `jobs/plan/endojs-endo-but-for-bots-pr1394-shepherd-20261015-expanded-window.md`
  - gate is `orchestrated`, owned by `…-split`
  - `handler-timeout: 7200`
  - the indivisible reason is recorded in the job file (`split-indivisible-reason`)
  - its body is a shepherd task:
    - focus on the one failing check and decide whether the PR caused it or it's an existing flake
    - re-run it if it's a flake; otherwise make a minimal fix on the head
    - no rebase and no base change
- **Orchestration record:** `jobs/orch/endojs-endo-but-for-bots-pr1394-shepherd-20261015-split.md`
  - serial, halts if the child fails
  - its description repeats the same `split-indivisible-reason` and `split-indivisible-handler-timeout: 7200`

**Follow-ups:** none beyond the child job, which the orchestrate watcher will release.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-shepherd-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 14 tokens (359799 cached reads)
- Output: 3000 tokens
- Cost: $0.5293998 (1 engagement(s) unpriced)
- Wall-clock: 2465s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
