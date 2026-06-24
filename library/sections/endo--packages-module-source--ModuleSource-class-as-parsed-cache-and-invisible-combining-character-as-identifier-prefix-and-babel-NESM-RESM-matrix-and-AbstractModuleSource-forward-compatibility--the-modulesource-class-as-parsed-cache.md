---
title: §The-ModuleSource-class as parsed-cache
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
---

The class captures the result of one Babel parse + analyze, so the cache can be shared across Compartments:

> ModuleSource captures the effort of parsing and analyzing module text so a cache of ModuleSources may be shared by multiple Compartments.

§Borrowable-pattern: §parsed-result-as-shareable-cache-across-compartments. §Sibling to cycle 221 @endo/bundle-source's §SHA-512-content-addressed-source-map-cache — both designs §cache-parsed-or-derived-data; cycle 221 caches by content-hash + filesystem; cycle 223 caches in-memory by reference.

### §Class-constructor-must-be-invoked-with-`new`

```js
if (new.target === undefined) {
  throw TypeError(
    "Class constructor ModuleSource cannot be invoked without 'new'",
  );
}
```

§The-constructor-guard-against-being-called-as-a-function. §Borrowable-pattern: §explicit-`new.target`-check + §TypeError-named-with-class-name + §the-error-mentions-`new`-explicitly. §A-`function`-declaration-can-be-called-without-`new`-with-undefined-this; §this-check-catches-the-mistake-with-a-clear-message.

§Sibling to cycle 222 endoclaw-skill-registry's §discriminated-union-via-key-presence — both designs §catch-the-mistake-early-with-a-clear-error.

### §Two-form-of-options with normalization

```js
if (typeof opts === 'string') {
  opts = { sourceUrl: opts };
}
```

§Single-line-normalization at the top of the constructor. §The-shorthand (`new ModuleSource(source, 'url.js')`) §is-equivalent-to-the-long-form (`new ModuleSource(source, { sourceUrl: 'url.js' })`). §Borrowable-pattern: §when-the-most-common-option-is-a-string, §accept-it-as-shorthand-and-normalize.

§Sibling to cycle 215 @endo/hex's §name-for-error-diagnostics-parameter — both designs §a-common-second-argument-can-be-passed-as-a-bare-string.
