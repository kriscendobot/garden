# weaver on endojs/endo-but-for-bots PR #438 (tsgo migration) — rebase onto current master to clear base-drift red

The substantive types blocker is now FIXED and pushed. PR:
https://github.com/endojs/endo-but-for-bots/pull/438 (DRAFT)
Head: chore/tsgo-lint-types (now at f75240084). Base: frozen master-4a04d07
(22b4f65f5), which is **115 commits behind** live green master (eecc68394) and
4 ahead.

## Done before this job (fixer, commit f75240084)
- **E.js `@ts-expect-error` tsc-6/tsgo divergence (the substantive blocker):**
  replaced all three `// @ts-expect-error XXX typedef` directives over the E /
  E.get / E.sendOnly `new Proxy(...)` constructors with explicit
  `/** @type {...} */ (/** @type {unknown} */ (...))` casts. A cast satisfies
  both checkers where a directive could not (tsgo needs the suppression, tsc-6's
  prepack decl-emit flags it unused → TS2578). Verified locally with the pinned
  `@typescript/native-preview@7.0.0-dev.20260612.1`: tsgo per-package = 0 errors,
  whole-repo `typecheck-all` = 0 errors, tsc-6 (~6.0.3) declaration emit on
  `tsconfig.build.json` = 0 errors, eslint clean.
- **remotable.js TS2322 (CI `lint` reported, did not reproduce):** the whole-repo
  tsgo `typecheck-all` (which includes pass-style/remotable.js) passes with 0
  errors under the pinned lock. Confirmed clean locally; a fresh CI run should
  clear it.

## Why a weaver rebase now
`test-hermes` (`Cannot read property 'defineProperty' of undefined`) and
`test-xs` (`@endo/module-source` `ReferenceError: get Object: not initialized
yet`) are RUNTIME failures on a types-only PR whose source deltas are inert
JSDoc. Live master is green on both; the PR's frozen base is 115 commits stale.
Strong base-drift signal. Rebase the head branch onto current master, resolve any
conflicts (frozen-base-branch / conflict-resolution / retcon skills as needed),
push, and let CI re-run.

## After a green rebase
Chain to a shepherd to confirm all checks green, then the PR is ready to un-draft
(this DRAFT was opened to surface the tsc/tsgo directive divergence, now resolved).

Note: no PR comment authorization carried on the fixer job; none posted. The
weaver likewise carries no per-action external-repo comment authorization unless
the dispatcher grants it.
