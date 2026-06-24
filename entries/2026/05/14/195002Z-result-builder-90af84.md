---
ts: 2026-05-14T19:50:02Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/14/193940Z-dispatch-liaison-90af84.md
---

Cut 5 of the devDep-cycle factoring design (#206) is open as draft PR
[#247](https://github.com/endojs/endo-but-for-bots/pull/247) on branch
`feat/eventual-send-test` (base `llm`).

## What landed on the branch

Two commits on `feat/eventual-send-test` off `origin/llm`:

1. `feat(eventual-send,eventual-send-test): break devDep cycle via @endo/eventual-send-test (Cut 5 of #206 design)`
2. `chore: Update yarn.lock`

The first commit adds a new private package `packages/eventual-send-test/`
hosting the eight `@endo/lockdown/commit-debug.js`-using test files
(`e`, `eventual-send`, `hp`, `local`, `message-breakpoints`, `proxy`,
`thenable`, `types`) plus the shared `_get-hp.js` fixture and the
`exports.test-d.ts` `tsd` type test, all moved via `git mv`. The two
tests reaching internal surfaces (`local.test.js`,
`message-breakpoints.test.js`) plus `_get-hp.js` now resolve
`@endo/eventual-send/src/*` via the new `test-endo-eventual-send`
condition added to `packages/eventual-send/package.json`'s `exports`
map. `@endo/eventual-send`'s devDeps lose `@endo/lockdown`, `ses`,
and `tsd`; the test/test:c8 scripts and the `ava` block are dropped.
`tsconfig.json` and `typedoc.json` exclude the new package alongside
the `harden-test` / `hex-test` precedent. `SECURITY.md` is the
canonical copy from `packages/ses/SECURITY.md` so the new #228 CI
gate stays green.

## Cycles eliminated

- `@endo/eventual-send` --devDep--> `@endo/lockdown`
- `@endo/eventual-send` --devDep--> `ses`

After this cut, every cycle-creating devDep flagged in the design is
gone except those slated for Cut 1 (`@endo/ses-test`, the largest).

## Verification

- `yarn install` clean (yarn.lock churn shipped in its own commit).
- `yarn test` in `@endo/eventual-send-test`: all 64 tests pass.
- `yarn lint:eslint` in both packages: 0 errors.
- `yarn lint:types` in `@endo/eventual-send`: clean.
- `yarn format`: clean (no drift introduced).
- `scripts/check-security-md.sh`: passes for the new package (the
  earlier `harden-test` / `hex-test` misses surface as a pre-existing
  red flag unrelated to this PR).

Affected packages: `@endo/eventual-send` (devDep delete +
test-condition exports), `@endo/eventual-send-test` (new).

Self-improvement: nothing this time. The Cut 4 (#210) and Cut 2 (#211)
precedents gave a clean pattern; the only delta here was carrying
`exports.test-d.ts` along with the rest of the suite, which was a
local decision and not a repeating gap. The pattern's third instance
makes the synthetic-test-package recipe robust enough that codifying
it as a skill might be considered if Cut 1 (`ses-test`) also lands
cleanly, but two instances is too few to generalize.
