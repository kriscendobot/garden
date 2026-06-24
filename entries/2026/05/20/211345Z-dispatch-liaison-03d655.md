---
ts: 2026-05-20T21:13:45Z
kind: dispatch
role: liaison
project: endo
to: fixer
---

# Dispatch: fixer 03d655 — translate check-package-uniformity.sh to zx, extend to tsconfig

Dispatch root: `dispatches/fixer--03d655/`. Project worktree on `kriscendobot/endo@chore/security-md-uniformity` (head `e98151eda`).

Maintainer directive (2026-05-20T21:11Z): on our mirror of [endojs/endo#3258](https://github.com/endojs/endo/pull/3258), respond to Chris's review feedback that new enforcement scripts should be JavaScript over shell — translate the new `scripts/check-package-uniformity.sh` to use `zx`. Also: ensure that the kind of drift that PR [endojs/endo#3270](https://github.com/endojs/endo/pull/3270) was opened to fix (tsconfig.json shape divergence from `packages/skel/`) cannot recur. Kris commented on #3270 that "we should add this to the scope of #3258".

## Context

- The shell script `scripts/check-package-uniformity.sh` (177 lines, on the PR branch) hashes `SECURITY.md` against skel, validates `LICENSE` modulo a copyright line, and asserts `package.json` field uniformity (`author`, `license`, `type`, `repository.{type,url,directory}`, `bugs.url`, `name`, `publishConfig.access`, `description`) with a small `EXCEPTIONS` allowlist (one entry: `packages/eslint-plugin:.type:` permitting the CJS ESLint v8 plugin to ship without `.type`).
- Wired into `.github/workflows/ci.yml` under the existing `lint` job as a step named "Check package uniformity".
- Chris's review (boneskull, 2026-05-19T23:16Z, APPROVED): *"I'm not going to block on it, but I'd prefer any new scripts are written in JS. We have `zx` at our disposal..."*
- PR #3270 (closed 2026-05-20T21:07Z, 0 commits — gh-stack stub) was titled *"chore(ts): fix tsconfigs for @endo/bytes & @endo/pass-style"*. The substantive fix landed elsewhere; per current master `packages/bytes/tsconfig.json` is now byte-identical to `packages/skel/tsconfig.json`, but `packages/pass-style/tsconfig.json` still drifts (off-template `include` shape: `src/**/*.js`, `src/**/*.ts`, `tools/**/*.js`).
- A sibling stacked PR #3271 (open, approved) tightens `packages/skel/tsconfig.json` to remove a too-broad `*.ts` include. Don't depend on it landing first; your check must reconcile against whatever `packages/skel/tsconfig.json` currently is in the branch.
- The repo already uses zx in `scripts/generate-dependabot.mjs` (shebang `#!/usr/bin/env zx`); `zx` is a workspace dependency in the root `package.json`. Follow that template.

## Task

Two-commit series on top of `chore/security-md-uniformity` head `e98151eda`:

**Commit 1** — translate the check to zx:
- Add `scripts/check-package-uniformity.mjs` that performs every check the shell script performs, with the same `EXCEPTIONS` allowlist semantics, the same error message shape (`<pkg>: <what differs>`), and the same exit-1-on-any-drift fail-closed behavior.
- Use `zx` idioms (don't shell out to `jq` / `sha256sum` / `awk`; use `fs.readFile`, `crypto.createHash`, `JSON.parse`).
- Update `.github/workflows/ci.yml` to invoke `node scripts/check-package-uniformity.mjs` (or `./scripts/check-package-uniformity.mjs` with the `#!/usr/bin/env zx` shebang, whichever is the existing convention — see `generate-dependabot.mjs`).
- Delete `scripts/check-package-uniformity.sh`.
- Subject: `chore(scripts): port check-package-uniformity to zx`.

**Commit 2** — extend to tsconfig uniformity:
- Add tsconfig-uniformity checks to the new `.mjs` script that catch the drift class #3270 was opened to address. The shape of the check is your call, but the intent is that *if `packages/<pkg>/tsconfig.json` (or `tsconfig.build.json`) diverges from `packages/skel/` in a way that breaks composite builds, CI fails*. Suggested approaches (pick the cleanest):
  - Byte-identical comparison to `packages/skel/tsconfig.json`, with an `EXCEPTIONS` allowlist for packages that legitimately need a different shape (today: at minimum `pass-style`, possibly others — survey the tree).
  - Structural (parsed-JSON) comparison of required keys (`extends`, `include`) tolerating ordering, with skel as the source of truth.
- Whichever you pick, *document the choice in a top-of-file comment block* the way the existing shell script documents its checks. Future readers should be able to see why the check is shaped this way without re-deriving from #3270.
- Surface every divergence the check finds; do not exit early on first failure.
- Subject: `chore(scripts): enforce tsconfig.json uniformity against skel`.

## Investigative latitude

You may decide between byte-identical and structural tsconfig checks based on what the current tree looks like. Run the check locally against current `packages/*` and report which packages currently drift and how — those packages either need fixes in this PR (preferred for small numbers, in their own commits) or `EXCEPTIONS` entries (for legitimate historical deviations, named with a one-line reason comment per entry).

If `packages/pass-style/tsconfig.json` is the only drifter the check would flag, fix it (align to skel) in a third commit `chore(pass-style): align tsconfig.json to skel`. If there are many drifters and the maintainer's intent is unclear, prefer adding them to `EXCEPTIONS` with TODOs naming each and flag this in the report rather than batch-fixing.

## Commit shape

- 2-3 commits as outlined above. Conventional-commit subjects.
- No changeset entries needed (this is CI/scripts plumbing; the existing PR is already a `chore:`).
- Run `yarn lint` locally if feasible to confirm nothing breaks; mention in the report whether you exercised it.

## Per-action authorization

- Standing on `kriscendobot/endo`: push to `chore/security-md-uniformity`.
- READ-ONLY elsewhere. No comments. No PR-create (PR #3258 already exists upstream; pushing the mirror branch updates it).

## Out of scope

- Don't open a new PR; the upstream PR already exists.
- Don't touch unrelated packages (no `homepage` alignment, no `eslint-plugin` ESM migration, etc.).
- Don't merge or un-draft.
- Don't post comments on #3258 yourself; the liaison will post the reply once your commits are in.

## Report

≤ 400 words: head SHA after push, the two-three commit subjects, the list of packages the new tsconfig check flagged (and how each was resolved: fixed, allowlisted, or out-of-scope), whether `yarn lint` (or the local check itself) ran clean, and a one-line `Self-improvement: ...`.
