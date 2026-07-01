# builder: enforce `.js` extension on module specifiers via lint (endojs/endo-but-for-bots)

**Repo:** `endojs/endo-but-for-bots` — base branch `llm`.

**Origin:** maintainer directive by kriskowal, a review comment on PR #442
(`feat/daemon-cas-extraction`):
https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3502513778
> "Lack of .js extension is not expected. Post a job for a builder to ensure
> this is enforced by lint."

The comment is on `packages/daemon-cas/src/content-store.js` line 6.

## What the directive is about

The flagged line is a **JSDoc `@import`** whose module specifier omits the
`.js` extension:

```js
/** @import { ContentStore } from '@endo/platform/fs/lite/types' */   // line 6 — extensionless
/** @import { ContentStoreOptions } from '../types.js' */             // line 7 — correct
```

Line 7 carries `.js`; line 6 does not. The maintainer wants lint to **catch**
this class of omission so it can't recur.

## What I (the gardener routing this) already established — start here

- The repo's `import/extensions` rule **is already active** for these packages.
  Config chain: each package `eslintConfig` extends `plugin:@endo/internal`
  (`packages/daemon-cas/package.json`) → `plugin:@endo/strict`
  (`packages/eslint-plugin/lib/configs/strict.js`) → `plugin:@endo/imports`
  (`packages/eslint-plugin/lib/configs/imports.js`), which sets:
  ```js
  'import/extensions': ['error', 'always', { ignorePackages: true }],
  ```
- **Why the omission slips through:** `eslint-plugin-import`'s `import/extensions`
  rule only inspects real `import`/`export`/`require` statements — it does **not**
  parse JSDoc `@import { … } from '…'` tags at all. So an extensionless specifier
  inside a JSDoc `@import` comment is invisible to the current rule. (Also note
  `ignorePackages: true` deliberately exempts real bare-package specifiers, which
  is correct for runtime imports — the gap here is specifically the JSDoc `@import`
  surface, and any relative JSDoc `@import` that should carry `.js`.)

So this is **not** a config toggle on the existing rule; enforcing extensions on
JSDoc `@import` specifiers needs a mechanism that actually reads those tags.

## Task

Make lint enforce the `.js` extension on module specifiers that the current
`import/extensions` rule misses — at minimum **relative JSDoc `@import`
specifiers** (the `../types.js` form), matching the existing `import/extensions`
'always' policy and its `ignorePackages` exemption for bare-package specifiers.

Investigate and choose the cleanest mechanism; candidates to weigh:
1. An **`eslint-plugin-jsdoc`** rule/setting (the repo already depends on
   `eslint-plugin-jsdoc`) that validates `@import` specifiers — check whether a
   suitable rule exists and can be configured in
   `packages/eslint-plugin/lib/configs/imports.js` (or the jsdoc config).
2. A small **custom rule** in `@endo/eslint-plugin`
   (`packages/eslint-plugin/lib/rules/`, e.g. alongside `harden-exports.js`)
   that flags extensionless relative specifiers in JSDoc `@import` tags, wired
   into the `imports`/`strict` config with a test under
   `packages/eslint-plugin/test/`.

Pick the option that best matches Endo conventions (prefer a well-maintained
existing plugin rule over a bespoke rule if it covers the case cleanly).

Then:
- **Fix the existing violation(s)** the new enforcement surfaces — including
  the PR #442 `content-store.js` line-6 specifier — and run a repo-wide
  `yarn lint` to confirm no other occurrences are left unaddressed (or fix them
  in the same PR).
- Add/adjust an **eslint-plugin test** if you author a custom rule.
- Add a **changeset** if the `@endo/eslint-plugin` package changes (its lint
  behavior is a published-package change).

## Scope / PR shape

- The lint change lives in `@endo/eslint-plugin` (repo-wide tooling), so open a
  **dedicated PR against `llm`** rather than folding it into #442; note in the PR
  body that it discharges the #442 review directive. Use your judgement if the
  fix is genuinely #442-local.
- Bot identity, standard PR-creation flow. Open DRAFT; the normal
  cleaner → judge → fixer-loop → un-draft gamut follows.
- After opening, the immediate #442 occurrence is fixed either by this PR (if it
  can touch daemon-cas cleanly) or flagged back so #442 folds the one-line fix.

## Verification

- `yarn lint` (which runs `lint:eslint`) at repo root **fails** on an
  extensionless relative JSDoc `@import` and **passes** once extensions are
  present — demonstrate both (a red run before, green after).
- New eslint-plugin test passes if a custom rule was authored.
- No unrelated lint regressions.

---
claim:
  host: endolinbot2
  gardener: 61
  claimed_at: 2026-07-01T00:17:11Z
