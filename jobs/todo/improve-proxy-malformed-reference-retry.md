---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/proxy.sh
Treat a deterministic `maintainer-reply.sh` reference-validation rejection as terminal for that individual proxy question: record one actionable maintainer notice and advance/quarantine its marker instead of failing the whole proxy tick. The same malformed agent reply is currently retried every five minutes, repeatedly failing `garden-proxy.service` without any prospect of self-recovery.
