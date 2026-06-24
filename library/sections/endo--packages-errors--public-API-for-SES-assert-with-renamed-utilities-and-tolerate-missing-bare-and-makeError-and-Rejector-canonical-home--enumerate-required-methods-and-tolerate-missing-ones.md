---
title: §Enumerate-required-methods-and-tolerate-missing-ones
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
const missing = [
  'typeof', 'fail', 'equal', 'string', 'note', 'details',
  'Fail', 'quote',
  // 'bare',
  // 'makeError',
  'makeAssert',
].filter(name => globalAssert[name] === undefined);
if (globalAssert.makeError === undefined && globalAssert.error === undefined) {
  missing.push('makeError');
}
if (missing.length > 0) {
  throw Error(
    `Cannot initialize @endo/errors, missing globalThis.assert methods ${missing.join(', ')}`,
  );
}
```

§Two-comment-out-lines (`'bare'` and `'makeError'`) are §load-bearing-comments-not-decoration — they §encode-a-tolerance-for-an-older-SES. The §honest-acknowledgment-comment:

> As of 2025-07, the Agoric chain's bootstrap vat runs with a version of SES that predates addition of the 'bare' and 'makeError' methods, so we must tolerate their absence and fall back to other behavior in that environment (see below).

§Named-tolerance-for-a-specific-runtime-environment — sibling to:

| Cycle | Source | Compat hack |
| --- | --- | --- |
| 199 | nat | Apps-Script bigint-literal-workaround |
| 205 | evasive-transform | Babel-traverse default-import-workaround |
| 213 | stream-node | Node-14 unhandled-error-race-defense |
| 217 | errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |

§Four-different-runtime-version-or-environment-compat-hacks now in library. §The-pattern: §name-the-specific-environment-and-the-specific-missing-feature; §don't-pretend-it's-not-there.
