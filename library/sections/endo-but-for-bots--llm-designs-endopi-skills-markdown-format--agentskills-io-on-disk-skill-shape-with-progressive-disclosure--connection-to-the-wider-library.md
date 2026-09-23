---
title: Connection to the wider library
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

This section is the **canonical *adopt-the-standard-with-progressive-disclosure* worked example**. Five threads:

1. **The cross-harness-standardization argument** — *adopt the existing standard rather than fragment*. When multiple peer projects converge on a format, joining preserves the ecosystem's interop. Reusable for any *de-facto-standard-adoption* situation.

2. **The progressive-disclosure context-budget pattern** — descriptors in the system prompt + bodies on demand. Bounds context cost regardless of skill count. Reusable for any *many-options-bounded-context* situation.

3. **The authoring-surface-vs-granting-surface split** — on-disk shape (filesystem editing) + EndoDirectory shape (daemon capability grants). The §guest-module bridge between them.

4. **The lenient-validation discipline** — *warn on violations, but remain lenient so foreign skills load*. The §rationale: standard-adoption requires accepting foreign-skills that may not follow every Endo convention.

5. **The named-three-open-questions** discipline — honestly enumerate the unresolved decisions. The §`allowed-tools` → capability grant question is a worked example of *standard-borrowing-with-Endo-specific-rigor* (Pi treats it experimentally; Endo could make it structural).

The §endopi-family-context: this is the *first endopi-* ingest in the library. Future cycles can ingest sibling designs (endopi.md meta-design at 583 lines; endopi-extension-package-manifest; endopi-iterative-compaction; endopi-jsonl-transcript-format; endopi-provider-registry-and-oauth; endopi-stdio-rpc-bridge; endopi-prompt-templates; endopi-edit-tool — all Proposed).

The §cycle 105/107 daemon-agent-capability layer connection: skills are *another shape of capability* (invokable instruction-bundle rather than function-call surface). The `allowed-tools` open question is asking whether to *make skills structurally capability-confined* like cycle 107's Dir/Shell/Git capabilities.
