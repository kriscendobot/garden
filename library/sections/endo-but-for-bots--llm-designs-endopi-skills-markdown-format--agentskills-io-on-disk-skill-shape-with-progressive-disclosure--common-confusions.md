---
title: Common confusions
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

- **"`agentskills.io` is just a website."** It's *the de-facto cross-harness specification*. Pi, Claude Code, and Codex all adopted it; the specification defines the directory layout + frontmatter schema. Endo joining the specification is *joining the cross-harness skill ecosystem*.
- **"Progressive disclosure is just lazy loading."** It's lazy loading *paired with descriptor-in-prompt*. Descriptors are eager (system prompt); bodies are lazy. The trade-off optimizes for *LLM decision quality* — descriptors are short enough to fit but rich enough to discriminate.
- **"Why scan multiple paths? Just pick one."** Cross-harness compatibility. Users with Claude + Pi + Endo skills want all of them available; scanning every harness's path enables that.
- **"Lenient validation lets bad skills load."** It does — *and that's the point*. Foreign skills may not follow every Endo convention. The §rationale: *better to warn and accept than reject and fragment the ecosystem*.
- **"`name` matching the parent dir is rigid."** It's the §filesystem-as-canonical-name discipline. The skill's identity IS the dir name; the frontmatter just *declares* it. Renaming the dir without updating the frontmatter would cause confusion; the validation catches this case.
- **"`allowed-tools` should obviously be a capability grant."** The §design names it as an open question for a reason: *Pi treats it experimentally; in Endo, this could be a structural grant*. The Endo answer requires more design work — what does *capability grant* mean for a skill at the system-prompt level? The open question is *should this be more rigorous in Endo than in Pi?*
- **"The daemon-formula bridge is just registration."** It's *the bridge between the filesystem authoring surface and the daemon's capability granting surface*. A skill on disk becomes a daemon formula; the formula can be `request`-granted to other agents like any other capability. The §discipline: *the same skill is reachable via both surfaces*.
- **"Why does the slash command exist if the LLM should decide?"** The §rationale: *user override*. The LLM might miss a skill that's relevant; the user knows they want it; the slash command bypasses LLM decision-making. The §discipline: *agency-with-user-override*.
- **"Five-phase implementation is over-engineered for a markdown parser."** The §phasing reflects *what's shippable when*. Phase 1 (parser) is useful even without agent integration; Phase 4 (daemon-formula bridge) needs the daemon-side design to be ready. The phasing matches the dependency graph.
- **"The Pi citations are unnecessary — design should be self-contained."** Citing Pi's specific files is *the reference-implementation discipline*. A future Endo implementer can read Pi's `skills.ts` to understand the canonical shape; the design doc doesn't need to re-document what Pi already documents.
