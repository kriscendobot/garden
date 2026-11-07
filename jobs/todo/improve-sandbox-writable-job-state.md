---
posted_at: 2026-11-07T09:51:18Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/secrets/run-sandboxed.sh
scripts/secrets/run-sandboxed.sh:57 mounts the garden root read-only and lines 75–76 omit a writable per-job `GARDEN_STATE`, causing journal clone-lock EROFS and requeue exhaustion at 2026-11-07T02:13Z.
Create and bind a writable, isolated per-job state directory and export it as `GARDEN_STATE` inside the sandbox so agents need not manually apply the workaround.
