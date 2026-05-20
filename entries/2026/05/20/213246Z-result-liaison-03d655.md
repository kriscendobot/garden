---
ts: 2026-05-20T21:32:46Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 211345Z-dispatch-liaison-03d655
---

# Result: fixer 03d655 — zx port + tsconfig uniformity for #3258 (pushed)

Fixer dispatch `03d655` complete. Four commits pushed to `kriscendobot/endo@chore/security-md-uniformity`, head now `8cf9943f5d24ae992499347ff8fa126b33919fb9` (was `e98151eda59f3e92651b3aed3aa165ef714f77e7`). Self-report at `journal/entries/2026/05/20/213047Z-result-fixer-03d655.md`. Upstream PR [endojs/endo#3258](https://github.com/endojs/endo/pull/3258) auto-updates from the fork push.

## Commit series

1. `c685f31e6 chore(scripts): port check-package-uniformity to zx` — translates the 177-line bash to `scripts/check-package-uniformity.mjs` using `node:*` imports, deletes the shell version, updates `.github/workflows/ci.yml`. Same `EXCEPTIONS` semantics, same error-line shape, same fail-closed exit-1 on any drift.
2. `95d761b6e chore(scripts): enforce tsconfig.json uniformity against skel` — adds tsconfig-uniformity checks with a structural deep-equality comparison (tolerates trailing commas via a small `stripJsonc` helper) and a `TSCONFIG_INCLUDE_EXCEPTIONS` allowlist per-entry-commented for legitimate deviations.
3. `32c4f5d4f chore(packages): align tsconfig.json include to skel` — fixes pure #3270-class drifters: `pass-style`, `path-compare`, `exo`, `cache-map` (replaced `src/**/*.{js,ts}` and `test/**/*.{js,ts}` with skel's canonical `src` / `test` shorthand).
4. `8cf9943f5 chore: align bytes/SECURITY.md to skel` — surfaced as a bonus: the PR's lint job had been failing in CI since 2026-05-15 because `packages/bytes/SECURITY.md` was copied from pre-alignment `hex` when `bytes` was added 2026-05-13. Same alignment shape as the branch's existing `51645e25c` commit.

## Tsconfig-uniformity allowlist (per-package, with one-line reason each)

`eslint-plugin` (CJS lib/ layout), `goblin-chat` (bin/), `cli` + `import-bundle` (demo/), `nat` + `test262-runner` (scripts/), `ses` (scripts/, src-xs/), `module-source` (scripts/, src-xs/, narrow test glob), `compartment-mapper` (demo/ plus intentional `src/**/*.{js,ts}` paired with `**/*.d.ts` exclude).

No `tsconfig.build.json` `.extends` drift found across the tree.

## Local verification

`yarn install --immutable && yarn lint` runs clean (zero errors; two pre-existing JSDoc warnings unrelated). `node scripts/check-package-uniformity.mjs` returns exit 0 on the final HEAD. Each aligned package's `yarn lint:types` (tsc) was exercised post-alignment and stays clean.

## Design choices worth flagging

- The mjs keeps the workspace-conventional `#!/usr/bin/env zx` shebang (matching `generate-dependabot.mjs` and `migrate-test-*.mjs`) but uses only `node:*` imports. CI invokes via `node scripts/check-package-uniformity.mjs` for portability.
- Tsconfig check uses structural deep-equality on parsed JSON rather than byte-identity, so packages that ship with trailing commas (`marshal`, `ocapn`, `patterns`, `trampoline`) compare equal without reformatting.
- A small inline `stripJsonc` handles line comments + trailing commas; block comments are deliberately unhandled (would surface as a clear `JSON.parse` error).

## Outstanding

The follow-up "reply to Chris on PR #3258" task remains open (will land as a separate journal entry / comment on the upstream PR once the bot identity's comment authority on endojs/endo is confirmed — task carried forward).

## Teardown

Dispatch root `/home/kris/dispatches/fixer--03d655/` torn down by the liaison after this entry lands.
