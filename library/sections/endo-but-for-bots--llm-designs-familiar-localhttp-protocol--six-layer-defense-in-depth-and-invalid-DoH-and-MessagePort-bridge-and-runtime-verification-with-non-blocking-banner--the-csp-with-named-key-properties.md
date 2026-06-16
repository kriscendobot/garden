---
title: §The-CSP-with-named-key-properties
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

```
default-src 'self';
script-src  'self' 'unsafe-inline' 'unsafe-eval';
connect-src 'self';
img-src     'self' data: blob:;
... (8 directives total)
```

§Key-properties-section pulls out §three-load-bearing-directives:

- `script-src 'unsafe-eval'` — §required-for-SES-lockdown's-eval-based-module-loader.
- `connect-src 'self'` — §the-network-confinement-mechanism (blocks all fetch / XHR / WebSocket / EventSource to non-self origins).
- `form-action 'self'` — §prevents-form-submissions-to-external-URLs.

§Borrowable-pattern: §don't-just-paste-the-config — §pull-out-the-load-bearing-lines + §name-the-reason-for-each.

§Chat-is-not-served-through-localhttp — §the-CSP-applies-only-to-weblet-iframes. §Two-different-trust-zones with §two-different-CSPs (Chat has its own; weblets get the restrictive one).
