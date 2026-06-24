---
ts: 2026-05-14T02:59:35Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: builder investigates Prettier rule for underscore-delimited thousands

Dispatch root: `dispatches/builder--prettier-underscore-thousands--20260514-025935--9d6a2e/`. Project worktree at `endojs/endo-but-for-bots@llm`.

Maintainer feedback (this session): "We should prefer to delimit groups of thousands with underscores (and presumably groups of four in hexadecimal). It should be possible to enforce this with a Prettier rule."

## Per-action authorization

Standing on endo-but-for-bots.

## Task

1. **Investigate Prettier's options for enforcing underscored-thousands**:
   - Prettier core: does any built-in option control numeric-literal formatting? `printWidth`, `singleQuote`, etc. don't fit; check the full options list.
   - Prettier plugins: search npm for `prettier-plugin-*number*`, `prettier-plugin-numeric`, `prettier-plugin-underscored-thousands`, etc.
   - Custom plugin: if no off-the-shelf plugin exists, sketch the shape of a custom one (Prettier's plugin API for visitor patterns + the JavaScript AST node types for numeric literals).
   - ESLint alternative: `eslint-plugin-unicorn`'s `numeric-separators-style` rule enforces underscores at configurable groupings; it's well-maintained and may be the right tool even if Prettier is the maintainer's preferred surface.

2. **Choose a path**:
   - If a maintained Prettier plugin exists, use it. Document the install + config.
   - If only the ESLint rule fits, surface that as the recommendation and ask the maintainer whether ESLint is acceptable.
   - If a custom Prettier plugin is the only Prettier-shaped path, sketch it and report; do NOT author a custom plugin in this dispatch (that's its own engagement).

3. **Issue a PR on endo-but-for-bots@llm** with whichever shape you settle on:
   - The config addition (`.prettierrc`, `.eslintrc.cjs`, etc.).
   - A repo-wide migration if the rule has an autofix mode (a single mechanical commit per the migration step).
   - Test coverage / verification that the rule fires correctly.
   - PR body: cites the maintainer's directive; describes the investigation outcome (which tool/plugin chosen and why); names the gotchas (does Prettier or ESLint format `1000` → `1_000` even inside comments / regexp char classes / string literals? — call out negatives).

4. **Apply the rule to the codebase** if its autofix is reliable. Otherwise, document the rule and leave the migration to a follow-up dispatch.

## Out of scope

- Do NOT modify the syrup-frame or cbor-frame packages (sister fixer dispatches will manually apply underscored thousands within their PRs).
- Do NOT touch CI workflows beyond adding the lint-rule check, if relevant.
- Do NOT add per-package overrides without strong rationale.

## Identity + flow

Identity kriscendobot. Per pr-creation-flow: open in **draft**. Topic branch `chore/prettier-underscore-thousands` (or similar). Push to endo-but-for-bots. Per pr-formation: use the repo's PR template; no checklists; explain the *behavior* not the *diff*.

## Report

PR URL, the tool/plugin chosen (Prettier core / Prettier plugin name / ESLint plugin name / custom), the config diff (one-paragraph description), whether autofix was applied repo-wide or deferred, gotchas surfaced, one-line verdict: "is the maintainer's preference for underscored thousands enforceable by tooling without ongoing friction?"
