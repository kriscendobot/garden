---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/formatting.md
source_commit: 10594d09fa6efff9f7d4271adc2f2f19214fd756
source_date: 2026-03-26
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 453 designs-lane ingest. 31-line
  primer/formatting.md from @endo/lal's agent-facing
  primer. Seventeenth lal-package artifact in the
  cluster. One hundred and first AUTHORED conformant
  single-body section doc in post-refactor era. One-
  hundred-forty-third consecutive non-garden source
  after the pivot (310-453).

  Single most structurally interesting move: §the-
  named-quasi-markdown-dialect-as-non-standard-inline-
  formatting — the LAL chat surface uses a CUSTOM
  markdown dialect ("Quasi-Markdown") with explicitly
  non-standard inline formatting: *bold* (single
  asterisk, NOT double), /italic/ (forward slash, NOT
  asterisk), _underline_, ~strikethrough~. The
  document warns "NOTE: differs from standard
  markdown!" Block-level elements match standard
  Markdown; the divergence is ONLY inline. §the-named-
  single-asterisk-as-bold-not-italic-in-quasi-markdown
  as tier-3 meta-pattern. The cluster's first explicit
  custom-language-definition: a formatting language
  distinct from standard Markdown, defined for the
  LAL agent's output surface. §the-named-quasi-
  markdown-optimized-for-capability-path-contexts
  (forward slash = italic avoids ambiguity with
  endo://... URLs and filesystem paths). §the-named-
  block-level-compatible-inline-level-diverges.
  §the-named-code-fence-in-message-same-format-as-
  llm-json-response connects to cycle 452. §the-
  named-formatting-primer-omits-IMPORTANT-marker
  (absent here vs present in tools.md, messaging.md,
  errors.md; sharpens cycle 407's framing to a
  correlation with defensive-ordering guidance).
  §the-named-IMPORTANT-marker-usage-correlates-with-
  defensive-ordering as tier-3 meta-pattern.

  Three citation arcs closed: cycle 452 (1, adjacent
  forward), cycle 449 (3, smallcaps filter-at-vocab-
  level now extends to format-level), cycle 407 (3,
  IMPORTANT-marker conditional usage).
---

31-line primer/formatting.md from @endo/lal's agent-facing primer. Documents the Quasi-Markdown dialect used for agent message output: non-standard inline formatting where `*bold*` = single asterisk (not double), `/italic/` = forward slash (not asterisk), `_underline_` = underscores, `~strikethrough~` = tildes; block-level elements match standard Markdown. **Single most structurally interesting move**: §the-named-quasi-markdown-dialect-as-non-standard-inline-formatting — *the LAL system defines a CUSTOM markdown dialect distinct from standard Markdown, optimized for capability-path contexts where forward slashes appear in URLs and filesystem paths.* §the-named-single-asterisk-as-bold-not-italic-in-quasi-markdown as tier-3 meta-pattern. §the-named-quasi-markdown-optimized-for-capability-path-contexts. §the-named-block-level-compatible-inline-level-diverges. §the-named-code-fence-in-message-same-format-as-llm-json-response. §the-named-formatting-primer-omits-IMPORTANT-marker; §the-named-IMPORTANT-marker-usage-correlates-with-defensive-ordering as tier-3 meta-pattern.

| Section | Topics | Status |
|---------|--------|--------|
| [quasi-markdown-dialect-with-non-standard-inline-formatting](../sections/endo-but-for-bots--packages-lal-primer-formatting-md--quasi-markdown-dialect-with-non-standard-inline-formatting.md) | agent-conventions, chat-ui | current |
