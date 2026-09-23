---
title: See also
source: designs/endopi-skills-markdown-format.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-15
source_authors: [Kris Kowal (prompted)]
source_lines: "1-173 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-eighth endo-but-for-bots design ingest. **First endopi-*
  design ingest in the library**. *Status: Proposed*. *Parent:
  endopi*. The 172-line design adopts the *agentskills.io
  specification* for on-disk skill format (Pi, Claude Code,
  Codex all already adopted it) so that skills authored for any
  harness can be consumed by any other. Three structurally
  interesting moves: (1) the *cross-harness-standardization*
  argument — *Pi, Claude Code, and Codex have all adopted the
  [agentskills.io specification]. The result is that a skill
  written for any of those harnesses can be loaded into the
  others. Endo joining this format means* — the canonical
  *adopt-the-existing-standard rather than fragment* discipline;
  (2) the *progressive-disclosure* context-budget pattern — *the
  system prompt receives a compact descriptor list (name +
  description) per skill. When the agent decides it needs the
  skill, it uses `read` to load the full SKILL.md* — reduces
  per-skill context cost from full-body-inline to descriptor-only;
  (3) the *authoring-surface-vs-granting-surface* split — on-disk
  shape (this design) is for *authoring*; the sibling
  `endoclaw-skill-registry` EndoDirectory is the *granting*
  surface; a guest module bridges them.
  
  Cycle 112 first endopi-* ingest, similar to how cycle 109 was
  first familiar-* ingest. Single-section cohesion-honest ingest.
  Pairs structurally with the cycle 105+107 daemon-agent-capability
  layer cycles — skills are *another shape of capability* (an
  invokable instruction-bundle rather than a function-call surface).
parent: endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure
---

- [[daemon]] (topic) — the endo daemon architecture; skills become daemon formulas via the bridge.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — meta-framework whose *Capabilities are objects, not configurations* discipline informs the `allowed-tools` open question.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — Dir/Shell/Git capabilities for Claw-like AI agents; the agent that uses skills is the same agent that uses these capabilities.
- `endo-but-for-bots--llm-designs-endoclaw-skill-registry` (named sibling) — the *daemon-side complement* (skills as EndoDirectory; this design bridges to it).
- `endo-but-for-bots--llm-designs-endopi-extension-package-manifest` (named sibling) — skills shippable as packages.
- `endo-but-for-bots--llm-designs-lal-fae-form-provisioning` (named sibling) — skill grants part of provisioning.
- `endo-but-for-bots--llm-designs-filesystem-watchers` (named sibling) — for cache invalidation on file change (Open question #3).
- `endo-but-for-bots--llm-designs-endopi` (meta-design parent) — the §parent design that this ingest is extracted from.
