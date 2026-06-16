---
title: Connection to the wider library
source: designs/daemon-agent-tools.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
source_lines: "1-350 (full file)"
topics: [daemon, capability-security]
status: current
notes: |
  Twenty-fifth endo-but-for-bots design ingest. **Status: Not
  Started**, with a §Revision note (2026-05-18) that *names three
  later designs as refining this sketch*: `daemon-mount-capabilities`,
  `daemon-git-capability`, `daemon-git-remotes`. The 350-line
  design is the *concrete-tool-shapes* design that bridges cycle
  105's daemon-capability-bank (meta-framework) with the *Claw-like*
  AI-coding-agent tool set (read / write / shell / git / search).
  Three structurally interesting moves: (1) the *Claw* naming —
  the title parenthetical *Claude-Code-like Capabilities* surfaces
  the user-facing-tool that motivates the design; (2) the
  *capability-granting via pet-name* mechanism connects the
  abstract capability model to concrete daemon operations
  (`endo grant fae fs /home/user/project`); (3) the §dynamic
  tool-discovery pattern — *the same agent code works with or
  without coding capabilities; it simply has fewer tools
  available* — encodes capability-driven configuration without
  agent-code modification.
  
  Pairs structurally with:
  - cycle 101's `daemon-commands-as-messages` (which names this
    design as a *parallel consumer* — agent tool invocations
    become commands too via the same self-addressed-message
    mechanism, giving daemon-capability-bank a built-in
    observability surface).
  - cycle 103's `daemon-value-message` (which names *future
    capability-grant-delivery* — value messages could carry the
    grants this design's capability-granting CLI uses).
  - cycle 105's `daemon-capability-bank` (the meta-framework
    this design implements concrete tool shapes for).
  - cycle 105's six Design Principles — applied directly here
    (capabilities-not-configurations, recursive attenuation,
    LLM discoverability via help() and M.interface() guards).
  
  The §Revision note pointing to three successor designs makes
  this a *partly-superseded sketch* — not deprecated like the
  cycle 99 chat-reply-chain-visualization, but explicitly
  identified as a sketch whose details are *refined* by later
  designs. Single-section cohesion-honest ingest reflects the
  design's unified Problem → Design → Granting → Discovery →
  Implementation argument.
parent: endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration
---

This section is the **canonical *Claw-like-AI-tool-set in capability form* worked example**. Four threads:

1. **The capability-driven dynamic tool registration** — the agent's tool set is determined by its granted capabilities; same agent code works with or without coding capabilities. Reusable for any *runtime-configurable-via-capability-grants* shape.

2. **The Shell array-based-execution + allowlist** discipline — `(command, args[])` tuples + allowed-commands enumeration + filtered-env + timeout + max-output-bytes. The §five-parameter shape is reusable for any *bounded-external-process-invocation* capability.

3. **The Git local-vs-network split** — local Git capability deliberately excludes push/pull (network is separate); fetch/pull/push live in `daemon-git-remotes`. The §one-capability-one-authority-domain invariant prevents *smuggling network and credential authority into local repository access*.

4. **The Revision-note + successor-pointers** — the partial-supersession lifecycle. The original sketch is *refined* (not deprecated); successor designs add detail; the original remains as the entry-point design.

The §cross-cycle complement completes the daemon design-graph triangle started in cycles 101+103+105:

- **Cycle 101** `daemon-commands-as-messages` — names *daemon-agent-tools* as parallel consumer (agent tool invocations become commands too, giving daemon-capability-bank built-in observability).
- **Cycle 103** `daemon-value-message` — the reply-primitive that agent-tool results flow through.
- **Cycle 105** `daemon-capability-bank` — meta-framework that this design's per-capability shapes (Dir/Shell/Git) implement.
- **Cycle 107** `daemon-agent-tools` (this ingest) — the concrete-tool-shapes layer that bridges meta-framework and AI-agent tools.

Together the four cycles describe the *daemon's AI-agent-capability layer*: state primitives (value/commands) + meta-framework (capability-bank) + concrete tool shapes (agent-tools).
