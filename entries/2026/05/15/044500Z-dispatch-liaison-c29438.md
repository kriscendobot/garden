---
ts: 2026-05-15T04:45:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - projects/endo/drafts/README.md
  - entries/2026/05/15/044500Z-dispatch-liaison-f47931.md
---

# Dispatch: designer compares the pi harness to endo, drafts a raft of gap-closing designs

Dispatch root: `dispatches/designer--c29438/`. Project worktree on `endojs/endo-but-for-bots@llm` (current head `68246ad92`).

Maintainer directive (2026-05-15): *"Please dispatch another analyst designer to perform a similar investigation based on the pi harness."* — same shape as the companion opencode dispatch `f47931`, against the *pi harness* target.

## Precedent

Same as the companion dispatch — use `designs/endoclaw.md` on `endojs/endo-but-for-bots@llm` as the comparative-design template. Read it first.

## Target

- **pi harness** — an agent harness for *Pi*. The maintainer's framing is concise: *"similar investigation based on the pi harness"*. The agent is responsible for:
  - Determining which "pi harness" is meant via web search. Candidates worth checking (verify via search; do not assume from training data):
    - Inflection AI's *Pi* and any published harness for it.
    - Anthropic / OpenAI agent harnesses named "pi".
    - Other AI-tooling projects using the *pi harness* phrase.
  - If multiple candidates surface and disambiguation matters, surface the candidates in the result entry and proceed with the strongest match. The maintainer's earlier discussions in this session may also help — search the journal (`journal/entries/`) for prior *pi* references before the web search.
  - Cloning the canonical repo into `external/pi-harness/` in the dispatch root (`mkdir external && git clone <url> external/pi-harness`).

## Endo surfaces to compare against

Same as the companion dispatch:
- `packages/daemon/`, `packages/chat/`, `packages/familiar/`, `packages/cli/`.
- `designs/endoclaw.md` (the template), `designs/README.md` (the roadmap).
- Any prior pi-related design on `llm` if present (grep first).

## Task

Read `garden/roles/COMMON.md` and `garden/roles/designer/AGENT.md` first.

1. **Disambiguate the target.** Grep journal entries for `pi` references first. Then web-search. Land on the strongest match; surface alternatives in the result.

2. **Clone the target** into `external/pi-harness/`. Read top-level README + `package.json` (or equivalent manifest).

3. **Read endo surfaces** per the companion dispatch's task list.

4. **Inventory the pi harness.** For each major feature/surface:
   - Source files implementing it (paths within the cloned repo).
   - Endo equivalent (existing / designed / missing).
   - Missing features: sketch landing in endo (package, formula type, capability implication).
   - Translation-friendly chunks: cite file paths and ranges.

5. **Author the primary comparison doc** at `designs/endopi.md` (or matching slug) on the project worktree. Same structure as `endoclaw.md`.

6. **Spin out sibling designs** when a gap warrants a dedicated implementation cut. Cross-link from primary.

7. **Update `designs/README.md`** per `designs/CLAUDE.md`: summary table, milestone placement, dependency graph.

8. **Per today's self-improvement**: commit + push BEFORE extended local validation.

9. **Open as DRAFT PR** against `llm`. Branch: `design/endopi`. Title: `design: pi-harness comparative analysis + gap-closing raft (endopi)`. Body cites the maintainer's prompt + the endoclaw precedent + per-design summaries.

10. **Preserve drafts in the journal** (`journal/projects/endo/drafts/`) if the dispatch ends before PR open.

## Per-action authorization

Standing on endo-but-for-bots: push to a new `design/endopi` branch, open draft PR. Clone external repos under the dispatch root.

## Out of scope

- No implementation. Design-only.
- No un-draft.
- No comment on PRs.
- No upstream interaction.

## Report

≤ 500 words: target disambiguation outcome (which "pi harness" was studied + alternatives surfaced), PR URL + head SHA, list of design files authored, count of gaps, count of pi-harness source files cited, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
