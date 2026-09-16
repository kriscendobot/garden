from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-dckc-powers-weblet-audit-20260916
reply_to: minion-town-dckc-powers-weblet-audit-20260916
msg_key: msg-minion-town-dckc-powers-weblet-audit-20260916-bc25b836fd57
notice_count: 1
first_seen: 2026-09-16T05:59:07Z
last_seen: 2026-09-16T05:59:08Z
sent_at: 2026-09-16T05:59:08Z
---
dckc POWERS-weblet audit (minion.town, READ-ONLY) — assessment complete.

The two uncatalogued dckc POWERS weblets surfaced by the 09-04 drift check confer ZERO live authority. Both are legacy records predating kriscendobot/minion.town#51:
- 806fc2ea… powers="counter"  (qbx4f2xd….ocap.site)
- c016601e… powers="@none"    (yalgahxp….ocap.site)
Both carry the OLD schema (a `powers` STRING, no directoryId), share one contentRoot, and dead-end.

WHY INERT: the deployed vhost validator (vhost-table.js validateVhostRecord) hard-rejects ANY record with a `powers` key — `"powers" in raw → return undefined`. The mere presence of that field is a poison pill → the record resolves to 404. No serve path reads `record.powers`; the old top-host string resolver is gone. Live-probed both at loopback AND public edge: /=404, bootstrap=404. Defense-in-depth: `counter`→plain Counter exo, `@none`→null; neither is @agent/EndoHost.

POSTURE: both WITHIN the authorized 08-27 open-plane posture of kriscendobot/garden#58 (containment drop-in disabled Aug 27 23:36). Containment intact; the 3 de-registered records stay absent.

RECOMMENDATION: catalogue BOTH as EXPECTED / known-inert legacy dckc experiments. No de-registration needed for containment (the validator already neutralizes them) — did NOT touch anything. They corroborate the 2026-09-04 security review's open operator item on the untracked containment drop-in ("back-only-attenuated, lower risk").

DECIDING QUESTION (optional, cosmetic only): do you want a hygiene sweep to move stale legacy `powers`-string records into a `vhosts-legacy-*` dir? Not a security need — purely store tidiness. Say the word and I'll post a job.
