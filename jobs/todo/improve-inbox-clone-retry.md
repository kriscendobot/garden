---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/inbox-read.sh
Retry a transient initial journal-clone failure with bounded backoff before giving up. A failed inbox clone currently makes the gardener silently skip its one inbox drain (`|| true`), risking an in-flight job missing its directed message entirely.
