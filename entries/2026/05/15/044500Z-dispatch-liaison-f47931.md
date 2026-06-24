---
ts: 2026-05-15T04:45:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - projects/endo/drafts/README.md
---

# Dispatch: designer compares opencode to endo, drafts a raft of gap-closing designs

Dispatch root: `dispatches/designer--f47931/`. Project worktree on `endojs/endo-but-for-bots@llm` (current head `68246ad92`).

Maintainer directive (2026-05-15): *"Please dispatch an analyst and designer to clone the opencode tool and compare and contrast it to endo familiar with the daemon and its designed features, to identify gaps or contrasting approaches, isolating chunks of code that might translate well to close feature gaps between these projects. This should result in a design for a raft of missing features citing sources that might be applicable. We have noted that opencode has a good interface and can work well with openrouter, but lacks concurrent subagent execution, which would fall out of endo more trivially. However, a space that is more like opencode UX might be helpful. This is a similar engagement to our earlier analysis of openclaw, which produced a similar bank of design documents."*

## Precedent

The earlier *openclaw* engagement landed `designs/endoclaw.md` on `endojs/endo-but-for-bots@llm` — a comparative design that maps openclaw features one-by-one to endo, calls out the capability-model contrast (openclaw = ambient authority; endo = ocap), and inventories gaps. Use this shape as the template. Read it first as a model:

- `designs/endoclaw.md` on the project worktree (`llm` branch).

Locate the file on the worktree; read it end to end.

## Targets

- **opencode** — open-source AI agent CLI. The maintainer notes:
  - Good interface / UX.
  - Works well with OpenRouter.
  - **Lacks** concurrent subagent execution (which would fall out of Endo more trivially given its formula isolation + capability model).
  - A space "more like opencode UX" might be helpful in Endo.

The agent is responsible for locating the canonical opencode repository via web search (likely a `github.com/<org>/opencode` repository), cloning it into the dispatch root's `external/` subdirectory (`mkdir external && git clone <url> external/opencode`), and studying it. Do not hard-code a URL based on training data; verify via search.

## Endo surfaces to compare against

- `packages/daemon/` — the core daemon: formula graphs, formulation, host/guest model, deferred tasks.
- `packages/chat/` — the existing chat UI.
- `packages/familiar/` — the Electron shell.
- `packages/cli/` — the `endo` command.
- The roadmap on `endo-but-for-bots@llm`: `designs/README.md` (summary table, dependency graph, milestones), and individual design docs especially:
  - `designs/endoclaw.md` (the model)
  - `designs/inflection-pi-comparison.md` or similar if a previous Pi-related design exists (search for it).
  - Any design that touches messaging, agent isolation, or LLM-router integration.

## Task

Read `garden/roles/COMMON.md` and `garden/roles/designer/AGENT.md` first.

1. **Clone the target.** Locate the canonical opencode repository (web search; pick the most-starred / actively maintained one whose feature set matches the maintainer's framing). Clone into `external/opencode/` in the dispatch root. Verify by reading its top-level README and `package.json`.

2. **Read endo surfaces.** Walk `designs/endoclaw.md` end to end as the template. Walk `designs/README.md` for the roadmap shape. Walk `packages/daemon/` enough to understand the formula model and agent isolation. Walk `packages/chat/` for the existing UX.

3. **Inventory opencode.** For each major opencode feature/surface, identify:
   - The opencode source files implementing it (file paths within the cloned repo).
   - The endo equivalent (existing / designed / missing).
   - **For missing features**: a sketch of how it would land in endo (which package, which formula type, which capability model implication).
   - **For features that translate well**: which chunks of opencode's source might inspire or be adapted (citing file paths and line ranges).

4. **Author the primary comparison doc** at `designs/endopen.md` (or similar slug; pick one consistent with the `endoclaw` precedent) on the project worktree. Structure mirroring `endoclaw.md`:
   - Metadata table (Created, Author = "(prompted)", Status = Not Started).
   - Background: what opencode is, where it lives, license, current state.
   - Architecture Comparison table.
   - Feature-by-feature mapping table.
   - Sections elaborating each major gap (concurrent subagent execution called out specifically; openrouter integration; the UX surface).
   - Sections elaborating each major contrast (capability model, persistence, extensibility, security).
   - Citation index of opencode source files referenced.
   - The maintainer's prompt at the end under `## Prompt`.

5. **Spin out a sibling design** for each gap that would warrant a dedicated implementation cut. The maintainer asked for "a raft" — so when the gap is substantive (e.g., the opencode-like UX surface; the openrouter integration), draft a separate `designs/<slug>.md`. Cross-link from the primary doc.

6. **Update `designs/README.md`** per the project's convention (`designs/CLAUDE.md`): add row(s) to the summary table, place into a milestone, add to the dependency graph if there are dependencies. The companion drafts are READ-NOT-LANDED if uncertainty exists; the primary doc is the load-bearing deliverable.

7. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

8. **Open as DRAFT PR** against `llm`. Branch: `design/endopen` (or matching slug). Title: `design: opencode comparative analysis + gap-closing raft (endopen)`. Body cites the maintainer's prompt + the endoclaw precedent + per-design summaries.

## Preserving drafts in the journal

If the dispatch's session ends before the PR opens (today's recurring failure mode), copy the comparative doc + any spin-out designs into `journal/projects/endo/drafts/` so the work survives the dispatch teardown — match the shape of the existing drafts there (`exo-import.md`, `exo-npm-registry.md`, `ses-top-level-await.md`, `ses-import-attributes.md`).

## Per-action authorization

Standing on endo-but-for-bots: push to a new `design/endopen` branch, open draft PR. Clone external repos under the dispatch root. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation of any of the designs. This is design-only.
- No un-draft. Maintainer reviews the bank.
- No comment on PRs.
- No upstream interaction.

## Report

≤ 500 words: PR URL + head SHA, list of design files authored (one-line each, primary first, spin-outs after), count of gaps identified, count of opencode source files cited, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
