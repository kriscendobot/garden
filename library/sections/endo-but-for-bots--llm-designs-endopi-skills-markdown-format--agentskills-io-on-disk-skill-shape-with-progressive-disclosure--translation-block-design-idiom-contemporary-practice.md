---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `agentskills.io specification` cross-harness standard | The *adopt-the-existing-standard rather than fragment* discipline. |
| `Pi, Claude Code, and Codex have all adopted the [agentskills.io specification]` | The *three-harness-adoption = de-facto-standard* recognition. |
| Progressive disclosure (descriptors in system prompt; bodies read on demand) | The *bounded-context-via-on-demand-load* pattern. |
| `SKILL.md` required + `scripts/` / `references/` / `assets/` optional | The *one-required-file-plus-optional-siblings* directory layout. |
| `name` must match parent directory name | The *filesystem-as-canonical-name* discipline. |
| `Endo follows Pi's posture: warn on violations, but remain lenient` | The *lenient-validation* discipline for foreign-format consumption. |
| On-disk shape (authoring) vs EndoDirectory (granting) | The *two-surface-via-guest-module-bridge* split. |
| `/skill:my-skill` slash command | The *user-override-for-LLM-skill-selection* affordance. |
| Default scan of Pi/Claude/Codex paths | The *be-the-most-inclusive-harness* posture. |
| `allowed-tools` could be *structural grant* not configuration | The *standard-borrowing-with-Endo-specific-rigor* direction. |
| Three Open questions named explicitly | The *honest-enumeration-of-unresolved-decisions* discipline. |
| Cite Pi's `packages/coding-agent/src/core/skills.ts` | The *cite-the-reference-implementation* discipline. |
