---
orchestration-failed: true
---
Recovered and verified prior durable work:

- Commit `3ef146ede` added exact-input and submodule-free VM regressions; merged in PR #1088.
- Causal oracle-buffer fix `7fae4aea2f` already covered this crash class.
- Artifact hash matched; fresh VM regression passed; PR checks were green and the case was documented.
- No new code changes were needed.
- Follow-up: the queued gauntlet was overtaken by the PR merge and could not complete its pre-merge gate.
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ab889c8f6184c60d-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 1999s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
