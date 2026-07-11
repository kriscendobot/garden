---
order: serial
children: ocapn-noise-demo-pr ocapn-daemon-minion-deploy-demo ocapn-two-daemon-invite-accept
on-child-failure: continue
state: running
created_by: orchestrator
created_at: 2026-07-11T03:51:59Z
---

role: orchestrator

# Orchestration: OCapN-over-Noise between real peers → PR stack + minion.town demos

Owns the **remainder** of the `OCapN.md` goal (garden root) after milestones 1 & 2
were proven in-session. Desired outcome (maintainer, 2026-07-11): **a stack of Endo
draft PRs and working demonstrations on minion.town.** Standing instruction:
**prefer progress on a tentative guess over delay** — children pick the smallest
reasonable default on any open question, proceed, and document the assumption.

## Already done (in-session, do not repeat)

- **M1** two-process OCapN capability round-trip over real WS and real TCP+CBOR;
  **M2** Crossed Hellos + reverse peer auth on both — pushed as branch
  `demo/ocapn-noise-two-peer` on `endojs/endo-but-for-bots` (base `llm`).
- Survey mapping the daemon integration: `jobs/tada/ocapn-noise-daemon-survey.md`.
- In flight (separate quota): `build-endo-daemon-ocapn-ws-transport` — WS transport
  wiring into PR #340's `networks/ocapn.js`. This is the predecessor the deploy
  child consumes; it is NOT a child of this orchestration (already promoted).

## Children (serial; on child failure: continue)

1. **ocapn-noise-demo-pr** — open the M1/M2 demo + crossed-hellos fix as a draft PR
   from the pushed branch. (First PR in the stack; independent — runs first while the
   WS-wiring job finishes.)
2. **ocapn-daemon-minion-deploy-demo** — deploy an OCapN-Noise-WS Pet Daemon on
   minion.town (systemd + Caddy `wss://minion.town/ocapn`, bypassing oauth2-proxy)
   and connect a local peer (M3 + M4). Consumes the WS-wiring branch; coordinates
   with the maintainer's systemd-daemon job if present, else deploys itself via SSM
   (`garden-fleet` AWS creds; host `i-0380cd68b90020fad`, aarch64).
3. **ocapn-two-daemon-invite-accept** — two Pet Daemons pair via invite/accept over
   Noise: TCP+CBOR between two local daemons, WS between local ↔ minion.town; land
   the forked two-daemon test as a stacked draft PR (M5).

## Open questions and their tentative defaults (children may revisit)

- **Base for daemon work:** PR #340's `claude/endo-daemon-ocapn-FkmHO` (has
  `@nets/ocapn`, TCP, in-process invite/accept suite). Default: stack on it.
- **Caddy route persistence:** box-local `conf.d/ocapn-demo.caddy` for the demo;
  durable route via the `kriscendobot/minion.town` repo if time allows.
- **Node identity binding** (`daemon-agent-network-identity`, Noise key ↔
  NodeNumber): default **defer** with PR #340's cross-checked-node-id stopgap; note
  it as the remaining gap for true mutual auth.
- **TCP to minion.town:** blocked by the 80/443-only security group. Default: do NOT
  open a security-group port; demonstrate TCP+CBOR between two **local** daemons and
  WS for the cross-host path. (Escalate to the maintainer only if a remote-TCP demo
  is explicitly required.)

## Definition of done

Every child has a `tada/` report; a draft-PR stack exists (demo PR, WS-wiring PR,
forked-two-daemon PR) and the minion.town WS demonstration + local TCP demonstration
have captured transcripts. Surface a concise completion summary (PR URLs, demo
transcripts, deferred gaps) to the maintainer inbox.
