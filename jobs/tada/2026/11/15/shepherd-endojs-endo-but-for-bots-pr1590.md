I found nothing to fix on PR #1590. CI on the head commit is already green, and the "cancelled run" in the job was a duplicate that had already been replaced.

**What happened.** The push of head `8d98a2e8` at 2026-11-14T15:22:02Z fired every workflow twice. A concurrency group cancelled one copy of each pair within 1–2 seconds, and the other copy ran to completion:

| Workflow | Cancelled duplicate | Run that completed (same commit) |
|---|---|---|
| CI | 43609796147 | 43609796328, success on attempt 2 |
| Floot Android | 43609796142 | 43609796146, success |
| IronHorse oracle sanitizers | 43609796201 | 43609796254, success |
| Test project mutual dependency versions | 43609796203 | 43609796300, success |
| OCapN Guile interop | 43609796177 | 43609796243, success |
| Workflow security audit | 43609796228 | 43609796233, success |

**Current state.**
- Every substantive check passed, including all four `test` jobs (Node 22/24 on ubuntu and macOS), both `cover` jobs, `lint` and `viable-release`. The rest are skipped by path filters.
- GitHub reports the PR as `MERGEABLE` / `CLEAN`.
- I ran the gauntlet's own CI check (the latest-checks filter in `ci-wait-merge.sh`) on the live check list. It discards cancelled runs that a later run of the same workflow replaced, and it reports 26 SUCCESS and 10 SKIPPED with no failures. The automation treats the PR as green, so the Phase 4 child is not blocked on CI.
- The bare `cover`, `test`, `test-async-hooks` and `viable-release` entries still show as failed in `gh pr checks`. They are leftovers from the cancelled duplicate. Those runs never got as far as expanding their test matrix, so their names don't match the completed jobs.

**What changed.** Nothing: no commits, pushes, PR comments or reruns. I didn't rerun 43609796147 just to clear those leftover entries from the GitHub page. It would take about an hour of CI and isn't needed for the automation's verdict.

**Follow-ups.** None. The PR stays draft, and its un-draft step is left to the gauntlet.

next: none (cancelled duplicate runs, replaced by successful runs: CI 43609796328, Floot Android 43609796146).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1590.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 68 tokens (2295343 cached reads)
- Output: 11694 tokens
- Cost: $2.2674846
- Wall-clock: 4283s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
