In `scripts/jobs/triager.sh` line 117, the main-line bare-clone fetch hard-dies on any failure:
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`.
Observed failure signature (garden-triager@kriscendobot-finbot, exit 1): the fetch was SIGTERM'd (`Terminated`) — a hung/reaped fetch — and `die` then printed `FATAL: fetch failed for kriscendobot-finbot` and exited 1, marking the unit failed and triggering self-heal.

A transient fetch failure (network blip, DNS, half-open connection reaped by a timeout, a slow fetch SIGTERM'd) is exactly the environmental condition every OTHER branch in this file handles gracefully. Make the fetch consistent with them: on fetch failure, do NOT `die` — instead `log "WARN: ..."`, `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "<msg>"` (throttled per dedup key, so a blip alerts at most once per window), and `exit 0` so the next tick retries. This mirrors the self-provision-clone-failed branch (l.95–104) and preserves the file's stated invariant that a missing/unreachable clone "must never be a hard die." Optionally also bound the fetch with a timeout so a hung fetch is reaped deterministically by the script rather than by systemd's SIGTERM. Keep the genuine, non-recoverable errors (ref resolution l.130, malformed SHA l.137) as `die`; only the network fetch should degrade to skip-and-retry.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-18T00:44:18Z
