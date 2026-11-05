---
gate: orchestrated
orchestrated_by: minion-town-first-users-orchestration-20261104
priority: normal
posted_by: producer
posted_at: 2026-11-05T00:00:18Z
---

---
requires: aws
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Reset the maintainer's own minion.town guest, then onboard it from root.** Authorization: maintainer kriskowal, 2026-11-04 ("wipe my guest, keep root"; journal message of that date). Delete ONLY the maintainer's guest data on production: pet names, published clips (unpublish), stored API keys; keep root and the `@agent`/`@host`/`@mail` structure. No other guest's data is authorized. **First identify which guest is the maintainer's** (not the `minion-mcp-test-cc` principal and not the canary/probe guests: the test principal currently holds 62 names including clip-*, weblet-*, prod-probe-*, pr53-power* and is a different identity); if it is ambiguous, STOP and ask via the maintainer inbox, changing nothing. Before deleting anything, snapshot the name list (names only, no secret values) into your report so a mistake is recoverable. Then recreate the guest empty by redeeming one of the coupons (or by a root-issued invitation, if coupon admission is not yet live) and verify the new account has no clips, so the shell shows the "+" add-clip button on first use. Report what was removed and what exists now. If the new-guest path fails, report the exact failure; do not recreate by any route that bypasses admission.

