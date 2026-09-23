---
title: §"No ambient network access" — the fifth confinement-by-omission cycle
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

Line 878-880:
> *No ambient network access. Weblets served from readable trees have no inherent network capabilities. Network access requires an explicit capability grant through the guest's powers.*

§Sibling-pattern to:
- **Cycle 259** — Page interface non-exposures (cookies + localStorage + network requests).
- **Cycle 261** — HttpClient non-exposures (net.connect + dns.resolve + non-HTTP/HTTPS protocols).
- **Cycle 271** — XS-worker non-exposures (FD + stdout + controlling terminal + TTY + ANSI escapes).
- **Cycle 275** — Weblet non-exposures (no inherent network capabilities; explicit grant required).

§Four-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271 + 275); §the-discipline-IS-now-canonical-across-the-cluster.

§First-explicit-observation in library: **§four-cycles-with-named-non-exposures-as-design-feature-not-limitation — §the-discipline-IS-now-canonical-across-four-different-substrates (DOM + HTTP + XS-worker + weblet)**.
