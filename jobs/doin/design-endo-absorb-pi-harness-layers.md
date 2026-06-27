# Design: should Endo's agent harness absorb layers of the Pi agent harness? (consolidation path)

Map: **design** → dispatch a designer (researcher-precedence first). Target repo:
`endojs/endo-but-for-bots`. Deliverable is a DESIGN DOC under `designs/`. Design only —
no implementation. Fork-scope; no upstream interaction.

## The question (maintainer)
Investigate whether it makes sense for **Endo's agent harness** to **absorb some layers
of the Pi agent harness**, and propose a path that **reduces the duplication and
coordination between these layers**.

## Start from the existing comparative analysis (do NOT redo it)
`designs/endopi.md` ("EndoPi: Comparative Analysis with the Pi Agent Harness", Reference
status, Kris-authored, extended per jcorbin's review on PR #265) already maps Endo's
agent surfaces against Pi. Build ON it; this job turns that comparison into an
absorb-or-coordinate RECOMMENDATION + a path.

## The two harnesses and their layers (the designer must map these precisely)
- **Pi agent harness:** the canonical pi `coding-agent` CLI, built on
  `@mariozechner/pi-agent-core` and `@mariozechner/pi-ai` (provider registry, agent
  loop, tool protocol, transcript/skills/prompt formats).
- **Endo's agent surfaces:**
  - `packages/lal` (agent-loop surface) and `packages/fae` (tool surface) — Endo-native,
    predate the Pi analysis.
  - `packages/genie` — already **embeds Pi inside Endo**: ships `pi-agent-core` +
    `pi-ai` as runtime deps, adds the ollama provider adaptor missing from pi-ai's
    registry, and layers Claw-like heartbeat / observer / reflector subagents on top.
  - The `packages/daemon` CapTP/object-capability agent system (the
    `designs/daemon-agent-*`, `endo-agent-tools`, `agent-tools-mount-fs-tools`,
    `agentry-agent-builder`, `familiar-*` cluster).
  - The endopi-* format/tool cluster: `designs/endopi-edit-tool.md`,
    `endopi-jsonl-transcript-format.md`, `endopi-prompt-templates.md`,
    `endopi-skills-markdown-format.md`.

## Deliverable — a design doc that:
1. **Layer map.** Decompose each harness into layers (provider/model adaptor; agent
   loop / turn driver; tool definition + dispatch protocol; transcript/JSONL format;
   skills + prompt-template format; sandbox/filesystem mount; subagent orchestration —
   heartbeat/observer/reflector). Put Endo's layers (lal / fae / genie / daemon) and
   Pi's layers side by side.
2. **Duplication + coordination cost.** Identify where the layers overlap or are
   maintained twice (e.g. genie depending on pi-agent-core/pi-ai while lal/fae provide
   an overlapping agent-loop/tool surface), and where the two harnesses must be kept in
   lockstep (the coordination seams — format compatibility, provider registry, tool
   protocol versioning, the ollama adaptor genie adds outside pi-ai).
3. **Absorb-or-coordinate recommendation, per layer.** For each layer, recommend one of:
   ABSORB (Endo internalizes / reimplements / vendors the Pi layer so the dependency and
   the dual surface collapse), KEEP DEPENDING (Pi stays the upstream; Endo adapts), or
   UNIFY (a shared seam both build on). Justify against maintenance cost, capability fit
   (CapTP/locators/petnames are Endo-specific and Pi has no analog), and upgrade risk of
   tracking `@mariozechner/*` releases.
4. **Consolidation path.** A concrete, staged path that reduces duplication and the
   coordination burden — what genie/lal/fae become, what (if anything) gets folded into
   the daemon agent system, and how transcript/skills/prompt formats converge. Phase it
   so each step is independently landable on the fork.
5. **Risks + open questions** for the maintainer (e.g. losing Pi upstream improvements
   by absorbing; whether the absorbed layers should remain API-compatible with pi-* for
   interop; sandbox-driver coupling noted in endopi.md's third pass).

## Constraints
- Design doc lives under `designs/` on `endojs/endo-but-for-bots`; cross-link
  `endopi.md` and the daemon-agent / endopi-* clusters. Reference PR #265's review
  thread for prior reviewer context (jcorbin).
- Design only — no package moves or code changes in this job.

---
claim:
  host: endolinbot
  gardener: 58
  claimed_at: 2026-06-27T16:46:06Z
