---
ts: 2026-05-21T05:46:40Z
kind: dispatch
role: cleaner
project: endo-but-for-bots
to: cleaner
---

# Dispatch: cleaner 4bcd7b — pr-creation-flow stage on endo-but-for-bots#332 (mirror of endojs/endo#2901)

Dispatch root: `dispatches/cleaner--4bcd7b/`. Project worktree on `endojs/endo-but-for-bots@mirror/2901-default-chaining` (head `052f4c1901580f3bcca1364c578692d18c19a385`).

Maintainer directive (2026-05-21T05:38Z, via liaison): *"Please dispatch a builder to create a mirror of https://github.com/endojs/endo/pull/2901 and run the gauntlet."* Builder dispatch 35d0d8 completed and opened DRAFT [PR #332](https://github.com/endojs/endo-but-for-bots/pull/332). This is the gauntlet's cleaner stage.

## PR shape

3-file +29/-31 refactor across `@endo/captp` (`packages/captp/src/captp.js`) and `@endo/compartment-mapper` (`packages/compartment-mapper/src/{node-modules,parse-archive-cjs}.js`) embracing the `?.` optional-chaining operator where previously open-coded. Mirror of endojs/endo#2901; original author kriskowal preserved; endolinbot is the committer.

`yarn lint` and `yarn test` for both packages reported clean by the builder (captp 11/11 pass, compartment-mapper 879 pass + 6 known unrelated failures).

## Task

Run your standard cleaner pass against PR #332's diff:

- **Coverage sweep** — for each touched file, ensure existing tests exercise the new optional-chaining paths. Since this is a behavior-preserving refactor (the open-coded `x && x.y && x.y.z` pattern and the `?.` shorthand have identical semantics for the supported value range), the existing tests should already cover the paths. If coverage gaps exist for the *containing* functions (i.e. not necessarily added by this PR but exposed by it), surface them; landing additional coverage commits is in scope.
- **Dead-code audit** — the refactor may incidentally make some defensive null-checks redundant if `?.` already short-circuits. Look for stragglers.
- **CI watch** — push any coverage / dead-code commits to the same branch (`mirror/2901-default-chaining` on `endojs/endo-but-for-bots`), then watch CI converge to green.

If you push nothing (no coverage gaps to fill, no dead code), say so explicitly in the report — that's a valid outcome for a small mechanical refactor.

## Per-action authorization

- Push to `mirror/2901-default-chaining` on `endojs/endo-but-for-bots`.
- READ-ONLY everywhere else. No comments. Don't un-draft.

## Out of scope

- Don't broaden the refactor beyond the three files in the diff.
- Don't move the PR to ready-for-review — that's the judge's call after the panel.

## Report

≤ 300 words:
1. Coverage assessment for each touched file: which existing tests cover the new `?.` paths.
2. Any commits you landed (subjects + final head SHA after push). If none: explicit "no commits".
3. CI status at end of your dispatch (URLs + summary).
4. One-line `Self-improvement: ...`.

Write the report into `journal/entries/2026/05/21/<HHMMSS>Z-result-cleaner-4bcd7b.md` and commit+push to origin journal before returning.
