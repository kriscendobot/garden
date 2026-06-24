---
ts: 2026-06-02T04:14:04Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 6ebd5e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 390
    role: surviving
  - repo: endojs/endo-but-for-bots
    pr: 391
    role: duplicate-closed
refs:
  - entries/2026/06/02/040046Z-dispatch-builder-6ebd5e.md
  - https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
---

# result: builder — rename @endo/endo-git → @endo/git (sixth concurrent collision)

## Disposition

**Sixth concurrent-orchestrator collision of the day.** Sibling
builder dispatch `db387a` (steward-spawned, ~14 seconds after my
dispatch) opened DRAFT PR #390 ~12 minutes before my builder's
PR #391. Both pre-flights (`gh pr list --search "endo-git in:title"`)
ran before either PR existed, so neither saw the other.

My builder detected the duplicate on first journal sync, **closed
#391 as a duplicate**, deleted the head branch and unused
frozen-base branch. Surviving PR is **#390**.

## Surviving PR (sibling-authored)

<https://github.com/endojs/endo-but-for-bots/pull/390>
- Title: `refactor(git): rename @endo/endo-git to @endo/git (follow-up to #382)`
- DRAFT against `llm`.
- Head: `rename-endo-git-to-git`.

## Verification before close

- 17 changed files, +34 / -34 (same as the closed #391).
- `git grep "@endo/endo-git"` returned empty.
- `npx corepack yarn install` regenerated lockfile cleanly.
- Pre-push-gate probe failures (`no-inline-import-jsdoc`,
  `security-md-hash-uniform: missing packages/endo/SECURITY.md`)
  are pre-existing on `llm` base, not introduced by the rename.
- Test runner: `packages/daemon test/git-remote.test.js` 29
  pass; `test/git.test.js` has one pre-existing failure
  (environment-specific local-git output regex) unrelated to
  rename.
- npm registry: `@endo/git`, `@endo/endo-git`, `@endo/exo-git`
  all unclaimed; workspace `private: true` regardless.

## Self-improvement signal for the gardener

Builder's pre-flight (`gh pr list --search "<title-substring>
in:title"`) should re-poll **after the initial branch push but
before `gh pr create`** so concurrent sibling dispatches detect
each other before both publish.

The two dispatches were issued 14 seconds apart; both pre-flights
ran before either PR was open. Adding a second pre-flight after
push (but before `gh pr create`) would catch the race; a *Notes
from the field* row on `skills/pr-creation-flow/SKILL.md` and a
matching norm on `roles/builder/AGENT.md` would land it.

## Collision tally for the day

1. #244 weaver/fixer (20:03Z).
2. PR #3 builder/builder (23:00Z).
3. PR #3 fixer/fixer (23:39Z).
4. Gateway phase 1 (~23:55Z).
5. Gateway phase 2 first-push non-fast-forward (concurrent design
   revisions; mild — only delayed by rebase).
6. **This one** — rename builder/builder (04:00Z, 14 sec apart).

The pattern is now robust evidence for a gardener intervention:
the pre-flight-re-poll norm above, plus the in-flight-dispatch
registry the prior collision notes recommended.

## Liaison disposition

Dispatch root torn down. PR #390 enters the steward's per-cycle
PR-creation-flow scan for the gamut.

The naming-precedent encoding kriskowal flagged remains
gardener-shaped (parallel `@endo/<short>` / `@endo/<endo-short>`
mirroring `stream` / `exo-stream`).
