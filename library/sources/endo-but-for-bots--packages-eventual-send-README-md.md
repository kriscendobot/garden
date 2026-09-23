---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/eventual-send/README.md
source_line_range: 1-332
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 431 designs-lane ingest. 332-line README.md for
  @endo/eventual-send — the E() primitive underlying
  every remote method call the cluster has framed.
  Closes the eventual-send framing the cluster has been
  invoking since cycle 401. Seventy-ninth AUTHORED
  conformant single-body section doc in post-refactor
  era. One-hundred-and-twenty-first consecutive non-
  garden source after the pivot (310-431). §one-
  hundred-and-twenty-one-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  promise-pipelining-as-round-trip-elimination — lines
  138-173. The KILLER feature: messages can be sent to
  UNRESOLVED promises; they queue and execute in order
  when the promise resolves. Without pipelining, four
  remote operations require four round trips:
  ```
  const mint = await bootstrap.getMint();        // wait
  const purse = await mint.makePurse();          // wait
  const payment = await purse.withdraw(100);     // wait
  await receiverPurse.deposit(100, payment);     // wait
  ```
  With pipelining, all four messages send immediately:
  ```
  const mintP = E(bootstrap).getMint();
  const purseP = E(mintP).makePurse();
  const paymentP = E(purseP).withdraw(100);
  await E(receiverPurse).deposit(100, paymentP);
  ```
  The cluster's many E()-using framings (cycles 401-
  430) now have a deeper purpose. Not just "uniform
  API across local/remote" but ROUND-TRIP ELIMINATION
  via pipelining. §the-named-messages-to-unresolved-
  promises-queue-and-deliver-in-order as tier-3 meta-
  pattern. This is what justifies the entire eventual-
  send architecture: the latency reduction is
  proportional to the chain depth.

  §the-named-E-works-uniformly-across-four-target-shapes
  — lines 61-65. E() handles: (1) a local object, (2) a
  local promise for an object, (3) a remote presence in
  another vat, (4) a promise for a remote presence.
  Cycle 416's E-send-as-locality-transparent now
  grounded with the four-shape enumeration. §the-named-
  four-target-shapes-for-E as tier-3 meta-pattern.

  §the-named-five-E-variants — lines 41-136:
  - E(target).method(...args) — eventual send
  - E.get(target).property — eventual property access
  - E.sendOnly(target).method(...args) — fire-and-forget
  - E.when(promiseOrValue, onFulfilled?, onRejected?) —
    turn tracking shorthand
  - E.resolve(value) — convert to HandledPromise
  §the-named-E-as-five-variant-namespace as tier-3
  meta-pattern.

  §the-named-HandledPromise-three-resolution-modes —
  lines 255-279. The underlying mechanism: a Promise
  subclass with three settle modes:
  - resolve(value): normal resolution
  - reject(reason): rejection
  - resolveWithPresence(handler): resolve with a remote
    presence
  §the-named-resolveWithPresence-as-settle-with-remote
  as tier-3 meta-pattern. Connects to cycle 423's
  pass-by-presence framing — resolveWithPresence is
  the constructor for pass-by-presence values.

  §the-named-eval-twins-mitigation-via-shim — lines
  31-33: "The shim ensures that every instance of
  Eventual Send can recognize every other instance's
  handled promises. This is how we mitigate, what we
  call, 'eval twins'." EVAL TWINS occur when two
  copies of eventual-send are loaded in the same
  realm (via different module resolution paths),
  creating DIFFERENT HandledPromise classes that
  don't recognize each other. The shim prevents this.
  §the-named-eval-twins-as-module-identity-hazard as
  tier-3 meta-pattern; SES environments have unique
  module-loading pitfalls.

  §the-named-per-target-FIFO-message-ordering — lines
  193-204. Messages to the SAME target are delivered
  in send order. Different targets have no order
  guarantee. §the-named-per-target-FIFO as tier-3
  meta-pattern.

  §the-named-write-local-deploy-distributed — lines
  16, 191, 210-220. "Write local code, deploy
  distributed, no changes needed." Core design intent.
  §the-named-local-to-distributed-without-code-change
  as tier-3 meta-pattern.

  §the-named-eventual-send-as-TC39-proposal-polyfill
  — lines 322-324: "This package implements the
  ECMAScript eventual-send proposal." Eventual-send
  is positioned as a polyfill of a proposed JS
  language feature. §the-named-package-as-proposal-
  polyfill as tier-3 meta-pattern.

  §the-named-Mark-Miller-thesis-as-eventual-send-
  foundation — lines 329-330: "Concurrency Among
  Strangers - Mark S. Miller's thesis on eventual
  send." The cluster's accumulated framings now
  connect to the academic root. §the-named-thesis-
  citation-as-academic-foundation as tier-3 meta-
  pattern.

  §the-named-turn-as-discrete-message-processing-unit
  — lines 109-126: E.when "for explicit turn tracking
  for debugging." TURNS are the discrete units of
  message processing — at each turn, all messages
  that arrived can be processed; new messages from
  this turn arrive in the next turn. §the-named-
  message-turns-as-event-loop-tick as tier-3 meta-
  pattern.

  §the-named-applyMethod-uses-verb-not-method-name —
  line 274: The HandledPromise handler's method
  signature is `applyMethod(target, verb, args)`.
  "Verb" instead of "method name." §the-named-verb-as-
  method-name-in-handler-protocol as tier-3 meta-
  pattern.

  §the-named-E-on-local-exo-provides-turn-isolation —
  lines 249-253: Even for local exos, using E()
  provides: (1) consistent async behavior; (2) turn-
  based execution prevents reentrancy bugs; (3) error
  isolation via promise rejection; (4) future-proof
  code. §the-named-E-as-reentrancy-prevention as
  tier-3 meta-pattern.

  §the-named-use-E-in-tests-even-for-local-targets —
  lines 281-303: "Use E() even in unit tests for
  consistency." Cycle 430's loopback-as-conformance-
  tester now joined by the recommendation to use E()
  in ALL test code. §the-named-E-in-tests-mirrors-
  production as tier-3 meta-pattern.

  §the-named-E-sendOnly-as-fire-and-forget-without-
  errors — lines 86-105: "You won't get errors if the
  method fails. Use regular E() if you need error
  handling." Trade-off explicit. §the-named-sendOnly-
  silently-drops-failures as tier-3 meta-pattern.

  §the-named-integration-map-to-other-Endo-packages —
  lines 305-318: eventual-send depends on / works
  with pass-style (arguments), patterns (signatures),
  exo (defensive targets), captp (network transport).
  The cluster's package dependency map now spans:
  pass-style at base; marshal serializes Passables;
  patterns describes shapes; exo combines Far +
  guards; eventual-send sends messages; captp wires
  cross-vat. §the-named-five-package-Endo-stack as
  tier-3 meta-pattern.

  §the-named-shim-required-outside-Agoric-Endo-
  environments — lines 18-29. Eventual-send relies on
  an Endo environment. Programs running in Agoric
  smart contracts or Endo plugins don't need to do
  anything special. Other contexts need to import
  the shim. §the-named-Endo-environment-as-runtime-
  prerequisite as tier-3 meta-pattern.

  §the-named-seventy-nine-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 430 (1, adjacent
  forward; Loopback uses E() internally for the cross-
  bootstrap calls) + cycle 429 (3, CapTP carries E()
  messages across vats — eventual-send is the
  message-passing API; CapTP is the wire transport)
  + cycle 425 (5, exo's E() integration now fully
  grounded; E-on-local-exo-provides-turn-isolation
  named) + cycle 423 (5, resolveWithPresence is the
  constructor for pass-by-presence values; pass-by-
  presence framing now has an E-side complement) +
  cycle 416 (5, E-send-as-locality-transparent
  grounded with four-target-shape enumeration; E in
  fae/src/tools.js is THIS API) + cycle 408 (3,
  three-channel-error-detection sibling to
  applyMethod handler protocol) + cycle 326 (75) +
  cycle 322 (75) + cycle 318 (5, Endo idiom — E and
  eventual send are the cluster's deepest primitive)
  + cycle 387 (3, branded-types via HandledPromise
  class identity matters for eval-twins). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-
  SEVENTY-TWO (762 + 10 net new).
---

332-line README.md for @endo/eventual-send — the E() primitive underlying every remote method call the cluster has framed. Closes the eventual-send framing the cluster has been invoking since cycle 401. Designs-lane after cycle 430 chat-lane captp/src/loopback.js. **Single most structurally interesting move**: §the-named-promise-pipelining-as-round-trip-elimination — *messages can be sent to UNRESOLVED promises; they queue and execute in order when the promise resolves. Without pipelining, four remote operations require four round trips; with pipelining, four messages send immediately. The cluster's many E()-using framings (cycles 401-430) now have a deeper purpose: not just "uniform API across local/remote" but ROUND-TRIP ELIMINATION via pipelining. The latency reduction is proportional to chain depth.* §the-named-messages-to-unresolved-promises-queue-and-deliver-in-order as tier-3 meta-pattern. §the-named-E-works-uniformly-across-four-target-shapes (local object, local promise, remote presence, promise for remote); §the-named-four-target-shapes-for-E. §the-named-five-E-variants (E.method + E.get + E.sendOnly + E.when + E.resolve); §the-named-E-as-five-variant-namespace. §the-named-HandledPromise-three-resolution-modes (resolve + reject + resolveWithPresence); §the-named-resolveWithPresence-as-settle-with-remote (constructor for pass-by-presence values; connects to cycle 423). §the-named-eval-twins-mitigation-via-shim (two copies of eventual-send creating different HandledPromise classes); §the-named-eval-twins-as-module-identity-hazard (SES environments have unique module-loading pitfalls). §the-named-per-target-FIFO-message-ordering; §the-named-per-target-FIFO. §the-named-write-local-deploy-distributed; §the-named-local-to-distributed-without-code-change. §the-named-eventual-send-as-TC39-proposal-polyfill; §the-named-package-as-proposal-polyfill. §the-named-Mark-Miller-thesis-as-eventual-send-foundation (Concurrency Among Strangers); §the-named-thesis-citation-as-academic-foundation. §the-named-turn-as-discrete-message-processing-unit; §the-named-message-turns-as-event-loop-tick. §the-named-applyMethod-uses-verb-not-method-name; §the-named-verb-as-method-name-in-handler-protocol. §the-named-E-on-local-exo-provides-turn-isolation (reentrancy prevention even for local targets); §the-named-E-as-reentrancy-prevention. §the-named-use-E-in-tests-even-for-local-targets (cycle 430's loopback-as-conformance-tester extended); §the-named-E-in-tests-mirrors-production. §the-named-E-sendOnly-as-fire-and-forget-without-errors; §the-named-sendOnly-silently-drops-failures. §the-named-integration-map-to-other-Endo-packages (cluster's five-package Endo stack); §the-named-five-package-Endo-stack (pass-style + marshal + patterns + exo + eventual-send + captp). §the-named-shim-required-outside-Agoric-Endo-environments; §the-named-Endo-environment-as-runtime-prerequisite. §the-named-seventy-nine-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-SEVENTY-TWO.
