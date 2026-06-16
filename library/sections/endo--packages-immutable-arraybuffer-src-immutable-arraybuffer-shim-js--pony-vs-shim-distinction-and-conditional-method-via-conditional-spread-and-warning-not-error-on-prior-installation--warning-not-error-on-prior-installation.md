---
title: §Warning-not-error on prior installation
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

```js
const overwrites = ownKeys(arrayBufferMethods).filter(
  key => key in arrayBufferPrototype,
);
if (overwrites.length > 0) {
  console.warn(
    `About to overwrite ArrayBuffer.prototype properties ${stringify(overwrites)}`,
  );
}
```

§Modern-shim-practice-frowns-on-conditional-installation. §The-comment-block-explains-why:

> Modern shim practice frowns on conditional installation, at least for proposals prior to stage 3. This is so changes to the proposal since an old shim was distributed don't need to worry about the proposal breaking old code depending on the old shim. Thus, if we detect that we're about to overwrite a prior installation, we simply issue this warning and continue.

§Warning-not-error-on-prior-installation as named modern-shim discipline. §The-shim-installs-unconditionally-with-a-warning + §the-warning-IS-the-diagnostic-but-not-a-blocker. §When-a-shim-might-overwrite-a-prior-installation, §warn-but-don't-fail + §the-warning-IS-the-evidence-of-the-overwrite.

§First-explicit-observation in library of §warning-not-error-on-prior-installation as modern-shim discipline. §Sibling-to-cycle-237's-`Beware`-prefix-marks-actionable-warning — §two-different-shapes-of-warning-discipline. §Cycle-237's-Beware-prefix-marks-the-comment + §cycle-245's-console.warn-IS-the-runtime-diagnostic.
