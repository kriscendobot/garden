---
title: §Resource-module property revisited
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

The package's §share-the-console-channel-with-SES property is what makes it §a-resource-module:

- Assertions thrown via `Fail`/`assert` are §redacted-in-the-thrown-error-message but §revealed-in-the-developer-console (via cycle 90's track-turns + cycle 93's stack-trace taming + cycle 96's causal-console + cycle 98's assert.js loggedErrorHandler bridge).
- §Two-channels-for-two-audiences: §thrown-Error-for-the-caller (redacted) + §console-log-for-the-debugger (full).

§Borrowable-pattern: §security-vs-diagnostic-tension resolved by §two-channels-with-different-trust-levels. The §debugger-channel-is-the-privileged-side; §the-thrown-error-is-the-untrusted-side.
