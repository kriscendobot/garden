Assessed the merged #52 deviation and current PR set. Register-by-id is settled: #53 preserved that architecture, received maintainer approval, and validated it in production. No maintainer question was needed.

Opened draft PR kriscendobot/minion.town#63 at commit `c469723`, reconciling the design with the owner-pinned `sites` facet, operator registry, content-plane serving, and remaining upgrade/powers/restart-durability gaps.

Verification: `git diff --check` passed; Mermaid parsed as `flowchart-v2`; GitHub `test` passed in 35s.

Follow-up: design gauntlet/review for #63. Live upgrade, powers bootstrap, always-on real-daemon CI, and restart durability remain future implementation work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-press-20260828-173506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 462s

<!-- garden-usage-end -->
