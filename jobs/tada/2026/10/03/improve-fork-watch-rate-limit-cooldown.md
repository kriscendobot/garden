Implemented and pushed commit `0dda6234be6` to `main2`.

- Routed fork-watch upstream probes through `gh_api_retry`, enabling the fleet-wide GitHub API cooldown.
- Preserved fail-open handling for inconclusive probes.
- Added regression coverage proving a primary-quota HTTP 429 arms the shared cooldown and suppresses sibling pollers.
- Verification: fork-watch suite passed 78/78; gh-api retry suite passed 61/61; Bash syntax and diff checks passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-rate-limit-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 182s

<!-- garden-usage-end -->
