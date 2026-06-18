---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/genie/src/tools/index.js
source_line_range: 1-25
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 384 chat-lane ingest paired to cycle 383 designs-lane
  evoke/SOUL.md. 25-line barrel export listing the genie
  package's tool surface. Thirty-second AUTHORED conformant
  single-body section doc in post-refactor era. Seventy-
  fourth consecutive non-garden source after the pivot
  (310-384). §seventy-four-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  FTS5-backend-already-shipping-future-feature-from-DESIGN
  — line 22 exports `makeFTS5Backend`. The cycle 382 DESIGN.
  md listed "Full Text Search (sqlite fts5)" as the FIRST
  item on the seven-named-future-enhancements list (line
  181). Cycle 384 shows it has already shipped. The future
  feature exists in source ahead of where the DESIGN
  doc placed it. §the-named-design-doc-trails-code as
  tier-3 meta-pattern; sibling shape to cycle 382's §the-
  named-readme-aspirational-design-current — there the
  README was aspirational and DESIGN was current; here
  DESIGN is stale and CODE is current. Both directions
  exist between the three documents.

  §The-named-VFS-abstraction-with-memory-and-node-variants
  — lines 18-19 export `makeMemoryVFS` and `makeNodeVFS`.
  Virtual File System abstraction with TWO backends: in-
  memory (presumably for testing or pure-substrate
  execution) and Node.js-filesystem (for production). The
  README and DESIGN both treated filesystem access as a
  single capability; cycle 384 source reveals the VFS
  abstraction. §the-named-two-backend-VFS-via-make-prefix
  as tier-3 meta-pattern; the agent can be parameterized
  with which filesystem flavor to use.

  §The-named-make-prefix-as-factory-naming-convention —
  six `make*` factory functions: makeCommandTool,
  makeFileTools, makeMemoryVFS, makeNodeVFS, makeMemoryTools,
  makeFTS5Backend. Sibling shape to cycle 367's §the-named-
  three-shapes-of-make-and-define-and-define-kit; genie's
  tools all follow the `make` pattern (single-instance with
  closure state) exclusively. §the-named-make-only-no-
  define-in-tool-layer as tier-3 meta-pattern; the tools
  are stateless services rather than class-instances.

  §The-named-rejectPatterns-and-rejectFlags-and-enforcePath-
  as-named-security-primitives — lines 12-14 export three
  named functions alongside `bash`: rejectPatterns (block
  regex-matching commands), rejectFlags (block specific CLI
  flags), enforcePath (validate paths don't escape). These
  are the actual implementation of cycle 381's README
  security claims ("Path traversal prevention", "Dangerous
  command detection"). §the-named-validator-as-exportable-
  primitive-not-private-helper as tier-3 meta-pattern; the
  security functions are usable independently by consumers
  who want to compose them with their own custom commands.

  §The-named-bash-as-tool-plus-three-named-validators —
  `bash` is exported alongside `makeCommandTool` +
  rejectPatterns + rejectFlags + enforcePath. The bash tool
  is one preset of the more general makeCommandTool factory
  using the three rejection/enforcement primitives. §the-
  named-named-preset-via-factory-and-named-validators as
  tier-3 meta-pattern.

  §The-named-eight-tool-README-vs-six-make-export-mismatch
  — cycle 381 README counted EIGHT tools (memory_get +
  memory_search + readFile + writeFile + editFile + webFetch
  + webSearch + bash). Cycle 384 source exports SIX
  factories (makeCommandTool + makeFileTools + makeMemoryVFS
  + makeNodeVFS + makeMemoryTools + makeFTS5Backend) plus
  TWO direct functions (webFetch + webSearch). The naming
  level is different: README counts logical tools; source
  exports composable factories. §the-named-logical-tool-
  count-not-equal-export-count as tier-3 meta-pattern.

  §The-named-makeFileTools-bundles-three-file-tools —
  the README's readFile + writeFile + editFile are a TRIO
  but the source bundles them under a single
  `makeFileTools` factory. §the-named-related-tools-bundled-
  by-factory as tier-3 meta-pattern.

  §The-named-makeMemoryTools-bundles-memory-get-and-search
  — similarly, memory_get + memory_search bundle under
  `makeMemoryTools` with `makeFTS5Backend` as the storage
  layer behind them. §the-named-tool-factory-with-pluggable-
  backend as tier-3 meta-pattern; the memory tools are
  parameterized by which backend (FTS5 or other) they use.

  §The-named-ts-check-pragma-as-opt-in-checking — line 1
  `// @ts-check` continues the cluster convention.

  §The-named-twenty-five-line-barrel-export — the file is
  pure re-exports plus a JSDoc preamble. Sibling shape to
  cycle 376's hidden.js (20-line constants-only module);
  both are single-purpose module-surface files.

  Closes seven citation arcs: cycle 383 (1, adjacent forward
  pair SOUL → tools index; agent discipline meets tool
  catalog) + cycle 382 (2, DESIGN's future-enhancements
  list contradicted by source; FTS5 has shipped; new
  design-doc-trails-code framing extends the readme-
  aspirational-design-current shape with a third direction)
  + cycle 381 (2, README's eight-tool catalog vs source's
  six-factory exports reveals counting-level discrepancy) +
  cycle 367 (5, make/define/define-kit naming convention;
  genie uses make-only) + cycle 374 (3, social-network
  capability-passing; tools are the capabilities passed in
  the network) + cycle 326 (58, pure-naming-as-discipline)
  + cycle 322 (58). Pushes citation-arc-closures-in-pivot
  to THREE-HUNDRED-SIXTY-SEVEN (360 + 7 net new).
---

25-line barrel export listing the genie package's tool surface. §the-named-FTS5-backend-already-shipping-future-feature-from-DESIGN (single most structurally interesting move — cycle 382 DESIGN listed FTS5 as future; cycle 384 source shows it shipped; new framing: design-doc-trails-code as sibling to readme-aspirational-design-current). §the-named-VFS-abstraction-with-memory-and-node-variants (two-backend VFS via make-prefix). §the-named-make-prefix-as-factory-naming-convention (six make* factories; sibling to cycle 367 trio; tools are make-only no define). §the-named-rejectPatterns-and-rejectFlags-and-enforcePath-as-named-security-primitives (named validators as exportable primitives not private helpers). §the-named-bash-as-tool-plus-three-named-validators (bash is a preset of the more general makeCommandTool factory). §the-named-eight-tool-README-vs-six-make-export-mismatch (logical-tool-count vs export-count discrepancy). §the-named-makeFileTools-bundles-three-file-tools (readFile + writeFile + editFile under single factory). §the-named-makeMemoryTools-bundles-memory-get-and-search (with FTS5 as pluggable backend); §the-named-tool-factory-with-pluggable-backend. §the-named-ts-check-pragma-as-opt-in-checking. §the-named-twenty-five-line-barrel-export. Seven citation arcs closed.
