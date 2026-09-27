Landed `05e02d8f4d1` on `main2` and closed the review-miss cluster.

- Added exact-head panel freshness sensing and completion gating across all PR-touching roles.
- Stale heads now receive a durable `review required` disposition without mutating the PR or automatically starting a gauntlet.
- Panel records now retain the full reviewed commit.
- Re-litigation flags PR #475 (`b28bb1fc3 → a4767d542b`), #858 (`7d23bf082 → 1ec375e2`), and #1226 (`4e1696a4 → 8515b8cdef`).
- Equal-head and metadata-only controls pass; metadata commits conservatively require review.
- All focused sensor, completion, panel-record, and draft-guardrail tests passed.

Self-improvement: `roles/COMMON.md`, `skills/panel/SKILL.md`; encoded the fleet-wide exact-head freshness contract.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-post-gauntlet-fixer-change-unreviewed.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 908s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
