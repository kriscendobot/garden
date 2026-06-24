---
ts: 2026-06-07T03:40:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--c71c70
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641290562
  - entries/2026/06/06/054752Z-result-shepherd-092a08.md
  - entries/2026/06/06/054900Z-result-steward-092a08.md
---

# dispatch: fixer — open a fresh PR addressing the eslint-plugin-unicorn root devDep gap (based on master)

Maintainer directive on `endojs/endo-but-for-bots#426` at
2026-06-07T03:38:27Z (kriskowal):

> Please dispatch a fixer to create a fresh PR that addresses the
> problem with the unicorn package, based on master.

This authorizes the fix that yesterday's shepherd `092a08` escalated
as `next: liaison` and that the steward surfaced to the user; the
maintainer now confirms the fix lands as a **separate PR against
`master`**, not as an amendment to PR #426 (which is the master-into-
llm sync PR and shouldn't carry an unrelated config fix).

## State at dispatch time

- **Bot master** (`endojs/endo-but-for-bots@master`): `4a04d078`
  (in sync with current `endojs/endo@master`).
- **Root cause** (per shepherd `092a08` escalation): master's new
  `unicorn/numeric-separators-style` rule wired via
  `@endo/eslint-plugin`'s peerDep, but the bot fork's root
  `package.json` does not provide `eslint-plugin-unicorn` as a
  devDependency. The 9p-server ESLint config's `plugin:@endo/internal`
  extends fail to resolve. Turbo cascades the abort so the test
  matrix never reaches its substance.
- **Affected paths**: root `package.json` (devDeps), `yarn.lock`
  (lockfile regen). Possibly `.changeset/<slug>.md` per the
  changeset convention if relevant for a root-only config bump.

## Task

In your `project/` worktree (currently detached HEAD on bot
master `4a04d078`):

1. **Create the fresh branch** off `origin/master`:
   `git checkout -b chore/eslint-plugin-unicorn-root-devdep`
   (or a similar conventional-commit-style name; pick what fits
   the repo's branch-naming convention).
2. **Add `eslint-plugin-unicorn` to root `package.json` devDeps.**
   Find the version constraint to use by reading what
   `@endo/eslint-plugin`'s `peerDependencies` declares (or what
   master's own root devDeps would have declared if upstream had
   added it; check upstream `endojs/endo@master` `package.json`
   for guidance). Match upstream's pin if reasonable.
3. **Regenerate `yarn.lock`**:
   `corepack yarn install` (or `corepack yarn` per the repo's
   `engines.yarn` config). Verify the lockfile change is minimal
   (only the eslint-plugin-unicorn entries).
4. **Verify locally**: `corepack yarn lint` (and any other lint-
   adjacent invocations the prior shepherd diagnostic surfaced).
   Pre-existing master findings unrelated to this fix are
   expected; the goal is the lint cascade from `@endo/internal`
   resolves cleanly.
5. **Commit** with conventional-commit messages:
   - `chore: add eslint-plugin-unicorn to root devDeps` (touches
     `package.json`).
   - `chore: Update yarn.lock` (touches `yarn.lock`), separate
     commit per the standing convention.
6. **Push the branch**: `git push origin HEAD:<branch-name>`.
7. **Open the PR DRAFT**: `gh pr create -R endojs/endo-but-for-bots
   --base master --head <branch-name> --draft --title <title>
   --body <body>`. Title: `chore: add eslint-plugin-unicorn to root
   devDeps` (or whatever the project's convention prefers). Body:
   - One-line statement of the gap (the unicorn peerDep was
     introduced via `@endo/eslint-plugin` but the root devDep was
     not).
   - Cite the precipitating PR #426 shepherd verdict
     (`entries/2026/06/06/054752Z-result-shepherd-092a08.md`)
     and the maintainer's authorizing comment
     (`#issuecomment-4641290562`).
   - Note that PR #426 (master-into-llm sync) will land cleanly
     once this fix is in `master` and re-synced.
   - "CI is the validation gate."

## Authorizations (per-action, forwarded by steward)

- **Push the new branch** to the bot fork. Implicit in the
  dispatch.
- **Open the DRAFT PR** against bot `master`. Implicit.
- **Post the draft-PR body** (`endo-but-for-bots` standing broad-
  comment authorization).
- **A brief reply on PR #426** acknowledging the directive and
  citing the new PR's number once opened. The same standing
  authorization covers it.

## Out of scope

- Do NOT amend PR #426 itself.
- Do NOT touch the `llm` branch directly.
- Do NOT shepherd this PR's CI yourself; a follow-on shepherd will
  be dispatched if needed once the PR's CI converges (or fails).

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- The new branch name and tip SHA.
- The opened PR number and URL.
- The exact version pin you chose for `eslint-plugin-unicorn` and
  the source of that pin (upstream master's value, or a fresh
  decision with rationale).
- The yarn.lock diff size (line count change).
- Any unrelated lint findings surfaced during local verification
  (pre-existing, expected; record for completeness).
- The reply comment URL on PR #426.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
