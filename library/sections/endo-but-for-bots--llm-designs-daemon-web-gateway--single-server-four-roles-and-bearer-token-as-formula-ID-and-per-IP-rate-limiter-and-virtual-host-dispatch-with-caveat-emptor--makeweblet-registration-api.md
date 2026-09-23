---
title: §makeWeblet registration API
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

```js
makeWeblet(webletBundle, webletPowers, requestedPort, webletId, webletCancelled)
// Returns: Far('Weblet', { getLocation, stopped })
```

§Five-named-parameters + §two-named-return-fields. §getLocation-returns-mode-dependent-URL (localhttp:// in unified mode; http://...:port/... in dedicated-port mode).

§Borrowable-pattern: §the-registration-API-doesn't-prescribe-the-mode + §the-implementation-returns-the-URL-form-that-applies. §The-caller-doesn't-need-to-care-which-mode-it-got.
