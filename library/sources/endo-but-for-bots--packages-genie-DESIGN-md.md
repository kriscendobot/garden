---
source_kind: design-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/genie/DESIGN.md
source_line_range: 1-203
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 382 chat-lane ingest paired to cycle 381 designs-lane
  @endo/genie README. 203-line DESIGN document for the bot-
  fork's AI agent framework. Thirtieth AUTHORED conformant
  single-body section doc in post-refactor era. Seventy-
  second consecutive non-garden source after the pivot
  (310-382). §seventy-two-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  tool-as-schema-help-execute-three-method-shape — lines
  124-145 specify the uniform tool interface. Every tool
  has THREE methods: `schema` (an M.interface from @endo/
  patterns), `help` (a function returning a description
  string), `execute` (an async function returning `{
  success, result }`). The interface is uniform; the
  implementation varies. §the-named-three-method-tool-
  shape as tier-3 meta-pattern. Schema validates inputs;
  help describes the tool; execute does the work. Three
  responsibilities, three named methods, one shape.

  §The-named-schema-via-M-interface — line 129 imports
  `M` from `@endo/patterns`. The tool schema uses
  `M.interface(...)`, `M.string()`, `M.number().optional()`,
  `M.boolean().optional()` patterns. §the-named-patterns-M-
  namespace-applied-to-tool-validation as tier-3 meta-
  pattern. The bot-fork's tool layer composes with the
  endojs/endo substrate's pattern-builder DSL (cycle 327
  patterns README named M.callWhen; cycle 367 exo used
  M.interface for method guards).

  §The-named-help-method-as-convention — every tool has
  `help: () => 'Tool description...'`. The function is
  parameterless and returns a description. §the-named-self-
  describing-tool-via-help-method as tier-3 meta-pattern.
  The agent can call `help()` on each available tool to
  generate documentation, system prompts, or LLM-visible
  catalogs without hard-coding the strings.

  §The-named-success-result-shape — line 142: `return {
  success: true, result: ... }`. Standardized return
  shape: success flag plus the actual result. §the-named-
  success-flag-as-uniform-result as tier-3 meta-pattern.
  The caller can branch on success without parsing the
  result body.

  §The-named-six-security-features-now-includes-rate-
  limiting — line 50-55 extends the README's five
  security properties with `Rate limiting support`. The
  DESIGN names a sixth security feature. §the-named-
  design-doc-adds-feature-beyond-README as tier-3 meta-
  pattern; the README is a subset; the DESIGN is the full
  surface.

  §The-named-four-design-principles — lines 73-98 enumerate
  Security-First + Modular & Extensible + Autonomous
  Execution + Developer-Friendly as the named principles.
  Each gets a sub-section. §the-named-four-named-design-
  principles as tier-3 meta-pattern; the principles are
  the design's vocabulary.

  §The-named-file-structure-as-architecture-diagram — lines
  28-34 show an ASCII tree of `src/system/` with `index.js`
  + `memory-context.js` + `workspace-context.js` + `tools-
  list.js`. The diagram IS the architecture documentation
  for that subsystem. §the-named-ascii-tree-as-component-
  decomposition as tier-3 meta-pattern.

  §The-named-memory-directory-layout — lines 149-157 show
  the on-disk structure: `MEMORY.md` (main file) + `memory/
  topic.md` + `memory/YYYY-MM-DD-summary.md` (dated
  summaries of prior session history). §the-named-dated-
  summary-files-as-session-history as tier-3 meta-pattern;
  the agent's history is partitioned by date in human-
  readable files. Sibling shape to cycle 381's §the-named-
  markdown-as-agent-state-format.

  §The-named-simple-substring-search-upgrade-path — line
  161: "Simple substring search (can be upgraded to vector
  embeddings)." Honest acknowledgment of the current
  implementation's limit and the future direction. §the-
  named-honest-current-implementation-with-named-upgrade
  as tier-3 meta-pattern; sibling honest-acknowledgment
  shape from cycles 357/359/372/375/377/378/379.

  §The-named-heartbeat-markdown-checkbox-format — lines
  167-177 specify the heartbeat file format: two sections
  (`## Current Tasks` with `- [ ]` checkboxes + `## Done
  Tasks` with `- [x]` checkboxes). Standard GitHub-flavored
  markdown checkbox syntax. §the-named-task-list-as-
  checkbox-markdown as tier-3 meta-pattern.

  §The-named-seven-future-enhancements-list — lines 179-187
  enumerate Full Text Search (sqlite fts5) + Semantic
  Search (RAG) + Tool Chaining + Conversation Memory + Rate
  Limiting + Webhooks + Caching as the future roadmap. The
  DESIGN names exactly which features are NOT yet
  implemented. §the-named-seven-named-future-enhancements
  as tier-3 meta-pattern.

  §The-named-design-doc-acknowledges-shortcuts-the-README-
  hides — comparing cycle 381 README and cycle 382 DESIGN
  reveals: the README implies a complete agent system; the
  DESIGN names the seven enhancements not yet shipped. The
  cycle 363→364 ANALOGY-VS-LITERAL arc finds a new
  variant here: the README ABSTRACTS the implementation's
  current state to its aspirational complete form; the
  DESIGN reveals the gap between current and aspirational.
  §the-named-readme-aspirational-design-current as tier-3
  meta-pattern.

  §The-named-four-step-tool-contribution-checklist — lines
  198-203 enumerate: define schema using `@endo/patterns`
  + implement `help()` documentation + add security
  validations + update `tools/index.js` exports. Four steps
  to add a new tool. §the-named-checklist-as-tool-
  extension-contract as tier-3 meta-pattern.

  §The-named-testing-strategy-four-layer — lines 189-194
  list Unit + Integration + End-to-end + Security
  validation as the four test layers. §the-named-four-
  layer-test-strategy as tier-3 meta-pattern.

  Closes seven citation arcs: cycle 381 (1, adjacent
  forward; README → DESIGN; DESIGN reveals the seven
  enhancements README hides; new READAEME-vs-DESIGN-as-
  aspirational-vs-current arc framing) + cycle 367 (3, exo
  README's M.interface composed with tool-as-schema-help-
  execute three-method shape; bot-fork tools are validated-
  OCAP objects via patterns; SECOND citation across two
  fork branches) + cycle 327 (6, patterns README's M
  namespace applied here to tool validation) + cycle 374
  (2, social-network demo on master cli; cycle 382 reveals
  tools are how that network's capabilities are
  parameterized in the bot-fork) + cycle 359 (2, honest-
  placeholder shape sibling — "can be upgraded to vector
  embeddings" is the same shape as "Fill in provided rules
  here") + cycle 326 (56, pure-naming-as-discipline) +
  cycle 322 (56, errors not directly used in DESIGN code
  examples). Pushes citation-arc-closures-in-pivot to
  THREE-HUNDRED-FIFTY-THREE (346 + 7 net new).
---

203-line DESIGN.md for @endo/genie, the bot-fork's AI agent framework. Chat-lane after cycle 381 designs-lane README. §the-named-tool-as-schema-help-execute-three-method-shape (single most structurally interesting move — uniform tool interface across all eight tools; schema = M.interface validation; help = self-description; execute = async work returning {success, result}). §the-named-schema-via-M-interface (composes with cycle 327 patterns + cycle 367 exo). §the-named-help-method-as-convention; §the-named-self-describing-tool-via-help-method. §the-named-success-result-shape. §the-named-six-security-features-now-includes-rate-limiting (DESIGN extends README's five with sixth: rate limiting); §the-named-design-doc-adds-feature-beyond-README. §the-named-four-design-principles (Security-First + Modular & Extensible + Autonomous Execution + Developer-Friendly). §the-named-file-structure-as-architecture-diagram (ASCII tree). §the-named-memory-directory-layout (MEMORY.md + memory/topic.md + memory/YYYY-MM-DD-summary.md); §the-named-dated-summary-files-as-session-history. §the-named-simple-substring-search-upgrade-path (honest acknowledgment; sibling honest-acknowledgment shape from cycles 357/359/372/375/377/378/379); §the-named-honest-current-implementation-with-named-upgrade. §the-named-heartbeat-markdown-checkbox-format. §the-named-seven-future-enhancements-list (Full Text Search via sqlite fts5 + Semantic Search via RAG + Tool Chaining + Conversation Memory + Rate Limiting + Webhooks + Caching). §the-named-design-doc-acknowledges-shortcuts-the-README-hides (new framing: README aspirational, DESIGN current); §the-named-readme-aspirational-design-current. §the-named-four-step-tool-contribution-checklist. §the-named-four-layer-test-strategy. Seven citation arcs closed.
