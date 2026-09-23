---
source: designs/daemon-debug-worker-restart.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 100774ffa0193df27dc87c7df6095afda419a57f
source_date: 2026-04-17
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Forty-first-comment-style design ingest (cycle 159). 386-
  line *Not Started* status design by Kris Kowal *(prompted)*,
  created 2026-04-17. Last touch commit `100774ff` 2026-05-02.

  §Load-bearing-gap: existing debugger hot-attaches to a
  *running* worker. §too-late-by-the-time-debugger-attaches —
  cannot catch init code, module-level side effects, or first
  message dispatch. §three-invariants enumerate what's
  needed: (1) XS engine paused before any code; (2) debugger
  must issue <go/>; (3) breakpoints can be set before any
  code runs. §enumerate-the-invariants pattern.

  §User-facing-one-method: `E(host).debugWorker('@main')`.
  §everything-else-is-implementation. §returned-Debugger-
  already-paused at XS <login> break. §caller-must-issue-go-
  before-anything contract. §pause-by-default-explicit-resume.

  Single most structurally interesting move: §compose-
  existing-not-invent-new (Design Decision 1). *No new
  restart primitive*. Mechanism = suspend (existing) +
  debug-flag (one new verb) + resume (existing path + one
  branch). §don't-invent-restart-as-a-concept observation.
  §preserve-identity-across-snapshot property (worker keeps
  handle / bus identity / inbox / metering state).

  §Two-approaches-considered for envelope protocol: (a) new
  `debug-resume` verb that duplicates resume logic vs (b)
  `debug-flag` verb sets per-handle flag + normal resume
  checks it. Chosen: §debug-flag-plus-normal-resume.
  §minimize-protocol-additions discipline. §flag-set-before-
  action-not-action-with-flag pattern. §fire-and-forget-
  control-verb (nonce 0).

  §take_debug_flag atomic-removal discipline: HashSet<Handle>
  with atomic remove+return-present. §one-shot-flag-not-
  persistent (set per resume; not bled across). §opt-in-per-
  resume property.

  §Six-step JS-manager implementation: identify pet name →
  get bus handle → suspend → set debug flag → create session
  → trigger resume → wait for login → return debugger exo.
  §sequence-matters-but-each-step-is-existing.

  §Inbox-as-resume-trigger observation: §opportunistic-
  shortcut — if worker's inbox has pending messages, no
  debug-ping needed; next route_message triggers resume.

  §<login>-break is before any bytecode (Design Decision 3):
  XS itself has paused-at-construction hook; design uses
  it, doesn't invent it. §XS-debug-loop-fires-at-machine-
  creation. §<login>-not-first-user-code distinction
  (earliest-possible-break).

  §Metering-survives-debug-restart discipline: §debug-
  doesn't-grant-unlimited-computation. §existing-mechanism-
  handles-escape-hatch (meterSetQuota for temporary disable).
  §escape-hatch-exists-elsewhere pattern.

  §CapTP-connections-broken acceptance (Design Decision 4):
  §accept-the-cost-because-developer-tool. Acknowledge cost
  + name alternative (proxy layer keeping refs alive) +
  defer it. §don't-build-the-proxy-layer-for-now choice.
  §returned-Debugger-is-itself-a-CapTP-capability
  compensation.

  §Five Design Decisions codify structural choices: (1)
  compose suspend + debug-aware resume; (2) debug flag on
  supervisor not per-message; (3) worker paused at <login>
  not at first user code; (4) CapTP connections broken; (5)
  method name `debugWorker` not `restartWorkerInDebugMode` —
  §user's-perspective-not-implementation-detail. §five-
  decisions-form-coherent-shape (not independent; reinforce
  each other).

  §Three-implementation-phases with tests: Rust supervisor →
  JS manager → Chat integration. §phased-with-tests pattern.
  §independent-phases-with-clear-handoffs; §manual-test-OK-
  for-UI-phase concession.

  §Three Dependencies with explicit Requires/Composes
  typology. §thin-layer-on-thick-substrate observation
  (design adds one thin layer on debugger + snapshot
  substrates).

  §Runtime-introspection-duo with cycle 145's formula-
  inspector + cycle 147's workers-panel: cycle 145 surfaces
  *static* formula-graph; cycle 147 surfaces *dynamic*
  worker-state at runtime; this design lets you *pause* the
  worker for inspection.

  Cycle 159 was nominally papers-lane (cycle 158 was
  comments). Papers-lane has been blocked for 53+
  consecutive cycles. Cycle 159 pivoted to designs-lane.
---

> Abstract: `daemon-debug-worker-restart.md` (386 lines, *Not
> Started*) is a **compose-existing-not-invent-new design**
> by Kris Kowal *(prompted)*. Adds *one method* —
> `E(host).debugWorker('@main')` — without any new supervisor
> primitive.
>
> §Load-bearing-gap: §too-late-by-the-time-debugger-attaches.
> §three-invariants enumerate what's needed.
>
> §User-facing-one-method surface. §Returned-Debugger-already-
> paused at XS `<login>` break.
>
> **Single most structurally interesting move**: §compose-
> existing-not-invent-new (Design Decision 1). Mechanism =
> suspend (existing) + debug-flag (one new verb) + resume
> (existing path + one branch).
>
> §Two-approaches-considered → §debug-flag-plus-normal-resume.
> §minimize-protocol-additions; §flag-set-before-action-not-
> action-with-flag.
>
> §Take-atomic-removal: §one-shot-flag-not-persistent.
>
> §Six-step JS-manager implementation. §Inbox-as-resume-
> trigger (opportunistic-shortcut).
>
> §<login>-break is before any bytecode (§XS-debug-loop-
> fires-at-machine-creation).
>
> §Debug-doesn't-grant-unlimited-computation; §existing-
> mechanism-handles-escape-hatch.
>
> §CapTP-connections-broken acceptance (§accept-the-cost-
> because-developer-tool).
>
> §Five Design Decisions form §coherent-shape.
> §Three-implementation-phases with tests.
> §Thin-layer-on-thick-substrate.
>
> §Runtime-introspection-duo with cycles 145 + 147.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break](../sections/endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break.md) | daemon, tooling, hardened-javascript | current |

Tight 386-line *Not Started* design. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  100774ff` (branch `origin/llm`) via the local bare-clone.
- Created 2026-04-17 / updated 2026-04-17 / status *Not
  Started*. Author Kris Kowal *(prompted)*.
- Last touch commit `100774ff` 2026-05-02 by Kris Kowal:
  *docs(designs): Endor architecture, SQLite, makeArchive,
  and supporting designs*.
- **Forty-first-comment-style design ingest.**
- Cycle 159 was nominally **papers-lane** (cycle 158 was
  comments). Papers-lane has been blocked for **53+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 159 pivoted to designs-lane.
- One cohesion-honest section.
