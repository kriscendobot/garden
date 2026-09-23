---
ts: 2026-05-22T22:54:03Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--b2b45b/project
refs:
  - entries/2026/05/22/223600Z-dispatch-general-contractor-b2b45b.md
---

Summary-fix bundle on PR #311 (`fix(module-source): pass defineProperty
through functor calling convention`). Four commits land on
`fix/module-source-define-property`, addressing all 2 must-fix-loop + 4
summary-fix items from barrister-34a687's pullrequestreview-4349123131.
No follow-ups touched (parked per the ledger at
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--311.md`).
No rebase; review context preserved.

## Must-fix items

**(1) Changeset compatibility claim was wrong (commit 59ae26f9a).**
The previous body said pairing the new `module-source` with an old `ses`
or `compartment-mapper` would "silently fail to set function `.name`
properties". The emitted preamble calls `$h_defineProperty(fn,'name',...)`
unconditionally; if the host omits the field, the destructured value is
`undefined` and the call invokes `undefined(...)`, which throws
`TypeError`. Rewrote the section as a "Host-pairing requirement" naming
the actual `TypeError` failure mode. Also covers summary-fix on em-dash
discipline in the same paragraph.

**(2) Regression test rewired (commit a310e61c7).** The original test
passed `defineProperty: Object.defineProperty` directly into the functor
input, demonstrating the patched code reaches the destructured field but
not pinning either the structural fix or the host-pairing surface.
Rewired by:

- Adding a structural assertion against `record.__syncModuleProgram__`
  that the emitted preamble does not contain `Object.defineProperty` in
  the functor body. This pins the patched emit shape directly. Verified
  the assertion fails on a temporarily-reverted emit (sed-swap of the
  HIDDEN binding for `Object.defineProperty` in `transform-analyze.js`,
  then restored).
- Adding a second test `host-pairing: old host (no defineProperty field)
  throws TypeError` that calls `initialize` with explicit
  `defineProperty: undefined` and asserts a `TypeError` instance. The
  test wires the helper so an explicit `undefined` is preserved
  (`Object.prototype.hasOwnProperty.call(options, 'defineProperty')`
  rather than default destructuring, which would coerce `undefined` to
  the intrinsic and silently hide the failure mode).
- The helper's `defineProperty:` line now sources from
  `intrinsicDefineProperty` captured at module-loader scope, with a
  comment naming why and pointing at the production callers; covers
  summary-fix on test:167.

## Summary-fix items (other)

**(3) Em-dash on changeset.** Folded into commit 59ae26f9a above.

**(4) `transform-analyze.js:85` archivist comment (commit ef63c2c81).**
Added five lines after the original "It's a function assigned to" note
explaining why this call uses the hidden binding (a module-local
`import { Object }` would shadow `Object.defineProperty`) and naming the
two host sites that pass the SES intrinsic in
(`ses/src/module-instance.js` and
`compartment-mapper/src/bundle-mjs.js`).

**(5) Bundle-mjs Object-shadow coverage (commit 712918f28).** Added
`packages/compartment-mapper/test/fixtures-object-shadow/` (4 files:
`app/{index.js,package.json}`, `object-dep/{index.js,package.json}`) and
a new test `bundled MJS preserves hoisted function name when module
shadows Object`. The test bundles via `makeFunctor`, evaluates the
bundle in a fresh Compartment, and asserts the entry namespace's
`F.name === 'F'`. Verified the test catches the bug by temporarily
reverting the emit fix in `transform-analyze.js`; the bundle threw
`TypeError: Object.defineProperty is not a function` at functor
evaluation, then restored the emit.

## Commits

```
712918f28 test(compartment-mapper): bundle-mjs preserves hoisted function name under Object shadow
ef63c2c81 docs(module-source): explain hidden-binding choice at the emit site
a310e61c7 test(module-source): pin the Object-shadow regression and host-pairing surface
59ae26f9a docs(module-source): correct changeset compatibility surface to TypeError
3ce1febf5 fix(module-source): pass defineProperty through functor calling convention (pre-existing)
```

## CI status

Pushed to `origin/fix/module-source-define-property`. CI queued and
pending across the full matrix (build, lint, cover, test 22/24 x
macos/ubuntu, test-async-hooks, test-hermes, test-xs, test262, zizmor,
viable-release, check-action-pins). PR is DRAFT; no review re-request
issued, no top-level comment posted (no per-action authorization in the
dispatch prompt). Pre-push gate ran clean modulo two pre-existing
repo-wide conditions unrelated to this PR
(`no-inline-import-jsdoc` on `evasive-transform/src/index.js` from PR
#3131; `security-md-hash-uniform` divergence across `immutable-arraybuffer`,
`bytes`, `hex`, `panic` SECURITY.md files). Contractor's next cycle
dispatches justice for re-panel.

Self-improvement: `Object.prototype.hasOwnProperty.call(options, key)`
is the right shape for test helpers that need to distinguish an
explicit `undefined` argument from an omitted key; default destructuring
(`const {x = default} = opts`) silently coerces both to the default and
hides bugs that depend on the distinction. Worth adding to a future
`coverage-driven-testing` skill or a panel-hint for prover that
flags helper-default-destructuring on regression tests that intend to
probe a "missing field" surface.
