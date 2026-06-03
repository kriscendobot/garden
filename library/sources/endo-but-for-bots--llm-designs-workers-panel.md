---
source: designs/workers-panel.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-14
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-fifth-comment-style design ingest (cycle 147).
  158-line *Not Started* status design by Kris Kowal
  *(prompted)*, created 2026-02-14 / updated 2026-02-24 (the
  same day as cycle 145's formula-inspector).

  **The observability sister** to cycle 145's formula-
  inspector: same author, same creation date, same *Not
  Started* status, same three-affected-packages partition,
  same §thin-API-thick-UI principle. Together they form the
  *daemon observability pair*: static formula-graph
  (inspector) + dynamic worker-state (panel).

  §Load-bearing-observation: *workers are opaque* — four
  facets of opacity (which workers running / what tenanted /
  resource consumption / log+metric correlation).
  §observability-essential-for-untrusted-guest-code thesis.

  §Five-feature panel: (1) Event Loop Latency Sparkline; (2)
  Tenant Capabilities; (3) Pet Name Retention Paths; (4)
  Per-Worker Logs; (5) Correlated View. The §enumerate-
  features-not-architecture discipline (product spec).

  Single most structurally interesting move: §event-loop-
  latency-via-setTimeout(0) probe — *the single most
  informative metric for a single-threaded JS worker: if the
  event loop is blocked, everything queued behind it stalls*.
  §setTimeout(0)-as-scheduling-delay-probe: schedule a
  zero-delay callback; the delta between scheduled and fire
  time *is* the event-loop scheduling delay. §three-color
  thresholds (green<10ms / yellow<100ms / red>100ms);
  §threshold-as-product-discipline (not configurable per
  worker); §1-second-default-probe-interval = 60
  samples/minute.

  §Streaming API: `E(worker).followMetrics()` returns async
  iterator of `{ timestamp, eventLoopLatencyMs }`. §iterator-
  not-event-bus shape; composes with cycle 137's daemon-
  message-streaming for progressive-text-delivery substrate.

  §Reverse-lookup-on-formula-graph for tenant capabilities:
  three formula types carry `worker` field (eval / make-
  bundle / make-unconfined); cycle 145 noted six types
  surface metadata, here only three carry the back-reference.
  §existing-GC-graph-as-tenant-source discipline — *daemon's
  `graph.js` already tracks formula references for GC*. API:
  `E(agent).listWorkerTenants(workerPetName) → Array<{
  petName, formulaType }>`.

  §Reuse-graph.js for retention path; cycle 145 and this
  design both reach into `packages/daemon/src/graph.js`.
  §union-find-and-reachability discipline. API:
  `E(agent).retentionPath(petName) → Array<{ name, formulaType
  }>`. §why-is-this-worker-alive question — workers that
  won't GC have *some* retention path back to a root; the
  panel shows the chain so user can identify which removal
  releases.

  §Per-worker-log-filtering surfaces existing infrastructure
  (§existing-infrastructure-needs-surfacing discipline
  parallel to formula-inspector's §existing-API-leverage
  observation). API: `E(agent).followWorkerLog(workerPetName)`.

  §Correlated-view via §shared-X-axis-time: top-lane latency
  sparkline + bottom-lane log entries as markers/rows;
  §click-spike-to-find-log affordance jumps from anomaly to
  contemporaneous logs. §discrete-events-as-markers-on-
  continuous-axis discipline = *flame-graph-without-the-flame*
  idiom.

  §CLI-mirror with §subcommand-flag-shape: `endo workers` +
  `endo worker <name> --logs/--metrics/--tenants`.
  Compositional flags reuse same `<name>` across three
  streams. Same shape as formula-inspector's `endo inspect
  <name>`.

  §Three-affected-packages partition — identical to cycle
  145's formula-inspector (daemon + chat + cli).

  §Scaling-considerations: (a) streaming overhead 10
  msg/sec/10-workers negligible; (b) §incremental-update-
  not-recompute retention-path cache; (c) §pre-compute-the-
  reverse-edge for tenant reverse-index; §sparkline-fixed-
  size-ring-buffer (60 samples) = §observability-without-
  unbounded-state discipline.

  §Security: §host-level-only (sensitive guest-code data);
  §probe-overhead-configurable for production. §Retention-
  path-graph-not-exposed-to-guests. §Inspection-not-control
  invariant (workers-panel stays read-only; cycle 145's
  formula-inspector adds an edit-toggle).

  §Test-plan-with-honest-uncertainty: five integration tests
  for five features (more confident than cycle 145's §Maybe-
  prefix discipline).

  §Upgrade-considerations: §graceful-degradation discipline
  — old workers don't sparkline; old logs don't filter; UX
  degrades smoothly. §process-behavior-changes-not-schema for
  probe addition (no formula-schema migration).

  Cycle 147 was nominally papers-lane (cycle 146 was
  comments). Papers-lane blocked 41+ consecutive cycles.
  Cycle 147 pivoted to designs-lane.
---

> Abstract: `workers-panel.md` (158 lines, *Not Started*) is
> the **observability sister** to cycle 145's formula-
> inspector — same author, same 2026-02-14 creation date,
> same partition, same principles. Together they form the
> *daemon observability pair*: static formula-graph
> (inspector) + dynamic worker-state (panel).
>
> §Load-bearing-observation: *workers are opaque*.
> §five-feature panel: event-loop-latency sparkline / tenant
> capabilities / pet-name retention paths / per-worker logs /
> correlated view.
>
> **Single most structurally interesting move**: §event-loop-
> latency-via-setTimeout(0) probe — *the single most
> informative metric for a single-threaded JS worker*. §three-
> color thresholds (green<10ms / yellow<100ms / red>100ms).
>
> §Streaming API: `E(worker).followMetrics()` returns async
> iterator. Composes with cycle 137's daemon-message-streaming.
>
> §Reverse-lookup-on-formula-graph for tenants (eval / make-
> bundle / make-unconfined). §Reuse-graph.js for retention
> path. §Per-worker-log-filtering surfaces existing
> infrastructure.
>
> §Correlated-view via §shared-X-axis-time with §click-spike-
> to-find-log affordance — the *flame-graph-without-the-flame*
> idiom.
>
> §CLI-mirror: `endo workers` + `endo worker <name>
> --logs/--metrics/--tenants`. §Three-affected-packages
> partition identical to cycle 145.
>
> §Host-level-only security; §inspection-not-control invariant.
> §Graceful-degradation upgrade discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view](../sections/endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view.md) | daemon, chat-ui, tooling | current |

Tight 158-line *Not Started* design. Sister to cycle 145's
formula-inspector. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@0ee0cbb3c`
  (branch `origin/llm`) via the local bare-clone.
- Created 2026-02-14 / updated 2026-02-24 / status *Not
  Started*. Author Kris Kowal *(prompted)*.
- Last touch commit `0ee0cbb3c7639985c971c30c2fb6f32e1944d55b`
  2026-02-28 (`Update design doc dates`).
- **Thirty-fifth-comment-style design ingest.** Sister design
  to cycle 145's formula-inspector (same author + creation
  date + status + partition + principles).
- Cycle 147 was nominally **papers-lane** (cycle 146 was
  comments). Papers-lane has been blocked for **41+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 147 pivoted to designs-lane.
- One cohesion-honest section.
