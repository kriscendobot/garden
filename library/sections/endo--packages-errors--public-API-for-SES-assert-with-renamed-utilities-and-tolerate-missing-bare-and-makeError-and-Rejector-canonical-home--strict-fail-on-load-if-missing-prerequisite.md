---
title: §Strict-fail-on-load-if-missing-prerequisite
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
if (globalAssert === undefined) {
  throw Error(
    `Cannot initialize @endo/errors, missing globalThis.assert, import 'ses' before '@endo/errors'`,
  );
}
```

§Fail-loud-not-degrade — same discipline as cycle 100 (makeRejectionHandlers) and cycle 216 (lal-transcript-memory-management). §Error-message-tells-the-user-what-to-do (*import 'ses' before '@endo/errors'*). §Borrowable-pattern: §when-a-module-depends-on-a-side-effect-from-another-module, §load-time-check-with-actionable-error-message.
