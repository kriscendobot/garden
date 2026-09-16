---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Catalogue and assess two previously uncatalogued dckc-owned POWERS weblets on the
minion.town endo-gateway, surfaced by the 2026-09-04 containment drift check
(maintainer-inbox message 20260904T043754Z-6ae1cc).

CONTEXT — the core containment property PASSED and is not in question. The
recursive scan of /var/lib/endo-gateway/store/vhosts/ on i-0380cd68b90020fad (49
active records, whitespace-tolerant filename+content match) confirmed all three
de-registered records remain ABSENT from the live active store and present in
vhosts-revoked-20260812/: f1d754fc..., fe0a8e60..., and
09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f. No
EndoHost-escape (@agent) powers record is active. The powers plane being open is
the AUTHORIZED 08-27 state per kriscendobot/minion.town#58 — do NOT re-arm
containment.

WHAT TO ASSESS — the scan surfaced, per its own "report any unexpected active
dckc-owned record" clause: dckc (sub 8929a9ae-b001-709d-02ea-e94df6225c0a) owns
20 active records, 18 content-only (safe) plus 2 POWERS weblets not previously
catalogued, e.g. 806fc2ea... powers:"counter" (label qbx4f2xd....ocap.site). Note
owner values on this host carry an embedded space, so keep the whitespace-tolerant
matching.

TASK: re-scan (the evidence is ~2 weeks old), identify both powers weblets fully,
and report for each what authority it actually confers, whether it is within the
authorized 08-27 posture or outside it, and whether it should be catalogued as
expected or de-registered. Recommend; do not de-register anything on your own
judgment. This is a READ-ONLY assessment plus a recommendation.

Prior related security review: reports of the 2026-09-04 minion.town security
review listed several open operator items on this daemon — check whether either
weblet intersects one before reporting.
