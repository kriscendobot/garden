---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/src/extract-tool-calls.js
source_line_range: 1-188
source_commit: db3739ef53f582422fb8bc031befa954c187db26
source_date: 2026-04-09
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 444 chat-lane ingest. 188-line
  extract-tool-calls.js from @endo/fae/src — the
  model-agnostic LLM response normalization layer that
  interprets three distinct wire formats (standard JSON,
  Qwen XML parameter format, bare function blocks) and
  strips chain-of-thought <think> blocks. One-hundred-
  and-thirty-fourth consecutive non-garden source after
  the pivot (310-444). Ninety-second AUTHORED conformant
  single-body section doc in post-refactor era.

  Single most structurally interesting move: §the-named-
  three-wire-format-normalization-as-model-agnostic-layer
  — cycle 416 ingested tools.js (tool DISCOVERY for
  dispatch TO the LLM); cycle 444 ingests the response
  side. extractToolCallsFromContent handles JSON inside
  <tool_call>, Qwen XML parameter format inside
  <tool_call>, and bare <function=name> blocks outside
  <tool_call>. Three formats, one uniform output shape.
  The normalization is the seam between fae's capability-
  first design (capabilities discovered per turn) and
  the LLM provider's wire format (provider-determined).
  §the-named-three-format-normalization-as-provider-
  agnostic-contract as tier-3 meta-pattern.

  §the-named-two-pass-extraction-handles-format-ambiguity
  — first pass over <tool_call> blocks (JSON or Qwen XML
  nested inside); second pass over bare <function=name>
  blocks from content with tool_calls removed. The two-
  pass structure prevents format confusion: a bare
  <function=name> inside a <tool_call> is handled by
  pass 1's parseFunctionParamFormat, not pass 2. §the-
  named-two-pass-structure-as-format-disambiguation.

  §the-named-think-block-stripping-for-chain-of-thought
  — both closed (<think>...</think>) and unclosed
  (<think>... without closing tag) variants stripped from
  cleanedContent. Tool calls INSIDE <think> blocks are
  still extracted correctly (first-pass regex captures
  them before the clean step). Models that emit reasoning
  before tool calls are handled without losing the tool
  calls. §the-named-think-blocks-transparent-to-tool-
  extraction.

  §the-named-last-resort-regex-for-malformed-json —
  within the JSON-parse catch, a final fallback applies
  regex patterns for "name" and "arguments" fields to
  recover from structurally broken JSON. Three tiers:
  JSON.parse → parseFunctionParamFormat → regex fallback.
  §the-named-three-tier-parse-cascade-for-robustness.

  §the-named-parseParamValue-typed-coercion — the XML
  parameter format carries raw string values; parseParam
  Value applies JSON.parse for arrays/objects/booleans,
  regex for numbers, fallback to trimmed string. The
  coercion reconstructs typed arguments from the XML
  surface. §the-named-xml-to-typed-value-coercion.

  §the-named-synthetic-tool-id-generation — IDs are
  generated as `tool_${Date.now()}_${index}` across both
  passes; index monotonically increments. No incoming
  tool_call_id from the LLM in XML format — the client
  fabricates IDs for downstream code that needs them.
  §the-named-client-fabricated-ids-for-xml-format.

  §the-named-fae-src-completes-at-two-modules — cycle
  416 ingested tools.js (discovery); cycle 444 ingests
  extract-tool-calls.js (extraction). fae-tool-interface
  .js (14 lines; defines FaeToolInterface M.interface)
  is the third src/ file. Together they form the complete
  tool pipeline: FaeToolInterface (capability contract)
  → tools.js (runtime discovery) → extract-tool-calls.js
  (response-side normalization). §the-named-fae-src-as-
  three-module-tool-pipeline.

  §the-named-extract-imported-in-COMPARISON-confirms-
  modularization — cycle 415 noted §the-named-Fae-
  extract-tool-calls-imported-Lal-inline (extract-tool-
  calls is a separate module in fae; lal inlines the
  same logic). Cycle 444 confirms: the module is clean
  (no fae-specific state; pure function; hardened export)
  — it could be shared, but is not yet. §the-named-
  shareable-but-not-shared-extraction-module.

  §the-named-ninety-two-conformant-cycles-and-counting.

  Closes seven citation arcs: cycle 443 (1, adjacent
  forward — whylip/README.md contextualized by knowing
  the Fae agent's tool-call parsing pipeline; {narrative,
  scene} JSON response is fae's own wire format, handled
  by this module if it contained tool calls) + cycle 416
  (5, MAJOR COMPLETION — tool discovery + response-side
  extraction together form the complete fae tool pipeline;
  §the-named-comparison-claim-confirmed-by-source: cycle
  415 noted extract-tool-calls-imported, now confirmed)
  + cycle 415 (5, §the-named-Fae-extract-tool-calls-
  imported-Lal-inline: the shared-but-not-shared framing
  named in cycle 415 confirmed by reading the module) +
  cycle 412 (3, three-tier-parse-cascade echoes three-
  level patterns) + cycle 326 (75) + cycle 322 (75) +
  cycle 364 (4, shapes with new normalization-layer form).
  Pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-NINETY-SEVEN (889 + 8 net new).
---

188-line `packages/fae/src/extract-tool-calls.js` — the model-agnostic tool-call extraction layer for the Fae agent. Exports a single function `extractToolCallsFromContent` that normalizes LLM assistant content across three wire formats (standard JSON, Qwen XML parameter format, bare function blocks) into a uniform `tool_calls` array, then returns cleaned content with tool markup and chain-of-thought `<think>` blocks stripped. Chat-lane after cycle 443 designs-lane whylip/README.md. **Single most structurally interesting move**: §the-named-three-wire-format-normalization-as-model-agnostic-layer — *cycle 416 ingested tools.js (tool DISCOVERY for dispatch TO the LLM); cycle 444 ingests the RESPONSE side. extractToolCallsFromContent handles (1) JSON inside `<tool_call>` tags, (2) Qwen XML `<function=name><parameter=k>v</parameter>` format inside `<tool_call>`, and (3) bare `<function=name>` blocks outside any wrapper. Three formats, one uniform output shape. The normalization is the seam between fae's capability-first design and the LLM provider's wire format.* §the-named-three-format-normalization-as-provider-agnostic-contract as tier-3 meta-pattern. §the-named-two-pass-extraction-handles-format-ambiguity (pass 1 captures `<tool_call>` blocks in any format; pass 2 sweeps bare function blocks from the remainder; prevents format confusion); §the-named-two-pass-structure-as-format-disambiguation. §the-named-think-block-stripping-for-chain-of-thought (both closed and unclosed `<think>` variants stripped; tool calls inside `<think>` still extracted correctly); §the-named-think-blocks-transparent-to-tool-extraction. §the-named-last-resort-regex-for-malformed-json (three-tier parse cascade: JSON.parse → parseFunctionParamFormat → regex fallback); §the-named-three-tier-parse-cascade-for-robustness. §the-named-parseParamValue-typed-coercion (XML parameter values coerced to typed JS values); §the-named-xml-to-typed-value-coercion. §the-named-synthetic-tool-id-generation (`tool_${Date.now()}_${index}`; client fabricates IDs for formats that carry none); §the-named-client-fabricated-ids-for-xml-format. §the-named-fae-src-completes-at-two-modules (tools.js discovery + extract-tool-calls.js extraction + fae-tool-interface.js contract = complete three-module tool pipeline); §the-named-fae-src-as-three-module-tool-pipeline. §the-named-extract-imported-in-COMPARISON-confirms-modularization (cycle 415 noted extract is separate in fae, inline in lal; confirmed shareable-but-not-shared); §the-named-shareable-but-not-shared-extraction-module. §the-named-ninety-two-conformant-cycles-and-counting. Seven citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-NINETY-SEVEN.

## Section list

- [endo-but-for-bots--packages-fae-src-extract-tool-calls-js--multi-format-tool-call-normalization](../sections/endo-but-for-bots--packages-fae-src-extract-tool-calls-js--multi-format-tool-call-normalization.md)
