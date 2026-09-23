---
ts: 2026-06-02T04:01:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--db387a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 382
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/382
  - https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
---

# dispatch: builder — rename `@endo/endo-git` to `@endo/git` (follow-up to #382)

kriskowal directive on the now-merged #382:

> @kriscendobot Please create a follow up that just renames `@endo/endo-git`
> to `@endo/git`. This parallels the relationship between `@endo/stream` and
> `@endo/exo-stream`, and establishes a precedent that we should record for
> further design reviews.

## Task

Open a new follow-up PR (DRAFT) that renames the `@endo/endo-git` workspace
package to `@endo/git`, mirroring the `@endo/stream` / `@endo/exo-stream`
naming relationship (the exo-side is `@endo/exo-git`, present in the same
tree — the concrete-side becomes `@endo/git`).

### Concrete changes

1. **Move the package directory**:
   ```
   git mv packages/endo-git packages/git
   ```
2. **Update `packages/git/package.json`**:
   - `"name": "@endo/endo-git"` → `"name": "@endo/git"`
   - `"directory": "packages/endo-git"` → `"directory": "packages/git"`
   - Any other internal references in the package.json (description,
     keywords, etc.) that mention `@endo/endo-git`.
3. **Update consumers** (found via `git grep`):
   - `packages/daemon/package.json`: dependency entry
     `"@endo/endo-git": "workspace:^"` → `"@endo/git": "workspace:^"`.
   - `packages/daemon/src/daemon.js`: any imports.
   - `packages/daemon/test/git-remote.test.js`, `packages/daemon/test/git.test.js`:
     any imports.
   - `packages/exo-git/{README.md,types.d.ts,src/types.js,package.json}`:
     any references in prose or types (e.g. the description string in
     `exo-git/package.json` mentions "pair with @endo/endo-git for the
     Node-side GitBackend").
4. **Update remaining references** in any READMEs, docs, or other files
   that mention `@endo/endo-git` literally. Use `git grep -n
   '@endo/endo-git'` and `git grep -n 'endo-git'` to enumerate;
   distinguish between `@endo/endo-git` (rename target) and
   `@endo/exo-git` (sibling — leave alone).
5. **Regenerate the lockfile**: `corepack yarn install` to refresh
   `yarn.lock` to reflect the rename.
6. **Regenerate composite tsconfigs**: `yarn build:types:gen` then verify
   with `yarn build:types:check` (exit 0 expected).

### Commit structure

Per project conventions and `yarn-lock-separate-commit` skill, split into:

1. `refactor(endo-git,daemon,exo-git): rename @endo/endo-git to @endo/git`
   (the substantive change — package move, name update, consumer updates)
2. `chore: Update yarn.lock` (separate yarn.lock commit)
3. `chore: regenerate composite tsconfig files` (if any composite changes
   beyond the rename; only include if files actually change)

If the tsconfig regeneration produces no changes beyond what's implied by
the rename, fold it into the refactor commit or omit.

### Branch & PR

- Branch name: `rename-endo-git-to-git` (off `llm` head `144096f08`)
- Open DRAFT PR via `gh pr create`:
  - Base: `llm`
  - Title: `refactor(git): rename @endo/endo-git to @endo/git (follow-up to #382)`
  - Body:
    ```
    Per kriskowal's follow-up directive on #382, rename the new workspace
    package to drop the redundant `endo-` prefix.

    This mirrors the `@endo/stream` / `@endo/exo-stream` naming convention
    already established in the workspace: the concrete-side package is
    `@endo/git` while the exo-side remains `@endo/exo-git`. The rename
    establishes precedent for future workspace package additions
    extracted from Endo proper.

    Closes the follow-up requested in
    https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
    ```

### Pre-PR verification

Before pushing and opening the PR:

- `git grep -n '@endo/endo-git'` and `git grep -n '"endo-git"'` and
  `git grep -n 'packages/endo-git'`: each should return zero matches
  (the rename is complete).
- `git grep -n 'exo-git'`: should still match (sibling left alone).
- `corepack yarn install` completes cleanly.
- `yarn build:types:check` exits 0.
- A quick syntax/lint pass on touched JS files via `yarn lint` (or a
  scoped equivalent the role knows how to call) is reassuring.

## Per-action authorizations

- `git mv` and edit operations within `packages/{endo-git,daemon,exo-git}`
  and their consumers. Authorized.
- `corepack yarn install` and `yarn build:types:gen`. Authorized.
- Push to new branch `endojs/endo-but-for-bots:rename-endo-git-to-git`.
  Authorized.
- Open DRAFT PR base=llm. Authorized.

## Not authorized

- Force-pushing.
- Targeting any base other than `llm`.
- Un-drafting (kriskowal will review the DRAFT PR; un-drafting happens via
  the judge later in the gauntlet, not here).
- Modifying files outside the listed scope (e.g. don't touch CI workflows,
  root README, etc. unless they mention `@endo/endo-git`).
- Closing #382 (already merged) or commenting on it (the steward will
  handle the back-link via the PR body).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--db387a/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--db387a/garden/roles/builder/AGENT.md`
3. Skills referenced by the builder just-in-time. Relevant:
   `rename-discipline`, `yarn-lock-separate-commit`, `pre-pr-checklist`,
   `pr-formation`.

Project worktree at `project/` on `llm` (head `144096f08`).

## Report

A `result` journal entry. Include: branch name pushed, new PR number + URL,
final head SHA after the substantive commit, list of files changed (broken
out by commit if multiple), all verification command outcomes (grep counts,
`yarn install` exit, `yarn build:types:check` exit), and any PR comments
posted (expected: none beyond the PR body).
