In `scripts/jobs/triager.sh`, the bare-clone fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) hard-`die`s (exit 1) on a transient/terminated fetch. Observed failure: the `git fetch` subprocess was SIGTERM-killed ("Terminated" in the log) and the script then printed `FATAL: fetch failed for kriscendobot-agoric-3-proposals`, failing the `garden-triager@kriscendobot-agoric-3-proposals` unit (exit 1) and driving a systemd restart loop (the cursor is not advanced, so the same tick recurs). A transient fetch failure (network blip, DNS, or a slow/large-repo fetch reaped by a timeout — agoric-3-proposals is large) must not wedge the unit. Change line 117 to mirror the transient-network handling already used by the self-provision path just above it (lines 94–105): on fetch failure, `log "WARN: …"` + throttled `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "$msg"` + `exit 0` so the next tick retries cleanly instead of `die`. Keep the message specific (fetch for `$slug` at `$BARE` failed, retried next tick; persistent failure means the upstream is unreachable). This makes the fetch step consistent with the file's stated design invariant that a transient network failure is never a hard die that crash-loops the unit.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-19T11:43:10Z
