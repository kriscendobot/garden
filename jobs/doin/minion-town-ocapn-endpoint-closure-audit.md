---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
requires: aws
handler-timeout: 5400

Read-only audit of minion.town's remaining publicly-reachable OCapN endpoints.
Deliverable is a report. Do NOT change production and do NOT deploy.

## Why this job exists

Two completed jobs (`minion-town-host-exposure-forensics`,
`ebfb-guest-unconfined-from-tree`) established that
`wss://minion.town/.well-known/ocapn-cbor-np` and `/ocapn-daemon` bootstrap
`EndoOcapnBootstrap` with method list exactly `getAgentBinding`, `getGreeter`,
`getNodeId`, `help` plus CapTP introspection, verified by a live WSS + Noise
probe with a fresh client key. Not EndoHost. A separate public `/ocapn` Greeter
demo exists, also reported not host.

That is a **first-level** check, and it was asked to go deeper but completed
without doing so. It is not sufficient, because the lesson of the incident it
came from is precisely that the dangerous object arrived INDIRECTLY: the weblet
gateway's own bootstrap was not a Host either; it RESOLVED to one. One
enumeration showing "the bootstrap is not EndoHost" does not establish that
nothing reachable from it is.

These endpoints are, after containment, the main thing minion.town still exposes
publicly without OAuth or invitation. They deserve a closure argument.

## Questions

1. **Walk the closure.** From a completed Noise IK session with a valid locator,
   what do `getAgentBinding` and `getGreeter` actually RETURN? Enumerate the
   method surface of each returned object, and of what those return in turn,
   going deep enough to either reach something host-shaped or establish that the
   reachable set is bounded. Present it as a closure: here is everything an
   unauthenticated peer can reach, and here is why it stops there. Include
   `getGreeter().hello`, which a peer job described as "the peer protocol, not an
   *immediate* host bootstrap" — the word doing the work there is "immediate".

2. **What does a valid nonce locator require, and how does a peer come to hold
   one?** This decides whether the endpoint is effectively gated or effectively
   open to anyone who can reach the port. Specifically: is the locator secret and
   unguessable; is it ever published, shared in the clear, logged, or derivable
   from public information; and does holding one convey authority beyond
   establishing a session. If locators are discoverable, treat the endpoint as
   open and say so plainly.

3. **Same two questions for the separate public `/ocapn` Greeter demo**, which
   is a distinct surface and got only a one-line clearance.

4. **Is `getAgentBinding` scoped per-peer?** Whose agent does a fresh,
   unknown peer's binding resolve to, and can a peer influence which agent it
   binds to. An agent binding that resolves to something shared or privileged is
   the same class of defect as the `@agent` powers string.

## Method

- Probe as an unauthenticated external client, from off-host, with fresh keys.
  Introspection only (`__getMethodNames__`, `__getInterfaceGuard__`); do NOT
  execute code, write state, or exercise any mutating method against production.
- Production changed at ~22:37-22:45Z (the weblet powers containment drop-in).
  Timestamp observations relative to that; the powers plane being disabled does
  not affect these endpoints, which were deliberately left untouched, but say so
  rather than assuming.
- If a question cannot be answered without a mutating probe or a credential you
  should not use, stop and report what would be needed. Do not improvise access.

## Report

If the closure is genuinely bounded, say so with the enumeration that demonstrates
it, and these endpoints are cleared. That is a good outcome and worth stating
plainly and confidently. If it is not bounded, or you cannot establish either way,
say which and why.

Keep specifics off public trackers.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T23:03:05Z
