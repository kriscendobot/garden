---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/providers/anthropic.js
source_line_range: 1-167
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 408 chat-lane ingest. 166-line providers/anthropic.js,
  the Anthropic API provider for @endo/lal. Tenth lal-package
  artifact in the cluster. Fifty-sixth AUTHORED conformant
  single-body section doc in post-refactor era. Ninety-eight
  consecutive non-garden sources after the pivot (310-408).
  §ninety-eight-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-tool-
  result-mapped-to-user-role-with-tool_result-block — lines
  77-89. The common format has FOUR roles (system/user/
  assistant/tool); Anthropic's API has THREE roles (system/
  user/assistant). The provider FOLDS the tool role into the
  user role: `if (msg.role === 'tool') { anthropicMessages.
  push({ role: 'user', content: [{ type: 'tool_result',
  tool_use_id: toolUseId, content: msg.content }] }) }`. The
  ROLE CARDINALITY is reduced at the format boundary. §the-
  named-role-cardinality-asymmetric-across-providers as
  tier-3 meta-pattern. The provider must NORMALIZE four
  roles to three by folding the tool role into user-role
  messages with type-tagged content blocks. The same
  conceptual operation (returning a tool result) is
  expressed as a different message structure in each API.

  §the-named-content-block-type-discrimination — lines 145-
  157: Anthropic's response.content is an ARRAY of blocks,
  each with a `type` field ('text' | 'tool_use'). Text
  blocks accumulate into message.content; tool_use blocks
  become tool_calls entries. The provider discriminates by
  block.type. §the-named-content-as-array-of-typed-blocks
  as tier-3 meta-pattern; reflects Anthropic's API design
  where a single response can interleave text and tool calls.

  §the-named-three-way-auth-error-detection — lines 122-138.
  The error detection checks THREE distinct sources: (1)
  HTTP 401 status code; (2) error body's `type` field
  matching 'authentication_error'; (3) regex match on
  message text "invalid x-api-key|api key|authentication".
  Defense in depth: three ways to detect the same condition
  because the Anthropic SDK may report auth errors via any
  of three channels. §the-named-three-channel-error-
  detection as tier-3 meta-pattern.

  §the-named-anthropic-max-tokens-hardcoded-4096 — line
  116: `max_tokens: 4096` HARDCODED. No env-var
  configurability for Anthropic. Cycle 406's providers/
  index.js showed Gemini and llamacpp providers support
  LAL_MAX_TOKENS. Anthropic does NOT. §the-named-feature-
  support-asymmetric-across-providers extends cycle 401's
  framing — different providers, different configurability.
  Here specifically: max_tokens cannot be increased for
  Anthropic at runtime.

  §the-named-id-fallback-synthesis-with-Date-and-Math-
  random — lines 67-68: if a tool call lacks an id,
  synthesize `tool_${Date.now()}_${Math.random().
  toString(36).slice(2)}`. Sibling to cycle 401's Ollama
  synthetic-tool-call-ID framing (`ollama_tool_${ts}_
  ${index}`). §the-named-id-fallback-synthesis-across-
  providers as tier-3 meta-pattern; both Anthropic and
  Ollama providers synthesize IDs when missing, with
  different shapes — Anthropic uses timestamp+random,
  Ollama uses timestamp+index.

  §the-named-arguments-string-or-object-dual-shape —
  lines 60-63: `args = typeof tc.function.arguments ===
  'string' ? JSON.parse(tc.function.arguments) :
  tc.function.arguments`. The arguments field can be a
  string (OpenAI convention; stringified JSON) OR an
  object (some providers pass through). The Anthropic
  provider accommodates BOTH. §the-named-dual-shape-
  arguments-field-with-string-or-object as tier-3 meta-
  pattern.

  §the-named-full-message-history-logged-per-chat-call
  — lines 107-111: `console.log('[LAL] Calling Anthropic
  API...'); console.log('[LAL] Messages:', JSON.
  stringify(anthropicMessages, null, 2))`. EVERY API
  call logs the FULL message history. Diagnostic but
  verbose; potential leak of conversation contents to
  stdout. §the-named-full-conversation-printed-to-
  stdout-per-call as tier-3 meta-pattern; extends cycle
  406's library-uses-console-log-against-convention
  framing — not just diagnostics but FULL conversation
  contents.

  §the-named-provider-as-bidirectional-format-translator
  — the file structure: toAnthropicMessages and
  toAnthropicTools convert common → Anthropic; the
  chat() method's response-handling code converts
  Anthropic → common. The provider sits at the
  boundary and translates IN BOTH DIRECTIONS. §the-
  named-bidirectional-format-mapper-at-provider-
  boundary as tier-3 meta-pattern.

  §the-named-common-format-stores-arguments-as-
  stringified-JSON — line 153: `arguments: JSON.
  stringify(block.input)`. The common format's
  convention is to STORE tool call arguments as
  stringified JSON, matching OpenAI's convention.
  When Anthropic returns input as an object, the
  provider stringifies it for the common format.
  §the-named-OpenAI-stringified-JSON-as-common-
  format-convention as tier-3 meta-pattern.

  §the-named-input_schema-vs-parameters-field-
  renaming — lines 28-35: `input_schema` is Anthropic's
  field name; the common format uses `parameters`.
  The provider renames at the boundary. §the-named-
  field-renaming-at-provider-boundary as tier-3 meta-
  pattern; trivial mechanical translation, but a
  named decision point.

  §the-named-Anthropic-system-string-separate-from-
  messages — lines 42-49: Anthropic API requires the
  system prompt as a TOP-LEVEL string, not as a
  role:'system' entry in the messages array. The
  provider extracts msg.role === 'system' into the
  system variable, drops it from messages. §the-named-
  system-prompt-extraction-for-Anthropic-API as tier-
  3 meta-pattern.

  §the-named-text-blocks-and-tool_use-blocks-as-
  output-content — lines 53-76: assistant messages can
  contain text + tool_use blocks interleaved. The
  provider builds the content array conditionally:
  text block only if msg.content is non-empty; tool_use
  blocks for each tool call. §the-named-conditional-
  content-block-construction as tier-3 meta-pattern.

  §the-named-no-harden-on-makeAnthropicProvider — like
  providers/index.js (cycle 406), this file doesn't
  call harden() on its export. The provider modules
  systematically violate the CLAUDE.md convention.
  §the-named-harden-discipline-systematically-absent-
  in-providers as tier-3 meta-pattern; extends cycle
  406's harden-discipline-not-uniform-across-package.

  §the-named-console-error-for-error-channel — line
  123: `console.error('[LAL] Anthropic API error:',
  error)`. The provider uses console.error (not
  console.log) for actual errors. Matches the
  CLAUDE.md convention's preference for console.error
  for diagnostics, but the file still violates the
  no-console-log rule elsewhere. §the-named-stderr-
  for-errors-stdout-for-info as tier-3 meta-pattern.

  §the-named-tool_use_id-fallback-unknown — line 78:
  `const toolUseId = msg.tool_call_id || 'unknown'`.
  If the inbound tool_call_id is missing, the
  Anthropic-side tool_use_id defaults to the literal
  string 'unknown'. §the-named-unknown-string-as-
  fallback-for-missing-ID as tier-3 meta-pattern;
  sibling to providers/index.js's `apiKey ||
  'ollama'` dummy.

  §the-named-fifty-six-conformant-cycles-and-counting
  — fifty-sixth AUTHORED conformant single-body
  section doc in post-refactor era.

  Closes nine citation arcs: cycle 407 (1, adjacent
  forward; primer says LLM should use these provider-
  abstracted tools, this file is one half of how
  that abstraction works) + cycle 406 (3, providers/
  index.js dispatches to this file; harden-discipline-
  not-uniform extended; console.log-against-
  convention reaffirmed) + cycle 401 (3, design doc's
  description of Anthropic provider — system-split
  + auth-error detection + tool-result-mapping — all
  confirmed and elaborated) + cycle 400 (3, the
  config.js helpers don't extend to per-provider
  feature configurability — Anthropic loses max-
  tokens) + cycle 402 (3, type-shape-accommodates-
  protocol-divergence: id-fallback-synthesis works
  here too) + cycle 326 (75) + cycle 322 (75) + cycle
  346 (3, name-aliasing for input_schema vs
  parameters) + cycle 318 (3, makePromiseKit sibling
  Endo idiom — this file uses no promise-kit but
  same Endo discipline). Pushes citation-arc-closures-
  in-pivot to FIVE-HUNDRED-AND-FORTY-NINE (540 + 9
  net new).
---

166-line providers/anthropic.js, the Anthropic API provider for @endo/lal. Tenth lal-package artifact in the cluster. Chat-lane after cycle 407 designs-lane lal/primer/tools.md. **Single most structurally interesting move**: §the-named-tool-result-mapped-to-user-role-with-tool_result-block — *the common format has FOUR roles (system/user/assistant/tool); Anthropic's API has THREE. The provider folds the tool role into the user role: tool results become user-role messages with type-tagged tool_result content blocks. The ROLE CARDINALITY is reduced at the format boundary.* §the-named-role-cardinality-asymmetric-across-providers as tier-3 meta-pattern. §the-named-content-block-type-discrimination (Anthropic's content is an array of typed blocks: 'text' or 'tool_use'); §the-named-content-as-array-of-typed-blocks. §the-named-three-way-auth-error-detection (HTTP 401 + error.type 'authentication_error' + regex match); §the-named-three-channel-error-detection (defense in depth across three signal sources). §the-named-anthropic-max-tokens-hardcoded-4096 (no env-var configurability); §the-named-feature-support-asymmetric-across-providers (Gemini/llamacpp have LAL_MAX_TOKENS; Anthropic doesn't). §the-named-id-fallback-synthesis-with-Date-and-Math-random; §the-named-id-fallback-synthesis-across-providers (sibling to cycle 401's Ollama synthetic IDs; different shapes — timestamp+random here vs timestamp+index there). §the-named-arguments-string-or-object-dual-shape; §the-named-dual-shape-arguments-field-with-string-or-object. §the-named-full-message-history-logged-per-chat-call (every call logs the FULL conversation); §the-named-full-conversation-printed-to-stdout-per-call (extends cycle 406's library-uses-console-log framing). §the-named-provider-as-bidirectional-format-translator; §the-named-bidirectional-format-mapper-at-provider-boundary. §the-named-common-format-stores-arguments-as-stringified-JSON; §the-named-OpenAI-stringified-JSON-as-common-format-convention. §the-named-input_schema-vs-parameters-field-renaming; §the-named-field-renaming-at-provider-boundary. §the-named-Anthropic-system-string-separate-from-messages; §the-named-system-prompt-extraction-for-Anthropic-API. §the-named-text-blocks-and-tool_use-blocks-as-output-content; §the-named-conditional-content-block-construction. §the-named-no-harden-on-makeAnthropicProvider; §the-named-harden-discipline-systematically-absent-in-providers (extends cycle 406). §the-named-console-error-for-error-channel; §the-named-stderr-for-errors-stdout-for-info. §the-named-tool_use_id-fallback-unknown ('unknown' string as fallback; sibling to providers/index.js's 'ollama' dummy); §the-named-unknown-string-as-fallback-for-missing-ID. §the-named-fifty-six-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-FORTY-NINE.
