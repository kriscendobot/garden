scripts/jobs/reaper.sh
Both poison-alert paths (reaper.sh:647-649 and 660-662) pipe into `poison-notice.sh` with `>/dev/null 2>&1` and, on failure, only `log "WARNING: could not surface ... poison job '$pbase' to maintainer inbox"` — then fall through and `break` (line 665), permanently dropping the alert. This defeats the safety mechanism: the poison job is parked in `plan/` (held) but the maintainer is never told, so a deterministically-overrunning job like `xs2rust-endor-stage8-boot-surface-remainder` (the 00:15:19 WARNING in the tail) silently disappears from human view. Harden by (a) capturing `poison-notice.sh`'s stderr to a tmp file and including its first line in the WARNING so the cause (push race, missing maintainer inbox, bad sender) is diagnosable, and (b) not swallowing the failure permanently — retry the notice across the reaper's existing push-attempt/backoff budget, or record the un-surfaced poison to a durable spool the next tick re-drains, so a transient failure to reach the inbox doesn't lose the only signal that a job is stuck.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  worker_kind: gardener
  claimed_at: 2026-07-18T00:22:30Z
