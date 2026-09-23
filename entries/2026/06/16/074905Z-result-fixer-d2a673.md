---
ts: 2026-06-16T07:49:05Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/063000Z-result-fixer-f2915b.md
  - entries/2026/06/16/052900Z-result-fixer-a849e6.md
---

# Fixer: OODA cycle 5 on PR #5 (20 swingset-runner/src TS errors)

OODA cycle 5 on `kriscendobot/agoric-sdk#5` per
`skills/ci-failure-classification-loop/SKILL.md`. Prior fixer f2915b
(cycle 4) cleared lint-primary's ESLint stage; CI then advanced to
`typecheck-all`, surfacing 20 pre-existing TS errors in
`packages/swingset-runner/src/`. This cycle addresses them with
targeted type annotations and guards.

## Pre / post

- Pre HEAD: `d019de698ecff560bc5a1b52434e29160558ea19` (chore: Update yarn.lock)
- Post HEAD: `1122a57c04` (fix(swingset-runner): clear 20 lint-primary TS errors in src/)
- 1 commit pushed (append, no force).

## Diagnostic correction to dispatch hypothesis

The dispatch attributed the 20 errors to `c659a18` (SwingSet
yargs-parser parseArgs adoption). Verified by bisect that this is
incorrect: `c659a18` touches only `packages/SwingSet/`, not
`packages/swingset-runner/`. Error counts on the branch:

| Commit | swingset-runner/src TS errors |
|---|---|
| upstream/master | 0 |
| `c2de346cc5`^ (pre-Endo-absorb) | 0 |
| `3a6be3fa1b` (Endo absorb) | 21 |
| `460617f92f` (slogulator readline fix) | 20 |
| `c659a18` (SwingSet parseArgs) | 20 |
| `d019de698e` (current pre-this-cycle) | 20 |

Root cause: the Endo absorb (Endo @1.5.0 / @1.10.0 / ses 2.x /
bundle-source 4.3.2) tightened types that swingset-runner/src
consumes (anylogger Adapter type, kvStore.get return narrowed to
`string | undefined`, postToInspector return narrowing). Reverting
`c659a18` would have re-introduced 4 yargs-parser lint errors
without touching the type errors. Took path B (fix in place).

## Per-error fix mapping

| # | File | Error | Fix |
|---|---|---|---|
| 1 | anylogger-legacy.js:11 | TS2322 Adapter mismatch | `@ts-expect-error` |
| 2 | anylogger-legacy.js:12 | TS2556 spread tuple | `@ts-expect-error` |
| 3 | dataGraphApp.js:74 | TS18048 arg possibly undefined | type-cast `(argv.shift())` |
| 4 | dataGraphApp.js:78 | TS2322 outfile null | type `string \| undefined` |
| 5 | dataGraphApp.js:92 | TS7029 fallthrough | restructure else branch |
| 6 | dataGraphApp.js:94 | TS2532 fields | type-cast `(argv.shift())` |
| 7 | kerneldump-entrypoint.js:15 | TS2339 .then on void | `export async function main` |
| 8 | kerneldump.js:109 | TS18048 target undefined | default `\|\| '.'` |
| 9-11 | kerneldump.js:110/114/124 | TS2345 string undefined | flowed from fix 8 + `fail: never` annotation |
| 12-14 | main.js:327/370/394 | TS2322 string undefined to null | type `string \| null \| undefined` on configPath/statsFile/swingsetBenchmarkDriverPath |
| 15 | main.js:490 | TS2345 null to URL ctor | default `\|\| '.'` |
| 16 | main.js:642 | TS2322 statLogger object to null | type via `ReturnType<typeof makeStatLogger> \| null` |
| 17 | main.js:743 | TS2339 close on never | flowed from fix 16 |
| 18-19 | main.js:814/820 | TS2339 .profile on `{}` | postToInspector `Promise<any>` |
| 20 | main.js:920 | TS2339 .log on never | flowed from fix 16 |

## Local validation

- `tsgo -p tsconfig.check.json --noEmit` under
  `packages/swingset-runner/src/`: 20 → 0 errors.
- Total repo TS error count: 392 → 372 (delta exactly 20).
- `yarn lint:eslint --quiet`: clean.

## Pre-push-gates result

- 8 deterministic probes: all pass.
- `yarn format`: pass (auto-fixed 4 paths, re-staged into the commit).
- `yarn lint`: fails on `lint:packages` (pre-existing
  cosmic-proto / client-utils typecheck-packages errors); unchanged
  from cycles 3/4 and unrelated to this cycle's changes.
- `yarn typecheck`: skip (no root script).

## Classification (cycle 5, head 1122a57c04 to be confirmed when CI settles)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized 2026-06-15) |
| C/this cycle | lint-primary | 20 swingset-runner/src TS | FIXED in 1122a57c04 |
| C/next cycle | lint-primary | ~20 swingset-runner/demo Zoe type refs | pending |
| C/next cycle | lint-primary | ~1 swingset-runner/test Promise ctor | pending |
| B | lint-primary / lint-packages | ~350 client-utils / cosmic-proto module-resolution | inherited monorepo state |
| C/cascade | test-* matrix | cancelled by upstream lint fail | should clear when lint-primary clears |

## PR comment

Posted top-level summary @-mentioning @kriskowal with the cycle-5
classification, per-error mapping, diagnostic correction, and
recommended next stage:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4716180232>

## Recommended next stage

`next: ooda-observation`. The CI run on `1122a57c04` will reveal
whether lint-primary's failure signature shrinks by 20 swingset-runner/src
errors. The next OODA cycle's options:

1. If `swingset-runner/demo/` errors are within the dispatch scope
   under the same "fix Class C in scope" lens, dispatch the next
   fixer against that 20-error subset (Zoe type-ref bindings).
2. The `swingset-runner/test/` single Promise<unknown> ctor error
   is a 1-line fix.
3. The remaining ~350 errors in agoric-cli / cosmic-proto / client-utils
   are inherited monorepo state predating the Endo absorb; classifying
   them Class B and surfacing to maintainer is appropriate per
   `skills/ci-failure-classification-loop/SKILL.md` § Termination.

Self-improvement: nothing this time. The pattern of "ESLint
short-circuit hiding typecheck-all errors until ESLint clears" is
notable but already informed the cycle 4 / cycle 5 transition; the
dispatch's misattribution to `c659a18` rather than the absorb
(`3a6be3fa1b`) is the kind of error a "bisect-before-blame" probe
would catch, but the cost of that probe (a full typecheck-all on each
suspect commit) is high enough that a one-cycle correction in the
result entry is the better trade.
