---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
`scripts/jobs/gauntlet.sh:276-316` checks only the REST latch before issuing `gh pr view`, despite the GraphQL quota latch logged at 08:36:15; this produced the doomed rate-limited metadata read at 08:50:11. Gate the metadata read on the GraphQL latch while retaining REST comment delivery, and capture/classify `gh pr comment` failures so primary REST exhaustion opens the shared REST cooldown before persisting the existing pending receipt.
