---
title: §Privileged-scheme-registration with §four-named-privileges
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

```js
protocol.registerSchemesAsPrivileged([
  {
    scheme: 'localhttp',
    privileges: {
      standard: true,       // URL parsing like http (host, path, query)
      secure: true,         // access to secure-context APIs (crypto.subtle, etc.)
      supportFetchAPI: true,// fetch() from renderer to this scheme
      corsEnabled: true,    // CORS requests within the scheme
    },
  },
]);
```

§Each-privilege-named-with-purpose. §Borrowable-pattern: §when-an-API-takes-an-options-bag-of-booleans, §the-design-document-names-each-one-with-its-purpose so future readers understand the trade-off.
