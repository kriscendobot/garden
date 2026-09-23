---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: The §Mapping table — *the same questions, different answers*
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

The §Genie Mapping table re-asks the umbrella questions of the
comparative-analysis frame, this time of Genie. The most
structurally interesting rows:

- **LLM API**: Lal has 5 providers; Genie inherits *`pi-ai`'s full
  registry verbatim* — **available** by transitive dependency.

- **Ollama provider**: Genie ships a custom `buildOllamaModel`
  adaptor in `src/agent/index.js` that *masquerades ollama as the
  `openai-completions` API style at `http://127.0.0.1:11434/v1`*,
  bypassing `pi-ai`'s absent native ollama entry. Concrete example
  of the *fill-the-Pi-gap-from-the-Endo-side* idiom.

- **Subscription OAuth**: Gap for both Lal/Fae and Genie. Genie
  *inherits whatever `pi-ai` ships*; OAuth providers are not
  enabled out of the box, but the registry shape supports them.

- **Agent loop**: Lal/Fae has its own loop; Genie uses `PiAgent`
  from `pi-agent-core`, subscribed via `runAgentRound` which
  *translates pi-agent-core events into Genie's ChatEvent stream*.
  Event translation at the boundary is the embedding-friendly
  pattern.

- **Tool model**: Genie's `ToolSpec` converted at boundary into
  `AgentTool` for `pi-agent-core` (`toAgentTool`); tools live in
  `src/tools/` (`vfs`, `command`, `web-fetch`, `web-search`,
  `memory`). The same boundary-translation discipline as for events.

- **Capability confinement**: This is *the row Genie loses the
  confinement story on*. Per-tool gating via `tool-gate.js` over an
  ambient-Node tool surface; tool execution is *gated on expected
  tool/arg pairs but is not capability-confined by SES grants*. The
  intent (per jcorbin) is to confine via `packages/sandbox` (whose
  primary driver today is podman; bwrap is also present;
  macOS/Windows drivers are anticipated) for `command` and
  `vfs-node`; that wiring is **not yet present in main**.

- **System prompt constitution**: `buildSystemPrompt` in
  `src/system/index.js`: composes runtime info, policy / strict-
  policy / security-notes sections, tool list, and a Claw-style
  workspace section. *Builds a flexible library of prompt parts.*

- **Persistence shape**: A Claw-compatible workspace dir (default
  `workspace_template/`): `SOUL.md` (persona), `HEARTBEAT.md`
  (tasks), `memory/` (observations.md, reflections.md, profile.md).
  *Markdown-on-disk; the agent reads its own past sessions through
  the memory tools.* The same Claw idiom cycle 117's
  `endopi-jsonl-transcript-format` documents.

- **Compaction**: **In progress** via the observer + reflector
  subagent pair. Observer compresses chat into prioritised
  `observations.md` entries (token-threshold + idle-timer trigger;
  30k-token default); reflector consolidates observations into
  long-term `reflections.md` and `profile.md` (40k-token threshold
  + daily heartbeat). *Both run as separate `PiAgent` instances
  with focused tool sets, gated by `tool-gate.js`.* Shipped
  substrate.

- **Autonomous execution**: A heartbeat subagent loads
  `HEARTBEAT.md`, executes pending tasks, and records
  `.heartbeats.log` per tick. *Claw's autonomous-task shape.*

- **Skill format**: A `skillsPrompt` option on `buildSystemPrompt`
  accepts a pre-rendered skills section. The on-disk format and
  discovery walker are not in Genie; the open spinout
  [endopi-skills-markdown-format](endopi-skills-markdown-format.md)
  still applies.

- **Interval scheduler**: `makeIntervalScheduler` runs *periodic
  agent prompts (cron-style) under the agent loop*. Substrate for
  scheduled-action agents.
