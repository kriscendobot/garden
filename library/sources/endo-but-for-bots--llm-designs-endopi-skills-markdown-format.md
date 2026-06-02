---
source: designs/endopi-skills-markdown-format.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-15
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-eighth endo-but-for-bots design ingest. **First endopi-*
  design ingest in the library**. Status: Proposed; Parent: endopi.
  The 172-line design adopts the *agentskills.io specification* for
  on-disk skill format (Pi, Claude Code, Codex all already adopted
  it) so that skills authored for any harness can be consumed by
  any other. Three structurally interesting moves: (1) the
  *cross-harness-standardization* argument — *Pi, Claude Code,
  and Codex have all adopted the [agentskills.io specification].
  The result is that a skill written for any of those harnesses
  can be loaded into the others* — the canonical adopt-the-
  existing-standard-rather-than-fragment discipline; (2) the
  *progressive-disclosure* context-budget pattern — *the system
  prompt receives a compact descriptor list (name + description)
  per skill. When the agent decides it needs the skill, it uses
  `read` to load the full SKILL.md* — bounds context cost
  regardless of skill count; (3) the *authoring-surface-vs-
  granting-surface* split — on-disk shape (this design) is for
  authoring; the sibling `endoclaw-skill-registry` EndoDirectory
  is the granting surface; a guest module bridges them.
  
  First of the endopi-* family in the library (similar to how
  cycle 109 was first familiar-*). The §parent meta-design
  endopi.md (583 lines, Reference) is queued. Single-section
  cohesion-honest ingest. Pairs structurally with the cycle
  105+107 daemon-agent-capability layer cycles — skills are
  *another shape of capability* (an invokable instruction-bundle
  rather than a function-call surface). The §`allowed-tools` open
  question asks whether to make skills structurally capability-
  confined like cycle 107's Dir/Shell/Git capabilities — *the
  Endo answer is more rigorous than Pi's; the alignment is worth
  doing*.
  
  Cycle 112 first endopi-* ingest. Cycle 112 pivoted from
  papers-lane (eighth consecutive papers-lane block since cycle
  97) to endopi-design-lane via the broader endo-but-for-bots
  designs corpus.
---

> Abstract: `designs/endopi-skills-markdown-format.md` adopts the
> *agentskills.io specification* — the cross-harness on-disk
> skill format that Pi, Claude Code, and Codex have all
> standardized on. The opening Motivation names the sibling
> `endoclaw-skill-registry` as the *daemon-side surface* (skills
> as pet names in an EndoDirectory) and identifies the *on-disk
> authoring shape* gap that this design fills. The §three
> benefits of joining: cross-harness consumption (read foreign
> skills without translation); cross-harness sharing (Endo
> skills run in Pi/Claude/Codex); progressive disclosure
> (descriptors in system prompt + bodies on demand reduces
> context cost). The §on-disk shape: `my-skill/SKILL.md`
> (required) + optional `scripts/` (helper scripts) + optional
> `references/` (loaded on demand) + optional `assets/`
> (templates/data). The §SKILL.md frontmatter per agentskills.io:
> required `name` (max 64 chars, lowercase a-z/0-9/hyphens,
> match parent directory name) + required `description` (max
> 1024 chars) + optional `license` / `compatibility` /
> `allowed-tools` / `disable-model-invocation`. The §lenient-
> validation discipline: *warn on violations, but remain lenient
> so foreign skills load*. The §loader scans Pi's paths +
> Claude's path + Codex's path. The §progressive-disclosure
> pattern injects a compact descriptor list into the system
> prompt; the agent uses `read` to load the full SKILL.md on
> demand. The §`/skill:my-skill` slash command forces immediate
> load. The §bridge to `endoclaw-skill-registry`: a guest module
> registers a skill-from-path as a daemon formula. The §five-
> phase implementation. The §three Open questions:
> project-local skill location convention; `allowed-tools` →
> capability grant?; cache invalidation on file change. The
> §citations to Pi's `coding-agent/docs/skills.md` +
> `coding-agent/src/core/skills.ts` + `system-prompt.ts` + the
> external agentskills.io specification.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [agentskills-io-on-disk-skill-shape-with-progressive-disclosure](../sections/endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure.md) | daemon | current |

The 172-line file is honestly one cohesive argument-cluster — *one design proposal* adopting the agentskills.io specification with Motivation + Design (4 subsections) + Phased implementation + Dependencies + Open questions + Citation. Single-section ingest preserves the unified structure.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-05-15 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 172 lines.
- **Twenty-eighth endo-but-for-bots design ingest, first endopi-* ingest in the library**.
- Cycle 112 was scheduled for papers-lane (eighth consecutive papers-lane block since cycle 97) and pivoted to endopi-design-lane via the broader endo-but-for-bots designs corpus.
- The §parent design `endopi.md` (583 lines, Reference status) is queued for future ingest. Other endopi-* candidates (8 of them; all Proposed) are also queued.
- Single-section cohesion-honest count. The 172-line file is *one unified design proposal* about adopting the agentskills.io specification; multi-section split would create artificial divisions.
