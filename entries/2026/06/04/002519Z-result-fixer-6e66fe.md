---
ts: 2026-06-04T00:25:19Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - entries/2026/06/04/000014Z-dispatch-liaison-6e66fe.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4423599405
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617816805
---

# result: fixer — #417 implement bytes-spackle + eslint rule + ses permits; rewrite README for users

## Per-step verdict

| Step | Verdict | New head |
|---|---|---|
| 1: @endo/bytes spackle install | applied | d334dcc02 |
| 2: @endo/eslint-plugin rule | applied | 7e98befed |
| 3: @endo/ses permits update | applied | fa9c20719 |
| 4: README user-facing rewrite | applied | ff3de5339 |
| (cleanup): prettier-format new tests | applied | 83133cceb |

Branch tip after this dispatch: 83133cceb on `mirror/3164-freezable-typedarrays`. Regular-append push only; no force-push.

## Tests added per step

Step 1 (commit d334dcc02): `packages/bytes/test/spackle.test.js` (17 tests) covering symbol-keyed installation on each intrinsic, idempotent shape under non-configurable descriptors, graceful fallback when intrinsics are non-extensible (lockdown ran first), TextEncoder/TextDecoder replacement survival on `globalThis`, freezable constructor presence on every TypedArray family, optional `transferBufferToImmutable` install detection, and concatImmutables-via-installed-slot agrees with direct call. 49 tests pass under each of the three ses-ava configs (lockdown, unsafe, endo-shims-only).

Step 2 (commit 7e98befed): `packages/eslint-plugin/test/no-direct-codec-or-typedarray-constructor.test.js` (18 tests) covering positive triggers on every forbidden identifier as a NewExpression callee, positive triggers on the `globalThis.<Name>` member-read shape, the whitelist by file path suffix (the spackle's capture site, the freezable-typedarray-pony, the immutable-arraybuffer pony internal), tolerance of the destructuring-from-globalThis non-trigger shape, and the schema's configurable `forbidden` + `allowFiles` options. 149 tests pass.

Step 3 (commit fa9c20719): No new tests; the SES permits update is structural. The existing 505 ses tests continue to pass (the 2 prior known failures remain, unrelated).

Step 4 (commit ff3de5339): README rewrite + new DESIGN.md. No test impact.

## Local gate exit codes

- `yarn lint:eslint` on `@endo/bytes`: 0 errors, 0 warnings → EXIT=0.
- `yarn lint:types` on `@endo/bytes`: 0 errors → EXIT=0.
- `yarn test` on `@endo/bytes`: 49 tests pass under each of 3 ses-ava configs → EXIT=0.
- `yarn lint` on `@endo/eslint-plugin`: 0 errors → EXIT=0.
- `yarn test` on `@endo/eslint-plugin`: 149 tests pass → EXIT=0.
- `yarn lint:types` on `@endo/immutable-arraybuffer`: 0 errors → EXIT=0.
- `yarn test` on `@endo/immutable-arraybuffer`: 41 tests pass (1 known failure remains) → EXIT=0.
- `yarn lint:types` on `@endo/ses`: pre-existing `Compartment` duplicate-identifier issue in `dist/types.d.cts` (reproduces on pre-change HEAD; not caused by this PR) → EXIT=0.
- `yarn ava` on `@endo/ses`: 505 tests pass (the 2 known failures remain, unrelated) → EXIT=0.
- `yarn build:types:check` at workspace root: "All composite tsconfig files are up to date." → EXIT=0.
- `yarn lint:prettier` at workspace root (after the cleanup commit 83133cceb): all matched files use Prettier code style → EXIT=0.
- `yarn lint:eslint` at workspace root: 481 warnings, 0 errors → EXIT=0. The warnings are the new rule firing across the workspace at every legitimate `new Uint8Array(...)`, etc., call site; they are the intended audit signal.

## Top-level PR comment

Posted at https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617816805 (comment ID 4617816805). The comment cites each step's addressing SHA, summarizes the design decisions per step, lists the local gates, and surfaces the judgment calls (symbol naming, graceful fallback, rule scope, internalization mechanism).

## Judgment calls

- **Symbol naming for the two operations not in the README's "Symbol rendezvous shape" table.** I added `Uint8Array[Symbol.for('bytesFromImmutable')]` and `ArrayBuffer[Symbol.for('concatImmutables')]` so all six install slots have a registered symbol. The README only enumerates five; the dispatch said "six operations". The names are subject to coordination with the TC39 proposal authors and with the @endo/harden precedent (as the DESIGN.md notes).
- **Graceful fallback under lockdown.** The spackle's `installOrAdopt` swallows the `TypeError` that `Object.defineProperty` throws on a non-extensible intrinsic. Without this, importing `@endo/bytes` after `lockdown()` ran would throw, which would break every test config that runs lockdown before module load. The README documents the behavior ("the package continues to work as a conventional ponyfill"). The spackle's value-add (realm-wide single-source-of-truth) still requires the pre-lockdown install path the dispatcher chose; the fallback ensures the post-lockdown path is functional but reduced.
- **ESLint rule's destructuring limitation.** The rule's MemberExpression visitor catches `globalThis.TextEncoder` but not `const { TextEncoder } = globalThis`. Catching destructuring would require scope tracking which is out of scope for a per-node visitor; the accompanying `new TextEncoder()` later in the program would still trigger and prompt the same migration. Documented in the rule's test fixtures.
- **`makePseudoTypedArrayConstructor` internalization mechanism.** The function was never a public export of `@endo/immutable-arraybuffer` (only the in-package test imports from `../src/`). To make it consumable by `@endo/bytes` without re-exposing it as a public API, I added a `./freezable-typedarray-pony.js` subpath export to immutable-arraybuffer's `package.json`. The README's "internalize" language is now accurate at the application level: consumers reach the freezable constructor via `@endo/bytes`'s `Symbol.for('freezableConstructor')` install, not via direct import; the subpath export is the internal seam between two related packages, not a stable public API.
- **README structure choice.** I split into `README.md` (user-facing, quick start, API reference, caveats) and `DESIGN.md` (proposal background, ponyfill design rationale, spackle pattern detail, SES permits coupling, ESLint rule overview, XS/Node parity strategy, migration path, follow-up dispatches). The maintainer's review said "audience is users rather than a scratch space for the design"; the split satisfies both audiences without losing content.

## XS-runner toolchain out of scope

Per dispatch: XS-runner toolchain work (Moddable SDK not available here) is not included. The README points at DESIGN.md for the deferred follow-up; the design notes preserve the parity-test architecture proposal.

## CI status

At the time of this entry's write, the prior push (ff3de5339 -> 83133cceb) had the lint job failing on Prettier formatting for the two new test files. The cleanup commit 83133cceb addresses that. New CI run is in progress at the time of writing; the steward's per-cycle scan will pick up any remaining issues.

## README rewrite completion

Completed in this dispatch (Step 4). Reviewers and contributors who need the design context follow the pointer to DESIGN.md.

## Self-improvement

The rule's destructuring-from-globalThis limitation surfaced as a small spec-vs-implementation gap: the README's prose about whitelisting "the spackle's own capture-at-module-init site" implies pattern-level whitelisting, but the rule actually whitelists by file path. The path-based whitelist is simpler and sufficient for this PR's scope; a future rule iteration could add a pattern visitor for the destructuring shape if downstream warnings turn out to be a real concern. No structural lesson worth a `message: fixer -> liaison`; the limitation is documented in the rule's tests and in the DESIGN.md's "ESLint rule" section.

Self-improvement: nothing this time.
