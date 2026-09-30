---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Fix: the claim gate's Claude utilization is not per-subscription.**

In `subscription_used_percent` (`scripts/jobs/usage-meter.sh` ~L1030), the primary source is the newest anthropic `rate_limit.seven_day.utilization` row across all of `journal/usage/*.jsonl`. It **does not filter by subscription.** The usage rows carry `host` but no pool or subscription. So `claude-endolin1` and `claude-endolin2`, which are different accounts on different hosts, both read whichever host reported last. On 2026-09-30 at 03:5xZ both read 57%, while the dashboards showed 73% and 58%.

**Why this is urgent:** the maintainer's standing policy is to stop at 90% utilization (`config/token-backoff-fraction` = 0.90). As of 2026-09-30 the fleet is deliberately spending both subscriptions up to 90% by about 12:00Z. With the shared reading, claude-endolin1 can overshoot to its hard cap while it reads claude-endolin2's lower figure.

**Fix:**
- Filter ledger rows to hosts that `config/subscription-mapping` maps to the subscription (anthropic provider, monk or gardener kinds). Or stamp the subscription onto usage rows at write time and filter on that.
- Keep the fallbacks (budget/live used_percent, manual checkpoints).
- Add a regression test with two subscriptions on two hosts reporting different utilizations.
- Land direct to main2.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:22:43Z
