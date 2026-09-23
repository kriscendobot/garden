---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--3d71c0
ts: 2026-06-03T15:12:48Z
ref_id: 3d71c0
---

# Cycle 159 result — daemon-debug-worker-restart.md (forty-first-comment-style design ingest)

Cycle 159 of the librarian arc. Nominally papers-lane (cycle 158 was
comments); papers-lane has been blocked for **53+ consecutive
cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/daemon-debug-worker-restart.md` — 386-
line *Not Started* status design by Kris Kowal *(prompted)*. Created
2026-04-17. Last touch commit `100774ff` 2026-05-02.

## Structural moves captured

- **§Load-bearing-gap**: existing debugger hot-attaches to a
  *running* worker; §too-late-by-the-time-debugger-attaches.

- **§Three-invariants** enumerate what's needed (XS engine paused
  before any code / debugger must issue <go/> first / breakpoints
  can be set before any code runs). §Enumerate-the-invariants
  pattern.

- **§User-facing-one-method**: `E(host).debugWorker('@main')`.
  §Returned-Debugger-already-paused at XS `<login>` break. §Pause-
  by-default-explicit-resume contract.

- **Single most structurally interesting move**: §compose-existing-
  not-invent-new (Design Decision 1). Mechanism = suspend (existing)
  + debug-flag (one new verb) + resume (existing path + one
  branch). §Don't-invent-restart-as-a-concept. §Preserve-identity-
  across-snapshot.

- **§Two-approaches-considered for envelope protocol** → §chosen-
  debug-flag-plus-normal-resume. §Minimize-protocol-additions.
  §Flag-set-before-action-not-action-with-flag.

- **§Take_debug_flag atomic-removal** with §one-shot-flag-not-
  persistent + §opt-in-per-resume.

- **§Six-step JS-manager implementation** with §sequence-matters-
  but-each-step-is-existing. §Inbox-as-resume-trigger §opportunistic-
  shortcut.

- **§<login>-break is before any bytecode** (Design Decision 3):
  §XS-debug-loop-fires-at-machine-creation. §Earliest-possible-
  break.

- **§Metering-survives-debug-restart** with §debug-doesn't-grant-
  unlimited-computation discipline. §Existing-mechanism-handles-
  escape-hatch via meterSetQuota.

- **§CapTP-connections-broken acceptance** (Design Decision 4):
  §accept-the-cost-because-developer-tool.

- **§Five Design Decisions** form §coherent-shape (not independent;
  reinforce each other). §User's-perspective-not-implementation-
  detail (`debugWorker` not `restartWorkerInDebugMode`).

- **§Three-implementation-phases with tests**: §phased-with-tests.
  §Thin-layer-on-thick-substrate.

## Cluster citations

- **§Runtime-introspection-duo with cycles 145 + 147**: cycle 145's
  formula-inspector surfaces *static* formula-graph; cycle 147's
  workers-panel surfaces *dynamic* worker-state; this design lets
  you *pause* the worker for inspection. Three observability tools
  now form a trio.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-daemon-debug-worker-restart`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break.md`
- **Topics**: daemon, tooling, hardened-javascript
- **Library totals**: 663 sections from 204 source documents
- **Lane rotation**: nominally papers-lane (53+ consecutive blocks);
  pivoted to designs-lane

Cycle 159 closes. Schedule next wake 1500s for cycle 160.
