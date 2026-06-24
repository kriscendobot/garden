---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: pre-pr-checklist

The pre-PR gate. Run before every push to a PR branch (initial create or follow-up), and again before any `gh pr edit --body` rewrite. Run as a step of the gardening state machine (`scripts/jobs/gardening/garden-pr.sh`, design: [`designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)); the deterministic subset of it is the [pre-push-gates](../pre-push-gates/SKILL.md) script, which the gate invokes mechanically.

## The minimum

For a JavaScript / monorepo / yarn project (the canonical case): adapt the command names to the consuming project.

- `npx corepack yarn format` (or `yarn format`): Prettier drift is the single most common review nit.
- `npx corepack yarn lint` for the packages you changed: catches ESLint-only rules.
- `npx corepack yarn docs` (or `tsc --build`): catches missing members on exported interfaces, type drift, broken type-import specifiers.
- `cd packages/<name> && npx ava` (or the project's test command): at least the tests nearest the change.
- Decide whether to add a changeset entry per project convention.

The deterministic, auto-fixable, and probe-able items above are run by the [pre-push-gates](../pre-push-gates/SKILL.md) script; this checklist is the broader human-facing review-yourself list around it.

## PR body template

When `gh pr create` opens a new PR, populate the body from `.github/PULL_REQUEST_TEMPLATE.md` in the base repo. Read the template at the head of the base branch and fill the section headings rather than inventing structure. Delete the guidance lines (the prompted prose under each heading) before submitting.

```sh
gh api "repos/<owner>/<repo>/contents/.github/PULL_REQUEST_TEMPLATE.md?ref=<base>" \
  --jq '.content' | base64 -d > /tmp/pr-body.md
# edit /tmp/pr-body.md to fill in the sections
gh pr create --base <base> --head <head> --body-file /tmp/pr-body.md --title '...'
```

The same template applies to body rewrites (`gh pr edit <N> --body-file ...`), not just initial creation. A PR that grew in scope should be reset to the template structure rather than appended to. The discipline of *what to write inside the sections* lives in [pr-formation](../pr-formation/SKILL.md).

**Do not line-wrap paragraphs in the PR body.** GitHub renders single newlines as `<br>`-style breaks rather than paragraph continuations. Each paragraph is a single physical line; let the browser wrap. Lists and headings still get their own lines. This is a deliberate exception to the project's prose markdown line-wrap convention.

## No methodology leak

The PR body describes the change, not the methodology. Do not mention this checklist, the template-fill workflow, the gardening state machine, the job board, or any internal agent role in the body or title. A reviewer should read the PR and learn what changed and why; how an agent assembled it is irrelevant.

The most pernicious leak is a literal `skills/<file>.md` or `roles/<file>.md` path citation in the body. These expose the garden's internal layout to every reader of the public PR. Cite the substance of the discipline (e.g. "Reverting the fix causes the new assertions to fail closed, confirming they are load-bearing"), not the file documenting the discipline.

## Lockfile rule

If the change adds or updates a dependency, commit `yarn.lock` in its own commit per [yarn-lock-separate-commit].

## Pitfalls

- **Plain `yarn` may not be on PATH** inside a fresh worktree; use `npx corepack yarn`.
- **Workspace-scoped commands** need `npx corepack yarn workspace <name> exec <cmd>` or `npx corepack yarn workspaces foreach -A run lint`.
- **Underscore-prefixed unused identifiers** clash with `no-underscore-dangle`. Use `// eslint-disable-next-line no-unused-vars` instead, or delete.
- **`/** @type {T} */`** binds to the next declaration, not the enclosing block. Keep the tag adjacent during refactors.

## Notes from the field

- _2026-05-13_: adopted from the reference. Project-specific lore (Yarn 4 specifics, the `@endo/internal` ESLint config, daemon test timeouts) was kept light. Subsume into a project-specific journal entry tagged with the project slug if a particular project's checklist drifts from the generic form.
- _2026-05-18_ (endo-but-for-bots, `packages/daemon`): when `packages/daemon/src/help.md` changes, run `node packages/daemon/scripts/generate-help-text-data.mjs` and then `yarn run prettier --write packages/daemon/src/help-text-data.js`. The generator emits unformatted output, so the unformatted diff is misleadingly large (a +147 / -245 vs. the real +21 / -2 content delta nearly led to a revert because it looked broken).
- _2026-06-24_: migrated from v1. Dropped the steward-dispatch framing: this checklist is a gardening-script step, and its deterministic subset runs as the [pre-push-gates](../pre-push-gates/SKILL.md) script. The conductor and other v1 role names were removed from the methodology-leak list (the principle stands: no internal artifact in the PR body).
