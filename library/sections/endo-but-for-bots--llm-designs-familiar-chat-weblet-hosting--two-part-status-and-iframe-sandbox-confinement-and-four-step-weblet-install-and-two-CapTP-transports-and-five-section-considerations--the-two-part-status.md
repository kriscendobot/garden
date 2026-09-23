---
title: §The-two-part-status
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

The opening §Status section has §two-part-shape:

> **Not yet implemented.** The Familiar-side infrastructure is ready (see `familiar-localhttp-protocol`):
> - `localhttp://` protocol handler serves weblet content with CSP confinement.
> - Navigation guard and exfiltration defenses are in place.
> - `preload.js` exposes `onSecurityWarnings` for the security warning banner.
>
> **Remaining work (all in `packages/chat/`):**
> - Weblet hosting panel UI...
> - MessagePort bridge...
> [...]

§Borrowable-pattern: §two-part-status (§Done-Elsewhere + §Remaining-Here) when a design §depends-on-predecessor-infrastructure-already-in-flight. §This-is-different-from-cycle-216's §Predecessor-section in §lal-transcript-memory-management — cycle 216 named §five-pieces-of-existing-infrastructure as inherited substrate; cycle 218 names §three-pieces-ready in a sibling design plus §five-pieces-remaining in this design's scope. §The-pattern-is-the-same-but-the-arrangement-is-different: §sibling-design-has-infrastructure-ready + §this-design-implements-the-consumer.

§Two-shapes-for-naming-predecessor-state:
1. cycle 216: §Predecessor section + §Existing-Infrastructure bullet list (parent-child relationship; parent is Complete; child is Not Started).
2. cycle 218: §Status section split into §Ready-in-sibling-design + §Remaining-here (peer relationship; sibling is Ready-but-not-this-design; this design is Not Started).

§Borrowable: §the-shape-of-the-Status-section-tracks-the-relationship-with-the-predecessor.
