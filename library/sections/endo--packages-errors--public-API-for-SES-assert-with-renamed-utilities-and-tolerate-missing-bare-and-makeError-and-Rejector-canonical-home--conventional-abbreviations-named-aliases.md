---
title: §Conventional-abbreviations + §named-aliases
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
export const b = bare;
export const X = details;
export const q = quote;

export const annotateError = note;
export const redacted = details;
export const throwRedacted = Fail;
```

§Two-different-naming-conventions-for-the-same-functions:

- §Conventional-abbreviations: `b` / `X` / `q` — §short-names-for-frequent-use-in-template-literals (e.g. `assert(x, X`bad value: ${q(x)}``)`).
- §Named-aliases: `annotateError` / `redacted` / `throwRedacted` — §domain-readable-names-for-prose-call-sites.

§Borrowable-pattern: §when-a-function-is-used-both-in-templates-and-in-prose, §export-it-under-two-names.
