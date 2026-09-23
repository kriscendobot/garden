---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §simplifyTag idiom and the *only-the-outer-one-removed*
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

rule

The §`simplifyTag(tag)` function strips a leading `'Alleged: '` or
`'DebugName: '` prefix:

```js
const simplifyTag = tag => {
  for (const prefix of ['Alleged: ', 'DebugName: ']) {
    if (tag.startsWith(prefix)) {
      return tag.slice(prefix.length);
    }
  }
  return tag;
};
```

The §JSDoc names the §explicit-non-recursion behavior: *If there
are multiple such prefixes, only the outer one is removed.* The
*one-level-strip* discipline — a tag like `'Alleged: Alleged: moola
issuer'` becomes `'Alleged: moola issuer'`, not `'moola issuer'`.

The §setBreakpoints validation *enforces canonical simple tags*:

```js
tag === simplifyTag(tag) ||
  Fail`Just use simple tag ${q(simplifyTag(tag))} rather than ${q(tag)}`;
```

The §don't-pass-in-already-prefixed-tag discipline pushes the
prefix-stripping responsibility to *the configuration time*, not
*the per-call match time*. The user must provide *simple tags*; if
they pass `'Alleged: foo'`, the error message tells them exactly
what to use instead (`'foo'`).
