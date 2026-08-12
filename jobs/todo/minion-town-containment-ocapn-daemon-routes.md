---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
requires: aws
handler-timeout: 3600

URGENT production containment on minion.town, authorized by the maintainer
(kriskowal) on 2026-08-12 in the liaison session. This job DOES change
production, deliberately and narrowly.

## Why

Job `deadmail-20260812T225323Z-c7db45` established that the public OCapN daemon
bootstrap is indirectly host-powerful for any bearer of a valid Noise location:
`getGreeter().hello()` yields the daemon's `localGateway`, whose
`followRetentionSet(peerNodeNumber)` has no peer binding and runs
`listFormulaNumbersByNode` directly. With `getNodeId()` publicly revealing the
local node, a caller enumerates every local formula number and calls
`provide(id)` on any of them, including `make-unconfined`, `eval`, and
`least-authority`. Every OCapN address embeds the designator in `loc=`, so every
invitation recipient holds the locator.

This is a SECOND, distinct defect from the weblet-powers one contained earlier
tonight (job `minion-town-containment-gateway-endo-sock`). That containment
stays in place; do not disturb it.

## Authorized actions

**0. Preserve evidence first (read-only).** Capture the current Caddy config for
the affected routes, the `endo-ocapn-daemon` / `endo-pet-daemon` unit or
container definition as deployed, and the current
`/data/ocapn-daemon-location.json` designator (record it, do not publish it).
Note the daemon's current formula-index size so a later comparison is possible.

**1. Close the public route(s) to the OCapN daemon.** The maintainer's
instruction is to disable `/ocapn-daemon`. **Both `/ocapn-daemon` AND
`/.well-known/ocapn-cbor-np` are public Caddy routes to the SAME daemon**, per
the peer forensics job, so closing only one leaves the identical bootstrap
reachable and the containment worthless. Close both. If you find any additional
public route reaching that daemon, close it too and report it.

Prefer a reversible, drop-in-shaped change with a written rollback, exactly as
the earlier containment job did. Record the rollback command in your report.

**MUST NOT be touched:**
- The separate public `/ocapn` Greeter demo. It is a different container
  (`/opt/ocapn-demo/`), was audited as bounded safe (two methods returning only
  strings), and stays up.
- The existing weblet-powers containment drop-in on `endo-gateway.service`.
- The daemon's own local socket and any non-public surface. This is about public
  reachability, not stopping the daemon, unless stopping the listener is the only
  reversible way to close the routes; if so, say why in your report.

## Verify, with evidence

- From OFF-HOST, attempt to reach both closed routes and show what they now
  return. A restart alone is not evidence.
- Attempt a Noise handshake against the closed endpoint using the current
  designator (which you hold from step 0) and show that it fails. **Do not walk
  the closure, do not invoke `hello` or `provide`** — the handshake mutates peer
  and retention state, which is why the reporting job stopped short of it. Prove
  the door is shut, nothing further.
- Confirm `/ocapn` (the toy demo) still serves, and that the earlier weblet
  containment is still in force.
- Confirm the daemon process itself and all other core units are still healthy.

## Report the cost

State plainly what this breaks: cross-host OCapN invite/accept, any live peer
sessions, and anything else depending on those routes. The maintainer is
knowingly taking OCapN-over-Noise down to close this, and needs to know exactly
what stopped working and what it will take to restore it once
`ebfb-ocapn-gateway-retention-set-peer-binding` lands and deploys.

## Bounds

- Do not rotate the Noise designator; that was considered and NOT chosen.
- Do not deploy code. Do not modify any account or invitation.
- Do not roll back either containment without the maintainer's explicit say-so.
- No exploit specifics on any public tracker.
- Message the maintainer as soon as step 1 is verified.
