---
title: §"chrome/weblet barrier" — the named UI deception defense
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

Line 862-865:
> *Chrome/weblet barrier. The weblet close tab is rendered by Chat's host frame, above the iframe boundary. The weblet cannot obscure, relocate, or impersonate the close control. This prevents UI deception attacks where a weblet renders fake chrome to trick the user.*

§First-explicit-observation in library: **§the-chrome/weblet-barrier-as-named-UI-deception-defense — §the-close-tab-IS-rendered-by-the-host-frame-not-the-iframe + §the-weblet-cannot-obscure-relocate-or-impersonate-the-close-control + §the-discipline-IS-UI-trust-rooted-in-the-host-frame**.

§Three-named-things-the-weblet-cannot-do (obscure + relocate + impersonate); §the-discipline-IS-asymmetric: the-host-frame-CAN-render-above-the-iframe + the-iframe-CANNOT-render-above-the-host-frame.

§Sibling-pattern to OS-level window-manager conventions for trusted UI; §the-Chat-IS-the-trusted-window-manager-for-its-weblets.
