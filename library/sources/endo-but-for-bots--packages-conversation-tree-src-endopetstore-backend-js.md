---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/conversation-tree/src/endopetstore-backend.js
source_line_range: 1-69
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 420 chat-lane ingest. 68-line endopetstore-
  backend.js from @endo/conversation-tree/src — the
  PERSISTENT backend whose async operations justify
  cycle 418's interface-parity-tax framing. Sixty-eighth
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-ten consecutive non-
  garden sources after the pivot (310-420). §one-
  hundred-and-ten-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  endopetstore-justifies-interface-parity-tax — cycle
  418 named the in-memory backend's async signatures
  as an interface tax: the in-memory backend doesn't
  need async, but the interface accommodates the
  persistent backend's async needs. Cycle 420 reads
  the persistent backend and sees the actual asyncs:
  every storage operation uses E(powers).storeValue
  (line 25) / E(powers).lookup (lines 32, 48) — genuine
  network/IPC round-trips through the eventual-send
  boundary. The async signatures are not vestigial; the
  persistent backend genuinely needs them. The two
  backends sit at OPPOSITE ENDS of the latency
  spectrum but share the SAME interface. §the-named-
  same-interface-opposite-latency-ends as tier-3 meta-
  pattern. Cycle 418's interface-parity-tax framing is
  now closed: the tax is paid by the in-memory backend
  so the persistent backend's async-ness is supported.

  §the-named-CT_PREFIX-shared-between-id-generation-
  and-petname-storage — line 9 declares `const
  CT_PREFIX = 'ct-'`. Cycle 414's conversation-tree/
  index.js generateId used `ct-${Date.now()}-
  ${nextSuffix}`. The petstore namespace uses the
  SAME `ct-` prefix for petname keys. The synthetic
  id and the petname share the prefix; namespace
  consistency across two layers (id generation in
  conversation-tree/index.js + petname storage here).
  §the-named-namespace-prefix-consistent-across-
  layers as tier-3 meta-pattern.

  §the-named-storeValue-and-lookup-as-persistence-
  primitives — lines 25, 32: uses E(powers).
  storeValue and E(powers).lookup. Confirms cycle
  404's mock-powers framing of storeValue as one of
  the guest powers that is NOT in the LLM-exposed
  tool catalog. §the-named-storeValue-as-persistence-
  used-from-agent-internal-code as tier-3 meta-
  pattern; storeValue is for the agent's INTERNAL
  use (like persistence), not for LLM-driven storage.

  §the-named-list-all-and-filter-by-prefix — lines
  40-58: getChildren calls E(powers).list() to get
  ALL petnames, filters by prefix `ct-`, then looks
  up each. O(n) over the ENTIRE petname namespace.
  §the-named-list-all-petnames-and-filter-by-prefix
  as tier-3 meta-pattern. The persistent backend has
  even worse query complexity than the memory
  backend (cycle 418) — same O(n) but with network
  round-trips per lookup.

  §the-named-getRoots-delegates-to-getChildren-null
  — lines 61-63: getRoots calls getChildren(null).
  Roots are children of null. §the-named-getRoots-
  as-getChildren-of-null as tier-3 meta-pattern;
  factoring through a single operation.

  §the-named-three-artifacts-agree-on-null-as-root-
  parent — counterexample to the cluster's drift
  framings. Three independent artifacts agree:
  - lal/agent.types.d.ts (cycle 402): TranscriptNode
    has parentMessageId; null root.
  - conversation-tree/src/memory-backend.js (cycle
    418): getRoots checks parentId === null.
  - conversation-tree/src/endopetstore-backend.js
    (cycle 420): getRoots delegates to getChildren
    (null).
  §the-named-cross-artifact-agreement-on-null-as-
  root as tier-3 meta-pattern; the cluster's drift
  vocabulary includes both drift AND agreement.

  §the-named-defensive-double-harden — line 25:
  `await E(powers).storeValue(harden(node), [petName])`.
  The node is hardened explicitly BEFORE being
  passed to storeValue. Conversation-tree's addNode
  (cycle 414) already hardens nodes; this backend
  hardens AGAIN. §the-named-double-harden-at-trust-
  boundary as tier-3 meta-pattern. Sibling to cycle
  416's trust-boundary-as-error-handling-asymmetry —
  the backend doesn't TRUST the caller's harden.

  §the-named-lookup-failure-as-not-found — lines 30-
  37, 46-55: both getNode and getChildren have try/
  catch around E(powers).lookup. If the lookup
  fails, the catch handler returns null (getNode) or
  skips (getChildren). §the-named-catch-as-existence-
  check as tier-3 meta-pattern; the petstore doesn't
  expose a `has` primitive used here; lookup-and-
  catch is the existence check.

  §the-named-eslint-disable-actively-needed — line
  2's file-level `/* eslint-disable no-await-in-loop
  */` is ACTIVELY needed here: line 44's `for (const
  name of allNames)` does await lookups inside.
  Compare with cycle 416's stale-eslint-disable in
  fae/src/tools.js. Some disables are needed, some
  are stale. §the-named-eslint-disable-need-varies-
  by-file as tier-3 meta-pattern; cluster's lint-
  config-vs-code drift extends with the contrast.

  §the-named-shared-petname-namespace-requires-prefix-
  filter — line 41: `E(powers).list()` returns ALL
  petnames, including those that aren't
  conversation-tree nodes. The backend filters by
  prefix `ct-` to ignore non-CT entries. The
  conversation-tree SHARES its petstore namespace
  with other code; namespace prefix discipline is
  required for coexistence. §the-named-petstore-as-
  shared-namespace as tier-3 meta-pattern.

  §the-named-per-petname-lookup-no-bulk-fetch —
  lines 44-56: for each matching petname, the
  backend does an individual lookup. No bulk-fetch
  optimization. Each child lookup is a round trip.
  §the-named-no-batch-API-for-petname-lookups as
  tier-3 meta-pattern; the petstore API exposes
  per-name primitives, not batch ones.

  §the-named-no-secondary-index-design-consistent —
  both backends (in-memory + endopetstore) have NO
  secondary index. getChildren and getRoots both
  scan. Design consistency across the two
  implementations. §the-named-design-consistency-
  across-backends as tier-3 meta-pattern; the
  backends share their query-time characteristics
  by design.

  §the-named-storeValue-takes-name-as-array — line
  25: `await E(powers).storeValue(harden(node),
  [petName])`. The petName is wrapped in an array,
  matching the path-array convention from cycle 401's
  mock-powers (where petNamePath is always an
  array). §the-named-petname-path-as-single-element-
  array as tier-3 meta-pattern.

  §the-named-type-assertion-via-JSDoc-cast — lines
  31, 41, 47: `/** @type {ConversationNode} */ (...)`
  and `/** @type {string[]} */ (...)`. JSDoc casts
  for runtime values that TypeScript can't infer.
  §the-named-runtime-type-assertion-via-JSDoc as
  tier-3 meta-pattern; sibling to cycle 416's type-
  narrowing-via-JSDoc-predicate.

  §the-named-import-E-from-endo-far — line 4:
  `import { E } from '@endo/far'`. Note the package
  is `@endo/far`, not `@endo/eventual-send`. Cycle
  410's setup.js used `@endo/eventual-send`. Cycle
  416's fae/src/tools.js used `@endo/eventual-send`.
  This file uses `@endo/far`. Different imports for
  the same E function — depends on whether the
  caller is in a "far" capability context or a
  general eventual-send context. §the-named-E-
  import-source-varies as tier-3 meta-pattern; the
  cluster's drift framings extend to import-source
  drift.

  §the-named-sixty-eight-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 419 (1, adjacent
  forward; conversation-tree provides storage for
  fae's transcript — cross-package dependency now
  visible at the storage level) + cycle 418 (5,
  MAJOR closure — interface-parity-tax framing's
  justification revealed; the tax was for THIS
  backend's actual async needs) + cycle 416 (3,
  trust-boundary-as-error-handling extends with
  defensive-double-harden) + cycle 414 (5,
  conversation-tree id-generation prefix matches
  this backend's namespace prefix; full picture of
  the tree storage) + cycle 404 (3, storeValue
  guest-power confirmed as persistence primitive) +
  cycle 402 (3, null-parent-as-root now confirmed
  by THREE artifacts) + cycle 401 (3, petNamePath-
  as-array convention) + cycle 326 (75) + cycle
  322 (75) + cycle 364 (4, shapes with new agree-
  ment framing). Pushes citation-arc-closures-in-
  pivot to SIX-HUNDRED-AND-SIXTY-FOUR (654 + 10 net
  new).
---

68-line endopetstore-backend.js from @endo/conversation-tree/src — the persistent backend whose actual async operations justify cycle 418's interface-parity-tax framing. Chat-lane after cycle 419 designs-lane fae/README.md. **Single most structurally interesting move**: §the-named-endopetstore-justifies-interface-parity-tax — *cycle 418 named the in-memory backend's async signatures as an interface tax. Cycle 420 reads the persistent backend and sees the actual asyncs: every storage operation uses E(powers).storeValue / lookup — genuine network/IPC round-trips. The async signatures are not vestigial; the persistent backend genuinely needs them. The two backends sit at OPPOSITE ENDS of the latency spectrum but share the SAME interface.* §the-named-same-interface-opposite-latency-ends as tier-3 meta-pattern. §the-named-CT_PREFIX-shared-between-id-generation-and-petname-storage (cycle 414's id-prefix matches this backend's petname-prefix); §the-named-namespace-prefix-consistent-across-layers. §the-named-storeValue-and-lookup-as-persistence-primitives (confirms cycle 404's guest-power-vs-LLM-tool surface); §the-named-storeValue-as-persistence-used-from-agent-internal-code. §the-named-list-all-and-filter-by-prefix (O(n) over entire petstore namespace plus network round-trips per lookup); §the-named-list-all-petnames-and-filter-by-prefix. §the-named-getRoots-delegates-to-getChildren-null; §the-named-getRoots-as-getChildren-of-null. §the-named-three-artifacts-agree-on-null-as-root-parent (counterexample to drift framings — lal/agent.types.d.ts, memory-backend, and endopetstore-backend ALL agree on null=root); §the-named-cross-artifact-agreement-on-null-as-root (cluster vocabulary includes drift AND agreement). §the-named-defensive-double-harden (backend doesn't trust caller's harden — sibling to cycle 416 trust-boundary framing); §the-named-double-harden-at-trust-boundary. §the-named-lookup-failure-as-not-found (try/catch around lookup is the existence check); §the-named-catch-as-existence-check. §the-named-eslint-disable-actively-needed (contrast with cycle 416's stale-eslint-disable); §the-named-eslint-disable-need-varies-by-file. §the-named-shared-petname-namespace-requires-prefix-filter; §the-named-petstore-as-shared-namespace (the petstore is a shared resource; conversation-tree namespaces itself with `ct-` prefix). §the-named-per-petname-lookup-no-bulk-fetch; §the-named-no-batch-API-for-petname-lookups. §the-named-no-secondary-index-design-consistent (both backends share this design choice); §the-named-design-consistency-across-backends. §the-named-storeValue-takes-name-as-array; §the-named-petname-path-as-single-element-array. §the-named-type-assertion-via-JSDoc-cast; §the-named-runtime-type-assertion-via-JSDoc. §the-named-import-E-from-endo-far (E imported from @endo/far here, not @endo/eventual-send as in cycle 410/416); §the-named-E-import-source-varies (cluster's drift framings extend to import-source drift). §the-named-sixty-eight-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-SIXTY-FOUR.
