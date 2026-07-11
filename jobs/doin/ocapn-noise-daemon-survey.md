role: researcher

# Survey: does the Pet Daemon speak OCapN-over-Noise, and what's missing for invite/accept over it?

READ-ONLY investigation. Do **not** modify code, do **not** open/close/comment on any PR or
issue, do **not** push to any project branch. Deliver all findings in your job **completion (tada)
report** — that report is the whole deliverable.

## Context

We have empirically proven (in a separate scratch worktree) that `@endo/ocapn-noise` establishes a
Noise IK session and round-trips an OCapN capability between two peers over BOTH real WebSocket/HTTP
and real TCP+CBOR, and that Crossed Hellos + reverse peer authentication behave correctly. The next
milestones need the **Pet Daemon** (`@endo/daemon`) to actually serve OCapN over the Noise netlayer,
and two Pet Daemons to connect via the **invite/accept** workflow over Noise (WS and TCP+CBOR).

## Repo / branch

`endojs/endo-but-for-bots`, branch **`llm`** (the active fork). Bare clone on disk at
`worktrees/endojs-endo-but-for-bots.git`. Also check **open PRs** for in-flight work.

## Questions to answer (cite files:line and PR/branch names)

1. **Daemon ↔ noise netlayer.** Does `packages/daemon` wire in `@endo/ocapn-noise`
   (`makeOcapnNoiseNetwork`) anywhere? If not, what netlayer(s) does the daemon currently use to
   reach remote peers (e.g. the existing tcp-netstring CapTP netlayer, `@endo/daemon` gateway/web
   server)? Point to the exact wiring (files, functions, how a netlayer is registered).

2. **Invite/accept workflow.** How does the daemon's invitation/acceptance (peer-to-peer pairing)
   currently establish a connection — which packages/functions (`@endo/daemon` invitations,
   `@endo/cli`, gateway)? Is there ANY existing path, landed or in-flight, to run invite/accept over
   the ocapn-noise network (WS or TCP+CBOR)? What node/location format does an invitation carry
   today, and how far is it from an OcapnLocation (`{designator, hints:{ws:url|tcp:host/port}}`)?

3. **Landed vs in-flight.** List merged and open PRs / branches implementing: the noise network, the
   `ws-node` and `tcp` transports, and any daemon integration of them. Give PR numbers / branch
   names and merge status.

4. **Gap analysis for milestones 4 & 5.** Concrete list of what code is missing to (a) have a Pet
   Daemon serve OCapN over WebSocket+Noise with a listener, and (b) connect two Pet Daemons via the
   invite/accept workflow over the Noise network on both transports. Note any spec/code gaps,
   half-landed abstractions, or TODOs you find.

Keep it concrete and grounded in the actual source. The consumer of this report is a builder driving
those two milestones.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  claimed_at: 2026-07-11T02:52:02Z
