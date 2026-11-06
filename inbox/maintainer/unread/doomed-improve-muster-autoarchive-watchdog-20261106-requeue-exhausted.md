from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T02:44:20Z
doom_base: improve-muster-autoarchive-watchdog-20261106
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T02:44:20Z
last_seen: 2026-11-06T02:44:20Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-muster-autoarchive-watchdog-20261106; it stays HELD until a human promotes it
(promote-plan.sh improve-muster-autoarchive-watchdog-20261106) or removes it, so nothing is lost.
Original job base: improve-muster-autoarchive-watchdog-20261106

--- original job body ---
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
