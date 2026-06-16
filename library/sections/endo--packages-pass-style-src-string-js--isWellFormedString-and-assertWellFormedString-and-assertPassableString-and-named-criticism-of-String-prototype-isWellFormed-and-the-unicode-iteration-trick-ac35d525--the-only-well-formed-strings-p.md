---
title: §The ONLY_WELL_FORMED_STRINGS_PASSABLE environment option
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
---

Lines 57-60:
```js
const ONLY_WELL_FORMED_STRINGS_PASSABLE =
  getEnvironmentOption('ONLY_WELL_FORMED_STRINGS_PASSABLE', 'disabled', [
    'enabled',
  ]) === 'enabled';
```

§The-runtime-toggle-pattern — §a-named-environment-option + §a-default-value + §a-named-set-of-allowed-non-default-values; §sibling-pattern to cycle 130's `@endo/env-options` from `ENDO_SEND_BREAKPOINTS` and related options.

§`getEnvironmentOption`-third-argument-IS-the-allowed-non-default-values-list — §the-function-IS-strict-about-recognized-values + §typos-are-rejected-at-load-time; §sibling-pattern to enum-like type narrowing at runtime.

§First-explicit-observation in library: **§the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list — §sibling-pattern to cycle 130's message-breakpoints env-option discipline**.
