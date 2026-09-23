---
title: §Destructure globalThis at top
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
const {
  ArrayBuffer,
  JSON,
  Object,
  Reflect,
  // eslint-disable-next-line no-restricted-globals
} = globalThis;
```

§Destructure-the-needed-globals-at-the-top-of-the-file with §eslint-disable-no-restricted-globals comment. §The-eslint-disable-comment-is-positioned-INSIDE-the-destructure-not-above-it — §the-disable-comment-attaches-to-the-closing-brace-line + §the-rule-applies-to-the-`} = globalThis` access. §When-a-project-has-no-restricted-globals-enforcement, §destructure-the-globals-at-module-load-and-disable-the-rule-with-an-inline-comment-at-the-access-site.

§Sibling-pattern-to-cycle-237's-`const { stringify: q } = JSON` (single global destructure) — §two-cycles-with-explicit-globalThis-destructure. §Cycle-237-destructured-from-JSON-without-eslint-comment; §cycle-245-destructures-from-globalThis-with-eslint-comment.

§The-`@endo/no-polymorphic-call`-eslint-disable on a different line — §two-different-named-eslint-disables in the same file. §Two-eslint-disables-with-distinct-named-justifications: §no-restricted-globals (canonical) + §no-polymorphic-call ("Allowing polymorphic calls because these occur during initialization"). §When-an-eslint-disable-is-applied, §provide-named-justification-in-the-comment-line-above.
