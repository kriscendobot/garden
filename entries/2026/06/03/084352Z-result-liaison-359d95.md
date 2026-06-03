---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--359d95
ts: 2026-06-03T08:43:52Z
ref_id: 359d95
---

# Cycle 147 result — workers-panel.md (thirty-fifth-comment-style design ingest)

Cycle 147 of the librarian arc. Nominally papers-lane (cycle 146 was
comments-lane); papers-lane has been blocked for **41+ consecutive
cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/workers-panel.md` — 158-line *Not Started*
design by Kris Kowal *(prompted)*, created 2026-02-14 / updated
2026-02-24. Last touch commit `0ee0cbb3c` 2026-02-28.

**The observability sister to cycle 145's formula-inspector** —
same author, same 2026-02-14 creation date, same *Not Started*
status, same three-affected-packages partition, same §thin-API-
thick-UI principle. Together they form the *daemon observability
pair*: static formula-graph (inspector) + dynamic worker-state
(panel).

## Structural moves captured

- **§load-bearing-observation**: *workers are opaque* (four facets
  of opacity: which workers running / what tenanted / resource
  consumption / log+metric correlation). §observability-essential-
  for-untrusted-guest-code thesis.

- **§five-feature panel** — concrete-affordance enumeration: event-
  loop-latency sparkline / tenant capabilities / pet-name retention
  paths / per-worker logs / correlated view.

- **Single most structurally interesting move**: §event-loop-
  latency-via-setTimeout(0) probe — *the single most informative
  metric for a single-threaded JS worker: if the event loop is
  blocked, everything queued behind it stalls*. §three-color
  thresholds (green<10ms / yellow<100ms / red>100ms);
  §threshold-as-product-discipline; §1-second-default-probe-interval.

- **§Streaming API** `E(worker).followMetrics()` returns async
  iterator of `{ timestamp, eventLoopLatencyMs }`. Composes with
  cycle 137's daemon-message-streaming.

- **§Reverse-lookup-on-formula-graph** for tenants: three formula
  types carry `worker` field (eval / make-bundle / make-unconfined).
  §existing-GC-graph-as-tenant-source discipline (graph.js already
  tracks references for GC).

- **§Reuse-graph.js** for retention path (§union-find-and-
  reachability; cycle 145's formula-inspector reaches into the same
  file). §why-is-this-worker-alive question.

- **§Correlated-view** via §shared-X-axis-time (top-lane sparkline +
  bottom-lane log markers + §click-spike-to-find-log affordance) =
  *flame-graph-without-the-flame* idiom.

- **§CLI-mirror** with §subcommand-flag-shape: `endo workers` +
  `endo worker <name> --logs/--metrics/--tenants`.

- **§Three-affected-packages partition** identical to cycle 145
  (daemon + chat + cli).

- **§Inspection-not-control invariant**: workers-panel stays
  read-only; cycle 145's formula-inspector adds an edit-toggle.
  §observability-vs-guest-isolation tension.

- **§Graceful-degradation upgrade discipline**: old workers don't
  sparkline; old logs don't filter; UX degrades smoothly.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-workers-panel`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view.md`
- **Topics**: daemon, chat-ui, tooling
- **Library totals**: 651 sections from 192 source documents
- **Lane rotation**: nominally papers-lane (41+ consecutive blocks);
  pivoted to designs-lane

## Daemon observability pair complete

The cycle 145 (formula-inspector) + cycle 147 (workers-panel)
pairing now covers both axes of daemon observability:

- **Static** (formula-graph): formula-inspector reveals what each
  pet-named capability *is* — type, fields, references, retention
  paths.
- **Dynamic** (worker-state): workers-panel reveals what each
  worker process is *doing* — latency, tenants, logs.

Both designs share the architectural shape: thin API additions on
the daemon side; thick UI rendering on the chat side; CLI mirror
for terminal use; host-level-only security.

Cycle 147 closes. Schedule next wake 1500s for cycle 148.
