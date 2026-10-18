# FIX round 2 for endojs/endo-but-for-bots#546: fixes pushed, CI green

I applied the round-2 panel's must-fix items and the cheap should-fix items. I pushed 8 follow-up commits to `mirror/endo-3137-build-ts` (`678ecb680` → `87152ec24`) with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` ended with rc 0: 16 of 16 checks passed.

One item is still open. This host's bot token can't edit the PR description: `gh pr edit` returned 403 on `updatePullRequest`. I posted job `endojs-endo-but-for-bots-pr546-body-trim-20261017`, pinned to `endolin-garden-ece02cb4`, to apply the shorter description. The pruner had marked that change summary-fix, not must-fix.

## Commits
- **`00da01231` fix(eventual-send):**
  - The `.ts` port had dropped the "is `T` any?" checks that base commit `c88bc8311` added to four helper types in `E.ts`. I restored them, so `E(x as any)` is typed `any` again. A new test in `exports.test-d.ts` checks this for `E` and `E.sendOnly`; it fails without the fix.
  - I restored the comment explaining why the generated methods use concise method syntax.
  - I removed `toBreakpointProperty`, which could never run: a Proxy `get` trap only receives string or symbol keys.
- **`450153b74` fix(patterns):** `patternMatchers.ts` now behaves exactly like the old `.js` file at runtime:
  - `M.split` and `M.partial` check `passStyleOf(harden(base)) === 'copyArray'` again, not `Array.isArray`.
  - The four `assert*Guard` helpers are typed `const` arrows again, so they can't be called with `new` and have no `prototype`.
  - `splitRecord` casts the `ownKeys` result again instead of filtering it.
  - The patterns suite passes (610 tests).
- **`7f4aa41e3` test(daemon):** `makeAmaroExecArgv` now takes `execArgv` as a parameter (defaulting to `process.execArgv`). New unit tests cover adding the hook and each way an existing hook can be spelled.
- **`12ef99747` test(daemon):** a new test bundles a module that imports `@endo/eventual-send` and `@endo/patterns` with `bundle-source`, then loads it with `importBundle`. It passes. The saboteur's failure only happens when code calls `@endo/compartment-mapper` directly on workspace sources without a `.ts` parser, so I documented that case rather than changing compartment-mapper.
- **`1ce2c07b2` fix(eslint-plugin):** `no-nonrelative-ts-import` now:
  - checks static template literals in `import()`;
  - no longer flags `.d.ts` specifiers;
  - says ".ts imports are allowed only within the same package" in its doc comment;
  - drops comments that only repeated the code or docs.
- **`5cad536c8` docs:**
  - Corrected the claim about the `amaro/strip` hook: `@endo/cli` registers it, and `@endo/daemon` only adds it to the processes it forks.
  - Made relative `.ts` imports same-package-only throughout.
  - Added a bundle-time note.
  - Cut the ts-node-pack and migration walkthroughs.
  - Removed the `…` character.
  - `AGENTS.md` now points to `docs/typescript.md` instead of restating its rules.
- **`87152ec24` chore(changeset):**
  - `@endo/cli` and `@endo/daemon` move from `minor` to `major`, with a `BREAKING:` line for the Node.js 22 floor. Both packages are private, so this only affects the changelog.
  - The `@endo/eventual-send` and `@endo/patterns` changeset stays `patch`, but now says exactly what changes when loading them from source (workspace link or git checkout).
  - Every changeset now has one sentence per line.

## Decision for you
I made the `@endo/cli` and `@endo/daemon` bump `major` rather than keeping `minor` with a justification; both are past 1.0. If you'd rather keep `minor` for private packages, it's a one-line revert in `.changeset/cli-ts-runtime.md`.

## Left as is
These were comment-only or optional:
- the `makeProxy` helper;
- lint-rule coverage of `TSImportEqualsDeclaration`, `TSImportType` and `require`;
- the unrelated pin-comment changes in the CI workflow files;
- splitting `yarn.lock` into its own commit;
- the breakpoint-sentinel coverage gap.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5678444 cached reads)
- Output: 28577 tokens
- Cost: $2.7529007999999995
- Wall-clock: 1112s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
