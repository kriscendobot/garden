Landed `539395a494fe58f61ae483473d0e2be79cc3bb93` on `main2`.

- Budgets: ordinary 2400s; builder/web-builder, shepherd, conductor, review directive, panel/repanel, and botanist 7200s. Explicit `handler-timeout:` still wins.
- Recorded the CI-wait/panel-fan-out invariant in `skills/job-board/SKILL.md`.
- Fixed doom notices to capture the effective role budget before removing the job file.
- Fixed repeated `common.sh` sourcing to prepend `scripts/jobs/bin` only once.
- Audit found no uncovered direct `ci-wait-merge.sh` host. Gauntlet clean/fix stages are covered through the shepherd budget.
- Verification: handler-budget 12/12, role-budget 25/25, reaper-doom 8/8, deadline-nudge 34/34; comment-watcher, dependabot-watcher, and gauntlet suites passed; `bash -n` passed for every edited script. Timeout-classifier remained at its baseline 33 passes/3 known subtest-4 failures.

Self-improvement: updated `skills/job-board/SKILL.md` and `skills/panel/SKILL.md` with the shared budget table and structural invariant.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-handler-budget-role-defaults.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 658s

<!-- garden-usage-end -->
