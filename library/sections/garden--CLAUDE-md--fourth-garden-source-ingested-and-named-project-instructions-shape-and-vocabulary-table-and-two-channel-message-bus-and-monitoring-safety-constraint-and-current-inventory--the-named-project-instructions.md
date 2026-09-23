---
title: §the-named-project-instructions-shape (first-explicit-observation)
section-slug: garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory
source-slug: garden--CLAUDE-md
url: https://github.com/kriskowal/garden/blob/main/CLAUDE.md
authors: [Endo project (collective; the garden's named-role-as-author convention; current-frontmatter authors = gardener + liaison + builder)]
status: (no explicit metadata table; YAML frontmatter declares created/updated/author)
ingest-cycle: 299
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 146
parent: garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory
---

The file IS named `CLAUDE.md` (not AGENT.md or SKILL.md). **§the-named-Claude-Code-auto-load-convention**: Claude Code auto-loads `CLAUDE.md` files into the agent's context; that's *exactly* what the garden wants at the root (liaison gets the project instructions) but NOT what it wants for roles/skills (subagents should load those explicitly).

The file's own line 26 names this: *"Files are named `AGENT.md` / `SKILL.md` / `COMMON.md` (not `CLAUDE.md`) on purpose: we do **not** want Claude Code to auto-load them into a subagent's context."* **§the-named-naming-convention-IS-the-named-discipline-against-auto-load**.

§the-named-discriminating-via-filename: which files get auto-loaded by Claude Code vs which get loaded explicitly IS named *by the filename extension* (`CLAUDE.md` auto + `AGENT.md` explicit).
