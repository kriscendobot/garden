---
posted_at: 2026-11-06T02:06:35Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
tier: mentor
dispatch: automatic
---
Maintainer directive (kriskowal, liaison muster 2026-11-06): watchdog notices in the maintainer inbox should be triaged automatically no later than the start of a muster.

Add a deterministic, no-LLM pre-pass, `scripts/jobs/muster-autoarchive.sh`, and have the liaison muster procedure (roles/liaison/AGENT.md § Muster, pass 1) run it before the compact pass. It archives, via maintainer-archive.sh, every unread maintainer-inbox message from `watchdog:*` senders that is non-actionable: (a) `recovered: true` or a RECOVERED body; (b) `budget-level-*` keys (informational worker-target changes); (c) any keyed notice whose `last_seen` is older than 24h; (d) journal-lock-contention / push-contention notices with notice_count <= 6 and last_seen older than 2h. It must never archive a notice with `notice_count` growing in the last 2h unless it matches (a) or (b), and must skip any key listed in an optional journal file `muster/autoarchive-skip` (one watchdog_key prefix per line) so the maintainer can pin a tabled matter. It prints a count by rule, not a list. Add a test under scripts/jobs/test/, run it, and push to main2 directly.

Also consider whether the watchdog emitter should stop sending class (b) to the maintainer inbox at all; report your finding in the completion report rather than changing the emitter.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-06T02:33:13Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-06T02:33:27Z
