---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-08-28T02:48:36Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Verify peer enlivenSturdyRef fetch of a minion.town guest by formula id

DEFERRED pending a maintainer decision (asked on kriscendobot/garden#58,
comment 5447765615; relayed to the maintainer inbox 2026-08-28). Promote only
after the maintainer answers the daemon-exposure question.

Context: the reveal half of kriscendobot/garden#58's chain is DONE and verified
live — `GET /account/guest-formula-id` on minion.town returns a signed-in
guest's own daemon guest-agent formula identifier, self-scoped
(kriscendobot/minion.town#61, merged, deployed). What remains is the peer fetch:
from a peer, `enlivenSturdyRef(<public OCapN-CBOR-Noise location>,
<revealed guest formula id>)` and invoke a harmless guest method to prove the
guest was fetched.

BLOCKER diagnosed: the app provisions/reveals guests in `endo-daemon.service`
(loopback `127.0.0.1:8920` only, state `/var/lib/endo-daemon/state/endo`), but
the public OCapN routes (`/.well-known/ocapn-cbor-np`, `/ocapn-daemon` → `:8931`;
`/ocapn` → `:8930`) front a SEPARATE `endo-pet-daemon` container — a different
graph, different node id (`a6cd6e01…`). A guest id minted by `endo-daemon@8920`
is not resolvable at the public pet-daemon, so the peer fetch cannot succeed as
deployed.

Task once authorized: per the maintainer's answer, either (a) expose
`endo-daemon.service` over a public OCapN-CBOR-Noise route (its own Caddy route +
an `@nets/ocapn` netlayer on that daemon), or (b) unify the app onto the
already-public pet-daemon; then run the end-to-end peer fetch from a garden-host
peer using a freshly-revealed guest id and report exact evidence
(location, id, method invoked, result) on kriscendobot/garden#58. Coordinate with
the standing `ocapn-cbor-noise-press` (owner of host↔minion.town daemon reach)
and the endo-CLI remote-interaction work (kriscendobot/garden#58 comment
5447329184).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5447180549
submitter: kriskowal
----- END ISSUE NOTE -----
