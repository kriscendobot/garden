Implemented and pushed the bounded qwen3.6 mentor trial to `main2` (`b504cf3c8f`).

- Added six explicit, single-use canary slots, serialized fleet-wide.
- Kept `qwen3.6` classified `local/minion`; ordinary mentor auctions remain inaccessible.
- Added separate `hermit-mentor-trial/local/qwen3.6` reputation attribution.
- Reused the existing guarded capability probe and verified demerit mechanism.
- Added automatic stops at two demerits, or ≥25% after three attributable outcomes.
- Added posting/status tooling, operating documentation, and cost-aware rationale.
- Verified: trial tests 17/17, capability-probe tests 22/22, worker-spine tests 290/290, checks tests 10/10.
- The aggregate dry-run gate reports unrelated pre-existing CLAUDE.md inventory drift.
- Follow-up: maintainers may curate slots 1–6 and explicitly review the resulting arm before any tier change.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/qwen-mentor-tier-trial.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1377s

<!-- garden-usage-end -->
