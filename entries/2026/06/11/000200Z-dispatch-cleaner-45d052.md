---
ts: 2026-06-11T00:02:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--45d052
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4453991038
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/001500Z-result-builder-5e0a82.md
---

# dispatch: cleaner — stage 1 of #403 gamut after builder 5e0a82 subsumed layers 2+3

Continuing the gamut on PR #403 after builder `5e0a82` landed
three commits implementing Phase 1 (README:53 ask), Phase 2
(Layer 2 mvs-resolver), Phase 3 (Layer 3 snapshot-mapper) of
the #358 stack. Phase 4 (Layer 4 daemon-worker integration) was
deferred to a follow-up PR with rationale documented in the PR
body's "Design departures #3" section.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`, DRAFT, base
  `llm-c85d618`, head `feat/registry-capability` at
  `74ada99151...` (full SHA TBD — fetch and check; the
  dispatch-prepare picked up older `584d06da3`).
- **FETCH AND CHECKOUT `74ada99151` BEFORE STARTING**.
- **Builder commits**:
  - `26df58b90` — Phase 1: rewrote `packages/exo-npm/README.md`
    per layering-refs ask; loosened error constructors to
    single-arg reason shape.
  - `a2fa05af1` — Phase 2: `src/mvs-resolver.js` + 12 tests.
  - `74ada9915` — Phase 3: `src/snapshot-mapper.js` + 8 tests.
- **39 tests passing**, lint clean on `@endo/exo-npm`.
- **Builder result entry**:
  `journal/entries/2026/06/11/001500Z-result-builder-5e0a82.md`.

## Task

In your `project/` worktree at the build head (FETCH +
CHECKOUT `74ada99151` FIRST):

1. **Read** `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md` for modern PR hygiene
   standards.
2. **Run `pre-push-gates`** in the project worktree. Address
   any probe failures introduced by the builder's commits (do
   NOT address pre-existing failures on `master`/`llm` that
   the builder noted as inheritance).
3. **Audit the PR body** the builder rewrote against
   `pr-formation`:
   - Title matches the new four-layer scope.
   - Summary explains the three landed layers + the deferred
     layer (with rationale).
   - Design departures section enumerates the three open-
     question decisions the builder made.
   - Test plan describes the test surfaces added.
   - Closes-issue lines are correctly qualified
     (`endojs/endo#N` for cross-repo refs).
4. **Audit the diff** against modern hygiene skills:
   - `garden/skills/changeset-discipline/SKILL.md` (a 3-layer
     PR likely needs an updated/new changeset).
   - `garden/skills/em-dash-style/SKILL.md`
   - `garden/skills/no-latin-shorthand/SKILL.md`
   - `garden/skills/relative-paths/SKILL.md`
   - `garden/skills/test-title-spec-spelling/SKILL.md`
   - `garden/skills/rename-discipline/SKILL.md` (the builder
     noted a post-rename naming — verify no stale
     `packages/registry-capability/` references remain).
5. **Rebase check**: `git fetch origin llm && git merge-base
   --is-ancestor origin/llm HEAD`. If the branch is behind
   `llm` since the frozen-base snapshot, that's a separate
   weaver concern, NOT a cleaner action. Note the gap; don't
   rebase yourself.
6. **Commit hygiene changes** one category per commit.
   PR-body edits via `gh pr edit` (no commit).
7. **Push** to `feat/registry-capability` (append push only).
8. **Post a top-level summary comment** on PR #403 noting
   the hygiene-pass findings and naming the new head SHA.
   End with: "Next stage: barrister panel."

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `feat/registry-capability` (append push
  only). Implicit in the cleaner dispatch.
- **Edit the PR body** via `gh pr edit` for structural
  rewrites. Standing cleaner authority.
- **Top-level summary comment** on PR #403. Standing.

## Out of scope

- Do NOT touch source files beyond hygiene fixups.
- Do NOT undeferr Layer 4 (the builder's deferral judgment is
  in the PR body; the panel/maintainer will weigh in).
- Do NOT rebase the branch.
- Do NOT request review or un-draft.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post head SHAs.
- The hygiene-pass commits (SHA + scope).
- PR-body edits made (before/after summary if any).
- Per-skill audit results.
- pre-push-gates resolution.
- The top-level summary comment URL.
- **Recommended next stage**: barrister panel.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next stage (barrister panel) and
tears down your dispatch root on return.
