---
ts: 2026-06-02T04:18:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/builder--db387a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 390
    role: opened
  - repo: endojs/endo-but-for-bots
    pr: 382
    role: predecessor
refs:
  - entries/2026/06/02/040100Z-dispatch-steward-db387a.md
  - https://github.com/endojs/endo-but-for-bots/pull/390
  - https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
---

# result: builder — opened #390, renames `@endo/endo-git` to `@endo/git`

## PR

- **Branch**: `rename-endo-git-to-git` (off `llm` head `144096f08`)
- **PR**: [#390](https://github.com/endojs/endo-but-for-bots/pull/390) (DRAFT, base `llm`)
- **Final head SHA**: `4ba7a87128718eca8c6a190dea6b2eeda576bb50`

## Commits

### 1. `refactor(git): rename @endo/endo-git to @endo/git` (`84a72231b`)

16 files, 18 insertions, 18 deletions.

Renames:

- `packages/endo-git/README.md` → `packages/git/README.md`
- `packages/endo-git/SECURITY.md` → `packages/git/SECURITY.md`
- `packages/endo-git/package.json` → `packages/git/package.json`
- `packages/endo-git/src/git-askpass-helper.cjs` → `packages/git/src/git-askpass-helper.cjs`
- `packages/endo-git/src/index.js` → `packages/git/src/index.js`
- `packages/endo-git/src/native-git-backend.js` → `packages/git/src/native-git-backend.js`
- `packages/endo-git/types.d.ts` → `packages/git/types.d.ts`

Modifications:

- `.gitignore` (allowlist entry).
- `packages/git/package.json` (name + repository directory).
- `packages/git/README.md` (heading).
- `packages/git/types.d.ts` (JSDoc header + two `declare module` specifiers).
- `packages/daemon/package.json` (dependency entry; yarn re-sorted alphabetically, folded into this commit).
- `packages/daemon/src/daemon.js` (import specifier).
- `packages/daemon/test/git.test.js` (import specifier).
- `packages/daemon/test/git-remote.test.js` (import specifier).
- `packages/exo-git/README.md` (two prose mentions).
- `packages/exo-git/package.json` (description).
- `packages/exo-git/src/types.js` (two JSDoc header mentions).
- `packages/exo-git/types.d.ts` (JSDoc header).

### 2. `chore: Update yarn.lock` (`4ba7a8712`)

1 file, 16 insertions, 16 deletions. Workspace name change only.

### 3. (omitted) `chore: regenerate composite tsconfig files`

`yarn build:types:gen` produced no changes. `packages/git` has `"build": "exit 0"` (same as the prior `packages/endo-git`) and does not participate in the composite TS build, so no per-package or root composite tsconfig file was updated. Per the dispatch instruction ("only if files actually change"), this commit was omitted.

## Verification

| Check                             | Outcome                                                                                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `git grep -n '@endo/endo-git'`    | zero matches                                                                                           |
| `git grep -n 'packages/endo-git'` | zero matches                                                                                           |
| `git grep -n 'exo-git'`           | matches preserved (sibling untouched, plus the README/types prose that points at it)                   |
| `corepack yarn install`           | exit 0 (with pre-existing peer-dep warnings unrelated to this change)                                  |
| `yarn build:types:gen`            | no changes written                                                                                     |
| `yarn build:types:check`          | exit 0; "All composite tsconfig files are up to date."                                                 |
| `yarn format --check`             | "All matched files use Prettier code style!"                                                           |
| `yarn lint`                       | 0 errors (2110 pre-existing warnings unrelated to this change)                                         |

## Pre-push gate

`skills/pre-push-gates/pre-push-gates.sh --probes-only` flags one finding attributable to this diff:

- `filename-no-stutter`: `packages/git/src/git-askpass-helper.cjs: basename starts with package name 'git'`.

This is a false positive in scope context. The `git-` prefix in the basename names the `git(1)` binary the helper drives (a credential askpass shim called by `git fetch` / `git push`), not the package name. The dispatch scoped the rename to the package surface ("Move `packages/endo-git` → `packages/git`, update name in package.json") and did not authorize touching internal file names; renaming the helper would balloon the diff (`native-git-backend.js` URL ref, two comments, two test assertions, a test description) outside the dispatch's boundary.

The remaining gate failures (`packages/chat/chat-bar-component.js`, `packages/ocapn/src/codecs/ocapn-pass-style.js`, multiple `sentence-per-line-md` finds in `TADA/`, `designs/`, and various READMEs, `no-inline-import-jsdoc` in `packages/9p-server`, `no-pull-citations` in `packages/chat/add-space-modal.js`, `security-md-hash-uniform` `missing: packages/endo/SECURITY.md`) are pre-existing and untouched by this diff.

## PR body

Body content authored from the upstream template per `skills/pr-formation/SKILL.md`. Lists the rename, the precedent (`@endo/stream` / `@endo/exo-stream`), the verification outcomes, and the back-link to the kriskowal directive on #382. PR opened DRAFT; un-drafting follows the judge's verdict per `skills/pr-creation-flow/SKILL.md` § Draft discipline.

## PR comments

None posted. Back-link is in the PR body only.

## Notes for the orchestrator

- The askpass-helper filename finding (above) is the only new gate finding. If the panel or maintainer chooses to absorb it, a follow-up rename to `packages/git/src/askpass-helper.cjs` is straightforward (one file rename + one URL ref in `native-git-backend.js` + two comments in same file + two assertions and a test description in `packages/daemon/test/git.test.js`).
- The dispatch's "frozen-base-branch" guidance is not used here: the dispatch explicitly named `base=llm` as the PR's base, and the branch is a small follow-up to the just-merged #382. The base name is the live `llm` branch, not a frozen snapshot.

Self-improvement: nothing this time.
