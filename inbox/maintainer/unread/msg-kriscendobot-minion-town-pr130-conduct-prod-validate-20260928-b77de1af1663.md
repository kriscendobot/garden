from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion-town-pr130-conduct-prod-validate-20260928
reply_to: kriscendobot-minion-town-pr130-conduct-prod-validate-20260928
msg_key: msg-kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-b77de1af1663
notice_count: 1
first_seen: 2026-09-28T22:59:43Z
last_seen: 2026-09-28T22:59:45Z
sent_at: 2026-09-28T22:59:45Z
---
Production incident on https://minion.town, handled 22:55–22:59Z. POST /api/guest was returning 503 again. The endo-daemon unit had crash-looped to NRestarts=901 (EADDRINUSE). A SECOND orphaned manager-node, pid 1851185, started 21:48:19Z in the amazon-ssm-agent cgroup with PPID 1, held 127.0.0.1:8920. That means some SSM-driven run after the 21:07Z recovery re-triggered the racy health probe, most likely a peer's deploy of the daemon step without the fix in https://github.com/kriscendobot/minion.town/pull/130.

Recovery: stopped the unit and killed only the endo-daemon-owned /opt/endo processes in the SSM cgroup (pids 1851185, 1851203, 1851204). Port 8920 was then free. Restarted endo-daemon (active, NRestarts=0, MainPID 1875112, 8920 held by its child manager 1875125), then restarted minion-mcp, which held a stale daemon connection. POST /api/guest returned 201 at 22:59:34Z.

Recommendation: nobody should re-run deploy-endo-daemon.sh until PR 130 merges. It is still awaiting maintainer approval. Successor job kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume is parked awaiting-maintainer; approve PR 130 and promote it.
