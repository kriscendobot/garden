---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:6628 logs an expected quota-preserving deferral as WARN, feeding the healthy 2026-10-25T02:24:25Z skip into the mentor failure digest. Downgrade the successful once-per-reset deferral to non-warning severity and test that it stays out of `journalctl -p warning`.
