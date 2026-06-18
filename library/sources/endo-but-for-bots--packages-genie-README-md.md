---
source_kind: repo-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/genie/README.md
source_line_range: 1-109
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 381 designs-lane ingest. 109-line README for
  @endo/genie, the bot-fork's AI agent framework. First
  ingest from the endo-but-for-bots fork's `llm` branch in
  this librarian session (most prior cycles have been
  endojs/endo). Twenty-ninth AUTHORED conformant single-
  body section doc in post-refactor era. Seventy-first
  consecutive non-garden source after the pivot (310-381).
  §seventy-one-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  Claw-like-as-positioning-reference — line 3 reads "A
  Claw-like AI Agent framework for the Endo hardened
  JavaScript project." The package positions itself by
  analogy to Claude (called "Claw" obliquely). This is
  meta-positioning: the package's tagline locates it in
  the AI-agent-framework landscape via analogical
  reference rather than via standalone description. §the-
  named-analogy-as-positioning-shorthand as tier-3 meta-
  pattern, sibling to cycle 363's @endo/benchmark
  "minimalistic ava-like interface" delegation; both READMEs
  define the package by what it RESEMBLES rather than
  reconstructing the concept from first principles.

  §The-named-four-component-AI-agent-framework — the
  Overview section names four components: Modular Tool
  System, Memory Integration, Heartbeat Execution, System
  Prompt Builder. The product is a four-part architecture,
  each part packaged separately for composition. §the-
  named-AI-agent-as-four-component-architecture as tier-3
  meta-pattern.

  §The-named-system-prompt-builder-as-first-class-feature
  — the "System Prompt Builder" is named as a top-level
  component. Building the prompt that goes to the LLM is
  not an implementation detail; it's an API surface.
  The systemBuilder function takes identity + soul + memory
  + tools + heartbeatPath + policy flags and returns the
  full system prompt. §the-named-prompt-construction-as-
  API-surface as tier-3 meta-pattern.

  §The-named-identity-soul-memory-tools-heartbeat-five-
  field-prompt-shape — lines 19-25 + 84-94 reveal the
  systemBuilder's parameter shape: identity (string;
  user identity), soul (string; internal truths), memory
  (path to MEMORY.md), tools (path to tools directory),
  heartbeatPath (path to HEARTBEAT.md). Five fields are
  the named decomposition of "what an agent is." §the-
  named-five-named-fields-as-agent-decomposition as tier-3
  meta-pattern.

  §The-named-soul-as-internal-truths — lines 21-22 + 87:
  "soul: Internal truths." The `soul` parameter is given
  this exact gloss. Distinct from `identity` (user-facing)
  and `memory` (factual/recallable). §the-named-soul-vs-
  identity-distinction as tier-3 meta-pattern; the agent
  has both an outward identity (how it presents) and an
  inward soul (what it believes). The parallel to evoke/
  SOUL.md at the repo root (29 lines, not yet ingested)
  suggests a project-wide pattern.

  §The-named-eight-tool-catalog-with-named-actions —
  lines 67-75 list eight tools: memory_get + memory_search
  + readFile + writeFile + editFile + webFetch + webSearch
  + bash. Each named explicitly with a one-line
  description. §the-named-tool-as-named-action as tier-3
  meta-pattern; the tool catalog is the agent's verbs.

  §The-named-bash-as-named-tool-with-safe-execution —
  line 75: "`bash` | Execute shell commands safely". Shell
  execution is in the catalog, marked "safely" — the
  implementation presumably contains the safety layer.
  §the-named-dangerous-capability-named-with-safety-
  qualifier as tier-3 meta-pattern.

  §The-named-heartbeat-as-autonomous-task-loop — line 9
  + 46-48 + 97-103: heartbeat execution loads tasks from
  `HEARTBEAT.md`, parses them, executes, updates task
  status. The agent runs autonomously by reading its own
  task file and ticking through items. §the-named-self-
  read-task-file-as-autonomy-loop as tier-3 meta-pattern.

  §The-named-MEMORY-md-as-persistent-knowledge-file +
  §the-named-HEARTBEAT-md-as-task-list-file — both are
  Markdown files (not databases, not JSON) that the agent
  reads and writes. §the-named-markdown-as-agent-state-
  format as tier-3 meta-pattern; the agent's knowledge
  and todo list are human-readable files in the same
  repo as the code.

  §The-named-security-as-cross-cutting-tool-requirement —
  lines 56-62 and 30 + 41-43 enumerate the security
  layer's discipline: Input validation + Path traversal
  prevention + Code injection prevention + Dangerous
  operation detection + Content validation. Every tool
  implements ALL FIVE. §the-named-five-security-properties-
  per-tool as tier-3 meta-pattern.

  §The-named-policy-flags-as-discipline-knobs — lines
  90-93: disableSuffix (boolean), disablePolicy (boolean),
  strictPolicy (boolean), securityNotes (string custom
  override). Four flags let consumers tune the prompt's
  policy section per-deployment. §the-named-policy-as-
  configurable-not-baked-in as tier-3 meta-pattern.

  §The-named-DESIGN-md-pointer — line 108: "Design
  Document (DESIGN.md) - Complete architecture and
  implementation details." This is a §the-named-DESIGN-
  md-as-package-root-design-document instance (sibling to
  cycle 375's @endo/module-source DESIGN.md). Cycle 382
  chat-lane has an obvious target.

  Closes seven citation arcs: cycle 380 (1, adjacent
  forward; both cycles are about packaging-and-release
  shapes at different scales — cycle 380 changeset entry,
  cycle 381 README of a new bot-framework package) +
  cycle 374 (1, names-in-transit demo on master branch's
  @endo/cli; cycle 381 reveals the llm-branch fork has
  its own agent framework atop the same substrate) +
  cycle 369 (1, daemon; genie likely composes with the
  daemon for capability messaging though README doesn't
  yet name it explicitly) + cycle 363 (1, benchmark
  README's analogy-as-positioning shape sibling) + cycle
  377 (1, secure-coding-guide named POLA; genie's five-
  security-properties-per-tool is an application of POLA
  at the tool layer) + cycle 326 (55, pure-naming-as-
  discipline; tool names + field names are pure naming)
  + cycle 322 (55, @endo/errors not explicitly named in
  the README but presumably used in the tool layer).
  Pushes citation-arc-closures-in-pivot to THREE-HUNDRED-
  FORTY-SIX (339 + 7 net new).
---

109-line README for @endo/genie, the bot-fork's AI agent framework. First ingest from endo-but-for-bots/llm branch in this librarian session. §the-named-Claw-like-as-positioning-reference (single most structurally interesting move — analogical positioning via "Claw-like" tagline; sibling shape to cycle 363 benchmark "ava-like" delegation). §the-named-analogy-as-positioning-shorthand. §the-named-four-component-AI-agent-framework (Tool System + Memory Integration + Heartbeat Execution + System Prompt Builder). §the-named-system-prompt-builder-as-first-class-feature; §the-named-prompt-construction-as-API-surface. §the-named-identity-soul-memory-tools-heartbeat-five-field-prompt-shape. §the-named-soul-as-internal-truths (sibling to evoke/SOUL.md project-wide pattern). §the-named-eight-tool-catalog-with-named-actions (memory_get + memory_search + readFile + writeFile + editFile + webFetch + webSearch + bash). §the-named-bash-as-named-tool-with-safe-execution. §the-named-heartbeat-as-autonomous-task-loop (HEARTBEAT.md self-read). §the-named-markdown-as-agent-state-format (MEMORY.md + HEARTBEAT.md). §the-named-five-security-properties-per-tool (input validation + path traversal prevention + code injection prevention + dangerous operation detection + content validation). §the-named-policy-flags-as-discipline-knobs (disableSuffix/disablePolicy/strictPolicy/securityNotes). §the-named-DESIGN-md-pointer (cycle 382 target). Seven citation arcs closed.
