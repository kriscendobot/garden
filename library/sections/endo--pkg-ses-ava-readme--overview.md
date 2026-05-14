---
title: @endo/ses-ava (overview)
source: packages/ses-ava/README.md
source_repo: endojs/endo
source_commit: 2845b6bd385c185893f6c9267a946bed6c65bf37
source_date: 2025-10-29
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [testing, hardened-javascript]
status: current
---

> Abstract: @endo/ses-ava is an ava-compatible test framework wrapper that runs tests under a SES-locked-down environment. Provides the same ava t.is / t.throwsAsync API surface but inside a hardened JS realm, so tests exercise code in the same environment production runs in.

# `@endo/ses-ava`

*SES-AVA* wraps AVA `test` functions and initializes the SES-shim with options
suitable for debugging tests. This includes logging errors to the console with
- deep stacks of prior turns
- unredacted stack traces
- unredacted error messages

To use this module, in your AVA test files, replace

```js
import 'ses'; // or however you initialize the SES-shim
import test from 'ava';
```
with
```js
import test from '@endo/ses-ava/prepare-endo.js';
```
and add
```json
  "devDependencies": {
    // ...
    "@endo/ses-ava": "...", // for the current version of @endo/ses-ava
    // ...
  },
```
specifically to "devDependencies". @endo/ses-ava itself depends on AVA as
a regular dependency, so it you include @endo/ses-ava as a regular
dependency, bundlers might bundle your code with all of AVA.

SES-AVA rhymes with Nineveh.


Source: [packages/ses-ava/README.md](https://github.com/endojs/endo/blob/2845b6bd385c185893f6c9267a946bed6c65bf37/packages/ses-ava/README.md) at commit `2845b6bd`.
