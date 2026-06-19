---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/conversation-tree/src/memory-backend.js
source_line_range: 1-53
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 418 chat-lane ingest. 52-line memory-backend.js
  from @endo/conversation-tree/src. The in-memory
  implementation of the TreeBackend interface cycle 414's
  conversation-tree/index.js consumed. Sixty-sixth
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-eight consecutive non-
  garden sources after the pivot (310-418). §one-hundred-
  and-eight-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  async-for-interface-parity-with-persistent-backend —
  every backend method is `async` (lines 19, 23, 27, 38)
  even though the in-memory Map operations themselves
  are synchronous. The async signatures are NOT for the
  Map's sake; they exist for INTERFACE PARITY with the
  persistent backend (endopetstore-backend.js) which is
  genuinely async. The TreeBackend interface must
  accommodate the async case, so all implementations
  honor it. §the-named-async-everywhere-because-some-
  implementations-need-it as tier-3 meta-pattern; the
  interface design accommodates the WORST CASE (async
  storage), not the BEST CASE (sync Map). The in-memory
  implementation is constrained by the persistent
  implementation's interface needs.

  §the-named-storage-primitives-vs-traversal-derivatives
  — the TreeBackend interface has FOUR operations
  (putNode + getNode + getChildren + getRoots) while the
  ConversationTree from cycle 414 has FIVE (adds
  getPath). The layering: ConversationTree (storage +
  traversal) → TreeBackend (storage only). getPath
  lives in the higher tree layer; it COMPOSES backend
  operations into a traversal. §the-named-four-storage-
  primitives-five-tree-operations as tier-3 meta-
  pattern; the storage layer is leaner than the consumer
  layer because traversal is derivable.

  §the-named-no-parentId-index-O-n-per-query — lines 27-
  46: getChildren and getRoots both ITERATE all nodes in
  the Map. No secondary index by parentId. Each query is
  O(n). Acceptable for in-memory ephemeral use; would
  be slow for large trees in persistent storage. §the-
  named-intentional-simplicity-of-in-memory-backend as
  tier-3 meta-pattern; the memory backend trades
  query-time complexity for code simplicity.

  §the-named-undefined-to-null-coercion — line 24:
  `return nodes.get(id) ?? null`. Map.get returns
  undefined; nullish-coalescing converts to null.
  §the-named-null-as-explicit-absence-not-undefined as
  tier-3 meta-pattern; Endo packages prefer null-as-
  explicit-absence over undefined-as-default-absence.

  §the-named-getRoots-checks-parentId-null — line 42:
  Roots are nodes with `parentId === null`. Confirms
  cycle 402's "tree rooted at null parent" framing.
  Same shape as the type definition. §the-named-null-
  parent-as-root-marker as tier-3 meta-pattern.

  §the-named-harden-on-backend-and-factory — lines 50,
  52: both the returned backend AND the factory function
  are hardened. Conversation-tree package follows the
  rigorous harden discipline established in cycle 414's
  conversation-tree/index.js. §the-named-package-wide-
  harden-discipline-in-conversation-tree as tier-3 meta-
  pattern.

  §the-named-import-JSDoc-tag-for-types-from-parent-
  directory — line 5: `/** @import { ConversationNode,
  TreeBackend } from '../types.js' */`. Imports types
  from the parent directory's types.js. §the-named-
  parent-directory-type-import as tier-3 meta-pattern.

  §the-named-in-memory-backend-for-browser-and-tests —
  lines 8-9: "Suitable for browser-side use and tests
  — state lives only as long as the page / process."
  The memory backend is targeted at NON-DAEMON contexts.
  §the-named-environment-specific-backend-deployment
  as tier-3 meta-pattern; in-memory for ephemeral,
  endopetstore for persistent.

  §the-named-type-narrowing-via-JSDoc-throughout — lines
  14, 17, 28, 39 all use `/** @type {...} */`
  annotations. The Endo discipline of JSDoc-as-
  TypeScript pervades. §the-named-JSDoc-types-pervasive
  as tier-3 meta-pattern; sibling to cycle 416's
  type-narrowing-via-JSDoc-predicate.

  §the-named-Map-as-id-index — line 15: `const nodes =
  new Map()`. The Map's keys are node ids; the Map IS
  the only index. No secondary index by parentId; no
  composite indices. Single primary index. §the-named-
  one-index-many-scans as tier-3 meta-pattern.

  §the-named-explicit-empty-array-then-push — lines 28-
  34, 39-45: each scan creates an empty array then
  pushes matching nodes. No filter() call. Could be
  written with Array.from + filter; isn't. Style
  choice. §the-named-explicit-collect-loop-vs-filter
  as tier-3 meta-pattern.

  §the-named-sixty-six-conformant-cycles-and-counting —
  sixty-sixth AUTHORED conformant single-body section
  doc in post-refactor era.

  Closes nine citation arcs: cycle 417 (1, adjacent
  forward; 2D design space now includes the
  conversation-tree storage layer as another point of
  variation) + cycle 414 (5, MAJOR completion — cycle
  414 saw the consumer layer (ConversationTree) using
  the backend interface; cycle 418 sees the backend
  implementation; the storage-primitives-vs-traversal-
  derivatives framing closes the picture) + cycle 416
  (3, async-for-interface-parity echoes cycle 416's
  type-union-reflects-trust-boundary — both are
  interface-design choices that affect implementation
  shape) + cycle 412 (3, nullish-coalescing pattern
  recurs) + cycle 402 (3, null-parent-as-root confirmed
  again at the storage level) + cycle 326 (75) + cycle
  322 (75) + cycle 364 (4, shapes count keeps growing)
  + cycle 387 (3, branded-types via TreeBackend
  interface). Pushes citation-arc-closures-in-pivot to
  SIX-HUNDRED-AND-FORTY-FOUR (635 + 9 net new).
---

52-line memory-backend.js from @endo/conversation-tree/src — the in-memory implementation of the TreeBackend interface cycle 414's conversation-tree/index.js consumed. Chat-lane after cycle 417 designs-lane COMPARISON-FAE-NANOBOT.md. **Single most structurally interesting move**: §the-named-async-for-interface-parity-with-persistent-backend — *every backend method is async (lines 19, 23, 27, 38) even though Map operations are synchronous. The async signatures are NOT for the Map's sake; they exist for INTERFACE PARITY with the persistent backend (endopetstore-backend.js). The TreeBackend interface accommodates the WORST CASE (async storage), not the BEST CASE (sync Map). The in-memory implementation is constrained by the persistent implementation's interface needs.* §the-named-async-everywhere-because-some-implementations-need-it as tier-3 meta-pattern. §the-named-storage-primitives-vs-traversal-derivatives (TreeBackend has FOUR ops: putNode/getNode/getChildren/getRoots; ConversationTree has FIVE: adds getPath as traversal derivative); §the-named-four-storage-primitives-five-tree-operations. §the-named-no-parentId-index-O-n-per-query; §the-named-intentional-simplicity-of-in-memory-backend (memory backend trades query-time complexity for code simplicity). §the-named-undefined-to-null-coercion (line 24: `?? null`); §the-named-null-as-explicit-absence-not-undefined. §the-named-getRoots-checks-parentId-null (confirms cycle 402's tree-rooted-at-null-parent); §the-named-null-parent-as-root-marker. §the-named-harden-on-backend-and-factory (rigorous discipline continues from cycle 414); §the-named-package-wide-harden-discipline-in-conversation-tree. §the-named-import-JSDoc-tag-for-types-from-parent-directory; §the-named-parent-directory-type-import. §the-named-in-memory-backend-for-browser-and-tests (NON-DAEMON contexts); §the-named-environment-specific-backend-deployment. §the-named-type-narrowing-via-JSDoc-throughout; §the-named-JSDoc-types-pervasive. §the-named-Map-as-id-index (single primary index, no secondary); §the-named-one-index-many-scans. §the-named-explicit-empty-array-then-push (vs filter()); §the-named-explicit-collect-loop-vs-filter. §the-named-sixty-six-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-FORTY-FOUR.
