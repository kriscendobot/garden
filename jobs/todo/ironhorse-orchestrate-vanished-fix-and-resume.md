---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch) AND endojs/endo-but-for-bots (journal board operations)

# Fix the orchestrate.sh "vanished from the board" race, then resume the Ironhorse test262 campaign

## Part 1 — diagnose and fix the race (garden-infra, `main2`, direct commit)

`ironhorse-test262-implementation-completion-resume-2` halted at child 1/22
(`ironhorse-js-07-promises-async-functions`) with reason "vanished from the
board" — `orchestrate.sh`'s `child_failure_detail` fallback (the child was in
none of `todo/`, `doin/`, or doomed-`plan/`). The job in fact completed
successfully (`jobs/tada/ironhorse-js-07-promises-async-functions.md` exists,
with substantive test262 coverage gains, 0 failures) — its `tada` commit
landed *before* the halt commit in journal history. This points to a
sync-timing race: the watcher's tick evaluated the child's state in the
narrow window between its doin→tada transition, found it in neither state,
and treated a genuinely-completing job as failed.

This is a **different bug** from the already-fixed stall-misdetection
(`requeue count rose from` → `has_productive_cycle_hint`, verified live and
correct — don't touch that fix). Diagnose the actual root cause in
`child_state`/`child_failure_detail`'s interaction with `sync_clone` — the
likely fix is re-syncing (or re-checking after a short bounded retry) before
concluding "vanished," rather than treating a single stale-clone read as
terminal failure. Land the fix on `main2` from an isolated per-job worktree
(garden-infra convention, no PR). Cover it with a regression test
(`scripts/jobs/test/orchestrate-test.sh` or wherever the existing
stall-detector regression coverage lives) that reproduces the race
deterministically rather than relying on real timing.

**Deploy it.** `orchestrate.sh` runs as a leader-only singleton
(`endolin-garden2-5bcdff64`). Land the fix on `main2`, then ensure it's
actually deployed on the leader — if you're not claiming this job on the
leader itself, trigger the deploy via the sysop `deploy` op
(`scripts/jobs/send-host-op.sh endolin-garden2-5bcdff64 op=deploy
authorized_by=kriskowal`; the maintainer has already authorized this shape of
action this session) rather than landing an undeployed fix a third
false-halt could occur under.

## Part 2 — resume the campaign, with an honest remaining-budget figure

The original campaign budget was **2,080,000 tokens**, calibrated 2026-08-11
against that week's quota (resets Friday 2026-08-15 21:00 Pacific — still
the current window). Two orchestration attempts (`resume`, `resume-2`) have
already run real, budget-consuming children (`js-06` through `js-07`, and
whatever else was in flight) under that original figure. **Do not blindly
reuse 2,080,000 for a third launch** — that would let the campaign spend
against the same allocation three times over. Instead:

1. Compute actual cumulative spend so far across the WHOLE campaign: sum
   `usage/ironhorse-js-*.jsonl` (all stages, all their gauntlet sub-jobs) for
   billable tokens, the same aggregation the budget mechanism itself already
   does per-campaign.
2. Subtract from 2,080,000 to get the true remaining allocation for this
   third launch.
3. Verify the 21 remaining children (`ironhorse-js-08-async-generators-for-await`
   through `ironhorse-js-28-issue-summary`) are still correctly staged in
   `jobs/plan/`, `gate: orchestrated`. Re-recover from git history only if
   anything has drifted since the last recovery — don't redo work that's
   already correct.
4. Launch: `post-orchestration.sh --serial --on-child-failure halt
   --budget-tokens <remaining-figure>` under a fresh base
   (`ironhorse-test262-implementation-completion-resume-3`), the 21 children
   in original order.

## Report

State plainly: the root cause found and the fix landed, the deploy
confirmation, the actual remaining-budget figure computed (show the
arithmetic), and confirmation the resume-3 launch succeeded (or, if the fix
needs more time than this job's budget allows, land and deploy Part 1 and
report Part 2 as a clean, explicit follow-up rather than launching against an
unfixed watcher.

<!-- garden-reaped: 0 -->
