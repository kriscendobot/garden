---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/providers/ollama.js
source_line_range: 1-144
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 412 chat-lane ingest. 143-line providers/ollama.js,
  the native Ollama provider for @endo/lal. Fourteenth lal-
  package artifact in the cluster. Sixtieth AUTHORED
  conformant single-body section doc in post-refactor era.
  One-hundred-and-two consecutive non-garden sources after
  the pivot (310-412). §one-hundred-and-two-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  ollama-preserves-tool-role-vs-anthropic-folds-it — lines
  68-74: `if (msg.role === 'tool') { ollamaMessages.push
  ({ role: 'tool', content: msg.content }) }`. Unlike
  Anthropic (cycle 408) which folds the 'tool' role into
  the 'user' role with type-tagged content blocks, Ollama
  has a NATIVE 'tool' role. The common format's 4-role
  design (system/user/assistant/tool) maps DIRECTLY to
  Ollama (4-role); it requires REDUCTION for Anthropic
  (4→3). §the-named-role-cardinality-preservation-vs-
  reduction-per-provider as tier-3 meta-pattern. Cycle
  408's role-cardinality-asymmetric-across-providers
  framing now has TWO data points showing the asymmetry
  direction: Anthropic REDUCES, Ollama PRESERVES.

  §the-named-id-synthesis-confirms-cycle-401 — lines
  125-138 contain the EXACT synthesis pattern cycle 401
  predicted: `ollama_tool_${Date.now()}_${index}`. Cycle
  401's framing came from reading LAL-ARCHITECTURE.md;
  cycle 412 reads the actual code and confirms the
  literal pattern. §the-named-design-doc-prediction-
  matches-code as tier-3 meta-pattern; refreshing
  counterexample to the cluster's many drift framings —
  here the design doc was ACCURATE about a specific
  implementation detail.

  §the-named-ollama-no-max-tokens-control-at-all — lines
  104-108: the chat() call passes only model + messages
  + tools. No max_tokens. The provider doesn't pass
  LAL_MAX_TOKENS through to Ollama at all. Anthropic
  (cycle 408) has hardcoded 4096; Ollama has NOTHING.
  Even more restricted than Anthropic. §the-named-
  provider-control-axis-no-control-hardcoded-control-
  env-control as tier-3 meta-pattern; three-level
  control axis across providers: Ollama (no control),
  Anthropic (hardcoded 4096), Gemini+llamacpp (env-var
  control per cycle 406).

  §the-named-ollama-tool-format-near-identity — lines
  29-37: `toOllamaTools` is nearly an identity
  function. Ollama's tool format matches the common
  format almost exactly: `type: 'function'`, function:
  { name, description, parameters }. Compare to
  Anthropic's input_schema rename (cycle 408). §the-
  named-API-format-distance-from-common-as-translation-
  burden as tier-3 meta-pattern; Ollama's API distance
  from the common format is zero; Anthropic's is
  larger.

  §the-named-conditional-spread-for-optional-properties
  — lines 90, 92: `...(host && { host })` and `...
  (apiKey && { Authorization: ... })` — conditional
  spread idiom for optional properties. The Ollama
  client constructor receives properties only if their
  values are truthy. §the-named-conditional-spread-as-
  optional-property-idiom as tier-3 meta-pattern.

  §the-named-authorization-bearer-pattern-optional —
  line 92: `Authorization: \`Bearer ${apiKey}\``. The
  Ollama provider sends Bearer auth IF apiKey is
  provided. §the-named-bearer-auth-conditional-on-
  apikey-presence as tier-3 meta-pattern.

  §the-named-diagnostic-verbosity-per-provider-
  asymmetric — Anthropic provider (cycle 408) logs the
  full message history on every call. Ollama provider
  logs only a one-line "[LAL] Calling Ollama at host
  with model: model" diagnostic. §the-named-log-
  verbosity-per-provider as tier-3 meta-pattern;
  diagnostic verbosity is not uniform across providers.

  §the-named-no-harden-across-all-providers — like
  anthropic.js (cycle 408) and providers/index.js
  (cycle 406), ollama.js doesn't call harden() on
  makeOllamaProvider. The providers/ directory's
  harden discipline is CONSISTENTLY ABSENT. Setup.js
  (cycle 410) was the exception. §the-named-harden-
  uniformly-absent-from-providers as tier-3 meta-
  pattern.

  §the-named-provider-adapted-from-external-source —
  line 5: "Adapted from llamadrome/ollama-backend.js."
  The provider references an external source it was
  adapted from. §the-named-provider-as-adapted-from-
  upstream as tier-3 meta-pattern.

  §the-named-typedef-redundancy-across-provider-files
  — lines 10-22: CommonTool and CommonChatMessage
  typedefs are duplicated between anthropic.js (cycle
  408) and ollama.js (this cycle). Same typedef, two
  files. §the-named-common-format-typedef-duplicated-
  across-providers as tier-3 meta-pattern; the common
  format is REDEFINED in each provider file rather
  than imported from a shared module.

  §the-named-dual-shape-arguments-handling-consistent-
  across-providers — lines 60-63: same `typeof tc.
  function.arguments === 'string' ? JSON.parse(...) :
  ...` pattern as cycle 408's anthropic.js. The dual-
  shape accommodation is consistent across providers.
  §the-named-arguments-string-or-object-shared-
  pattern as tier-3 meta-pattern.

  §the-named-empty-string-fallback-for-content — line
  114: `const content = response.message?.content ||
  ''`. If the response has no content (e.g., a tool-
  call-only response), default to empty string.
  §the-named-empty-string-as-content-fallback as
  tier-3 meta-pattern.

  §the-named-nullish-coalescing-in-tool-call-mapping
  — lines 133-134: `name: tc.function?.name ?? ''`
  and `arguments: JSON.stringify(tc.function?.
  arguments ?? {})`. Nullish-coalescing operator (??)
  for falsy-but-meaningful defaults. §the-named-
  nullish-coalescing-for-meaningful-defaults as
  tier-3 meta-pattern.

  §the-named-Ollama-as-named-import-from-package —
  line 8: `import { Ollama } from 'ollama'`. The npm
  package's name is just 'ollama'. §the-named-package-
  name-matches-domain-as-naming-discipline as tier-3
  meta-pattern.

  §the-named-content-fallback-empty-string-for-
  assistant-with-only-tools — line 55: `const ollamaMsg
  = { role: 'assistant', content: msg.content || ''
  }`. Same empty-string default in the outbound
  direction. Assistant messages can have only tool
  calls (no text); the content field must still exist
  in Ollama's format, just as empty string.

  §the-named-tool-call-mapping-strips-id-but-resends-
  function-shape — lines 56-66: outbound tool_calls
  contain only `function: { name, arguments }`. The
  `id` field is NOT sent in the outbound direction.
  Asymmetric: ids are SYNTHESIZED on inbound but NOT
  PRESERVED on outbound. §the-named-id-asymmetric-
  synthesized-inbound-stripped-outbound as tier-3
  meta-pattern.

  §the-named-sixty-conformant-cycles-and-counting —
  sixtieth AUTHORED conformant single-body section
  doc in post-refactor era.

  Closes nine citation arcs: cycle 411 (1, adjacent
  forward; the result-flows-to-host framing for
  define-endow happens via the agent loop that calls
  this provider) + cycle 408 (5, MAJOR completion of
  role-cardinality framing — Anthropic folds, Ollama
  preserves; both data points named) + cycle 406 (3,
  providers/index.js dispatches here; harden-
  discipline-uniformly-absent now has three data
  points) + cycle 401 (5, synthetic-tool-call-IDs
  prediction VERIFIED — refreshing counterexample to
  the cluster's drift framings) + cycle 400 (3,
  config.js helpers used upstream) + cycle 387 (3,
  branded-types discipline at provider-format level)
  + cycle 326 (75) + cycle 322 (75) + cycle 318 (3,
  Endo idiom — this file uses no makePromiseKit but
  shares Endo discipline). Pushes citation-arc-
  closures-in-pivot to FIVE-HUNDRED-AND-EIGHTY-EIGHT
  (579 + 9 net new).
---

143-line providers/ollama.js, the native Ollama provider for @endo/lal. Fourteenth lal-package artifact in the cluster. Chat-lane after cycle 411 designs-lane primer/capabilities.md. **Single most structurally interesting move**: §the-named-ollama-preserves-tool-role-vs-anthropic-folds-it — *lines 68-74 show Ollama has a NATIVE 'tool' role; the common format's 4-role design maps DIRECTLY to Ollama (4→4) while it required REDUCTION for Anthropic (4→3 per cycle 408). The role-cardinality asymmetry cycle 408 named is now confirmed as provider-specific with two data points: Anthropic REDUCES, Ollama PRESERVES.* §the-named-role-cardinality-preservation-vs-reduction-per-provider as tier-3 meta-pattern. §the-named-id-synthesis-confirms-cycle-401 (exact `ollama_tool_${Date.now()}_${index}` pattern cycle 401 predicted is implemented here verbatim — refreshing counterexample to cluster's drift framings: the design doc was ACCURATE about this detail); §the-named-design-doc-prediction-matches-code. §the-named-ollama-no-max-tokens-control-at-all (Ollama has NO max-tokens at all; Anthropic hardcoded 4096; Gemini/llamacpp env-controlled); §the-named-provider-control-axis-no-control-hardcoded-control-env-control (three-level control axis). §the-named-ollama-tool-format-near-identity (zero translation burden); §the-named-API-format-distance-from-common-as-translation-burden. §the-named-conditional-spread-for-optional-properties; §the-named-conditional-spread-as-optional-property-idiom. §the-named-authorization-bearer-pattern-optional; §the-named-bearer-auth-conditional-on-apikey-presence. §the-named-diagnostic-verbosity-per-provider-asymmetric (Anthropic logs full conversation; Ollama logs one line per call); §the-named-log-verbosity-per-provider. §the-named-no-harden-across-all-providers (third data point — anthropic.js, providers/index.js, ollama.js all skip harden; setup.js per cycle 410 was the exception); §the-named-harden-uniformly-absent-from-providers. §the-named-provider-adapted-from-external-source (line 5 "Adapted from llamadrome/ollama-backend.js"). §the-named-typedef-redundancy-across-provider-files (CommonTool + CommonChatMessage redefined in each provider file rather than imported from shared module); §the-named-common-format-typedef-duplicated-across-providers. §the-named-dual-shape-arguments-handling-consistent-across-providers; §the-named-arguments-string-or-object-shared-pattern. §the-named-empty-string-fallback-for-content; §the-named-empty-string-as-content-fallback. §the-named-nullish-coalescing-in-tool-call-mapping; §the-named-nullish-coalescing-for-meaningful-defaults. §the-named-Ollama-as-named-import-from-package; §the-named-package-name-matches-domain-as-naming-discipline. §the-named-content-fallback-empty-string-for-assistant-with-only-tools. §the-named-tool-call-mapping-strips-id-but-resends-function-shape; §the-named-id-asymmetric-synthesized-inbound-stripped-outbound. §the-named-sixty-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-EIGHTY-EIGHT.
