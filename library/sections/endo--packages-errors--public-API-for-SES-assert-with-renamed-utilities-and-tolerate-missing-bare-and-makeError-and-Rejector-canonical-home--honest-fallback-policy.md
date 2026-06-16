---
title: §Honest-fallback-policy
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
const bare = globalBare || quote;
const makeError = globalMakeError || globalError;
```

§Two-named-fallbacks for the §missing-in-pre-1.13.0-SES case. §The-comment-pinpoints-the-fallback:

> As of 2025-07, the Agoric chain's bootstrap vat runs with a version of SES that predates the addition of the 'bare' and 'makeError' methods, so we must fall back to 'quote' for the former and 'error' for the latter.

§Named-runtime-compat-fallback. §The-fallback-is-honest-not-silent (the comment names it explicitly).
