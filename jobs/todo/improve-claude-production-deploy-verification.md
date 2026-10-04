---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
deploy/aws/scripts/deploy-app.sh
deploy/aws/scripts/deploy-app.sh:302 accepts a deployment after only `/healthz` and binary checks; the 2026-10-04T16:22:52Z canary found the live unit still lacked `ENDO_CLAUDE_*`, had `MemoryMax=256M`, and returned 404. Add a feature-gated post-restart assertion that verifies the rendered unit environment, `MemoryMax=1G`, enabled wiring log, and non-404 `/account/claude/<nonce>` route, failing and preserving diagnostics when the deployed revision requires Claude support.
