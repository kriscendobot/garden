## Completion report — `ebfb-build-followup-474-eslint-avoidquotes`

**Outcome:** DRAFT PR opened — endojs/endo-but-for-bots **#542**, base `master-7c25992` (frozen snapshot of `master`@`7c259920e`), head `refactor/eslint-plugin-visitor-shorthand`. erights' request on #474 visibly closed via a top-level comment linking #542.

**What I did**
1. Confirmed `packages/eslint-plugin` lives on `master` and that `object-shorthand`'s `avoidQuotes: true` comes from `eslint-config-airbnb-base` via `@endo/style` (no repo-local override). The config governing the rule sources is `packages/eslint-plugin/package.json`'s `eslintConfig`.
2. **Scoped relaxation** — added an `overrides` entry to that `eslintConfig`, scoped to `lib/rules/*.js`, setting `object-shorthand: ['error','always',{ avoidQuotes: false }]`. Not a global flip.
3. **Applied the shorthand** to the handler the relaxed rule flags. Running eslint after step 1 flagged **exactly one** handler: the anonymous `'Program:exit': function () {...}` in `lib/rules/harden-exports.js`, now `'Program:exit'() {...}`. Also removed the file's `/* eslint-disable func-names */` directive, which the conversion left orphaned (verified it's no longer needed; default `eslint .` stays clean).

**What changed:** 2 files — `packages/eslint-plugin/package.json` (+16 config) and `lib/rules/harden-exports.js` (handler + dropped directive). No `yarn.lock` change.

**Key finding (why only one handler):** `object-shorthand` never reports **named** function expressions (shorthand would drop the name). The `assert-fail-as-throw.js` handlers (`Program: function installAssertFailAsThrow()`, `'Program:exit': function restoreAssertFailAsThrow()`) are named, so they were correctly left untouched regardless of `avoidQuotes`. The only quoted-key handler that was both anonymous and exempted-by-`avoidQuotes` was the harden-exports one.

**Validation (package scope, run via `node <store-path>` to bypass the sandbox bin-shim block):** eslint clean · `tsc` clean · mocha **137 passing** · prettier clean on both files · `git status` shows only the two intended files. Full-monorepo `yarn lint`/`tsc` deferred to PR CI + the open-PR gamut (cleaner → judge → fixer-loop → un-draft), which the DRAFT picks up.

**Follow-ups:** none required. (Out-of-scope observation, not touched: `lib/rules/no-harden-pattern-maker.js` carries two `eslint-disable` directives that `--report-unused-disable-directives` flags as unused, but the repo's normal lint does not run that flag, so they don't fail CI.)

**Self-improvement:** nothing this time — the `frozen-base-branch`, project-README, and known sandbox-bin-shim workaround all covered this cleanly.
