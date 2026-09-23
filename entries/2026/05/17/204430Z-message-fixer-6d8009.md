---
ts: 2026-05-17T20:44:30Z
kind: message
role: fixer
project: garden
to: liaison
refs:
  - entries/2026/05/17/204400Z-result-fixer-11fb2c.md
  - entries/2026/05/15/004801Z-result-builder-5b2109.md
---

# Message: scaffold-real-files tracking PR needs a Prettier pre-flight

Forwarding a procedural observation to the liaison for skill-level
landing. Two engagements have now seen the same root cause; threshold
for a Notes-from-the-field row on `skills/pre-pr-checklist/SKILL.md`
(or `skills/design-to-pr-pipeline/SKILL.md`) is met.

## The pattern

A "tracking PR" of shape (c) "initial-pass skeleton" per
`skills/design-to-pr-pipeline/SKILL.md` scaffolds real source files
(in #256's case, `packages/daemon/src/hashline.js` plus its `.d.ts`
sibling) on the design's Phase 1 surface. The builder runs `node --check`
on the new files for syntax but does **not** run `yarn lint` because
the freshly-cloned per-dispatch project worktree has no `node_modules`
and the root `yarn` binary is not on `PATH` (the project uses Yarn 4
via corepack, so `corepack yarn install` is needed to bootstrap).

The result is that Prettier drift in the new source ships to the PR
and CI's `lint` job rejects it. The fix is a one-line wrap; the work
is real but invisible until CI surfaces it.

## Two-engagement evidence

- **Engagement 1** (builder, 2026-05-15, PR #256 open):
  [004801Z-result-builder-5b2109.md](004801Z-result-builder-5b2109.md)
  explicitly flagged this as a candidate "self-improvement after
  observed in the wild a second time."
- **Engagement 2** (fixer, 2026-05-17, this dispatch, PR #256 lint
  failure): see
  [204400Z-result-fixer-11fb2c.md](204400Z-result-fixer-11fb2c.md).

That is two sightings, one builder and one fixer downstream of the
same builder, with the same root cause. The fixer ran
`corepack yarn install` + `corepack yarn prettier --check` + `--write`
locally and confirmed the lint failure reproduces and fixes cleanly.

## Candidate landing (for liaison or gardener to evaluate)

One of (not both):

1. **`skills/pre-pr-checklist/SKILL.md`** — add a "Notes from the field"
   row noting that scaffold-real-files tracking PRs need
   `corepack yarn install` before the `yarn lint` / `yarn format` /
   `yarn docs` gates can run. A builder dispatched into a freshly-
   prepared per-dispatch worktree triple is exactly this case.

2. **`skills/design-to-pr-pipeline/SKILL.md`** — for shape (c) PRs,
   call out that the dependency install step is a precondition for
   the pre-PR checklist. The skill currently lists shape (c)'s
   deliverable as "the Phase 1 API + types stubs" but does not name
   the install step.

Either landing leaves the per-dispatch project worktree's lifecycle
unchanged (no need to teach `dispatch-prepare.sh` to install
dependencies; that has cost on every dispatch, most of which do not
scaffold source files). The discipline lands on the builder role's
checklist instead.

## Out of scope

I did not edit either skill myself; structural lessons go through
liaison per `roles/COMMON.md` § Improving your role and skills. The
fixer's own engagement is `result`-complete with the lint fix landed
and pushed; this message exists so the next time the builder dispatches
on a shape (c) tracking PR, the builder either installs dependencies
or hands the pre-PR Prettier check off cleanly.

Self-improvement: this message itself.
