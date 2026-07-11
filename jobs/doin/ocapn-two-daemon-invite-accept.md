---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-11T06:31:03Z -->

role: builder

# Two Pet Daemons connect via invite/accept over OCapN-Noise, both transports (M5)

**Goal:** demonstrate **two Endo Pet Daemons** pairing through the **invite/accept**
workflow over the OCapN-Noise network — over **WebSocket** (local ↔ minion.town) and
over **TCP+CBOR** (two local daemons, since minion.town blocks non-443 inbound) — and
land the supporting test as a **draft Endo PR** stacked on the WS branch.

**Prefer tentative progress over delay:** default to the smallest reasonable choice,
proceed, document assumptions.

## Context (from survey `jobs/tada/ocapn-noise-daemon-survey.md`)

- Invite/accept is landed and transport-agnostic-by-opacity: CLI `invite` prints an
  `endo://{peerKey}/{formula}@{hint}?type=invitation&from=…&fromNode=…` locator;
  `accept` reads it from stdin; both sides call `addPeerInfo({node, addresses})`.
  Hints are opaque transport-prefixed strings, routed by
  `network.supports(addressString)`.
- PR #340 already runs an **in-process** multiplayer invite/accept/value-exchange/
  partition/restart/three-party suite over `@nets/ocapn` (Noise+TCP+CBOR). What is
  missing: a **forked two-daemon** run, a **WS** run, and routing real `endo://`
  peer dials through `@nets/ocapn` (advertise `ocapn+noise+…` hints in
  `getPeerInfo`/`locate`).
- Open gap: `daemon-agent-network-identity` — the Noise session key is not yet bound
  to the daemon's `NodeNumber`/`designator` (PR #340 uses a cross-checked node-id
  report as a stopgap). Decide whether to close this for true mutual auth or defer
  as #340 does; **default: defer with the stopgap**, and note it.

## Task

1. On the WS branch (from `build-endo-daemon-ocapn-ws-transport` /
   `ocapn-daemon-minion-deploy-demo`), add a **forked two-daemon** integration test
   that runs the invite/accept + a capability round-trip over `@nets/ocapn`,
   **parameterized over `ocapn+noise+tcp` AND `ocapn+noise+ws`**. Make the daemon
   select the ocapn netlayer for an invitation whose hints carry `ocapn+noise+…`
   (teach `getPeerInfo`/`locate`/`accept` to advertise them).
2. **Live demonstrations:** (a) two local daemons invite/accept + round-trip over
   **TCP+CBOR+Noise**; (b) a local daemon accepts an invitation from / dials the
   **minion.town** daemon over **WS+Noise** (through the Caddy `wss://minion.town/
   ocapn` route from the deploy job). Capture scripts + transcripts.
3. Open a **draft PR** (stacked on the WS branch) with the forked-two-daemon test
   and any routing changes. `yarn lint` + `yarn lint:types` clean in
   `packages/daemon`; ses-ava tests green; separate `chore: Update yarn.lock` commit
   if deps change. No upstream ferry.

## Done

The stacked draft PR (green forked two-daemon invite/accept test over both
transports in-process) + transcripts of the two live demonstrations (local-TCP and
local↔minion-WS). Report the PR URL, the transcripts, the identity-binding decision,
and any spec/code gaps filed or routed around.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  claimed_at: 2026-07-11T06:31:06Z
