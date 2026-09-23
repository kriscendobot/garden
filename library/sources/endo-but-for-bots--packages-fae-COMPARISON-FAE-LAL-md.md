---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/COMPARISON-FAE-LAL.md
source_line_range: 1-386
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 415 designs-lane ingest. 386-line COMPARISON-FAE-
  LAL.md from @endo/fae package — the cluster's FIRST
  comparison document. Bridges the lal cluster (cycles
  399-413) and the conversation-tree cycle (414) into a
  broader Fae/Lal landscape. Sixty-third AUTHORED
  conformant single-body section doc in post-refactor era.
  One-hundred-and-five consecutive non-garden sources
  after the pivot (310-415). §one-hundred-and-five-cycles-
  with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  fae-extensible-vs-lal-mediated-as-two-philosophies —
  lines 28-50 articulate two design philosophies for LLM
  agents: (1) Fae — Extensible Tools: "Tools are first-
  class capability objects that can be created, sent
  between agents, and adopted at runtime... Security
  comes from the capability model itself — you only give
  Fae the tools you trust it with." (2) Lal — Mediated
  Evaluation: "an agent should be able to propose actions
  that a human reviews before execution. The eval-
  proposal system means Lal can write arbitrary code,
  but that code only runs when the HOST explicitly grants
  it. This creates a human-in-the-loop workflow." TWO
  PHILOSOPHIES, ONE RUNTIME — Fae and Lal share the
  daemon, providers, and base agent loop but differ in
  HOW AUTHORITY FLOWS. §the-named-two-LLM-agent-design-
  philosophies as tier-3 meta-pattern. The cluster gains
  a new comparative vocabulary: extensible-tools-with-
  capability-adoption vs static-tools-with-mediated-
  evaluation.

  §the-named-comparison-document-confirms-cycle-407-
  revision — line 19 of the at-a-glance table:
  "Lal: Mediated (eval-proposal → HOST approval)". Line
  132 of the tool table: "`evaluate` | — | Propose code
  for HOST approval". The COMPARISON document is
  UNAMBIGUOUS that Lal has the eval-proposal workflow.
  Cycle 401's LAL-ARCHITECTURE.md ("no proposal/grant
  workflow") was WRONG, and cycle 407's revision of cycle
  402's vestigial-types framing is now CONFIRMED by an
  independent source. §the-named-third-source-confirms-
  cycle-407-revision as tier-3 meta-pattern.

  §the-named-fifth-document-joins-opus-4-5-faction —
  line 269: Anthropic default model `claude-opus-4-5-
  20251101`. The lal-package drift cluster gets a FIFTH
  document:
  - Faction A (sonnet-4-6): config.js source + setup.js
    example (2 docs)
  - Faction B (opus-4-5): README + LAL-ARCHITECTURE +
    **COMPARISON-FAE-LAL** (3 docs)
  - Faction C (3-5-sonnet-20241022): simulator README
    (1 doc)
  §the-named-document-drift-factions-now-five-documents
  as tier-3 meta-pattern; the factions grow.

  §the-named-fifth-document-on-tool-count — line 18:
  "Lal: 16 fixed tools". Cluster tool-count drift now
  spans FIVE documents:
  - LAL-ARCHITECTURE comment: 16
  - LAL-ARCHITECTURE table: 18
  - mock-powers.js: 22
  - primer/tools.md: 15
  - **COMPARISON-FAE-LAL: 16**
  §the-named-five-tool-counts-across-five-documents as
  tier-3 meta-pattern.

  §the-named-fae-CLAUDE-md-uses-uppercase-special-names
  — fae's inner CLAUDE.md (read in this context) shows
  "these are builtins (`AGENT`, `SELF`, `HOST`,
  `KEYPAIR`, `MAIL`)" — uppercase names. Plus the
  regex `/^[A-Z][A-Z0-9-]{0,127}$/`. But cycle 411's
  lal/primer/capabilities.md showed @-prefixed
  lowercase (@self, @host, @agent, @main). TWO
  conventions for special names across sibling
  packages. §the-named-special-name-case-convention-
  disagrees-between-fae-and-lal as tier-3 meta-pattern.

  §the-named-five-vs-four-special-names-across-
  packages — fae CLAUDE.md lists FIVE builtins (AGENT,
  SELF, HOST, KEYPAIR, MAIL); lal primer lists FOUR
  (@self, @host, @agent, @main). The two packages
  have different special-name SETS. §the-named-
  special-name-set-differs-between-packages as tier-3
  meta-pattern.

  §the-named-comparison-doc-Lal-column-says-uppercase
  — line 234 of the COMPARISON's Lal column: "Special
  petnames (SELF, HOST, AGENT)". This DISAGREES with
  Lal's own primer (capabilities.md) which uses @-
  prefixed lowercase. Even the COMPARISON document's
  account of Lal disagrees with Lal's own primer.
  §the-named-comparison-doc-disagrees-with-described-
  document as tier-3 meta-pattern; the cluster's drift
  now includes "Doc A describing Doc B's facts
  incorrectly."

  §the-named-fae-imports-lal-providers — line 263:
  "Fae imports this as a dependency: `import {
  createProvider } from '@endo/lal/providers/index.js'`."
  Cross-package dependency direction: fae depends on
  lal's provider system. The provider implementations
  live in lal; fae REUSES them. §the-named-fae-as-
  consumer-of-lal-provider-system as tier-3 meta-
  pattern.

  §the-named-Lal-system-prompt-6x-larger-than-Fae —
  lines 213-240: Fae's system prompt is ~400 words;
  Lal's is ~2500 words. Lal's prompt is six times
  larger because of the SmallCaps encoding guide, the
  eval-proposal lifecycle, and the stricter response
  protocol. §the-named-system-prompt-size-asymmetry-
  per-philosophy as tier-3 meta-pattern; mediated
  agents need more LLM-side instruction than
  extensible-tools agents.

  §the-named-Fae-has-no-tests-Lal-has-Ava — line 23:
  "Test suite: Fae: None, Lal: Ava tests + simulator".
  The two sibling agents differ on testing maturity.
  §the-named-test-coverage-asymmetric-between-siblings
  as tier-3 meta-pattern.

  §the-named-Fae-has-JSDoc-only-Lal-has-d-ts — line
  22. Cycle 402's agent.types.d.ts is Lal-specific;
  Fae uses inline JSDoc. §the-named-type-discipline-
  asymmetric-between-siblings as tier-3 meta-pattern.

  §the-named-Fae-tool-as-exo-with-schema-execute-help
  — lines 75-80: "Tools are objects implementing
  schema(), execute(args), help()... Guarded by M.
  interface('FaeTool', ...) pattern. Called via E
  (tool).execute(args) (works for both local and
  remote)." Fae's tools are exo objects following the
  cycle 401 mentioned makeExo pattern. §the-named-
  faetool-as-exo-with-three-required-methods as tier-3
  meta-pattern.

  §the-named-Fae-rediscovers-tools-every-turn — line
  78: "Re-discovered every turn... Can be hot-reloaded
  after adoptTool." Fae's tool set is DYNAMIC at
  runtime — newly adopted tools are immediately usable.
  §the-named-runtime-tool-discovery-per-turn as tier-3
  meta-pattern; contrast with Lal's hardcoded static
  tool catalog.

  §the-named-Lal-blocks-on-proposal-Fae-does-not —
  line 192: "Waiting behavior: Fae: Never waits (tools
  complete immediately); Lal: Blocks on Promise.race()
  for pending proposals." Lal's iteration loop can
  BLOCK on human approval; Fae's never blocks. §the-
  named-agent-loop-can-block-on-mediation as tier-3
  meta-pattern.

  §the-named-Lal-injects-proposal-results-as-user-
  messages — line 193: "Notification injection: ...
  Lal: Proposal results pushed as user messages."
  The transcript is augmented with synthetic user
  messages when proposals settle. §the-named-
  synthetic-user-message-as-event-notification as
  tier-3 meta-pattern.

  §the-named-Lal-message-format-implicit-Fae-message-
  format-explicit — lines 196-207: Fae gives the LLM
  inline message content (`"Message #N from <id>:
  <text>"`); Lal pushes a generic "You have new mail"
  and expects the LLM to call listMessages(). Fae is
  MORE EAGER about exposing message content; Lal is
  more DEMAND-DRIVEN. §the-named-eager-vs-demand-
  message-content-exposure as tier-3 meta-pattern.

  §the-named-three-globals-in-comparison-doc-vs-four-
  in-howto-code — line 230: "Available globals in
  evaluated code (E, M, makeExo)" — THREE globals.
  Matches cycle 401's design doc, NOT cycle 409's
  howto-code.md (which had four with harden).
  COMPARISON-FAE-LAL.md SIDES with cycle 401.
  §the-named-comparison-doc-sides-with-design-doc-on-
  globals as tier-3 meta-pattern.

  §the-named-Fae-extract-tool-calls-imported-Lal-
  inline — lines 313-316: "Note: Fae imports
  extractToolCallsFromContent from src/extract-tool-
  calls.js. Lal has the same function defined inline
  in agent.js (code duplication)." The same function
  exists in both packages — Fae as a module, Lal
  inlined. §the-named-shared-function-modularized-in-
  one-duplicated-in-other as tier-3 meta-pattern.

  §the-named-sixty-three-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 414 (1, adjacent
  forward; conversation-tree was first non-lal
  package; COMPARISON-FAE-LAL is second non-lal
  package and bridges the two agents) + cycle 407
  (5, MAJOR confirmation — third independent source
  affirms cycle 407's revision of cycle 402's
  vestigial-types framing) + cycle 411 (3, special-
  name convention disagrees — primer says @-prefixed
  lowercase; fae CLAUDE + COMPARISON say uppercase) +
  cycle 410 (3, drift factions extended to FIVE
  documents) + cycle 405 (3, three-surfaces framing
  applies to both Lal AND Fae but at different
  scales) + cycle 401 (5, design doc claim about no-
  proposal-workflow definitively refuted by third
  document) + cycle 387 (3, branded-types via M-
  interface for FaeTool) + cycle 326 (75) + cycle
  322 (75) + cycle 364 (4, shapes count keeps
  growing with new philosophical axis). Pushes
  citation-arc-closures-in-pivot to SIX-HUNDRED-AND-
  SEVENTEEN (607 + 10 net new).
---

386-line COMPARISON-FAE-LAL.md from @endo/fae — the cluster's FIRST comparison document; bridges the lal cluster (cycles 399-413) and conversation-tree (cycle 414) into a broader Fae/Lal landscape. Designs-lane after cycle 414 chat-lane conversation-tree/index.js. **Single most structurally interesting move**: §the-named-fae-extensible-vs-lal-mediated-as-two-philosophies — *lines 28-50 articulate two design philosophies for LLM agents: Fae uses dynamic tool discovery and runtime capability adoption (security from the cap model itself); Lal uses mediated evaluation and human-in-the-loop approval (eval-proposal). TWO PHILOSOPHIES, ONE RUNTIME — Fae and Lal share the daemon, providers, and base loop but differ in HOW AUTHORITY FLOWS.* §the-named-two-LLM-agent-design-philosophies as tier-3 meta-pattern. §the-named-comparison-document-confirms-cycle-407-revision (third independent source affirms Lal HAS the proposal/grant workflow; cycle 401's design doc claim is definitively refuted); §the-named-third-source-confirms-cycle-407-revision. §the-named-fifth-document-joins-opus-4-5-faction (Anthropic-default model factions now: A sonnet-4-6 {2}, B opus-4-5 {3 docs incl. COMPARISON}, C 3-5-sonnet {1}); §the-named-document-drift-factions-now-five-documents. §the-named-fifth-document-on-tool-count (now 5 tool counts across 5 documents: 16/18/22/15/16); §the-named-five-tool-counts-across-five-documents. §the-named-fae-CLAUDE-md-uses-uppercase-special-names (regex `/^[A-Z][A-Z0-9-]{0,127}$/` + AGENT/SELF/HOST/KEYPAIR/MAIL); §the-named-special-name-case-convention-disagrees-between-fae-and-lal (5 in fae vs 4 in lal primer; uppercase vs @-lowercase). §the-named-five-vs-four-special-names-across-packages; §the-named-special-name-set-differs-between-packages. §the-named-comparison-doc-Lal-column-says-uppercase (COMPARISON's Lal column disagrees with Lal's own primer); §the-named-comparison-doc-disagrees-with-described-document. §the-named-fae-imports-lal-providers (cross-package dependency: fae → lal → conversation-tree); §the-named-fae-as-consumer-of-lal-provider-system. §the-named-Lal-system-prompt-6x-larger-than-Fae (Fae ~400 words; Lal ~2500); §the-named-system-prompt-size-asymmetry-per-philosophy. §the-named-Fae-has-no-tests-Lal-has-Ava; §the-named-test-coverage-asymmetric-between-siblings. §the-named-Fae-has-JSDoc-only-Lal-has-d-ts; §the-named-type-discipline-asymmetric-between-siblings. §the-named-Fae-tool-as-exo-with-schema-execute-help (FaeTool is an exo with three required methods); §the-named-faetool-as-exo-with-three-required-methods. §the-named-Fae-rediscovers-tools-every-turn; §the-named-runtime-tool-discovery-per-turn. §the-named-Lal-blocks-on-proposal-Fae-does-not; §the-named-agent-loop-can-block-on-mediation. §the-named-Lal-injects-proposal-results-as-user-messages; §the-named-synthetic-user-message-as-event-notification. §the-named-Lal-message-format-implicit-Fae-message-format-explicit; §the-named-eager-vs-demand-message-content-exposure. §the-named-three-globals-in-comparison-doc-vs-four-in-howto-code (COMPARISON sides with design doc on 3 globals); §the-named-comparison-doc-sides-with-design-doc-on-globals. §the-named-Fae-extract-tool-calls-imported-Lal-inline (same function, different code-org); §the-named-shared-function-modularized-in-one-duplicated-in-other. §the-named-sixty-three-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-SEVENTEEN.
