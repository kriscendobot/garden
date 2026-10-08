---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-restart.sh
scripts/jobs/deploy-restart.sh:147 logs and defers a failed concurrent restart; `garden-monk@3.service` failed at 2026-10-08T03:38:46Z. Add bounded, delayed per-unit retry with final failure accounting so transient systemd restart races recover during the deploy.
