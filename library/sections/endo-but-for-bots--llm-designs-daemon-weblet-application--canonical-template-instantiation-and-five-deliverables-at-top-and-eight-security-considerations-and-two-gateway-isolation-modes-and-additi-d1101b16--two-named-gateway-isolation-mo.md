---
title: §Two named gateway isolation modes — Mode A + Mode B
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

Lines 424-487 carry §two-named-gateway-isolation-modes with `A` and `B` labels:

- **Mode A: Virtual host on the unified server** — each weblet has a distinct hostname in the `Host` header (the access token).
- **Mode B: Dedicated port on 127.0.0.1** — each weblet has its own port.

§First-explicit-observation in library: **§two-named-gateway-isolation-modes-with-A-and-B-labels — §two-named-architectural-alternatives + §each-mode-IS-a-named-deployment-shape + §the-design-supports-both-not-just-one**.

§Both modes share the same security goal: §origin-isolation. §the-discipline-IS-modal-not-monolithic; §sibling-pattern to many systems with multiple deployment shapes (e.g., k8s deployment vs. statefulset).
