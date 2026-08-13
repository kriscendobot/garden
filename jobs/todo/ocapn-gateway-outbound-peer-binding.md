---
role: builder
---
<!-- garden-promoted-from-plan: gate=deferred priority=2 at=2026-08-13T16:10:57Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: endojs/endo-but-for-bots (base `llm`), and upstream endojs/endo `llm` if it
shares the shape.

Parked so it is not lost. This is the residual left deliberately unfixed by
https://github.com/endojs/endo-but-for-bots/pull/978 and its upstream port
(job `endo-upstream-llm-retention-set-peer-binding`). Both of those bind the
gateway returned by `hello` to the authenticated peer and refuse local-index
enumeration; neither closes this.

## The residual

The host `gateway()` powers facet is shared across transports and does not carry
authenticated peer identity. So on the OUTBOUND path — a peer WE dial — the
gateway presented is the shared bearer, un-bound to the specific dialed peer.
That peer can therefore call `followRetentionSet` for a THIRD node and receive
the formula numbers retained for that node. Combined with the node number those
are formula IDs that `provide` accepts, so a peer we dial can reach capabilities
intended for a different peer.

This does NOT reopen local-index enumeration (that is refused outright), so it is
narrower than the fixed bug. It is the same family: cross-peer capability
confusion arising from an operation performed in the daemon's authority without
binding to the caller's identity.

## The fix, as the finding job described it

Thread authenticated peer identity through the `gateway()` powers facet across
EVERY transport, and return a peer-bound gateway rather than the shared bearer.
This is why it was left out of the first PR: it is a broader change touching all
transports, not a local guard.

## Why this is parked rather than posted

It is not an active exposure on a contained system, and it deserves a considered
change rather than an incident-speed one. Promote it when the immediate incident
work has settled. Three people flagged during the incident that a residual living
only in a PR body gets consumed by the merge and forgotten; this park is the
answer to that.

## Context

Found 2026-08-12 during the minion.town OCapN incident. See the completion
reports for `ebfb-ocapn-gateway-retention-set-peer-binding`,
`deadmail-20260812T225323Z-c7db45` (the original closure walk), and
`minion-town-containment-ocapn-daemon-routes`.
