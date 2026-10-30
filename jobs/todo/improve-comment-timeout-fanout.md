---
posted_at: 2026-10-30T06:50:56Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1960 failed to open its shared cooldown when five distinct sources timed out from 06:47:38Z through 06:48:56Z; every source instead logged only a local strike. Harden the host-wide fanout ledger and threshold path so concurrently running watcher instances reliably share and trip one cooldown, and add a concurrent-instance regression test.
