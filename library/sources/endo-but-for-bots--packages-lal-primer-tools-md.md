---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/tools.md
source_line_range: 1-90
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 407 designs-lane ingest. 89-line tools.md from
  @endo/lal's agent-facing primer. Ninth lal-package
  artifact in the cluster after the README, providers/
  config.js, LAL-ARCHITECTURE.md, agent.types.d.ts,
  simulator README, mock-powers.js, primer/README.md,
  and providers/index.js. Fifty-fifth AUTHORED conformant
  single-body section doc in post-refactor era. Ninety-
  seven consecutive non-garden sources after the pivot
  (310-407). §ninety-seven-cycles-with-named-pivot-
  domain-stay.

  Single most structurally interesting move: §the-named-
  cycle-402-vestigial-framing-needs-revision — cycle 407
  REVISES cycle 402's framing of the PendingProposal and
  ProposalNotification types as "vestigial." Cycle 402
  reasoned: cycle 401's LAL-ARCHITECTURE.md said "No
  proposal/grant workflow is needed" + "There is no
  proposal/grant workflow", so the types in agent.types.
  d.ts that define PendingProposal (with proposalId,
  promise, codeNames) and ProposalNotification (with
  status 'granted'|'rejected') must be vestigial — left
  over from an earlier design. Cycle 407's primer/
  tools.md REVEALS the truth: line 61-62 defines
  `define(source, slots) — Propose code with named
  slots for the host to fill (PREFERRED)`. The primer
  tells the LLM that define() is PREFERRED for code.
  The types are NOT vestigial — they implement the
  PREFERRED code-evaluation mechanism. The design doc
  is WRONG. §the-named-design-doc-claims-workflow-
  absent-but-primer-prefers-it as tier-3 meta-pattern.

  §the-named-librarian-self-revision-of-prior-cycle-
  framing — cycle 402's vestigial-types-from-abandoned-
  design framing is now revised. The librarian's own
  accumulated framings can themselves be wrong; new
  evidence (cycle 407's primer reveals define() as
  preferred) updates the prior cycle's analysis. §the-
  named-revision-of-prior-framing-as-cluster-discipline
  as tier-3 meta-pattern. The cluster is not just
  building up framings — it must also revise them.

  §the-named-four-different-tool-counts-across-four-
  documents — extends cycle 405's three-models-across-
  four-documents framing. Cycle 407 counts FIFTEEN
  tools in primer/tools.md: help + 7 directory + 8 mail
  (incl. reply) + locate + inspect + readText +
  writeText + define + evaluate. Compare:
  - Primer tools.md: 15 tools (this cycle)
  - LAL-ARCHITECTURE.md comment: "16 tool definitions
    total" (cycle 401 + 402)
  - LAL-ARCHITECTURE.md table: 18 tools (cycle 401 +
    402)
  - Mock-powers.js: 22 methods (cycle 404)
  FOUR DIFFERENT TOOL COUNTS across four sibling
  documents about the same agent. §the-named-four-
  tool-counts-across-four-documents as tier-3 meta-
  pattern. The drift cluster's vocabulary now spans
  count-disagreement at the same numeric level as the
  cluster's model-string disagreements (cycles 399-
  403 named THREE Claude model strings; cycle 407
  finds FOUR tool counts).

  §the-named-define-and-evaluate-as-paired-code-tools
  — lines 61-64: define (proposal-with-slots) and
  evaluate (direct execution). Two distinct
  approaches to code execution. §the-named-propose-
  vs-execute-as-two-code-tools as tier-3 meta-
  pattern.

  §the-named-three-tier-tool-preference-direct-
  define-evaluate — lines 66-69: "IMPORTANT: Always
  prefer direct tool calls over `evaluate()` or
  `define()`. Many tasks can be accomplished without
  code execution." Three priority tiers: (1) direct
  tools (listMessages, readText, writeText, etc.); (2)
  define (proposal); (3) evaluate (last resort).
  §the-named-priority-ordered-tool-preference as
  tier-3 meta-pattern.

  §the-named-reply-as-preferred-over-send — lines
  31-34: reply() is PREFERRED for responses; send()
  is for initiating NEW conversations only.
  Asymmetric guidance: the primer pushes the LLM
  toward reply() over send() in most cases. §the-
  named-message-reply-preferred-over-fresh-send as
  tier-3 meta-pattern.

  §the-named-PREFERRED-marker-on-recommended-tools —
  lines 32, 62 use "(PREFERRED)" in parentheses to
  mark recommended tools within a pair. §the-named-
  PREFERRED-as-priority-marker-within-tool-pair as
  tier-3 meta-pattern.

  §the-named-inspect-before-evaluate-on-unfamiliar —
  lines 50-53: "IMPORTANT: Always call `inspect()`
  before using `evaluate()` on an unfamiliar
  capability. The response includes method signatures
  with argument types. Do NOT guess method names or
  argument shapes — read the help text first."
  Defensive ordering: inspect THEN evaluate. §the-
  named-defensive-tool-ordering as tier-3 meta-
  pattern.

  §the-named-locate-defensive-prerequisite — lines
  43-45: "IMPORTANT: Only call `locate()` with names
  you know exist. Call `list()` first to see your
  pet names." Another defensive ordering: list THEN
  locate. §the-named-list-before-locate-as-defense-
  against-unknown-names as tier-3 meta-pattern.

  §the-named-IMPORTANT-uppercase-as-LLM-priority-
  signal — lines 43, 50, 68 all use "IMPORTANT:"
  prefix. §the-named-uppercase-marker-as-priority-
  signal as tier-3 meta-pattern; the primer's
  formatting includes affordances for LLM attention
  allocation.

  §the-named-listMessages-includes-sent-and-received
  — lines 20-23: "List inbox messages (includes BOTH
  sent and received messages)." Surprising: the
  inbox is the message JOURNAL, not the received-
  only queue. §the-named-inbox-as-bidirectional-
  journal-not-incoming-queue as tier-3 meta-pattern.

  §the-named-messageId-and-replyTo-for-threading —
  lines 21-23: messageId is unique identifier;
  replyTo is the messageId of the parent message.
  Same shape as cycle 402's TranscriptNode
  (messageId + parentMessageId). §the-named-
  message-threading-shape-shared-between-inbox-and-
  transcript as tier-3 meta-pattern; the threading
  pattern is consistent between the inbox messages
  and the transcript structure.

  §the-named-readText-and-writeText-as-shortcuts —
  lines 54-57: shortcut tools for ReadableTree and
  WritableTree capabilities. Avoid evaluate() for
  file reading and writing. §the-named-shortcut-
  tools-for-common-capability-operations as tier-3
  meta-pattern.

  §the-named-inspect-vs-inspectCapability-naming-
  drift — primer uses `inspect`; LAL-ARCHITECTURE.md
  uses `inspectCapability`. Cycle 405 already noted
  this drift; cycle 407 confirms.

  §the-named-locate-vs-identify-distinct-methods —
  primer's `locate` returns an `endo://...` URL;
  LAL-ARCHITECTURE.md's `identify` returns a raw
  formula ID. Different methods, different return
  shapes, but the primer doesn't expose `identify`
  to the LLM (only `locate`). The LLM gets the URL-
  shaped result, not the raw ID. §the-named-locate-
  for-URL-identify-for-raw-ID as tier-3 meta-
  pattern.

  §the-named-primer-omits-form-storeValue-
  followMessages-identify-from-LLM-tools — cross-
  reference with cycle 404's mock-powers.js (22
  methods): the primer's 15 tools OMIT storeValue,
  followMessages, form, and identify. Confirms cycle
  404's §the-named-LLM-exposed-tool-surface-as-
  subset-of-guest-power-surface framing. The LLM
  gets a FILTERED view of the guest power surface.

  §the-named-second-person-document-addressing-LLM —
  entire primer addresses the LLM in second person
  (your capabilities, your directory, your @self
  locator). Confirms cycle 405's framing.

  §the-named-fifty-five-conformant-cycles-and-
  counting — fifty-fifth AUTHORED conformant single-
  body section doc in post-refactor era.

  Closes nine citation arcs: cycle 406 (1, adjacent
  forward; tool-name-drift visible in JSDoc continues
  here at tool-catalog level) + cycle 402 (5,
  vestigial-types framing REVISED; major realignment)
  + cycle 405 (3, primer-tool-name-drift confirmed
  with inspect vs inspectCapability) + cycle 404 (3,
  LLM-tool-surface as subset of guest-power-surface
  now numerically confirmed with primer's 15 vs
  mock's 22) + cycle 401 (3, design doc's "no
  proposal/grant workflow" claim is WRONG given
  define() is preferred) + cycle 400 (3, four-tool-
  count framing extends three-model-string framing)
  + cycle 326 (75) + cycle 322 (75) + cycle 364 (4,
  shapes count keeps growing). Pushes citation-arc-
  closures-in-pivot to FIVE-HUNDRED-AND-FORTY (531 +
  9 net new).
---

89-line tools.md from @endo/lal's agent-facing primer. Ninth lal-package artifact in the cluster. Designs-lane after cycle 406 chat-lane providers/index.js. **Single most structurally interesting move**: §the-named-cycle-402-vestigial-framing-needs-revision — *cycle 407 REVISES cycle 402's framing of PendingProposal/ProposalNotification types as "vestigial." The primer says `define(source, slots) — Propose code with named slots for the host to fill (PREFERRED)`. The types are CURRENT, not vestigial — they implement the PREFERRED code mechanism. Cycle 401's design doc claim ("no proposal/grant workflow") is WRONG.* §the-named-design-doc-claims-workflow-absent-but-primer-prefers-it as tier-3 meta-pattern. §the-named-librarian-self-revision-of-prior-cycle-framing; §the-named-revision-of-prior-framing-as-cluster-discipline (the cluster is not just building framings — it must also revise them). §the-named-four-different-tool-counts-across-four-documents (primer 15 + LAL-ARCHITECTURE comment 16 + LAL-ARCHITECTURE table 18 + mock-powers 22); §the-named-four-tool-counts-across-four-documents extends cycle 405's three-models-across-four-documents framing. §the-named-define-and-evaluate-as-paired-code-tools; §the-named-propose-vs-execute-as-two-code-tools. §the-named-three-tier-tool-preference-direct-define-evaluate; §the-named-priority-ordered-tool-preference. §the-named-reply-as-preferred-over-send; §the-named-message-reply-preferred-over-fresh-send. §the-named-PREFERRED-marker-on-recommended-tools; §the-named-PREFERRED-as-priority-marker-within-tool-pair. §the-named-inspect-before-evaluate-on-unfamiliar; §the-named-defensive-tool-ordering. §the-named-locate-defensive-prerequisite; §the-named-list-before-locate-as-defense-against-unknown-names. §the-named-IMPORTANT-uppercase-as-LLM-priority-signal; §the-named-uppercase-marker-as-priority-signal. §the-named-listMessages-includes-sent-and-received; §the-named-inbox-as-bidirectional-journal-not-incoming-queue. §the-named-messageId-and-replyTo-for-threading; §the-named-message-threading-shape-shared-between-inbox-and-transcript. §the-named-readText-and-writeText-as-shortcuts; §the-named-shortcut-tools-for-common-capability-operations. §the-named-inspect-vs-inspectCapability-naming-drift. §the-named-locate-vs-identify-distinct-methods; §the-named-locate-for-URL-identify-for-raw-ID. §the-named-primer-omits-form-storeValue-followMessages-identify-from-LLM-tools (confirms cycle 404's subset-relationship). §the-named-second-person-document-addressing-LLM. §the-named-fifty-five-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-FORTY.
