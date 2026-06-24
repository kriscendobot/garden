---
source: designs/endopi-prompt-templates.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f4a9dc6d13234bc5a8b6c8642b3082d5d8a488d8
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  **Ninth and final endopi-* design ingest** (after cycles 112 +
  117 + 121 + 122 + 124 + 126 + 128 + 129). With this cycle, the
  endopi-* family is **9/9 complete** at 19 cycles (112 → 131).
  104-line *Proposed* design (Parent: endopi.md) closes the
  §Prompt templates gap from cycle 121's family keystone —
  *self-contained, low-risk feature; useful before larger
  workflow features land*. The smallest endopi-* design in the
  family (cycle 121: 583 / 119: 526 / 116: 435 / 107: 350 /
  103: 331 / this cycle: 104).

  Single most structurally interesting move: the §editor-
  expansion-not-agent-invocation distinction. *Selecting one
  expands the template body into the editor; the agent loop does
  not run until the user presses Enter. This matches Pi's UX: a
  template is editor expansion, not agent invocation*. The
  *template-is-text-not-trigger* discipline locks in cycle 129's
  per-kind-confinement table: prompts are *pure text expansion.
  No capability surface at all*.

  §Mustache-style `{{name}}` variables. Two argument-passing
  mechanisms: form-field prompts (variable-prompt UI surfaces
  when invoked with no arguments; reuses cycle 116's
  daemon-form-request form-rendering surface from
  lal-fae-form-provisioning) OR bash-style positional arguments
  on the slash command line. §Two-modes-for-one-knob — same
  template works in both modes.

  §Shared-discovery-walker discipline — same walker as cycle
  112's skills-format scans a parallel set of paths for `*.md`
  files. Two canonical-name paths (`.pi/` for Pi, `.agents/` for
  cross-harness) × two scopes (global at `~/`, project at
  `cwd/`). Walk-up-from-cwd lets a project override global
  templates. *One-walker-many-resource-kinds* substrate-reuse
  discipline visible across cycles 112 + 129 + this cycle.

  §Composition — *template body can reference a skill ("then use
  `/skill:gh-cli`"). The agent loop processes the skill reference
  on submit, the same way it processes any slash command in a
  user message*. The *natural-composition-via-text-not-API*
  observation: there's no template-to-skill programmatic
  invocation; both are text routed through the same agent-loop
  dispatch on submit.

  §Three-phase implementation: (1) loader + discovery; (2)
  slash-command registration; (3) variable substitution + form
  UI for missing variables. *Minimal-then-add-features* shape;
  each phase ships independently.

  Two §Out of scope decisions: (a) template execution as agent
  prompts (templates expand the user's editor; they do not run
  autonomously; *autonomous prompts are endoclaw's
  proactive-messages territory* — the §editor-expansion-not-
  agent-invocation discipline restated); (b) variable types
  beyond strings (*Pi keeps variables as plain string
  substitution; Endo follows* — the §follow-Pi-for-simplicity
  discipline).

  Two file-level Pi citations: `coding-agent/docs/prompt-
  templates.md` + `coding-agent/src/core/prompt-templates.ts`.

  Cycle 131 was nominally papers-lane (cycle 130 was comments).
  Papers-lane has been blocked for 25+ consecutive cycles.
  Cycle 131 pivoted to designs-lane.

  **Family arc closure**: 19 cycles across 9 endopi-* designs
  with one keystone (cycle 121) + eight spinouts (cycles 112,
  117, 122, 124, 126, 128, 129, 131). Each ingest traced back to
  the keystone and built on the prior ingest's vocabulary.
---

> Abstract: `endopi-prompt-templates.md` (104 lines, *Proposed*
> status; Parent: endopi.md) is the **ninth and final endopi-*
> design**. The endopi-* family is now **9/9 complete**. Closes
> the §Prompt templates gap from cycle 121's keystone —
> *self-contained, low-risk feature; useful before larger workflow
> features land*.
>
> **Single most structurally interesting move**: the §editor-
> expansion-not-agent-invocation distinction. *Templates expand
> the user's editor; they do not run autonomously*. Selecting a
> template *expands the template body into the editor; the agent
> loop does not run until the user presses Enter*. The
> *template-is-text-not-trigger* discipline.
>
> §Mustache-style `{{name}}` variables. Form-field prompts (via
> cycle 116's lal-fae-form-provisioning UI) when invoked without
> arguments OR bash-style positional arguments inline. §Shared-
> discovery-walker discipline — same walker as cycle 112's skills
> scans parallel paths. §Composition: template body can reference
> a skill via text (`/skill:gh-cli`) — the agent loop processes
> it on submit; natural-composition-via-text-not-API.
>
> §Smallest endopi-* design (104 lines). Two §Out of scope
> decisions (no autonomous execution; no variable types beyond
> strings — *Pi keeps variables as plain string substitution;
> Endo follows*).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker](../sections/endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker.md) | agent-conventions | current |

Tight 104-line design — the smallest endopi-* design in the
family. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@f4a9dc6d`
  (the branch `origin/llm`) via the local bare-clone. Same
  commit as cycles 122 (`endopi-edit-tool`), 126
  (`endopi-stdio-rpc-bridge`), 129
  (`endopi-extension-package-manifest`).
- Last touched 2026-05-15 by endolinbot in commit `f4a9dc6d`.
- Status: *Proposed*. Parent: `endopi.md` (cycle 121's family
  keystone).
- **Twenty-seventh-comment-style design ingest.** With this
  ingest, the endopi-* family is **9/9 complete**:
  cycles 112 + 117 + 121 (keystone) + 122 + 124 + 126 + 128 +
  129 (unifier) + 131 (this cycle).
- Cycle 131 was nominally **papers-lane** (cycle 130 was
  comments). Papers-lane has been blocked for **25+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 131
  pivoted to designs-lane to close out the family.
- Cohesion-honest one-section count.
