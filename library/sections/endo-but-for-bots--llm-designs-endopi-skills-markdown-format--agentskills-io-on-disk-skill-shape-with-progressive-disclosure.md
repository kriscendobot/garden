---
title: The §motivation that names cycle 105-adjacent `endoclaw-skill-registry` as the *daemon-side surface* (skills as pet names in an EndoDirectory, discovered via `list` and resolved via `lookup`) and identifies the *on-disk authoring shape* gap as what this design fills; the §canonical *agentskills.io specification* adoption discipline — Pi, Claude Code, and Codex have all adopted the same format, so a skill written for any of those harnesses can be loaded into the others (Endo joining this format means cross-harness consumption + cross-harness sharing + progressive-disclosure reduces context cost); the §on-disk shape with `my-skill/SKILL.md` (required) + optional `scripts/` (helper scripts the body references) + optional `references/` (details loaded on demand) + optional `assets/` (templates, data); the §SKILL.md frontmatter — `name` (required, max 64 chars, lowercase `a-z` / `0-9` / hyphens, must match parent directory name) + `description` (required, max 1024 chars) + optional `license` / `compatibility` / `allowed-tools` / `disable-model-invocation`; the §validation discipline — *Endo follows Pi's posture: warn on violations, but remain lenient so foreign skills load*; the §loader sketch with `discoverSkills({paths: [...]})` scanning `~/.pi/agent/skills` + `~/.agents/skills` + `~/.claude/skills` + `.agents/skills` (walk up from cwd) + `.pi/skills`; the §progressive-disclosure pattern — *the system prompt receives a compact descriptor list (name + description) per skill. When the agent decides it needs the skill, it uses `read` to load the full SKILL.md*; the §`/skill:my-skill` slash command for forcing immediate load; the §daemon-side integration — *on-disk shape is the authoring surface; the endoclaw-skill-registry EndoDirectory is the granting surface*; a guest module bridges them by registering skill-from-path as daemon formula; the §cross-harness compatibility — *Pi documents adding `~/.claude/skills` to its settings. Endo does the same in reverse* (default scan of Pi, Claude Code, Codex skill paths); the §five-phase implementation plan; the §three open questions (project-local skill location convention; `allowed-tools` → capability grants?; in-memory skill cache invalidation on file change); the §citations to Pi's `coding-agent/docs/skills.md` + `coding-agent/src/core/skills.ts` + `system-prompt.ts` + the external `agentskills.io` spec
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--abstract.md)
- [Body](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure--common-confusions.md)
