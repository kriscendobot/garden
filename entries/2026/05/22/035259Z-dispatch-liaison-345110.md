---
ts: 2026-05-22T03:52:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
---

# Dispatch: builder extends Prettier configuration to format Markdown files (based on llm)

Dispatch root: `dispatches/builder--345110/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-22): *"Please dispatch a builder to extend the Prettier configuration to run on Markdown files, based on the llm branch."*

Base is **llm** per the maintainer's explicit directive (overrides the standard "implementations branch off master" norm). This is appropriate because llm carries the active design-document corpus (`designs/*.md`) — landing the Markdown format on llm formats the design docs in the same commit and lets the maintainer review the format pass against the design content in one place. A later boatman ferry can carry the config + Markdown-format pass back to master.

## Pre-flight

The project carries a "Markdown Style Guide" convention per `project/CLAUDE.md` § Markdown Style:

- Wrap lines at 80 to 100 columns.
- **Start each sentence on a new line so that diffs are per-sentence.**
- See `CONTRIBUTING.md` § "Markdown Style Guide" for full details.

That sentence-per-line discipline is the load-bearing convention. **Prettier's default for Markdown is `proseWrap: "preserve"`**, which leaves existing line breaks alone — so a sentence-per-line file stays sentence-per-line. The new Prettier config for Markdown should keep `proseWrap: "preserve"` so the project's discipline survives the format pass. Auto-reflowing to a column width (`"always"` / `"never"`) would clobber the sentence-per-line guide and is the wrong choice unless the maintainer overrules the existing convention.

The pre-push-gates skill carries a `sentence-per-line-md` probe (per `garden/skills/pre-push-gates/SKILL.md`); the goal is for the new Prettier markdown pass to *not* fight that probe. After the format pass, the probe's findings should be unchanged (or strictly improved) — not regressed.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/pr-formation/SKILL.md`, `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/yarn-lock-separate-commit/SKILL.md`.
3. Read `project/CLAUDE.md` § Markdown Style and `project/CONTRIBUTING.md` § "Markdown Style Guide" (if it exists) for the binding conventions.
4. **Inventory the existing Prettier surface.**
   - The root `.prettierrc` / `.prettierrc.json` / `.prettierrc.cjs` / `prettier` field in `package.json` — wherever the config lives.
   - The root `.prettierignore` — does it exclude `*.md` today?
   - The per-package overrides, if any (some packages may carry their own `.prettierrc`).
   - The root `package.json` scripts: `yarn format`, `yarn lint:format`, and any other Prettier entry points. What file globs do they target today?
   - The project's `@endo/eslint-config` ESLint plugin: does it pull `eslint-plugin-prettier` over `*.md` today?
5. **Make the minimal extension.** Add Markdown to the Prettier surface so `yarn format` formats `*.md` files:
   - **Glob.** Update the `yarn format` script (or whatever wraps Prettier at the root) to include `**/*.md`. If the script today is `prettier --write '**/*.{js,ts,…}'`, add `,md` to the brace expansion (or factor into a `.prettier.config.js` that uses Prettier's discovery). Mirror the change in `yarn lint:format` (the check-only equivalent).
   - **Config.** Add a Markdown override in the Prettier config preserving sentence-per-line: `overrides: [{ files: ['*.md', '*.markdown'], options: { proseWrap: 'preserve', tabWidth: 2, printWidth: 80 } }]`. The `proseWrap: 'preserve'` is non-negotiable per the *Pre-flight* analysis above. (If the existing root Prettier config already sets `proseWrap: 'preserve'` globally, no override is needed.)
   - **Ignore.** Remove any `*.md` exclusion from `.prettierignore`. Keep targeted excludes for vendored markdown (e.g., `LICENSE.md` fixtures inside test-data dirs, generated `CHANGELOG.md` blocks) only when they exist today and are genuinely off-limits.
6. **Run the format pass.** After the config change, run `yarn format` (or whichever script you wired). The diff is expected to be large — Prettier will normalize trailing whitespace, list-marker style, code-fence languages, and bold/italic markers across the entire markdown corpus. Inspect the diff before staging.
7. **Verify discipline survives the format pass.**
   - The `sentence-per-line-md` probe in pre-push-gates should report **no new findings** after the format pass. Spot-check 3-5 representative files (`README.md`, a `designs/*.md`, a `packages/<pkg>/README.md`) to confirm sentence boundaries are preserved.
   - The line-width discipline (80-100 cols) interacts subtly with `proseWrap: 'preserve'` — Prettier will leave lines that already exceed `printWidth` alone in `preserve` mode. Spot-check that the wrap-discipline section in `CONTRIBUTING.md` is not contradicted.
   - If the format pass produces a sentence-per-line regression (a multi-sentence line that wasn't broken before), **stop, surface the case, and adjust the config** rather than committing the regression.
8. **Commit shape.**
   - Commit 1: `chore(prettier): extend format to *.md` — the config + script change. Small, reviewable.
   - Commit 2: `chore(prettier): format all *.md files` — the format pass diff. Pure mechanical, no manual edits.
   - **Separate** `chore: Update yarn.lock` only if a dependency was added or version-bumped (unlikely for this change; Prettier already covers Markdown out of the box, no plugin needed).
   - One changeset entry only if the change is observable downstream (it isn't — this is repo-internal tooling, not a published package change).
9. **Local validation.**
   - `yarn format` — should produce no diff on a clean tree after the format-pass commit lands.
   - `yarn lint:format` (or whatever the check-only equivalent is named) — should pass.
   - `yarn lint` (the project-wide ESLint pass) — should pass.
   - `yarn docs` — should pass; spot-check that the link rendering in 2-3 design docs is unchanged.
   - Pre-push-gates: `garden/skills/pre-push-gates/<script>` — the `sentence-per-line-md` probe is the load-bearing one; the `em-dash-style` and `relative-paths` probes are advisory. Auto-fix sweeps from the gate on out-of-scope files should be reverted before commit per the established pattern.
10. Push to `endojs/endo-but-for-bots:chore/prettier-markdown` on llm.
11. Open **DRAFT** PR on `endojs/endo-but-for-bots` against `llm`. Title: `chore(prettier): extend format to *.md files`. Body covers:
    - Why on llm (design-doc corpus + later ferry).
    - The two-commit shape.
    - The `proseWrap: 'preserve'` decision with rationale (sentence-per-line discipline survival).
    - A note on the expected diff size of commit 2.
    - Any per-package or per-file carve-outs you had to add (and why).

## Per-action authorization

- Push to `endojs/endo-but-for-bots:chore/prettier-markdown`.
- Open draft PR on `endojs/endo-but-for-bots` against `llm`.
- READ-ONLY on `endojs/endo`. No comments outside the new PR's own body.

## Out of scope

- No edits to source code (`packages/*/src/`) — config + scripts + the mechanical format-pass diff only.
- No rewrite of `CONTRIBUTING.md` § Markdown Style Guide — the style guide is the source of truth; the Prettier config conforms to it, not the other way around. If you find an irreconcilable tension between Prettier's defaults and the style guide, **surface it** rather than rewriting the guide.
- No changes to ESLint config except as strictly required to let Prettier own Markdown formatting (e.g., disabling an existing `eslint-plugin-md` rule that would fight Prettier).
- No upstream ferry. No un-draft (contractor's PR-creation-flow scan handles the gauntlet).

## Report

≤ 400 words. PR URL + head SHA. The config file(s) edited and the diff shape (add `*.md` to the `yarn format` glob; the Markdown override block in Prettier config; ignore-file changes). The total file count and line-delta of commit 2 (the format pass). Any sentence-per-line regressions found and how resolved. Pre-push-gates probe status (especially `sentence-per-line-md`). Local validation per command. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-345110.md` and push journal (rebase if non-fast-forward).
