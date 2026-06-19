---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/LAL-ARCHITECTURE.md
source_line_range: 1-488
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 401 designs-lane ingest. 488-line architectural
  reference document for @endo/lal — the canonical design
  doc behind cycle 399's README and cycle 400's source.
  Forty-ninth AUTHORED conformant single-body section doc
  in post-refactor era. Ninety-one consecutive non-garden
  sources after the pivot (310-401).
  §ninety-one-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move:
  §the-named-design-by-negation — the LAL-ARCHITECTURE.md
  articulates Lal by what it does NOT have at least eight
  distinct times across the document: "No dynamic tool
  discovery" (line 39, 161); "No proposal/grant workflow"
  (lines 41, 233-235); "No max-iteration guard" (line 151);
  "no separate message bus abstraction" (line 297); "no
  persistent session management" (line 337); "No JSONL
  persistence. No memory consolidation" (line 346); "no
  workspace files, no memory consolidation, no skills
  system" (lines 279-280); "Transcript is lost when the
  daemon process restarts" (line 347). The design doc
  defines the agent by negation; each "no X" articulates
  a deliberate choice against an alternative architecture
  Lal could have taken. §the-named-design-by-negation
  as tier-3 meta-pattern: a design document that
  specifies the system by listing the features it
  consciously does NOT implement.

  §the-named-design-doc-AND-README-agree-against-source —
  LAL-ARCHITECTURE.md (line 364) lists the Anthropic
  default model as `claude-opus-4-5-20251101`. Cycle 399's
  README (line 22) also said opus-4-5. Cycle 400's source
  (line 31) defines it as `claude-sonnet-4-6-20250514`.
  TWO documents agree (design doc + README); ONE source
  disagrees. Strengthens cycle 400's framing: the
  document tier moves together; the source tier moves
  ahead. §the-named-document-tier-vs-source-tier-as-two-
  speed-strata as tier-3 meta-pattern. Sixth direction of
  document-vs-code drift now distinguished from the
  fifth: cycle 400 named ONE-document-vs-source
  disagreement; cycle 401 names TWO-documents-vs-source
  disagreement (the two documents stayed in lockstep
  while the source moved).

  §the-named-sixteen-tools-comment-vs-eighteen-in-table —
  the design doc's quoted code comment (line 167) says
  "16 tool definitions total" but the table that
  immediately follows (lines 190-209) enumerates 18 tools
  (help + 7 directory + 7 mail + identify + inspectCapability
  + evaluate). Self-inconsistency WITHIN a single document.
  §the-named-intra-document-inconsistency as tier-3
  meta-pattern — drift not between document and source
  but between two adjacent sections of the same document.

  §the-named-system-prompt-section-numbering-missing-six
  — the system prompt structure diagram (lines 254-276)
  numbers sections 1, 2, 3, 4, 5, 7, 8, 9, 10, 11 — the
  numbering JUMPS over 6. Possibly a typo in the design
  doc; possibly section 6 was elided from this
  reference but retained in the actual prompt. §the-
  named-elided-section-as-numbering-gap as tier-3
  meta-pattern; small but structurally telling
  inconsistency.

  §the-named-ReAct-style-loop-as-named-pattern — line 122:
  "This is the ReAct-style loop where the LLM alternates
  between reasoning and tool use." The design doc
  explicitly names the agent loop's pattern as ReAct —
  borrows the name from the public AI literature
  (Reasoning + Acting). §the-named-borrowing-named-
  pattern-from-public-AI-literature as tier-3 meta-
  pattern; sibling to bot-fork's broader vocabulary
  borrowing (caplet, runlet, worklet, weblet).

  §the-named-evaluate-as-direct-execution-not-proposal —
  lines 40-41, 231-244. Evaluate is the most powerful
  tool; it runs code directly. Other guest systems
  (Fae) use a proposal/grant workflow where the LLM
  proposes code and the host grants execution. Lal does
  not. The design doc explicitly contrasts this:
  "Unlike Fae, ..." (line 426). §the-named-direct-
  execution-without-grant-workflow as tier-3 meta-
  pattern; conscious trade-off named.

  §the-named-tool-call-only-response-protocol — line 273:
  the system prompt instructs the LLM to respond ONLY
  with tool calls, no prose. All communication goes
  through the `send()` tool. §the-named-no-prose-only-
  tool-calls as tier-3 meta-pattern; another design-by-
  negation move (no prose responses).

  §the-named-XML-format-tool-call-extraction — lines
  130-134, 146-148. Some models embed tool calls as
  `<tool_call>JSON</tool_call>` in the content field
  rather than the dedicated tool_calls field. Lal
  parses these out. Also strips `<think>...</think>`
  blocks. §the-named-extracting-tool-calls-from-
  content-as-compatibility-shim as tier-3 meta-pattern
  — the design accommodates LLM behavior that doesn't
  conform to the OpenAI tool_calls spec.

  §the-named-synthetic-tool-call-IDs-for-Ollama — line
  394: Ollama doesn't issue tool call IDs, so the
  provider generates them: `ollama_tool_${timestamp}_${index}`.
  §the-named-synthesizing-missing-protocol-fields-at-
  provider-boundary as tier-3 meta-pattern; sibling to
  the XML extraction shim — both compensate for upstream
  divergence from the OpenAI spec.

  §the-named-provider-specific-LAL_MAX_MESSAGES — line
  348-349: only the llama.cpp provider supports
  LAL_MAX_MESSAGES truncation. The Anthropic and Ollama
  providers do not. §the-named-feature-not-uniformly-
  supported-across-providers as tier-3 meta-pattern.

  §the-named-transcript-grows-indefinitely — lines
  337-347: no truncation by default, no consolidation,
  no persistence. Transcript lost on daemon restart.
  Each statement is a deliberate choice articulated as
  a non-feature. §the-named-impermanent-unbounded-
  transcript as tier-3 meta-pattern; sibling design-by-
  negation move.

  §the-named-Lal-compared-to-Fae — lines 289, 426. Two
  explicit comparisons to a sibling system: "A key
  difference from Fae: Lal's system prompt instructs
  the LLM to respond only with tool calls" (line 289)
  and "Unlike Fae, Lal also persists its config into
  the guest's petname store" (line 426). §the-named-
  design-via-contrast-with-sibling-system as tier-3
  meta-pattern; design doc partly defines Lal by what
  it IS NOT (cousin Fae).

  §the-named-static-system-prompt-vs-dynamic-context —
  lines 279-281: "There is no dynamic context building —
  no workspace files, no memory consolidation, no
  skills system. The system prompt is a single
  hardcoded string." This is THE design choice that
  most distinguishes Lal from Claude Code-style
  agentic systems. §the-named-no-dynamic-context-only-
  static-prompt as tier-3 meta-pattern.

  §the-named-cancellation-via-promise-race — lines
  116-118: messageIterator.next() is raced against a
  cancelled promise. §the-named-promise-race-as-
  cancellation-mechanism as tier-3 meta-pattern;
  sibling to standard Endo cancellation idioms.

  §the-named-fixed-set-of-sixteen-or-eighteen-tools — the
  count itself is uncertain per the intra-document
  drift; the structural fact is the tool set is FIXED
  at module load, no runtime extension. §the-named-
  closed-tool-set-as-design-choice as tier-3 meta-
  pattern.

  §the-named-cycle-401-confirms-cycle-400-document-
  drift-direction — cycle 400 named "README-AND-CODE-
  DISAGREE-ON-DEFAULT-VALUE" as a fifth direction.
  Cycle 401 confirms it: the third document (the
  design doc itself, separate from the README) ALSO
  says opus-4-5. Two of three artifacts agree; the
  source disagrees. §forty-nine-conformant-cycles-and-
  counting as session-level observation. §the-named-
  document-tier-vs-source-tier-as-two-speed-strata
  becomes the more precise framing.

  Closes ten citation arcs: cycle 400 (1, adjacent
  forward; design doc agrees with cycle 399 README
  against cycle 400 source — directly extends cycle
  400's framing) + cycle 399 (2, the lal README is the
  other document in the pair) + cycle 386 (3, README-
  vs-CODE-inversion sibling for document-drift) +
  cycle 384 (3, design-doc-trails-code sibling) +
  cycle 360 (3, README-undercounts-implementation
  sibling — design doc has same "16 tools" claim) +
  cycle 364 (4, four-shapes-of-design-vs-implementation-
  arc — now extended to a fifth/sixth direction) +
  cycle 357 (4, ABSTRACTING direction of drift sibling)
  + cycle 326 (75, pure-naming-as-discipline) + cycle
  322 (75, errors framing) + cycle 378 (23, no direct
  use but tool-call extraction relates to mode-
  selector pattern). Pushes citation-arc-closures-in-
  pivot to FOUR-HUNDRED-EIGHTY-NINE (479 + 10 net new).
---

488-line LAL-ARCHITECTURE.md, the canonical design document for @endo/lal — the third document in the lal package after the README and source. Designs-lane after cycle 400's chat-lane source. **Single most structurally interesting move**: §the-named-design-by-negation — the design doc articulates Lal at least eight times as what it does NOT have (no dynamic tool discovery; no proposal/grant workflow; no max-iteration guard; no separate message bus abstraction; no persistent session management; no JSONL persistence; no memory consolidation; no skills system; transcript lost on restart). §the-named-design-doc-AND-README-agree-against-source (the design doc says opus-4-5; the README says opus-4-5; the source says sonnet-4-6 — TWO documents agree, source moves ahead); §the-named-document-tier-vs-source-tier-as-two-speed-strata. §the-named-sixteen-tools-comment-vs-eighteen-in-table (intra-document inconsistency); §the-named-intra-document-inconsistency. §the-named-system-prompt-section-numbering-missing-six (numbering gap). §the-named-ReAct-style-loop-as-named-pattern; §the-named-borrowing-named-pattern-from-public-AI-literature. §the-named-evaluate-as-direct-execution-not-proposal; §the-named-direct-execution-without-grant-workflow. §the-named-tool-call-only-response-protocol; §the-named-no-prose-only-tool-calls. §the-named-XML-format-tool-call-extraction; §the-named-extracting-tool-calls-from-content-as-compatibility-shim. §the-named-synthetic-tool-call-IDs-for-Ollama; §the-named-synthesizing-missing-protocol-fields-at-provider-boundary. §the-named-provider-specific-LAL_MAX_MESSAGES; §the-named-feature-not-uniformly-supported-across-providers. §the-named-transcript-grows-indefinitely; §the-named-impermanent-unbounded-transcript. §the-named-Lal-compared-to-Fae; §the-named-design-via-contrast-with-sibling-system. §the-named-static-system-prompt-vs-dynamic-context; §the-named-no-dynamic-context-only-static-prompt. §the-named-cancellation-via-promise-race; §the-named-promise-race-as-cancellation-mechanism. §the-named-closed-tool-set-as-design-choice. §the-named-cycle-401-confirms-cycle-400-document-drift-direction; §forty-nine-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to FOUR-HUNDRED-EIGHTY-NINE.
