---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/panel-run-record.sh
Add an idempotent, CAS-safe migration that recognizes legacy `ssh---git-github.com-*` panel-run directories and moves their records into the canonical owner-repo-PR directory, preserving history and refusing collisions with differing content. This reunites the already-split records without relying on an agent to perform a one-time journal cleanup; cover it with a regression test.
