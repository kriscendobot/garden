---
title: §Library scope
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

The package is the public-API-surface for the SES error/assert substrate. §What-other-cycles-import-from-here:

- §`hideAndHardenFunction` — used by cycles 102, 134, 138, 142, 148.
- §`Rejector` typedef — used by cycles 102, 104, 110, 115, 120, 123, 125, 127, 150.
- §`Fail` / `q` / `X` / `b` — used everywhere assertions are thrown.
- §`assert` / `annotateError` / `note` — used in @endo/marshal, @endo/pass-style, @endo/patterns.

§This-is-the-package-that-makes-the-Rejector-and-hideAndHardenFunction-disciplines-portable. §The-disciplines-themselves-live-in-this-file; §the-application-of-them-lives-everywhere-else.
