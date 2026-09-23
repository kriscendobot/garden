---
title: "@endo/errors — §public-API-for-SES-assert + §Rejector-canonical-home + §hideAndHardenFunction-canonical-definition"
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

`@endo/errors` is the §public-import-surface for the SES `assert` substrate (cycle 98). 132-line `index.js` + 23-line `rejector.js` + small README. §The-load-bearing-purpose stated in the README:

> When host and guest programs share a JavaScript context, there is some risk that the guest will call a host function and induce it to throw an exception that inadvertently reveals information about its internal state to the guest. [...] For this reason, the `@endo/errors` package provides utilities for constructing errors with redacted messages.

§Redaction-as-a-cross-context-defense — the package §exists-because-information-leaks-between-host-and-guest-are-a-security-problem.
