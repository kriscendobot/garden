---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
---

# Event-loop-latency sparkline with tenant listing, retention paths, and correlated log view

> *Workers are opaque. There is no way to see which worker
> processes are running, what capabilities are tenanted in
> each worker, what their resource consumption looks like, or
> to correlate logs and metrics with specific workers.*
>
> — `designs/workers-panel.md` §What is the Problem Being Solved

`workers-panel.md` (158 lines, *Not Started* status, created
2026-02-14 / updated 2026-02-24) is the **observability
sister** to cycle 145's formula-inspector — both 2026-02-14
created by Kris Kowal *(prompted)*, both *Not Started*, both
surface daemon internals to the user via a chat-UI panel +
CLI mirror. The formula-inspector exposes the *static*
formula-graph; this design exposes the *dynamic* worker-state.

## The §load-bearing-observation — *workers are opaque*

The §What-is-the-Problem-Being-Solved paragraph names four
opacity facets:

1. Which worker processes are running
2. What capabilities are tenanted in each worker
3. What their resource consumption looks like
4. How logs and metrics correlate with specific workers

The §observability-essential-for-untrusted-guest-code thesis:
*for a system designed to host potentially untrusted guest
code, observability is essential*. The §host-level-observation-
surface (the maintainer / operator needs to see what's
running; the guests don't get to see this).

## The §five-feature panel — concrete-affordance enumeration

The design enumerates **five concrete features** the Workers
panel surfaces. Each gets its own H3 subsection in the source:

1. **Event Loop Latency Sparkline** — `setTimeout(0)` probe.
2. **Tenant Capabilities** — formulas with `worker` field
   matching this worker's identifier.
3. **Pet Name Retention Paths** — trace from worker back to
   GC roots.
4. **Per-Worker Logs** — filter the global log to a specific
   worker.
5. **Correlated View** — shared X-axis (time) with latency
   sparkline + log entries.

The §enumerate-features-not-architecture discipline: this is a
*product spec*, not an architectural design. Each feature
maps to a chat-UI render and a CLI command.

## The §single most structurally interesting move — §event-loop-latency-via-setTimeout(0) probe

> *Instrument each worker with a periodic `setTimeout(0)`
> probe that measures scheduling delay. This is the single
> most informative metric for a single-threaded JS worker: if
> the event loop is blocked, everything queued behind it
> stalls.*

The §setTimeout(0)-as-scheduling-delay-probe discipline. The
*setTimeout(0)* idiom schedules a zero-delay callback; the
delta between the scheduled time and the actual fire time
*is* the event-loop scheduling delay. For a single-threaded
JS worker, this is the *load-bearing latency signal*.

The §the-single-most-informative-metric-for-a-single-threaded-JS-worker
thesis: in a multi-threaded system you'd look at CPU, thread
contention, lock waits. In a single-threaded JS worker, *the
event loop is the bottleneck*; everything else is downstream
of it. A blocked event loop is *the* observable that
correlates with user-visible latency.

§Three-color thresholds with §green-yellow-red mapping:

- **Green** < 10ms: healthy
- **Yellow** < 100ms: noticeable, may degrade UX
- **Red** > 100ms: blocking, work is piling up

The §threshold-as-product-discipline (not configurable per
worker): consistent thresholds across the panel let the user
recognize *unhealthy* without per-worker interpretation. The
§1-second-default-probe-interval (configurable) gives 60
samples/minute — enough granularity to spot spikes without
adding measurable overhead.

§Streaming API: `E(worker).followMetrics()` returns an async
iterator of `{ timestamp, eventLoopLatencyMs }`. The
§iterator-not-event-bus shape: each worker exposes *its* own
followMetrics; the UI subscribes per-worker. Composes with
cycle 137's daemon-message-streaming for the
*progressive-text-delivery* substrate.

## The §reverse-lookup-on-formula-graph for tenant capabilities

> *List the pet names of capabilities whose formulas
> reference a given worker. Specifically, formulas with a
> `worker` field matching this worker's formula identifier.*

Three formula types carry a `worker` field:

- `eval` — evaluated expressions
- `make-bundle` — bundled plugins
- `make-unconfined` — unconfined caplets

(Cycle 145's formula-inspector cited six total formula types
that surface metadata; here only three carry the *worker*
back-reference.)

§Reverse-lookup-on-formula-graph: the design notes that
*daemon's `graph.js` already tracks formula references for
GC; this information needs to be surfaced*. The §existing-
GC-graph-as-tenant-source discipline: GC needs the same
references; expose them.

§API: `E(agent).listWorkerTenants(workerPetName)` returns
`Array<{ petName, formulaType }>`. The §pet-name-plus-formula-
type return shape lets the UI render *what kind* of tenant
each is (eval-style code, bundled plugin, unconfined caplet).

## The §reuse-graph.js for retention path

> *Reuse the GC graph from `packages/daemon/src/graph.js`
> which already implements union-find and reachability
> analysis.*

The §graph.js-already-does-this observation. Cycle 145's
formula-inspector and this design both reach into
`packages/daemon/src/graph.js` for retention-path computation.
The §union-find-and-reachability discipline: GC must compute
*which formulas are still reachable from a root*; retention-
path is the trace.

§API: `E(agent).retentionPath(petName)` returns `Array<{
name, formulaType }>` from target back to root.

The §why-is-this-worker-alive question: a worker that won't
GC has *some retention path* back to a root (PINS directory
or agent pet store). The panel shows the chain so the user
can identify *which removal* would release it.

The §pairs-with-formula-inspector observation: cycle 145's
formula-inspector design surfaces retention paths *generically*
for any capability; this design *specializes* the surface for
workers (the user wants to know *why this worker is alive*).

## The §per-worker-log-filtering — surface existing infrastructure

> *The daemon already has per-formula logging (the `endo log`
> command accesses it); it needs to be filterable by worker
> formula identifier.*

§Existing-infrastructure-needs-surfacing discipline (parallel
to formula-inspector's §existing-API-leverage observation):
the daemon already logs per-formula; the panel just adds a
filter and a UI viewer.

§API: `E(agent).followWorkerLog(workerPetName)` returns async
iterator of log entries.

## The §correlated-view — §shared-X-axis-time

> *A timeline-aligned view where log entries and latency
> spikes can be viewed together: Shared X-axis (time). Top
> lane: sparkline of event loop latency. Bottom lane: log
> entries as markers/rows at their timestamps. Clicking a
> latency spike scrolls to the nearest log entries.*

The §correlated-view-via-shared-time-axis idiom. Two
information streams (continuous latency + discrete log
events) sharing one axis. The §click-spike-to-find-log
affordance: latency spikes are *anomalies*; the user wants to
know *what was happening* at the spike. Clicking the spike
jumps to the contemporaneous log entries.

The §discrete-events-as-markers-on-continuous-axis discipline
is the *flame-graph-without-the-flame* idiom: information-
dense observability without architectural commitment to a
heavier framework.

## The §CLI-mirror — same shape as formula-inspector

```
endo workers                  # list active workers
endo worker <name> --logs     # tail logs
endo worker <name> --metrics  # current latency
endo worker <name> --tenants  # tenanted capabilities
```

The §subcommand-flag-shape: one top-level `workers` listing
+ one per-worker `worker <name>` verb taking flags for each
of the three streams. Compositional: same `<name>` is reused
across `--logs`, `--metrics`, `--tenants`.

§Same shape as formula-inspector's `endo inspect <name>` —
both designs share the §thin-API-thick-UI principle (cycle
145's slogan).

## The §three-affected-packages partition — sister to cycle 145

§Affected Packages:

> - `packages/daemon` — worker metrics probe, tenant listing,
>   retention path API, filtered log streaming
> - `packages/chat` — workers panel UI, sparkline rendering,
>   log viewer
> - `packages/cli` — new `endo workers` and `endo worker`
>   commands

**Identical partition** to cycle 145's formula-inspector:
daemon (data sources + APIs) → chat (UI panel) + cli (CLI
mirror). Two cohabiting designs adopt the same architectural
shape. The §thin-API-thick-UI discipline: each panel adds a
small number of `E(agent).*` methods; UI rendering carries
the weight.

## The §scaling-considerations discipline

§Three scaling moves:

1. **Streaming overhead is negligible**: *At 1s intervals
   with 10 workers, this is 10 messages/second — negligible*.
2. **Retention path caching**: *Cache the result and update
   incrementally when the graph changes*. The §incremental-
   update-not-recompute discipline.
3. **Tenant reverse-index**: *Consider maintaining a reverse
   index for efficiency*. The §pre-compute-the-reverse-edge
   discipline.

The §sparkline-fixed-size-ring-buffer (60 samples; *bound
memory*) is the §observability-without-unbounded-state
discipline. The panel is a *probe*, not a *recorder*.

## The §security-considerations — §host-level-only

§Security:

- Worker metrics and logs may contain sensitive data from
  guest code. *Restrict observability APIs to host-level
  authority*.
- §Probe-overhead-configurable: *should be configurable or
  disableable for production deployments where the overhead
  is unacceptable*.
- Retention path computation reveals the formula graph
  structure. *Acceptable for the owning host but must not be
  exposed to guests*.

The §inspection-not-control invariant: even with host-level
authority, the inspector *observes* the worker; it doesn't
*direct* it. (Cycle 145's formula-inspector goes one step
further with the §edit-toggle, but workers-panel stays
read-only — workers are processes, not data structures.)

The §observability-vs-guest-isolation tension: maximum
observability for the host + zero observability for guests.
The §host-as-debugger / §guest-as-debuggee asymmetry.

## The §test-plan-with-honest-uncertainty

§Test plan covers five integration scenarios + one UI test:

- Probe reports values within expected range under idle and
  loaded conditions (unit test)
- Tenant list includes the eval formula's pet name
  (integration)
- Worker logs filtered by worker pet name contain only
  entries from that worker (integration)
- Retention path from a worker traces back to a pet store
  root (integration)
- Sparkline color coding + tenant list accuracy + real-time
  log update (UI test)

The §five-integration-tests-cover-five-features symmetry: one
test per feature. Cycle 145's formula-inspector had a §Maybe-
prefix-on-tests discipline (honest uncertainty); this design
is more confident — the tests are *expected*, not *maybe*.

## The §upgrade-considerations — §backward-compat by graceful-degradation

§Upgrade:

- *Existing workers (before upgrade) don't report metrics.
  The UI should handle the absence gracefully (show "no data"
  instead of a sparkline).*
- The latency probe must be added to `worker.js` `main()` —
  *changes the worker process behavior but doesn't affect the
  formula schema*. §process-behavior-changes-not-schema
  discipline.
- *Log entries written before the upgrade won't have worker
  tags; filtered log views will simply not show historical
  entries for those workers.*

The §graceful-degradation discipline: old workers don't show
sparklines; old logs don't filter. The user experience
*degrades smoothly* rather than failing loudly.

## Related sections

- cycle 145
  [[endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal]]
  — sister observability design (same 2026-02-14 creation
  date; same *Not Started* status; same three-affected-
  packages partition; same §thin-API-thick-UI principle; same
  Kris Kowal *(prompted)* attribution). Together they form
  the *daemon observability pair*: static formula-graph
  (inspector) + dynamic worker-state (panel).
- cycle 49
  [[endo-but-for-bots--llm-designs-retention-path-notation--retention-path-notation]]
  — the retention-path notation both observability tools
  visualize.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — *capabilities are objects, not configurations*: the
  capability-bank's shared-resources framing is what *tenant
  listing* surfaces.
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — the streaming substrate that `followMetrics` and
  `followWorkerLog` ride on.
