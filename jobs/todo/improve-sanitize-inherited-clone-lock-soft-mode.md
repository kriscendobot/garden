---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/self-heal-run.sh
scripts/jobs/self-heal-run.sh:142 passes inherited `GARDEN_CLONE_LOCK_SOFT` into every wrapped service; the 18:39:06 bulletin and 18:39:48 orchestrate warnings show mandatory journal syncs incorrectly abandoning as “OPTIONAL.” Sanitize clone-lock soft-mode variables from the handler environment, leaving scripts that explicitly scope soft acquisition unaffected.
