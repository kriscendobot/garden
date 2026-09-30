---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ci-wait-merge.sh
scripts/jobs/gardening/ci-wait-merge.sh:463 treats GitHub Actions account-billing startup failures as ordinary CI red; at 2026-09-30T10:13:35Z this left the gauntlet agent to discover and hand off the payment-limit blocker, then failed its follow-up gate. Add deterministic recognition of the Actions “payments failed/spending limit” failure and emit a durable maintainer escalation plus a distinct blocked result, so the gauntlet is parked cleanly without agent discretion.
