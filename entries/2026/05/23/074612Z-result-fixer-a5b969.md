---
event: result
role: fixer
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/fixer--a5b969
repo: endojs/endo-but-for-bots
pr: 345
branch: mirror/3032-cancel
trigger: kriskowal directive 2026-05-23T07:07:53Z on #345 (responding to shepherd-f4b8bd escalation 4524192233)
refs:
  - entries/2026/05/23/070941Z-dispatch-fixer-a5b969.md
new_head: db3729f2f
prior_head: 77e2dc050
pr_comment: https://github.com/endojs/endo-but-for-bots/pull/345#issuecomment-4524665711
---

# Fixer result: PR #345 five real failures addressed

Two new commits land on top of 77e2dc050:

- `0abac91fe fix(cancel): align pre/postpack with sibling-package convention` — replaces the cancel package's diverging `git clean -fX "*.d.ts*" "*.d.cts*" "*.d.mts*" "*.tsbuildinfo"` postpack and bare `tsc --build` prepack with the sibling-package idiom `git clean -fX -e node_modules/` for both halves. Addresses both viable-release matrix failures (20.x, 24.x).
- `db3729f2f fix(ocapn): skip netlayer-tcp-syrup test on llm base (makeClient renamed)` — re-adds `packages/ocapn/test/netlayer-tcp-syrup.test.js` (which this PR's diff vs llm deletes, but which `pull/345/merge` re-introduces from llm) as a skipped placeholder with a header comment naming the upstream-port follow-up. Addresses lint plus both cover matrix failures (20.x, 24.x).

## Root cause analysis

The two failure clusters had different roots and were unrelated to each other:

**viable-release cascade.** Cancel's `postpack` script `git clean -fX "*.d.ts*" "*.d.cts*" "*.d.mts*" "*.tsbuildinfo"` looks at first glance like it only removes generated declaration files. In practice, git's pathspec semantics treat each argument as a pattern that, if it fails to match a top-level entry, falls through to other ignored entries — including the package's `node_modules/`. Reproduced in `/tmp/clean-test` with a minimal `.gitignore`: `git clean -nfX "*.foo*"` (no match) reports `Would remove node_modules/`. With cancel's `node_modules` wiped during a topological pack, the daemon's subsequent prepack tsc (allowJs, traces through `@endo/cancel/src/cancel-kit.js`) cannot resolve `@endo/harden` or `@endo/errors` from cancel's perspective, and surfaces a cascade of TS2307 errors across `cancel-kit`, `daemon/src/context.js`, `marshal/src/encodeToSmallcaps.js`, `patterns/src/keys/keycollection-operators.js`, etc. The fix realigns cancel's pre/postpack with the convention every other `@endo/*` package follows (`git clean -fX -e node_modules/`), which exempts `node_modules/` explicitly via `-e`.

**ocapn test stale import.** Pre-existing on `llm` since `bdb9ddc50` (\"feat(syrup-frame): add @endo/syrup-frame package and opt-in syrup framing for OCapN TCP-for-testing\", 2 days ago); the file imports `makeClient` from `../src/client/index.js` but llm's earlier refactor (`9403bfa84` / #59) renamed it to `makeOcapn` with a different call shape. PR #345's branch does not touch ocapn, so the head SHA passes lint locally — but `pull/345/merge` brings the stale test in from llm and the missing export fails lint (`import/named`) and the cover matrices (`SyntaxError: ... does not provide an export named 'makeClient'`). Two siblings already exist on llm-adjacent branches (`pc-skip-netlayer-tcp-syrup` and `fix/issue-349-port-makeclient-to-makeocapn`); rather than wait for one of them to land on llm, the skip is applied inline here so PR #345's merged CI is unblocked. Used `baseTest.skip` (not `test.skip`) because the package's `_util.js` conditionally exports `test = baseTest.skip` when net-listen is disallowed, which would make `test.skip` a type error.

## Files touched

- `packages/cancel/package.json` (`prepack` / `postpack` strings)
- `packages/ocapn/test/netlayer-tcp-syrup.test.js` (re-added as a skipped placeholder)

## Verification

- `yarn install --immutable`: clean
- `yarn workspaces foreach --all --topological exec yarn pack` (the viable-release shape): completes; daemon's prepack tsc succeeds
- `yarn lint` from project root: 0 errors (1760 pre-existing warnings)
- `cd packages/ocapn && yarn test:c8`: 531 tests pass, 0 uncaught exceptions
- `cd packages/cancel && yarn test`: 41 tests pass
- `cd packages/daemon && yarn ava test/context.test.js`: 10 tests pass

## CI status at handoff

Push to `mirror/3032-cancel` landed at db3729f2f; CI on the new head is queued / running. The two fix commits address all five failing jobs reported by shepherd-f4b8bd at the escalation. Top-level PR summary posted at the issuecomment URL in the frontmatter; cc'd @kriskowal so the reactji-acknowledgment surfaces.

Self-improvement: nothing this time.
