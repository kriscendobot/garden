---
ts: 2026-05-18T08:27:00Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/18/081740Z-message-builder-dacaa9.md
---

# Dispatch: gardener lands one-line Notes-from-the-field on pre-pr-checklist

Dispatch root: `dispatches/gardener--987edd/`. Garden-only.

Builder `dacaa9` surfaced a single-engagement gotcha at `entries/2026/05/18/081740Z-message-builder-dacaa9.md`: `packages/daemon/scripts/generate-help-text-data.mjs` emits output that is **not** Prettier-formatted, so when `help.md` is edited and the generator is re-run, the resulting `help-text-data.js` diff is misleadingly large (the builder saw +147/−245 before `prettier --write`, +21/−2 after — the latter being the real content delta).

Per today's recurring threshold rule (single-engagement evidence ≠ standing rule, but ≥ Notes-from-the-field tier), land the builder's preferred option (1):

## Task

Read `garden/roles/COMMON.md`, then `garden/skills/pre-pr-checklist/SKILL.md`, then the builder's message verbatim.

1. **Edit `garden/skills/pre-pr-checklist/SKILL.md`** — add a "Notes from the field" entry (or extend an existing § Common churn / generated-files section if one exists) covering:

   > When `packages/daemon/src/help.md` changes, run `node packages/daemon/scripts/generate-help-text-data.mjs` then `yarn run prettier --write packages/daemon/src/help-text-data.js`. The generator emits unformatted output; the unformatted diff is misleadingly large (the builder saw +147/−245 vs the real +21/−2 content delta).

   Cite `entries/2026/05/18/081740Z-message-builder-dacaa9.md` as provenance.

2. **Do NOT modify the generator script itself** — the builder noted option (2) (piping through Prettier) as more durable but heavier lift; defer to a separate engagement.

3. **Frontmatter**: bump `updated`; add `liaison, gardener` to `author` if not already there.

4. **Write the result entry** at `journal/entries/2026/05/18/<ts>-result-gardener-987edd.md`: one file edited, one-line `Self-improvement: ...`.

5. **Commit + push both branches.**

## Per-action authorization

Standing on garden's main + journal per CLAUDE.md § Conventions.

## Out of scope

- No code on any project repo.
- No modification of the generator script.
- No promotion to a standing rule (single-engagement evidence per threshold).

## Report

≤ 150 words: file path edited, one-line `Self-improvement: ...`.
