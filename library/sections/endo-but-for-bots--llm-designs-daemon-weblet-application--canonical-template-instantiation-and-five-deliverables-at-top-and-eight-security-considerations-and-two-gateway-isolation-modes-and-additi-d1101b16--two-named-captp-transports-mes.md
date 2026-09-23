---
title: §Two named CapTP transports — MessagePort + WebSocket fallback
source-slug: endo-but-for-bots--llm-designs-daemon-weblet-application
section-slug: canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-weblet-application.md
source-repo: endojs/endo-but-for-bots
source-path: designs/daemon-weblet-application.md
source-author: Kris Kowal (prompted)
total-lines: 985
ingest-cycle: 275
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-daemon-weblet-application--canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension
---

Lines 565-633 carry §two-named-CapTP-transports:

- **Primary**: MessagePort (iframe-to-host communication; transferred from Chat).
- **Fallback**: WebSocket (external browser; for weblets opened outside Chat).

§First-explicit-observation in library: **§two-named-CapTP-transports-with-primary-and-fallback-shape — §the-design-supports-both-the-iframe-case-and-the-external-browser-case + §the-discipline-IS-graceful-degradation**.

§Sibling-pattern to many systems with primary+fallback transports.
