---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-11T17:34:21Z -->

role: builder

# True cross-host Pet-Daemon ↔ Pet-Daemon invite/accept over wss (closes M5)

**Depends on** `ocapn-pet-daemon-dockerfile-minion` (the full Endo Pet Daemon running on
minion.town via `@nets/ocapn` over WS+Noise, reachable at a `wss://minion.town/…` route).

The M5 test job (PR #688) already proves forked two-daemon invite/accept over Noise
**locally** (both daemons on one host, TCP and WS). This job closes the **literal** goal
DoD: a **local** Pet Daemon and the **minion.town** Pet Daemon — two real daemons on
different hosts — pairing through the **invite/accept workflow** over `wss://` + Noise.

## Task

1. Run a **local** Endo Pet Daemon in the garden container with `@nets/ocapn` (WS+Noise)
   installed (same image/build as the minion.town one).
2. Drive the **invite/accept** workflow between the local daemon and the minion.town
   daemon over `wss://minion.town/…`: mint an invitation on one side, accept it on the
   other (CLI `invite`/`accept` or the agent-side `addPeerInfo`/invitation exo), so the
   accepting peer selects `@nets/ocapn` and dials over WS+Noise. Because the minion.town
   daemon advertises a loopback `ws:url`, carry the public-endpoint rewrite the demo
   client uses (the Noise handshake binds the location **designator**, independent of URL).
3. **Round-trip a capability** across the paired daemons (e.g. one daemon hands the other a
   `Far` reference and it's invoked back). Capture a **transcript**.
4. Also capture the **TCP+CBOR** side between **two local** Pet Daemons (minion.town blocks
   non-443, so remote-TCP is out of scope — demonstrate TCP locally, WS cross-host), unless
   PR #688's transcripts already suffice — if so, reference them instead of re-running.

**Prefer tentative progress over delay.** If the full CLI invite/accept can't be driven
end-to-end cross-host, fall back to the programmatic `@nets/ocapn` dial + bootstrap
capability invoke (already proven live) and clearly document the gap between that and the
full pet-name invitation flow.

## Done

A captured transcript of a **local Pet Daemon and the minion.town Pet Daemon** connecting
via invite/accept over `wss://` + Noise and round-tripping a capability, plus the local
TCP demonstration (or a reference to #688's). Land scripts + README + transcript on a
stacked branch → draft PR. Report the exact pairing steps and any gap vs the full
pet-name invitation workflow.
