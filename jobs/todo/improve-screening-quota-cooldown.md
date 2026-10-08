---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/screening/driver.py
scripts/jobs/screening/driver.py:32 invokes `gh` directly, bypassing the host-wide primary-quota admission/cooldown; after the 04:54:23 quota exhaustion, the 04:55:19 screener tick failed fatally. Route its GitHub reads through a hardened, cooldown-aware script interface and treat a live/exhausted quota as a quiet deferred tick with no state write, while retaining fatal handling for malformed responses.
