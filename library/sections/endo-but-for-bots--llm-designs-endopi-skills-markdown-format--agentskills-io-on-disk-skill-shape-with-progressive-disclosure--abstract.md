---
title: Abstract
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

The §Motivation block (lines 11-32) names the gap: the sibling design `endoclaw-skill-registry` covers the *daemon-side surface* (skills as pet names in an EndoDirectory; discovered via `list`; resolved via `lookup`); what it does not cover is the *on-disk authoring shape* — a directory with a `SKILL.md` file at its root, frontmatter declaring the skill's name and description, free-form markdown body, optional helper scripts and reference docs alongside. The §cross-harness-standardization argument: *Pi, Claude Code, and Codex have all adopted the agentskills.io specification for this shape. The result is that a skill written for any of those harnesses can be loaded into the others. Endo joining this format means: (1) the Endo agent can consume skills written for other harnesses without translation (`~/.claude/skills`, `~/.codex/skills`); (2) a skill authored for Endo can be shared with users of other harnesses; (3) Progressive disclosure (descriptions in the system prompt; bodies read on demand by the agent) reduces context cost compared to inlining every skill*. The §Design (lines 34-127) decomposes into four subsections. The §on-disk shape: `my-skill/SKILL.md` (required) + optional `scripts/` (helper scripts the body references) + optional `references/` (details loaded on demand) + optional `assets/` (templates, data). The §SKILL.md frontmatter per agentskills.io: required `name` (max 64 chars, lowercase a-z/0-9/hyphens, must match parent directory name) + required `description` (max 1024 chars) + optional `license` / `compatibility` / `allowed-tools` / `disable-model-invocation`. The §validation discipline: *Endo follows Pi's posture: warn on violations, but remain lenient so foreign skills load*. The §loader sketch defines `discoverSkills({paths: [...]})` scanning Pi's paths (`~/.pi/agent/skills`, `~/.agents/skills`, `.agents/skills` walk-up, `.pi/skills`) + Claude's path (`~/.claude/skills`); injects skills into the system prompt as a compact descriptor list (name + description); the agent uses `read` to load the full SKILL.md on demand. The §`/skill:my-skill` slash command forces immediate load. The §integration with the daemon-side registry — *the on-disk shape is the authoring surface. The endoclaw-skill-registry EndoDirectory is the granting surface. The bridge: a guest module that, given a filesystem path to a skill directory, registers the skill as a daemon formula and adds it to the agent's `skills/` EndoDirectory*. The §two consumption modes documented — author-locally + share-via-daemon-request. The §cross-harness compatibility: *Pi documents adding `~/.claude/skills` to its settings. Endo does the same in reverse: a setting (or default) instructs the agent to scan `~/.claude/skills`, `~/.codex/skills`, and the Pi paths*. The §Phased implementation (lines 128-138) names five phases: (1) frontmatter parser + discovery walker; (2) system-prompt injection (compact descriptor list); (3) slash command `/skill:name`; (4) daemon-formula bridge; (5) cross-harness paths default-enabled. The §Dependencies (lines 140-146) name three sister designs: `endoclaw-skill-registry` (daemon-side complement); `endopi-extension-package-manifest` (skills shippable as packages); `lal-fae-form-provisioning` (skill grants part of provisioning). The §Open questions (lines 148-159) name three honestly: (a) where do project-local skills live? Pi uses `.pi/skills/` and `.agents/skills/`; Claude Code uses `.claude/skills/`. Endo could pick one or scan all three. (b) Does `allowed-tools` map onto capability grants? *Today Pi treats it experimentally; in Endo, this could be a structural grant ('this skill only sees these capabilities'). The Endo answer is more rigorous than Pi's; the alignment is worth doing*. (c) Is the in-memory skill cache invalidated on file change? Pi hot-reloads via `/reload`; Endo can use the existing `filesystem-watchers` design once it lands. The §Citation (lines 161-166) names four sources: Pi's `coding-agent/docs/skills.md`, `coding-agent/src/core/skills.ts`, `system-prompt.ts` (skill formatting block), and the external agentskills.io specification.
