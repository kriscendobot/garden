---
title: §the-named-monitoring-safety-constraint (first-explicit-observation)
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

> "Only repositories whose comments and pull requests are gated against untrusted contributors are safe to monitor; anything else exposes the steward and its subordinates to text that an untrusted actor can write, which is a prompt-injection hazard for any role that reads a daemon tail or follows a `NEW` line to its source."

**§the-named-prompt-injection-as-named-cross-cutting-hazard**: the document explicitly names *prompt injection* as the named risk model. **§the-named-LLM-context-as-named-attack-surface**.

§the-named-allowlist-discipline: "As of 2026-05-13 only `endojs/endo-but-for-bots` meets this bar in the garden's active set". **§the-named-explicit-allowlist**: only-one-repo on the named allowlist; everything else IS disallowed by default.

§the-named-two-surface-monitoring-constraint: §event-level surveillance (daemons reading `NEW` lines) + §content-level surveillance (parent-context @-mention monitor). **§two-named-surveillance-surfaces with the-named-same-safety-constraint applied to both**.

§the-named-explicit-maintainer-authorization-required-for-additions: §the-named-process-for-widening-the-allowlist. **§the-named-defensive-default-with-explicit-opt-in**.
