---
ts: 2026-06-04T00:26:58Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/04/000014Z-dispatch-liaison-6e66fe.md
  - entries/2026/06/04/002519Z-result-fixer-6e66fe.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
---

# result: #417 sequential implementation complete (bytes spackle + eslint + permits + README user-rewrite)

User asked for a single subagent to do all steps sequentially.
Fixer `6e66fe` closed cleanly with five commits across four
packages.

## Outcome

- **New head**: `83133cceb` on `mirror/3164-freezable-typedarrays`
  (regular append; no force).
- **Top-level comment**: `4617816805`.

## Commits

1. `d334dcc02` — `feat(bytes): spackle install on intrinsics
   via registered Symbol.for keys`.
2. `7e98befed` — `feat(eslint-plugin): forbid direct
   TextEncoder/TextDecoder/TypedArray-ctor/ArrayBuffer
   construction`.
3. `fa9c20719` — `feat(ses): admit @endo/bytes spackle
   registered symbols in permits`.
4. `ff3de5339` — `docs(immutable-arraybuffer): rewrite README
   for users; move design to DESIGN.md`.
5. `83133cceb` — `chore: prettier-format the new test files`.

## Tests added

- `packages/bytes/test/spackle.test.js`: 17 tests.
- `packages/eslint-plugin/test/no-direct-codec-or-typedarray-
  constructor.test.js`: 18 tests.
- Existing: 149 eslint-plugin / 41 immutable-arraybuffer / 505
  SES all pass across three ses-ava configs.

## Gates

All clean (0 errors) except a pre-existing SES `Compartment`
duplicate-identifier issue reproducing on pre-change HEAD
(not introduced by this fixer).

## README split

- **`README.md`** (user-facing): quick start, API, caveats,
  relationship to `@endo/bytes`.
- **`DESIGN.md`** (contributor-facing): proposal background,
  ponyfill design, spackle pattern, symbol rendezvous, SES
  permits coupling, ESLint rule, XS/Node parity strategy,
  migration path.

## Judgment calls

1. Added two symbol names (`bytesFromImmutable`,
   `concatImmutables`) not enumerated in the prior README
   table so all six install slots have a registered symbol.
2. `installOrAdopt` falls back gracefully when intrinsics are
   non-extensible (lockdown ran first); keeps the package
   functional as a conventional ponyfill.
3. ESLint rule whitelists by file path suffix; destructuring
   from globalThis is not catchable but the accompanying
   `new X()` would trigger.
4. Internalized `makePseudoTypedArrayConstructor` via new
   `./freezable-typedarray-pony.js` subpath export from
   `@endo/immutable-arraybuffer` (consumed only by
   `@endo/bytes`).

## XS-runner deferred

Per dispatch scope (Moddable SDK toolchain not available).
Remains as a follow-up.

## Teardown

`dispatches/fixer--6e66fe` torn down.

## Steward queue post-engagement

- **#417** sequential implementation at `83133cceb`; awaits
  maintainer reassessment.
- **#418** evasive-parser fixer in flight (`fixer--091a1a`).
- **#411** rebased at `37440d0e2`; awaits CI green + boatman
  re-ferry.
- All other queue items unchanged.
