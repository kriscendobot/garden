---
title: See also
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

- [[eventual-send]] (topic) — the pipeline this instruments; `E(target).method(...args)` produces a sending event that schedules a receiving event in the target's vat.
- [[errors]] (topic) — the causal console + assert.note machinery this section feeds.
- [[capability-theory]] (topic) — the sending-event-causes-receiving-events DAG is the runtime instance of the Drossopoulou-Noble-Miller-Murray 2015 paper's *only-connectivity-begets-connectivity* axiom.
- `endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates` — the first section: the disclaimers and gates that determine when this section's instrumentation runs.
- `endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation` — the second section: the wrapFunction / addRejectionNote machinery that the returned TurnStarterFns invoke.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining` — eventual-send + promise-pipelining; this section's causal model is what makes the diagnostic surface track the pipelined chain.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — partial-failure + when-catch; broken-reference rejections carry the causality chain when the call site is many turns away.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules` — the formal Hoare logic; track-turns' runtime causal-event DAG is the operational counterpart to the *METH-CALL-2* postcondition that bounds reachability after a method call.
