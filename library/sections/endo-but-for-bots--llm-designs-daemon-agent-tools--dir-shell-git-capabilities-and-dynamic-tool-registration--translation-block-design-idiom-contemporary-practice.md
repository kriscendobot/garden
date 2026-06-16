---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `Claw-like` (Claude-Code-like) agents | The *named-target* discipline; design's audience is concrete AI coding agents. |
| `ambient authority` vs `capability-confined equivalents` | The *replace-ambient-with-capabilities* discipline; Endo's core value proposition. |
| `Dir rooted at project directory` | The *bounded-root-capability* pattern; structural-confinement at the project boundary. |
| `Shell with command allowlist + array-based execution` | The *bounded-process-invocation* pattern; allowlist + array + no-shell-expansion + timeout + max-bytes. |
| `Git split by authority` (local-only excludes push/pull) | The *one-capability-one-authority-domain* invariant. |
| `git push / pull / config / hook` explicitly excluded | The *enumerate-exclusions-with-rationale* discipline; not just *what's permitted* but *what's denied and why*. |
| `endo grant fae fs /home/user/project` pet-name grant | The *named-capability-grant* CLI shape; agents look up by pet-name. |
| `try { lookup('fs') ... } catch { skip }` dynamic tool registration | The *capability-driven-configuration* pattern; runtime adapts to granted capabilities. |
| Form-based capability provisioning | The *form-flow-includes-capability-grants* shape; agent setup is a single form. |
| `M.interface('Shell', { exec: M.call(...).returns(...) })` | The *self-documenting-shape* discipline; the guard *is* the spec. |
| `Revision note (2026-05-18) ... refines this sketch` | The *partly-superseded-sketch* lifecycle; design refined by successors but not deprecated. |
| `Phased approach. Filesystem first, shell + git progressively harder to confine` | The *user-value-vs-security-difficulty* phasing rationale. |
