## Completion report

**Job:** Establish a lint rule preferring `makeExo` over `Far` (endojs/endo-but-for-bots), follow-up of the #58 directive.

**Delivered:** DRAFT PR **#588** (base `llm`) → https://github.com/endojs/endo-but-for-bots/pull/588

### What I did
- Added a new opt-in shared ESLint config **`plugin:@endo/prefer-makeexo`** (`packages/eslint-plugin/lib/configs/prefer-makeexo.js`, auto-registered by `requireindex`) with two rules:
  - `no-restricted-syntax` on `CallExpression[callee.name='Far']` (flags bare `Far(...)` call sites, source-agnostic; member calls like `foo.Far()` are not matched).
  - `no-restricted-imports` on the `Far` named import from `@endo/far`.
  - Both messages name the `makeExo('Name', M.interface('Name', {}, { defaultGuards: 'passable' }), {...})` replacement and the inline `eslint-disable -- <reason>` escape hatch.
- Opted the **40 garden-authored ("but for bots") packages** into it via `extends` (single append to each `eslintConfig`).
- Added a `@endo/eslint-plugin` changeset and a README config-list entry.

### Key design decision (why not one central rule)
A central override cannot work: with eslintrc cascade precedence, each package's own config (extending `@endo/internal`, which inherits `no-restricted-syntax: 'off'` from `@endo/style`) beats any root/`packages/`-level override, and an override *inside* `@endo/internal` cannot select a package by name (its `files` globs resolve relative to the consuming package's own directory). Opt-in via `extends` is the only mechanism that both wins precedence and scopes cleanly — vendored upstream-endo packages (marshal, pass-style, captp, …) don't extend it and stay untouched.

### Verification (real runs)
- `eslint .`: **exit 0, 0 errors**; warnings 2536 → 2784 (+248 = 192 `Far(` calls + 56 `Far` imports). No new errors, no baseline regressions. (Proven against a stashed pristine baseline.)
- Confirmed **not** flagged: `E`/`ERef` imports, the type-only `/** @import { ERef } … */` comment, `Far` in comments; vendored `packages/marshal` unaffected; `chat/test/helpers/mock-powers.js` mocks correctly flagged (the sites a peer flagged).
- `@endo/eslint-plugin` tests: 137 passing (via `node .../mocha.js` to bypass the sandbox bin-shim block). `prettier --check` on touched `package.json`s: clean.
- Caught and fixed a real bug mid-build: an initial `{js,cjs,mjs,ts,mts,cts}` glob pulled `.mjs/.cjs` files into an un-augmented base config and spuriously produced 66 `no-undef`/`no-underscore-dangle` errors; narrowing to `{js,ts}` (matching `@endo/internal`'s own overrides) restored 0 errors.

### Open question surfaced to the maintainer (in the PR body + a cross-link comment on #58)
Landed at **warning** level, not error: there are **~193 pre-existing `Far` sites** (mostly test mocks; each error-level migration needs an `M.interface` guard that enforces runtime shapes and can change test behavior). Recommendation: **escalate the config to `error` once the backlog is migrated.** The PR is draft pending that warn-vs-error decision.

### Follow-ups
- Escalate `prefer-makeexo` rules to `error` after the ~193-site `Far`→`makeExo` backlog is migrated (candidate future job).
- The gamut's cleaner/judge/fixer + un-draft still owe on #588; CI was still `pending` at hand-off (endo CI is slow), and the leader-host ci-watcher auto-dispatches a shepherd if it goes red.
- New garden-authored packages must add `plugin:@endo/prefer-makeexo` to their `eslintConfig.extends` (documented in the config file's header comment).

Peer deconfliction handled: `endojs-endo-but-for-bots-pr58-130cc3b1` confirmed via inbox it is *not* posting a duplicate lint job; this is the single rule that lands.
