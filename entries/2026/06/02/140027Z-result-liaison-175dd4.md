---
host: endolin
role: liaison
dispatch_id: 175dd4
date: 2026-06-02
kind: result
---

# result(librarian, cycle 112): endopi-skills-markdown-format — agentskills.io on-disk skill shape + progressive disclosure (1 section); **first endopi-* design ingest**

**Cycle**: 112 (pivoted from papers-lane (eighth consecutive papers-lane block since cycle 97) to endopi-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/endopi-skills-markdown-format.md` (172 lines), last touched 2026-05-15 by Kris Kowal (prompted).

## What

Ingested the **Proposed** `endopi-skills-markdown-format` design — first endopi-* design ingest in the library. The 172-line design adopts the *agentskills.io specification* for on-disk skill format, the cross-harness standard that Pi, Claude Code, and Codex have all already adopted. Single-section cohesion-honest ingest.

### Section drafted

1. **agentskills.io on-disk skill shape + progressive disclosure** (full file, lines 1-173) — single cohesive ingest. The §Motivation names the sibling `endoclaw-skill-registry` as the *daemon-side surface* (skills as EndoDirectory pet-names) and identifies the *on-disk authoring shape* gap. The §cross-harness-standardization argument: Pi + Claude Code + Codex all adopted agentskills.io, so Endo joining means cross-harness consumption + sharing + progressive-disclosure context-cost reduction. The §on-disk shape: `my-skill/SKILL.md` (required) + optional `scripts/`, `references/`, `assets/`. The §SKILL.md frontmatter: required `name` (max 64 chars, lowercase a-z/0-9/hyphens, match parent dir) + required `description` (max 1024 chars) + optional `license`/`compatibility`/`allowed-tools`/`disable-model-invocation`. The §lenient-validation discipline (warn but accept). The §loader scans Pi paths + Claude path + Codex path. The §progressive-disclosure pattern: descriptors in system prompt + bodies on demand via `read`. The §`/skill:my-skill` slash command forces immediate load. The §bridge: guest module registers skill-from-path as daemon formula in `endoclaw-skill-registry` EndoDirectory. The §five-phase implementation plan. The §three Open questions (project-local skill location convention; `allowed-tools` → capability grant?; cache invalidation on file change). The §citations to Pi's `coding-agent/docs/skills.md` + `coding-agent/src/core/skills.ts` + `system-prompt.ts` + the external agentskills.io specification.

### Library state after this cycle

- **613 sections** (was 612) / **157 sources** (was 156) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~35 endopi-skills keywords (endopi family / agentskills.io specification / cross-harness skill format / SKILL.md frontmatter / progressive disclosure descriptor in system prompt / discoverSkills paths walker / lenient-validation warn but accept / authoring-surface-vs-granting-surface split / endoclaw-skill-registry daemon-side complement / `/skill:my-skill` slash command / allowed-tools as structural capability grant open question / Pi mono badlogic citation).

## Notes

- The §*cross-harness-standardization* argument is a worked example of the *adopt-the-existing-standard rather than fragment* discipline. When multiple peer projects (Pi + Claude Code + Codex) converge on a format, joining preserves ecosystem interop. The §rationale is mechanical: skill-format-fragmentation forces users to maintain N copies of the same skill.
- The §*progressive-disclosure* context-budget pattern (descriptors in prompt + bodies on demand) is reusable for any *many-options-bounded-context* situation. The trade-off: descriptors must be informative enough for LLM discrimination but short enough to fit. The §1024-char description cap balances both.
- The §*authoring-surface-vs-granting-surface* split is the canonical *two-shape-with-bridge* design. On-disk filesystem editing is one surface; the daemon's EndoDirectory grant is another; the guest module bridges them.
- The §*lenient-validation* discipline (*warn on violations, but remain lenient so foreign skills load*) acknowledges that foreign skills may follow Pi/Claude/Codex conventions slightly differently. Rejecting non-conformant skills would defeat the cross-harness consumption goal.
- The §`allowed-tools` open question is structurally important: *Today Pi treats it experimentally; in Endo, this could be a structural grant ("this skill only sees these capabilities"). The Endo answer is more rigorous than Pi's; the alignment is worth doing*. Connects to cycle 105's *Capabilities are objects, not configurations* — `allowed-tools` could become a structural capability filter, not an advisory configuration.
- The §citations to Pi's `coding-agent/src/core/skills.ts` + `system-prompt.ts` is the *cite-the-reference-implementation* discipline. The design doesn't re-document what Pi already documents; it points to the canonical implementation.

## Library-position context

The endopi-family in the library:

- **Cycle 112** `endopi-skills-markdown-format` (this ingest, Proposed) — first endopi-* design ingest.
- **Queued** `endopi.md` (Reference, 583 lines) — the §parent meta-design.
- **Queued** 8 other endopi-* Proposed designs (edit-tool, extension-package-manifest, iterative-compaction, jsonl-transcript-format, prompt-templates, provider-registry-and-oauth, skills-markdown-format (this), stdio-rpc-bridge).

The endopi-family is *the Pi-and-Endo integration design space*. Pi is `badlogic/pi-mono`'s coding agent; the endopi-* designs bridge Pi's protocols + formats with Endo's capability discipline.

## Rotation discipline

Cycle 112 papers-lane block reached 8 consecutive (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110 / 112). The §rotation discipline continues to extend gracefully into adjacent lanes; this cycle pivoted into endopi-design-lane to diversify the corpus.

## Next

- Cycle 113 (chat-lane → continuing endopi or familiar-design-lane): remaining endopi-* designs (8 Proposed siblings); remaining familiar-* designs (familiar-daemon-bundling Complete; familiar-unified-weblet-server In Progress); broader endo-but-for-bots designs.
- Cycle 114 (papers-lane): consider whether infrastructure is available for a PDF-based ingest.
- Cycle 115 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines); `packages/patterns/src/keys/copyBag.js` (bag-sibling to copySet.js).

ScheduleWakeup 1500s for cycle 113.
