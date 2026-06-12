---
ts: 2026-06-12T05:29:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--8a9446
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/052621Z-result-builder-4ef77c.md
---

# dispatch: cleaner — stage 1 of #438 gamut (tsgo migration)

Continuing the gamut on the freshly-opened tsgo migration PR
#438 per the standard chain.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`
  ("chore(types): switch lint:types to tsgo for the dev loop"),
  DRAFT, base `master-4a04d07`, head `chore/tsgo-lint-types`
  at `4dc641a27...`. Builder 91fa4a's 7-commit ladder landed.
- **Two material design departures** surfaced by builder
  (documented in PR body with 3 routing options each):
  1. tsgo strict-mode causes 39/49 packages to fail (JSDoc
     gaps cascading from `packages/harden/make-hardener.js:155`).
  2. tsgo crashes on unified `typecheck-all` (upstream
     Go-runtime panic in tsgo's relater on
     `7.0.0-dev.20260611.2`).

## Task

In your `project/` worktree at `4dc641a27` (FETCH if
needed):

1. **Read** `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md`.
2. **Run `pre-push-gates`** in the project worktree. Address
   probe failures introduced by builder commits (do NOT
   address pre-existing).
3. **Audit the PR body** against pr-formation.
4. **Audit the diff** against modern hygiene skills:
   - changeset (probably N/A since this is a build-tooling
     change, no public-API delta)
   - em-dash, no-latin-shorthand, relative-paths,
     test-title-spec-spelling, rename-discipline (the
     49-package sweep should be uniform).
5. **No rebase** — PR is fresh on current frozen base.
6. **Commit hygiene fixes** one category per commit.
7. **Push** (append push only).
8. **Post a top-level summary comment** on PR #438 ending
   with: "Next stage: barrister panel."

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `chore/tsgo-lint-types` (append push
  only).
- **Edit the PR body** via `gh pr edit` for structural
  rewrites.
- **Top-level summary comment** on PR #438. Standing.

## Out of scope

- Do NOT address the two design departures (those are the
  panel's call; builder routed them).
- Do NOT touch source beyond hygiene fixups.
- Do NOT request review or un-draft.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post head SHAs.
- The hygiene-pass commits.
- PR-body edits.
- Per-skill audit results.
- pre-push-gates resolution.
- The top-level summary comment URL.
- **Recommended next stage**: barrister panel (note that
  the panel will weigh the two design departures).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next stage and tears down your
dispatch root on return.
