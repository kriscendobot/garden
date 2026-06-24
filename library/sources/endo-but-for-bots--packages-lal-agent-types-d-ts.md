---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/agent.types.d.ts
source_line_range: 1-127
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 402 chat-lane ingest. 127-line agent.types.d.ts,
  the TypeScript type-definition file for @endo/lal. Pairs
  to cycle 401's LAL-ARCHITECTURE.md (whose §the-named-
  type-system section lists eight types) and cycle 400's
  source. Fiftieth AUTHORED conformant single-body section
  doc in post-refactor era. Ninety-two consecutive non-
  garden sources after the pivot (310-402). §ninety-two-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  vestigial-types-from-abandoned-design — lines 81-96 still
  define PendingProposal and ProposalNotification types,
  but cycle 401's LAL-ARCHITECTURE.md (lines 41, 233-235)
  explicitly states "No proposal/grant workflow is needed"
  and "There is no proposal/grant workflow — the evaluate
  tool call blocks until the code finishes and the result
  is stored under resultName." The design moved on; the
  types remained. The types file LAGS BEHIND the design
  decision. §the-named-types-lag-design-decision as tier-3
  meta-pattern.

  §the-named-drift-direction-can-invert-between-document-
  pairs — cycle 401 found documents (README + design doc)
  LAGGING the source on the Anthropic default model.
  Cycle 402 finds types LAGGING the design decision on
  proposal/grant workflow. The drift direction INVERTS:
  in one case documents lag code; in another case code
  lags documents. The two-speed strata can run in either
  direction. The cluster's drift vocabulary now must
  distinguish drift DIRECTION as well as drift KIND.
  §the-named-bidirectional-document-code-drift as tier-3
  meta-pattern.

  §the-named-richer-types-than-design-doc-describes —
  lines 118-127 define TranscriptNode as a "linked-chain
  transcript" where each node stores only messages
  appended at that step plus a parent pointer. Cycle
  401's LAL-ARCHITECTURE.md (line 340) said the
  transcript is "an in-memory array that grows
  indefinitely" — a flat array. The types define a
  more sophisticated linked-chain structure that the
  design doc does not describe. Either the types are
  aspirational (planned future structure) or the design
  doc undercounts the actual implementation. §the-named-
  types-richer-than-design-doc as tier-3 meta-pattern.

  §the-named-WorkerConfig-for-form-submission-flow-not-in-
  architecture-doc — lines 99-104 define WorkerConfig as
  "Configuration for a worker spawned from a form
  submission." But cycle 401's LAL-ARCHITECTURE.md
  describes Lal as a single-agent message-following loop;
  the form-submission flow is mentioned in the inner
  package CLAUDE.md (lal/CLAUDE.md line 5) but NOT in
  the architecture document. The .d.ts knows about a
  feature the .md doesn't document. §the-named-types-
  document-features-architecture-doc-omits as tier-3
  meta-pattern.

  §the-named-ToolCallArgs-as-flat-union-of-all-tool-
  arguments — lines 56-76: a single record type with 19
  optional fields, every possible argument across all 18
  tools. No discriminated union per tool kind. §the-named-
  flat-optional-union-as-tool-argument-shape as tier-3
  meta-pattern; sibling to cycle 387 AGENTS.md branded
  types discipline but at a simpler level — flat optional
  record rather than tagged union.

  §the-named-id-optional-on-ToolCall — line 36: ToolCall
  has `id?: string` (optional). Matches cycle 401's
  observation that Ollama synthesizes IDs. The TypeScript
  schema accommodates the upstream LLM behavior. §the-
  named-type-shape-accommodates-protocol-divergence as
  tier-3 meta-pattern; sibling to cycle 401's synthetic-
  tool-call-IDs-for-Ollama.

  §the-named-tool-call-id-optional-on-ChatMessage — line
  47: same shape; ChatMessage has `tool_call_id?:
  string`. The optionality is consistent across the
  schema where Ollama-style synthesis is needed.

  §the-named-ChatMessage-role-as-string-literal-union —
  line 44: `role: 'system' | 'user' | 'assistant' |
  'tool'`. Sibling to cycle 400's literal-union-as-enum-
  shape and cycle 378's mode-selector shape. The
  TypeScript discriminator for OpenAI-format role.

  §the-named-Tool-as-discriminated-by-type-function —
  lines 30-33: `type: 'function'` is the literal that
  marks a function-shaped Tool. Discriminator is a string
  literal. The schema leaves room for other future
  type values (extension point) without committing to
  them now. §the-named-discriminator-as-extension-point
  as tier-3 meta-pattern.

  §the-named-Tool-Parameters-as-nested-typed-record —
  lines 11-22: ToolParameterProperty has type +
  description + items + oneOf. The oneOf field supports
  OpenAI's anyOf/oneOf type variants. ToolParameters is
  type: 'object' + properties: Record + required:
  string[]. Reflects OpenAI's JSON-Schema-subset tool
  parameter format. §the-named-JSON-schema-subset-as-
  tool-parameter-format as tier-3 meta-pattern.

  §the-named-InboxMessage-as-alias-for-StampedMessage —
  line 78. The design doc names this type; the types
  file confirms. §the-named-type-alias-as-renaming-
  for-clarity as tier-3 meta-pattern; sibling to cycle
  346's name-aliasing-for-domain-vocabulary.

  §the-named-GuestPowers-as-alias-for-EndoGuest — line
  79. Cycle 401's LAL-ARCHITECTURE.md identifies this
  alias (line 451). Design doc and types agree here.

  §the-named-PendingProposal-with-promise-field — lines
  81-88: the type has a "promise: Promise<unknown>"
  field that suggests the proposal mechanism was async
  and held a pending promise. §the-named-async-grant-
  workflow-as-vestigial-shape as tier-3 meta-pattern.

  §the-named-ProposalNotification-status-granted-or-
  rejected — lines 90-96: `status: 'granted' |
  'rejected'`. The vestigial type carries the
  vocabulary of an explicit grant/reject decision —
  a more elaborate workflow than what the current
  design uses.

  §the-named-LalContext-with-whenCancelled-and-cancelled
  — lines 107-110: TWO cancellation fields, both
  optional. Either or both can be present. Suggests
  two parallel cancellation idioms in the daemon. §the-
  named-dual-cancellation-shape as tier-3 meta-pattern.

  §the-named-TranscriptNode-linked-chain — lines 118-
  127: linked-chain transcript with messageId,
  parentMessageId, messages, and optional
  lastInboxNumber. This is a TREE structure rooted at
  messageId === null. §the-named-tree-rooted-at-null-
  parent as tier-3 meta-pattern.

  §the-named-fifty-conformant-cycles-and-counting —
  fiftieth AUTHORED conformant single-body section doc
  in post-refactor era (cycles 353-402). Session-level
  observation.

  Closes nine citation arcs: cycle 401 (1, adjacent
  forward; this is the types file that lags behind cycle
  401's design decision) + cycle 400 (2, source-vs-
  document framing extends to types-vs-design-decision) +
  cycle 399 (3, the README is the document tier that
  cycle 401 named) + cycle 387 (3, branded-types
  discipline at simpler level) + cycle 378 (2, string-
  literal-union sibling for ChatMessage role) + cycle
  346 (3, name-aliasing-for-domain-vocabulary) + cycle
  364 (4, four-shapes now seven-shapes-and-counting) +
  cycle 326 (75) + cycle 322 (75). Pushes citation-arc-
  closures-in-pivot to FOUR-HUNDRED-NINETY-EIGHT (489 +
  9 net new).
---

127-line agent.types.d.ts, the TypeScript type-definition file for @endo/lal. Chat-lane after cycle 401 designs-lane LAL-ARCHITECTURE.md. **Single most structurally interesting move**: §the-named-vestigial-types-from-abandoned-design — PendingProposal and ProposalNotification types (lines 81-96) still exist despite cycle 401's LAL-ARCHITECTURE.md explicitly declaring "no proposal/grant workflow." The design moved on; the types remained. §the-named-types-lag-design-decision. §the-named-drift-direction-can-invert-between-document-pairs (cycle 401: documents lag source; cycle 402: types lag design decision; two-speed strata can invert direction); §the-named-bidirectional-document-code-drift as tier-3 meta-pattern. §the-named-richer-types-than-design-doc-describes (TranscriptNode is a linked-chain tree; design doc describes a flat array). §the-named-WorkerConfig-for-form-submission-flow-not-in-architecture-doc (.d.ts knows about a feature the .md doesn't document); §the-named-types-document-features-architecture-doc-omits. §the-named-ToolCallArgs-as-flat-union-of-all-tool-arguments (19 optional fields, no discriminated union); §the-named-flat-optional-union-as-tool-argument-shape. §the-named-id-optional-on-ToolCall; §the-named-type-shape-accommodates-protocol-divergence (matches Ollama synthetic IDs). §the-named-tool-call-id-optional-on-ChatMessage. §the-named-ChatMessage-role-as-string-literal-union (sibling to cycles 378, 400). §the-named-Tool-as-discriminated-by-type-function; §the-named-discriminator-as-extension-point. §the-named-Tool-Parameters-as-nested-typed-record; §the-named-JSON-schema-subset-as-tool-parameter-format. §the-named-InboxMessage-as-alias-for-StampedMessage; §the-named-type-alias-as-renaming-for-clarity. §the-named-GuestPowers-as-alias-for-EndoGuest. §the-named-PendingProposal-with-promise-field; §the-named-async-grant-workflow-as-vestigial-shape. §the-named-ProposalNotification-status-granted-or-rejected. §the-named-LalContext-with-whenCancelled-and-cancelled; §the-named-dual-cancellation-shape. §the-named-TranscriptNode-linked-chain; §the-named-tree-rooted-at-null-parent. §the-named-fifty-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FOUR-HUNDRED-NINETY-EIGHT.
