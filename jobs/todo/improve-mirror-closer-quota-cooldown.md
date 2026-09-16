---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
Persist a GitHub-primary-quota cooldown after the first refusal and skip subsequent timer ticks until the reset window, rather than issuing one known-doomed GraphQL request every five minutes. This will eliminate recurring rate-limit warnings while preserving unresolved mappings for a post-reset retry.
