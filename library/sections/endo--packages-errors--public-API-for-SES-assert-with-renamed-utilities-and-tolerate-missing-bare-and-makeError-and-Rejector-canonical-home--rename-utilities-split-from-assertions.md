---
title: §Rename-utilities-split-from-assertions
source-slug: endo--packages-errors
section-id: public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
url: https://github.com/endojs/endo/tree/master/packages/errors
authors: [Endo contributors]
repo: endojs/endo
path: packages/errors/{index.js,rejector.js,README.md}
status: shipping
ingest-cycle: 217
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-errors--public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
---

```js
const {
  bare: globalBare,
  details,
  error: globalError,
  Fail,
  makeAssert: _omittedMakeAssert,
  makeError: globalMakeError,
  note,
  quote,
  ...assertions
} = globalAssert;
```

§The-global-assert-mixed-assertions-and-utility-functions. §This-module-splits-them-apart. §The-rest-spread captures everything-not-named-above as the §assertion-functions; the named bindings are §utility-functions.

§Borrowable-pattern: §when-a-substrate-API-mixes-two-different-shapes, §split-them-in-the-public-API + §rename-as-needed-for-domain-readability. The §rest-spread-collects-everything-not-named is the §clean-way-to-discriminate.

§Omit-makeAssert pattern: `makeAssert: _omittedMakeAssert` extracts but does not re-export — §destructure-with-underscore-prefix-to-deliberately-discard.
