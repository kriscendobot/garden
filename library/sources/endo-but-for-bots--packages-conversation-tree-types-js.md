---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/conversation-tree/types.js
source_line_range: 1-42
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 421 designs-lane ingest. 41-line types.js from
  @endo/conversation-tree — the canonical type
  definitions. Closes the conversation-tree picture
  (cycles 414, 418, 420 saw consumer + memory + persistent
  backend; cycle 421 sees the type definitions binding
  them). Sixty-ninth AUTHORED conformant single-body
  section doc in post-refactor era. One-hundred-and-
  eleven consecutive non-garden sources after the pivot
  (310-421). §one-hundred-and-eleven-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  consumer-API-restricts-storage-API-flexibility — the
  ConversationTree.getChildren (line 37) has signature
  `(parentId: string) => Promise<ConversationNode[]>` —
  REQUIRES a string. But the TreeBackend.getChildren
  (line 28) has signature `(parentId: string | null) =>
  Promise<ConversationNode[]>` — ACCEPTS null. The
  consumer-facing API is MORE RESTRICTIVE than the
  storage API. Users CANNOT pass null to
  ConversationTree.getChildren; they must use getRoots()
  for null-parent queries. The backend handles both
  cases; the consumer layer exposes only the non-null
  case. §the-named-consumer-API-adds-and-restricts-
  relative-to-storage as tier-3 meta-pattern. Cycle 418
  noted the consumer ADDS getPath as a traversal
  derivative; cycle 421 notes the consumer also
  RESTRICTS getChildren. The layering is bidirectional:
  the consumer API can both add NEW operations AND
  restrict existing ones — refining the layering
  framing.

  §the-named-ChatMessage-shape-shared-between-conversation-
  tree-and-lal — lines 4-9: ChatMessage typedef matches
  lal/agent.types.d.ts (cycle 402) exactly. Same 4-role
  union ('system' | 'user' | 'assistant' | 'tool'),
  string content, optional tool_calls and tool_call_id.
  But the two packages DON'T import from each other —
  they DUPLICATE the typedef. §the-named-cross-package-
  type-duplication-with-matching-shape as tier-3 meta-
  pattern. Two packages independently define a shape-
  compatible ChatMessage type. Drift across packages
  could now happen if either side changes; for now, they
  match.

  §the-named-addNode-as-construct-putNode-as-store —
  line 34 ConversationTree.addNode: `(parentId, messages,
  metadata?) => Promise<ConversationNode>` — constructs
  a node from parts. Line 26 TreeBackend.putNode: `(node:
  ConversationNode) => Promise<void>` — stores a pre-
  constructed node. Different APIs for different layer
  roles: construct vs store. §the-named-construct-vs-
  store-as-layer-distinction as tier-3 meta-pattern;
  cycle 418's storage-primitives-vs-traversal-derivatives
  now refined: the layer also distinguishes
  CONSTRUCTION (consumer) from STORAGE (backend).

  §the-named-metadata-as-open-schemaless-record — line
  20: `metadata: Record<string, unknown>`. Arbitrary
  metadata. §the-named-open-record-for-extensibility
  as tier-3 meta-pattern.

  §the-named-scene-summary-label-as-metadata-uses —
  line 20's comment: "Arbitrary metadata (scene,
  summary, label)". Three example metadata fields hint
  at conversation-tree use cases: scene suggests
  narrative/game-like uses; summary suggests memory
  consolidation; label suggests tagging. §the-named-
  metadata-use-cases-hint-at-cluster-uses as tier-3
  meta-pattern; cycle 417's nanobot has explicit memory
  consolidation; conversation-tree's metadata supports
  summary (consolidation-related) usage.

  §the-named-id-comment-says-endo-messageId-or-uuid —
  line 17: "Unique identifier (endo messageId or
  generated uuid)". Confirms cycle 414's framing:
  the id is the daemon's messageId when available,
  generated when not. §the-named-dual-id-source-
  daemon-or-generated-confirmed as tier-3 meta-
  pattern.

  §the-named-parentId-comment-says-endo-replyTo —
  line 18: "Parent node id (endo replyTo), null for
  roots". The parentId IS the endo daemon's replyTo
  field. So the tree structure mirrors the inbox
  message threading. Cycle 407 noted messageId +
  replyTo for threading; cycle 421 confirms the tree
  uses these directly. §the-named-parentId-as-endo-
  replyTo-field as tier-3 meta-pattern.

  §the-named-timestamp-as-number-not-Date — line 21:
  `timestamp: number`. Plain number, not Date.
  JavaScript Date.now() returns milliseconds since
  epoch. §the-named-epoch-milliseconds-as-timestamp
  as tier-3 meta-pattern.

  §the-named-export-empty-as-types-only-module — line
  41: `export {}`. The module exports nothing; it
  only declares typedefs. The empty export makes it a
  module (instead of a script). §the-named-types-only-
  module-marker as tier-3 meta-pattern.

  §the-named-getNode-pass-through-between-layers —
  line 27 TreeBackend.getNode: `(id: string) =>
  Promise<ConversationNode | null>`. Line 35
  ConversationTree.getNode: same signature. Pass-
  through; the consumer-facing API is identical to
  the storage API for getNode. §the-named-getNode-
  identical-across-layers as tier-3 meta-pattern.

  §the-named-getRoots-pass-through-between-layers —
  line 29 TreeBackend.getRoots: `() =>
  Promise<ConversationNode[]>`. Line 38
  ConversationTree.getRoots: same. Pass-through.
  §the-named-getRoots-identical-across-layers as
  tier-3 meta-pattern.

  §the-named-three-tier-API-layering — the cluster
  now sees THREE tiers in the conversation-tree
  package: ConversationTree (consumer-facing, ADDS
  getPath, RESTRICTS getChildren) → TreeBackend
  (storage-facing, full primitives) → backend
  implementations (memory + endopetstore, no
  interface changes from TreeBackend). §the-named-
  consumer-storage-implementation-three-tier-layering
  as tier-3 meta-pattern.

  §the-named-metadata-optional-on-addNode-but-
  required-on-ConversationNode — line 34: addNode's
  metadata parameter is `?` (optional). Line 20:
  ConversationNode's metadata field is REQUIRED.
  So addNode generates a default metadata (empty
  object per cycle 414's `metadata = {}` default)
  when caller omits it. §the-named-optional-input-
  required-output-pattern as tier-3 meta-pattern.

  §the-named-ChatMessage-tool_calls-as-untyped-
  object-array — line 7: `tool_calls?: object[]`.
  The tool_calls field is an array of OBJECTS — not
  the more specific shape lal/agent.types.d.ts gives
  (cycle 402's ToolCall typedef). Conversation-tree
  is LESS PRECISE than lal about tool_calls
  structure. §the-named-conversation-tree-less-
  precise-than-lal-on-tool_calls as tier-3 meta-
  pattern; types-only file uses less-precise types
  than the lal package's own type definitions.

  §the-named-sixty-nine-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 420 (1, adjacent
  forward; type definitions bind the persistent
  backend's data shape) + cycle 418 (5, MAJOR
  REFINEMENT — storage-primitives-vs-traversal-
  derivatives extended to consumer-adds-and-restricts;
  the layer can both add NEW operations and RESTRICT
  existing ones) + cycle 414 (5, dual-id-source
  (daemon or generated) confirmed; cycle 414's
  generateId fallback confirmed in type comment) +
  cycle 407 (5, messageId/replyTo threading confirmed
  as the SAME mechanism the conversation-tree uses;
  parentId IS the replyTo field) + cycle 402 (5,
  ChatMessage typedef shape-compatible between
  conversation-tree and lal; CROSS-PACKAGE TYPE
  DUPLICATION named) + cycle 326 (75) + cycle 322
  (75) + cycle 387 (3, branded-types — conversation-
  tree types are open Record vs lal's branded types)
  + cycle 364 (4, shapes count) + cycle 346 (3,
  name-aliasing — conversation-tree's id ↔ lal's
  messageId; conversation-tree's parentId ↔ lal's
  parentMessageId, replyTo). Pushes citation-arc-
  closures-in-pivot to SIX-HUNDRED-AND-SEVENTY-FOUR
  (664 + 10 net new).
---

41-line types.js from @endo/conversation-tree — the canonical type definitions binding the three artifacts cycles 414, 418, 420 ingested. Designs-lane after cycle 420 chat-lane endopetstore-backend.js. **Single most structurally interesting move**: §the-named-consumer-API-restricts-storage-API-flexibility — *ConversationTree.getChildren (line 37) requires `parentId: string` — REJECTS null. TreeBackend.getChildren (line 28) accepts `parentId: string | null` — ACCEPTS null. The consumer-facing API is MORE RESTRICTIVE than the storage API. Cycle 418 noted the consumer ADDS getPath as a traversal derivative; cycle 421 notes the consumer also RESTRICTS getChildren. The layering is bidirectional: the consumer API can both add NEW operations AND restrict existing ones.* §the-named-consumer-API-adds-and-restricts-relative-to-storage as tier-3 meta-pattern. §the-named-ChatMessage-shape-shared-between-conversation-tree-and-lal (matches cycle 402's lal type exactly but DUPLICATED across packages without import); §the-named-cross-package-type-duplication-with-matching-shape (drift risk if either side changes). §the-named-addNode-as-construct-putNode-as-store; §the-named-construct-vs-store-as-layer-distinction (cycle 418's storage-vs-traversal refined to include construct-vs-store). §the-named-metadata-as-open-schemaless-record; §the-named-open-record-for-extensibility. §the-named-scene-summary-label-as-metadata-uses (hints at narrative/consolidation/tagging use cases); §the-named-metadata-use-cases-hint-at-cluster-uses. §the-named-id-comment-says-endo-messageId-or-uuid (confirms cycle 414's dual-id-source framing); §the-named-dual-id-source-daemon-or-generated-confirmed. §the-named-parentId-comment-says-endo-replyTo (parentId IS the endo replyTo — tree structure mirrors inbox threading); §the-named-parentId-as-endo-replyTo-field. §the-named-timestamp-as-number-not-Date (epoch ms); §the-named-epoch-milliseconds-as-timestamp. §the-named-export-empty-as-types-only-module; §the-named-types-only-module-marker. §the-named-getNode-pass-through-between-layers; §the-named-getNode-identical-across-layers. §the-named-getRoots-pass-through-between-layers; §the-named-getRoots-identical-across-layers. §the-named-three-tier-API-layering (ConversationTree → TreeBackend → backend implementations); §the-named-consumer-storage-implementation-three-tier-layering. §the-named-metadata-optional-on-addNode-but-required-on-ConversationNode (default-construction pattern); §the-named-optional-input-required-output-pattern. §the-named-ChatMessage-tool_calls-as-untyped-object-array (conversation-tree LESS PRECISE than lal's ToolCall typedef); §the-named-conversation-tree-less-precise-than-lal-on-tool_calls. §the-named-sixty-nine-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-SEVENTY-FOUR.
