Completed Kimi accounting and journal backfill.

- Attributed exactly $64.00 / 6,400¢ across 28 token-bearing Kimi engagements using deterministic largest remainder; 14 zero-token quota/outage attempts receive $0.
- Added 24 append-only reputation invoice adjustments; four token-bearing failed attempts remain documented in the allocation report without finalized reputation events.
- Added durable tier-review carry-forward and a full allocation/effectiveness report on `journal2` (`7c08e423`).
- Landed append-only adjustment support on `main2` (`08266cad`).

Verification: adjustment-specific reducer checks passed; the broader auction test still has unrelated routing/claim failures.

Follow-up: deploy `main2` so the journal reducer consumes invoice adjustments; retain Kimi disabled pending matched mentor-tier trials.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-kimi-64-dollar-accounting.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 434s

<!-- garden-usage-end -->
