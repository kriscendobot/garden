---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §security-considerations — §host-level-only
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

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
