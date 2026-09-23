---
title: Connection to the wider library
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "78-117 (trackTurns JSDoc + body + TurnStarterFn typedef)"
topics: [eventual-send, errors, capability-theory]
status: current
parent: endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model
---

This section is the **canonical worked example of *runtime causal-event tracking via stack-located sending events and at-the-bottom-of-a-new-stack receiving events*** at the @endo/eventual-send level. Three threads:

1. **The sending-event-causes-receiving-events model** generalizes beyond track-turns. Any pipeline where *some code in a stack causes some code at the bottom of a future stack to run* can be modeled with this DAG. The library can cite this section whenever a design needs to reason about *causality across asynchronous boundaries*.

2. **The inert-fallback guard pattern**. Three-condition fallback (feature-flag off OR environment incomplete OR SES not installed) returns the input unchanged. Reusable for any instrumentation module that should disappear when preconditions don't hold.

3. **The Caused-by chain construction**. Eagerly link new sending-events to prior-error references via `annotateError(newError, X\`Caused by: ${priorError}\`)`. Builds an unbounded-depth causal chain that the causal-console traverses on display.
