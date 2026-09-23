Implemented and pushed commit `c2cf72c017` to `main2`.

- Blocked plan jobs now reject ordinary promotion; only `unblock.sh --unblock` can release them.
- Serial orchestration leaves re-parked blocked children untouched.
- Added promotion and end-to-end orchestration regression coverage.
- Verified: gate tests 9/9, orchestration tests 78/78, full job suite 386/386.
- Self-improvement: updated `skills/job-board/SKILL.md` with the artifact-unblock promotion contract.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-blocked-gate-refusal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 562s

<!-- garden-usage-end -->
