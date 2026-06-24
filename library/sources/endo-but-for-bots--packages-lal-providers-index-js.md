---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/providers/index.js
source_line_range: 1-114
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 406 chat-lane ingest. 113-line providers/index.js,
  the LLM provider factory that ties together the four
  providers and uses config.js helpers from cycle 400.
  Eighth lal-package artifact in the cluster after the
  README (cycle 399), providers/config.js (cycle 400),
  LAL-ARCHITECTURE.md (cycle 401), agent.types.d.ts
  (cycle 402), simulator README (cycle 403), mock-powers
  (cycle 404), and primer README (cycle 405). Fifty-
  fourth AUTHORED conformant single-body section doc in
  post-refactor era. Ninety-six consecutive non-garden
  sources after the pivot (310-406).

  Single most structurally interesting move: §the-named-
  JSDoc-comment-undercounts-implementation-within-same-
  source-file — lines 21-24's JSDoc comment lists THREE
  providers ("anthropic.com" → Anthropic; "/v1" suffix
  → llama.cpp; "Otherwise" → Ollama). But the function
  IMPLEMENTS four providers — Gemini is imported (line
  8), dispatched (lines 52-75), and constructed via
  makeGeminiProvider. The JSDoc comment is missing the
  ENTIRE Gemini branch. The doc-vs-code drift now
  occurs at the SMALLEST POSSIBLE SCALE: within a
  single function's own JSDoc comment. §the-named-
  intra-function-JSDoc-drift as tier-3 meta-pattern; a
  fractal of the cluster's larger document-vs-code
  drift framings now visible at the function-comment
  scale.

  §the-named-comment-lags-implementation-within-one-
  file — the cluster has now identified drift at:
  multi-document scale (cycle 401: README + design doc
  + source disagree); document-internal scale (cycle
  401 LAL-ARCHITECTURE.md sixteen-vs-eighteen tools);
  function-comment scale (cycle 406, here). The drift
  vocabulary is now FRACTAL — same pattern appears at
  multiple zoom levels. §the-named-fractal-drift-
  across-zoom-levels as tier-3 meta-pattern.

  §the-named-hardcoded-fallback-auth-token-as-dummy-key
  — line 79: `const apiKey = env.LAL_AUTH_TOKEN ||
  'ollama'`. The openai-compatible provider DEFAULTS
  apiKey to the literal string 'ollama' when no
  LAL_AUTH_TOKEN is provided. This lets the OpenAI-
  compatible provider work against a local llama.cpp
  instance that doesn't actually need a key — the
  'ollama' string is a dummy stand-in. §the-named-
  dummy-string-where-real-secret-not-needed as tier-3
  meta-pattern.

  §the-named-library-uses-console-log-against-its-own-
  convention — lines 48, 65, 86, 100: every provider
  creation logs `[LAL] Using X provider at BASEURL
  with model: MODEL`. The outer CLAUDE.md convention
  (cycle 402 context) says: "Libraries should be
  silent by default. No console.log from library
  code." But this code uses console.log for provider
  initialization diagnostics. §the-named-code-
  violates-its-own-stated-convention as tier-3 meta-
  pattern. Novel direction of drift: not document
  lagging code, not code lagging design, but code
  VIOLATING the convention the design doc states.
  Eighth direction of document-vs-code drift?

  §the-named-no-harden-on-createProvider — the file
  declares `export const createProvider = env => {
  ... }` (line 36) but no `harden(createProvider)`
  call appears in the file. The CLAUDE.md convention
  says: "Every named export MUST have a corresponding
  `harden(exportName)` call immediately after the
  declaration." Cycle 400's config.js followed this
  convention strictly. This file does not. §the-named-
  harden-discipline-not-uniform-across-package as
  tier-3 meta-pattern; another code-violates-
  convention instance.

  §the-named-uniform-Provider-interface-across-four-
  implementations — lines 13-16's @typedef defines
  Provider as `{ chat: (messages: object[], tools:
  object[]) => Promise<{ message: object }> }`. All
  four providers (anthropic, gemini, llamacpp,
  ollama) expose this single chat method. The shape
  is uniform across providers. §the-named-single-
  method-interface-as-provider-contract as tier-3
  meta-pattern.

  §the-named-if-with-early-return-as-dispatch-style —
  lines 41-107: four `if (providerKind === '...')`
  branches plus a default block (no else if). Each
  branch has its own early return. The default block
  is the file's final lines (98-107). §the-named-
  early-return-instead-of-else-chain as tier-3 meta-
  pattern; compared to cycle 400's substring-match-
  cascade inside detectProviderKind, this is the
  PROVIDER CONSTRUCTION dispatch (different layer of
  the same configuration flow).

  §the-named-duplicated-env-parsing-across-providers
  — lines 59-64 (gemini max-tokens parsing) and lines
  80-85 (openai-compatible max-tokens parsing) are
  identical code: parseInt(...).if-defined-else-
  undefined for max-tokens (defaults 4096) and max-
  messages (defaults undefined). Duplicated across
  two provider branches. §the-named-env-var-parsing-
  duplicated-across-branches as tier-3 meta-pattern.

  §the-named-asymmetric-auth-requirement — the four
  providers handle LAL_AUTH_TOKEN differently:
  Anthropic and Gemini THROW if missing (lines 43-47,
  54-58); openai-compatible DEFAULTS to dummy
  'ollama' (line 79); Ollama PASSES THROUGH whatever
  is set (line 99, no check). §the-named-auth-
  required-vs-optional-vs-dummy-vs-passthrough as
  tier-3 meta-pattern.

  §the-named-providers-imported-via-named-factory-
  functions — lines 7-10 import makeXProvider for
  each of the four providers. Standard Endo idiom for
  factory-function-returning-objects. Sibling to
  cycle 400's makeExo discipline. §the-named-
  makeXProvider-as-factory-naming-convention as
  tier-3 meta-pattern.

  §the-named-re-exports-of-all-four-factories — lines
  110-113: `export { makeAnthropicProvider } from
  './anthropic.js'` for all four providers. Re-
  exports allow direct use of factories outside the
  createProvider dispatch. §the-named-re-export-as-
  alternative-API-surface as tier-3 meta-pattern.

  §the-named-default-LAL_HOST-localhost-11434 — line
  37: `const baseURL = env.LAL_HOST ||
  'http://localhost:11434'`. The default LAL_HOST
  points at the Ollama default port. So out-of-the-
  box, no env config, you get Ollama as the
  provider. §the-named-ollama-as-default-out-of-the-
  box-provider as tier-3 meta-pattern.

  §the-named-resolveModelForHost-applied-to-LAL_MODEL
  — line 39: `const model = resolveModelForHost(
  baseURL, env.LAL_MODEL)`. This is the function
  cycle 400 named §the-named-resolveModelForHost-
  upgrades-qwen3-default. The provider factory calls
  it on every createProvider invocation. §the-named-
  config-helper-called-per-provider-construction as
  tier-3 meta-pattern.

  §the-named-imports-from-sibling-config-module — line
  11: imports detectProviderKind and
  resolveModelForHost from ./config.js. The provider
  factory depends on the configuration helpers cycle
  400 ingested. §the-named-modular-config-separated-
  from-construction as tier-3 meta-pattern.

  §the-named-fifty-four-conformant-cycles-and-
  counting — fifty-fourth AUTHORED conformant single-
  body section doc in post-refactor era.

  Closes nine citation arcs: cycle 405 (1, adjacent
  forward; primer-tool-name-drift sibling now visible
  at JSDoc-within-function scale) + cycle 400 (3,
  config.js helpers this file uses; the JSDoc undercount
  recurs at the same shape) + cycle 402 (3, types lag
  design vs comments lag implementation; both intra-
  package drift instances) + cycle 401 (3, "no
  console.log" convention this file violates) + cycle
  386 (3, README-vs-CODE-inversion sibling for JSDoc
  drift) + cycle 384 (3, design-doc-trails-code
  sibling) + cycle 326 (75) + cycle 322 (75) + cycle
  364 (4, shapes count keeps growing). Pushes
  citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-
  THIRTY-ONE (522 + 9 net new).
---

113-line providers/index.js, the LLM provider factory that ties together the four providers and uses config.js helpers from cycle 400. Eighth lal-package artifact in the cluster. Chat-lane after cycle 405 designs-lane primer/README.md. **Single most structurally interesting move**: §the-named-JSDoc-comment-undercounts-implementation-within-same-source-file — *lines 21-24's JSDoc lists THREE providers (anthropic/llama.cpp/ollama); the function IMPLEMENTS four (gemini is imported, dispatched, constructed but NOT in the comment). Drift now visible at the SMALLEST scale: a function's own JSDoc disagrees with its own body.* §the-named-intra-function-JSDoc-drift as tier-3 meta-pattern. §the-named-comment-lags-implementation-within-one-file; §the-named-fractal-drift-across-zoom-levels (multi-document scale → document-internal scale → function-comment scale; same pattern at multiple zoom levels). §the-named-hardcoded-fallback-auth-token-as-dummy-key (line 79: `apiKey = env.LAL_AUTH_TOKEN || 'ollama'`); §the-named-dummy-string-where-real-secret-not-needed. §the-named-library-uses-console-log-against-its-own-convention (four `console.log` calls despite CLAUDE.md's "no console.log from library code"); §the-named-code-violates-its-own-stated-convention as tier-3 meta-pattern (novel EIGHTH direction of drift: code-violates-stated-convention). §the-named-no-harden-on-createProvider (CLAUDE.md says every export MUST have harden; createProvider doesn't); §the-named-harden-discipline-not-uniform-across-package. §the-named-uniform-Provider-interface-across-four-implementations; §the-named-single-method-interface-as-provider-contract. §the-named-if-with-early-return-as-dispatch-style; §the-named-early-return-instead-of-else-chain. §the-named-duplicated-env-parsing-across-providers; §the-named-env-var-parsing-duplicated-across-branches. §the-named-asymmetric-auth-requirement (Anthropic+Gemini throw; openai-compatible defaults to 'ollama' dummy; Ollama passthrough); §the-named-auth-required-vs-optional-vs-dummy-vs-passthrough. §the-named-providers-imported-via-named-factory-functions; §the-named-makeXProvider-as-factory-naming-convention. §the-named-re-exports-of-all-four-factories; §the-named-re-export-as-alternative-API-surface. §the-named-default-LAL_HOST-localhost-11434; §the-named-ollama-as-default-out-of-the-box-provider. §the-named-resolveModelForHost-applied-to-LAL_MODEL; §the-named-config-helper-called-per-provider-construction. §the-named-imports-from-sibling-config-module; §the-named-modular-config-separated-from-construction. §the-named-fifty-four-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-THIRTY-ONE.
