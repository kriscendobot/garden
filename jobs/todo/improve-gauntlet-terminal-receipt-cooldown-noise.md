---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
`gauntlet.sh:271-273` emits one WARN per terminal receipt when the shared GitHub API cooldown rejects reads; two redundant warnings occurred at 07:53:01 and 07:53:11. Pre-check `api_cooldown_active rest` before the comment lookup, matching `retry_terminal_pending`, and defer silently because the cooldown owner already logs the actionable quota warning. Add a hermetic test that multiple terminal receipts during cooldown create pending records without per-gauntlet warning spam.
