---
ts: 2026-05-14T06:29:06Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--carry-turadg-feedback-to-226--20260514-061345--63f3ef/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/226
  - https://github.com/endojs/endo/pull/3255#discussion_r3229246963
---

# Carried turadg's aliasing feedback to endo-but-for-bots#226

Inspected PR #226 on entry: the aliasing rewrite (`eslint-plugin-import:
'npm:eslint-plugin-import-x@4.16.2'` in the dev catalog) was already
present at SHA `1e4f819a1`. No PR-introduced suppression edits remained
to revert (the prior approach with `airbnbImportRulesDisabled` had been
force-pushed away before this dispatch).

`yarn lint` from the root was NOT clean however: import-x@4's bundled
`unrs-resolver` is stricter than `eslint-plugin-import@2`'s resolver
chain, and surfaced 11 new errors that the prior resolver silently
passed.

Two categories:

- `import/no-extraneous-dependencies` for `tsd` in `*.test-d.ts` files
  across `packages/exo/` (6) and `packages/marshal/src/types.test-d.ts`
  (1).
- `import/export` overlap across `export *` chains in
  `packages/marshal/index.js` (2), `packages/init/pre-remoting.js` (1),
  and the `packages/compartment-mapper/test/fixtures-symlink/app/`
  fixture (1).

Two follow-up commits:

- `f38d828b7 chore(lint): clean import-x@4 lint findings`
  - `**/*.test-d.ts` added to `devDependencies` allowlist in
    `packages/eslint-plugin/lib/configs/imports.js`.
  - `tsd: catalog:dev` added to `packages/exo/package.json` (it was
    being used by exo's `test/*.test-d.ts` without being declared).
  - `// eslint-disable-next-line import/export` added on three
    locations matching pre-existing convention.
- `5ea8d7e72 chore: Update yarn.lock`

`yarn lint` now reports 0 errors, 2 pre-existing JSDoc warnings (same
as master). Pushed to
`origin/feat/migrate-eslint-plugin-import-x` (`884194716..5ea8d7e72`).
Summary comment posted on PR #226
(`https://github.com/endojs/endo-but-for-bots/pull/226#issuecomment-4448213020`)
citing turadg's comment id 3229246963 verbatim.

Out of scope (held to dispatch brief): no comment on endojs/endo#3255,
no PR title/body rewording, no upstream ferry update. The PR body
still describes the superseded approach (mentions
`airbnbImportRulesDisabled`); the maintainer or a separate dispatch
can redraft if desired.

Self-improvement: when a dispatch task says "verify lint passes" on a
PR that has been force-pushed since the dispatch was framed, run lint
first against the actual HEAD rather than trusting the PR body's
"0 errors" claim. The PR description here lagged the rewrite, and the
real fixer work turned out to be addressing import-x's stricter rules,
not reverting suppressions that had already been removed.
