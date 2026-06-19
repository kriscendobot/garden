---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/providers/config.js
source_line_range: 1-69
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 400 chat-lane ingest paired to cycle 399 designs-
  lane @endo/lal README. CYCLE 400 MILESTONE. 69-line
  providers/config.js, the LLM provider detection and
  model-resolution logic that implements the URL-heuristic-
  dispatch named in cycle 399 README. Forty-eighth AUTHORED
  conformant single-body section doc in post-refactor era.
  Ninety consecutive non-garden sources after the pivot
  (310-400). §ninety-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  cycle-399-vs-cycle-400-default-model-disagreement —
  cycle 399 README (line 22) listed the Anthropic default
  as `claude-opus-4-5-20251101`. Cycle 400 source (line
  31) defines the Anthropic default as `claude-sonnet-4-6-
  20250514`. The README and the source disagree on the
  Anthropic default model. §the-named-readme-says-opus-
  source-says-sonnet as tier-3 meta-pattern. Sibling shape
  to cycle 386's petname-edgename-naming-inversion-
  between-README-and-CODE and cycle 384's design-doc-
  trails-code: a third direction of document-versus-code
  drift now named within ONE PACKAGE — the README and the
  source files in lal/providers/config.js disagree about
  a default value. Fitting CYCLE 400 MILESTONE
  observation: document drift is pervasive enough across
  the cluster that even when README and source live in
  the same package directory, they can disagree.

  §The-named-four-provider-kinds — lines 10 + 30-35
  enumerate FOUR provider kinds: anthropic + gemini +
  openai-compatible + ollama. Cycle 399 README named TWO
  (anthropic + llama.cpp-as-OpenAI-compatible). Cycle 400
  source reveals FOUR. §the-named-readme-undercounts-the-
  implementation recurs (cycle 360 framing applied to a
  different document-code pair).

  §The-named-detectProviderKind-as-ordered-fall-through-
  URL-heuristic — lines 12-26 perform ordered checks: (1)
  anthropic.com → 'anthropic'; (2) googleapis.com OR
  generativelanguage → 'gemini'; (3) /v1 in URL →
  'openai-compatible'; (4) default → 'ollama'. The
  ordering matters: anthropic checked first; ollama is
  the fallback. §the-named-substring-match-cascade-as-
  dispatch as tier-3 meta-pattern.

  §The-named-googleapis-or-generativelanguage-as-disjunction
  — line 17-19: Gemini detection uses TWO substrings ORed
  together (googleapis.com OR generativelanguage). Both
  match Google's hosting; the disjunction handles two URL
  shapes for the same provider. §the-named-disjunction-
  for-two-URL-shapes-of-one-provider as tier-3 meta-
  pattern.

  §The-named-v1-as-OpenAI-compatible-marker — line 22:
  any URL containing `/v1` matches as "openai-compatible".
  This is the OpenAI v1 API path convention; matches not
  just OpenAI but llama.cpp + many local servers. The
  marker is the URL path component, not the host. §the-
  named-path-component-as-API-version-marker as tier-3
  meta-pattern.

  §The-named-string-literal-union-as-provider-kind-type
  — line 10: `'anthropic' | 'gemini' | 'openai-compatible'
  | 'ollama'`. TypeScript union of literal strings
  constrains the return values. §the-named-literal-union-
  as-enum-shape as tier-3 meta-pattern; sibling to cycle
  378's string-literal-union-as-mode-selector
  (`'safe' | 'unsafe'`).

  §The-named-resolveModelForHost-upgrades-qwen3-default
  — lines 50-68: if user explicitly set "qwen3" but
  switched provider, auto-upgrade to provider-default.
  Lines 53-56 explain: "users who configured before
  provider detection was added get the right model
  automatically." Backward-compatibility logic for
  configuration drift across versions. §the-named-
  upgrade-stale-default-to-current-default as tier-3
  meta-pattern.

  §The-named-record-string-string-as-default-models-shape
  — line 29: `/** @type {Record<string, string>} */`. The
  defaultModels object's type is the JS Record-of-string-
  to-string. Sibling to cycle 387 AGENTS.md branded-
  types discipline at a simpler level.

  §The-named-harden-each-export — lines 27 + 36 + 48 + 69:
  every named export and the defaultModels constant has
  `harden(...)` immediately after declaration. Per bot-
  fork CLAUDE.md convention. §the-named-harden-after-
  every-named-export as tier-3 meta-pattern; the convention
  is applied uniformly to all four exports in this
  module.

  §The-named-three-named-functions-plus-one-named-constant
  — detectProviderKind + getDefaultModelForHost +
  resolveModelForHost (three exported functions) + the
  hardened defaultModels constant. Four hardened
  bindings total. The module surface is small but each
  binding is defended.

  §The-named-default-models-disagree-with-README-on-
  Anthropic-version — the specific disagreement is on
  Anthropic's default. README says opus-4-5; source says
  sonnet-4-6. Sonnet-4-6 is the newer family on the
  Anthropic side but README says opus-4-5. Could be (1)
  README written when opus was default and source
  updated; (2) README written aspirationally and source
  matches a different design; (3) genuine bug. The
  cluster's documentation-trails-code framings would
  predict (1) is most likely.

  §The-named-cycle-400-milestone-observation — the
  fortieth-AFTER-the-thirty-tenth conformant cycle (cycle
  392 was 40th-conformant; cycle 400 is 48th-conformant;
  cycle 400 is the NUMERIC 400 milestone). The librarian
  has run forty-eight consecutive conformant single-body
  cycles since the post-refactor refactor (cycles 353-400).
  §forty-eight-conformant-cycles-and-counting as session-
  level observation.

  Closes seven citation arcs: cycle 399 (1, adjacent
  forward; README → source disagreement) + cycle 386 (3,
  README-vs-CODE-inversion sibling shape) + cycle 384 (3,
  design-doc-trails-code sibling shape) + cycle 360 (3,
  README-undercounts-implementation; cycle 399 named 2
  providers, source has 4) + cycle 378 (2, string-literal-
  union-as-mode-selector sibling shape) + cycle 326 (75,
  pure-naming) + cycle 322 (75). Pushes citation-arc-
  closures-in-pivot to FOUR-HUNDRED-SEVENTY-NINE (472 +
  7 net new).
---

69-line providers/config.js, the LLM provider detection and model-resolution implementation. Chat-lane after cycle 399 designs-lane lal README. **CYCLE 400 MILESTONE**. §the-named-cycle-399-vs-cycle-400-default-model-disagreement (single most structurally interesting move; README says claude-opus-4-5, source says claude-sonnet-4-6 for Anthropic default; document-code drift WITHIN ONE PACKAGE); §the-named-readme-says-opus-source-says-sonnet. §the-named-four-provider-kinds (README named 2, source has 4); §the-named-readme-undercounts-the-implementation recurs. §the-named-detectProviderKind-as-ordered-fall-through-URL-heuristic (anthropic → gemini → /v1 → ollama default); §the-named-substring-match-cascade-as-dispatch. §the-named-googleapis-or-generativelanguage-as-disjunction; §the-named-disjunction-for-two-URL-shapes-of-one-provider. §the-named-v1-as-OpenAI-compatible-marker; §the-named-path-component-as-API-version-marker. §the-named-string-literal-union-as-provider-kind-type (sibling to cycle 378). §the-named-resolveModelForHost-upgrades-qwen3-default (backward-compat for configuration drift across versions); §the-named-upgrade-stale-default-to-current-default. §the-named-record-string-string-as-default-models-shape. §the-named-harden-each-export (applied uniformly to four bindings); §the-named-harden-after-every-named-export. §the-named-three-named-functions-plus-one-named-constant. §the-named-default-models-disagree-with-README-on-Anthropic-version. §the-named-cycle-400-milestone-observation; §forty-eight-conformant-cycles-and-counting. Seven citation arcs closed.
