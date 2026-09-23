---
title: §Resource-module disclaimer
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

The opening comment names the package's place in the SES dependency stack:

> This module assumes the existence of a non-standard `assert` host object. SES version 0.11.0 introduces this global object and entangles it with the `console` host object in scope when it initializes [...] To the extent that this `console` is considered a resource, this module must be considered a resource module.

§Resource-module-discipline — the package's import order matters; it transitively depends on `globalThis.assert` being installed by SES first; the §entanglement-with-console gives the package §the-power-to-hide-details-from-guests-but-reveal-them-to-the-debugger-console.
