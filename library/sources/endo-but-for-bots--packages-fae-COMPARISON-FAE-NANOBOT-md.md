---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/COMPARISON-FAE-NANOBOT.md
source_line_range: 1-281
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 417 designs-lane ingest. 281-line COMPARISON-FAE-
  NANOBOT.md from @endo/fae — the cluster's SECOND
  comparative architecture document. Introduces a THIRD
  LLM agent (nanobot, a Python-based standalone
  framework) into the cluster's vocabulary. Sixty-fifth
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-seven consecutive non-
  garden sources after the pivot (310-417). §one-hundred-
  and-seven-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  capability-first-vs-platform-first-as-second-
  philosophical-axis — lines 28-49 articulate a new
  philosophical axis for LLM agent design: Fae is
  CAPABILITY-FIRST ("designed around the object-
  capability model... no ambient authority"); nanobot is
  PLATFORM-FIRST ("designed as a complete assistant
  platform... own configuration, persistence, channels,
  scheduling, and memory"). Cycle 415 named the first
  philosophical axis (extensible-tools vs mediated-
  evaluation; Fae vs Lal within Endo). Cycle 417 adds a
  second axis (capability-first vs platform-first; Endo-
  resident vs standalone-platform). Fae lives at the
  intersection of "extensible-tools" + "capability-
  first"; Lal at "mediated-evaluation" + "capability-
  first"; nanobot at "static-registry" + "platform-
  first." Three points in a 2D design space.

  §the-named-LLM-agent-design-space-as-multi-axis as
  tier-3 meta-pattern. The cluster's vocabulary for
  comparing LLM agents is now MULTI-DIMENSIONAL.
  Different comparisons probe different axes; the same
  agent (Fae) can be compared on different dimensions
  depending on its counterpart.

  §the-named-fae-as-comparative-hub — fae is the package
  that maintains comparisons with multiple alternative
  systems (lal AND nanobot). The fae/ directory holds
  TWO comparison documents — fae sits at the center of
  comparative analysis. §the-named-package-as-
  comparative-center as tier-3 meta-pattern.

  §the-named-different-comparative-axes-per-comparison
  — the same package is compared on different
  dimensions depending on the counterpart. Fae-vs-Lal
  is INTRA-runtime (both Endo, different authority
  flow); Fae-vs-nanobot is INTER-runtime (different
  language, different security model, different
  deployment model). §the-named-comparison-axis-
  depends-on-counterpart as tier-3 meta-pattern.

  §the-named-three-tool-registration-strategies — line
  103 lists: Fae dynamic per-turn; nanobot static at
  startup + MCP at first use. Adding Lal's hardcoded
  module-level from cycle 401: THREE strategies for
  tool registration in the cluster:
  - Lal: hardcoded at module load (no extension)
  - Fae: dynamic per-turn (runtime discovery via
    adoption)
  - nanobot: static at startup + MCP bridge (mostly
    static with extensibility hatch)
  §the-named-tool-registration-strategy-axis as tier-3
  meta-pattern.

  §the-named-MCP-bridge-as-tool-extension-mechanism —
  line 103: nanobot has an MCP bridge for adding
  tools at first use. MCP = Model Context Protocol.
  FIRST reference to MCP in the cluster. §the-named-
  MCP-as-inter-system-tool-protocol as tier-3 meta-
  pattern.

  §the-named-accumulating-transcript-vs-rebuilt-context
  — lines 72-79. Fae accumulates a SINGLE growing
  transcript (no truncation, no summarization). nanobot
  REBUILDS the message array from scratch each request
  with windowed history + LLM-summarized memory. Two
  strategies for managing the LLM's context window.
  Connects to cycle 401's Lal-has-no-memory-
  consolidation framing — Lal and Fae share the
  accumulating-transcript strategy; nanobot has the
  rebuilt-context strategy. §the-named-context-window-
  strategy-axis as tier-3 meta-pattern.

  §the-named-max-iteration-guard-presence-varies — line
  67: Fae and Lal have NO max-iteration guard
  (confirmed for Lal per cycle 401's design doc).
  nanobot has max_iterations=20. Design choice differs.
  §the-named-loop-iteration-bound-axis as tier-3 meta-
  pattern.

  §the-named-ReAct-loop-shared-across-three-LLM-agents
  — lines 55-56: "Both implement a ReAct-style loop."
  Combined with cycle 401's Lal-is-ReAct framing, ALL
  THREE agents (Fae, Lal, nanobot) use ReAct. The
  underlying loop pattern is the COMMON GROUND across
  the design space. §the-named-ReAct-as-common-ground
  as tier-3 meta-pattern.

  §the-named-language-asymmetry-JS-vs-Python — line 12:
  Fae is JavaScript (Hardened JS / SES); nanobot is
  Python 3.11+. The two agents live in different
  language ecosystems entirely. §the-named-language-
  ecosystem-as-design-constraint as tier-3 meta-pattern.

  §the-named-security-model-ocap-vs-filesystem-sandbox —
  line 14: Fae has Object-capability (ocap); nanobot
  has Filesystem sandboxing (optional). Two security
  models. §the-named-security-model-axis as tier-3
  meta-pattern.

  §the-named-channel-count-asymmetry — line 22: Fae has
  Endo chat UI only; nanobot has Telegram, WhatsApp,
  Discord, Slack, Feishu, CLI, … (multi-channel).
  §the-named-single-vs-multi-channel-deployment as
  tier-3 meta-pattern.

  §the-named-LLM-provider-count-3-vs-15+ — line 16: Fae
  has 3 providers (Ollama, llama.cpp, Anthropic);
  nanobot has 15+ via LiteLLM. nanobot uses an
  abstraction layer (LiteLLM) that supports many more
  providers. §the-named-provider-abstraction-via-
  external-library as tier-3 meta-pattern.

  §the-named-session-persistence-axis — line 19: Fae
  None; nanobot JSONL files per session. §the-named-
  persistence-as-distinguishing-feature as tier-3 meta-
  pattern.

  §the-named-subagent-system-presence-varies — line 20:
  Fae None; nanobot Background subagent system.
  Subagents are a nanobot-specific feature.
  §the-named-subagent-as-platform-feature as tier-3
  meta-pattern.

  §the-named-scheduling-presence-varies — line 21: Fae
  None; nanobot Cron service. §the-named-scheduling-as-
  platform-feature as tier-3 meta-pattern.

  §the-named-tool-validation-interface-guard-vs-JSON-
  Schema — line 105: Fae validates via FaeTool exo
  interface guard (compile-time-ish); nanobot validates
  via JSON Schema before execution (call-time). Two
  validation strategies. §the-named-validation-timing-
  axis as tier-3 meta-pattern.

  §the-named-result-format-Justin-vs-plain-string —
  line 106: Fae uses Justin (Endo serialization;
  cycle 401 framing); nanobot uses plain strings.
  §the-named-result-serialization-axis as tier-3 meta-
  pattern.

  §the-named-message-format-asymmetry — lines 82-90.
  Fae prepends `"Message #N from <id>: <text>"`;
  nanobot passes content directly with channel/chat_id
  appended to system prompt. §the-named-routing-info-
  in-system-prompt-vs-in-message as tier-3 meta-pattern.

  §the-named-pre-processing-tools-vs-context — line 63:
  Fae's pre-processing is tool discovery; nanobot's
  pre-processing is context building (system prompt +
  memory + skills + history). §the-named-pre-processing-
  step-character-differs as tier-3 meta-pattern.

  §the-named-sixty-five-conformant-cycles-and-counting.

  Closes ten citation arcs: cycle 416 (1, adjacent
  forward; fae source's runtime-discovery now contrasted
  with nanobot's static-at-startup) + cycle 415 (5,
  MAJOR EXTENSION — two-philosophies-axis now joined
  by a SECOND axis to form a 2D design space) + cycle
  401 (5, Lal-design-by-negation framing reframed —
  the things Lal lacks (memory, skills, sessions) are
  what nanobot HAS; Lal/Fae are minimal-by-design,
  nanobot is operationally-complete) + cycle 412 (3,
  three-level provider control axis now joined by
  three-tool-registration-strategy axis — cluster's
  axis-collecting discipline becomes a pattern) +
  cycle 409 (3, capability-attenuation framing extends
  to capability-first design philosophy) + cycle 405
  (3, three-surfaces framing applies but nanobot has
  MULTI-channel external surface) + cycle 326 (75) +
  cycle 322 (75) + cycle 364 (4, shapes count keeps
  growing with new philosophical axis) + cycle 387 (3,
  branded-types via FaeTool guard). Pushes citation-
  arc-closures-in-pivot to SIX-HUNDRED-AND-THIRTY-FIVE
  (626 + 9 net new).
---

281-line COMPARISON-FAE-NANOBOT.md from @endo/fae — the cluster's SECOND comparative architecture document. Introduces a THIRD LLM agent (nanobot, a Python-based standalone framework) into the cluster's vocabulary. Designs-lane after cycle 416 chat-lane fae/src/tools.js. **Single most structurally interesting move**: §the-named-capability-first-vs-platform-first-as-second-philosophical-axis — *lines 28-49 articulate a SECOND philosophical axis for LLM agent design: Fae is CAPABILITY-FIRST (object-capability model, no ambient authority, minimal-by-design); nanobot is PLATFORM-FIRST (complete assistant platform with own configuration, persistence, channels, scheduling, memory). Combined with cycle 415's axis (extensible-tools vs mediated-evaluation), the cluster's design space is now 2D: Fae = extensible+capability-first; Lal = mediated+capability-first; nanobot = static+platform-first.* §the-named-LLM-agent-design-space-as-multi-axis as tier-3 meta-pattern. §the-named-fae-as-comparative-hub (fae maintains comparisons with both lal AND nanobot); §the-named-package-as-comparative-center. §the-named-different-comparative-axes-per-comparison; §the-named-comparison-axis-depends-on-counterpart (Fae-vs-Lal intra-runtime; Fae-vs-nanobot inter-runtime). §the-named-three-tool-registration-strategies (Lal hardcoded + Fae dynamic-per-turn + nanobot static-at-startup-with-MCP); §the-named-tool-registration-strategy-axis. §the-named-MCP-bridge-as-tool-extension-mechanism (FIRST MCP reference in cluster); §the-named-MCP-as-inter-system-tool-protocol. §the-named-accumulating-transcript-vs-rebuilt-context (Lal/Fae accumulate; nanobot rebuilds with windowed history + LLM-summarized memory); §the-named-context-window-strategy-axis. §the-named-max-iteration-guard-presence-varies (nanobot 20; Lal/Fae none); §the-named-loop-iteration-bound-axis. §the-named-ReAct-loop-shared-across-three-LLM-agents (common ground); §the-named-ReAct-as-common-ground. §the-named-language-asymmetry-JS-vs-Python; §the-named-language-ecosystem-as-design-constraint. §the-named-security-model-ocap-vs-filesystem-sandbox; §the-named-security-model-axis. §the-named-channel-count-asymmetry (Fae single; nanobot multi); §the-named-single-vs-multi-channel-deployment. §the-named-LLM-provider-count-3-vs-15+ (nanobot uses LiteLLM abstraction); §the-named-provider-abstraction-via-external-library. §the-named-session-persistence-axis. §the-named-subagent-system-presence-varies; §the-named-subagent-as-platform-feature. §the-named-scheduling-presence-varies; §the-named-scheduling-as-platform-feature. §the-named-tool-validation-interface-guard-vs-JSON-Schema; §the-named-validation-timing-axis. §the-named-result-format-Justin-vs-plain-string. §the-named-message-format-asymmetry; §the-named-routing-info-in-system-prompt-vs-in-message. §the-named-pre-processing-tools-vs-context; §the-named-pre-processing-step-character-differs. §the-named-sixty-five-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-THIRTY-FIVE.
