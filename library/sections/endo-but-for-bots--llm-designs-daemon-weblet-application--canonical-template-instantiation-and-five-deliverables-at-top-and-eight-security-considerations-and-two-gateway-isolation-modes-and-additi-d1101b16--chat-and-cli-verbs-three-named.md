---
title: §Chat and CLI verbs — three named verbs
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

Lines 634-795 introduce §three-named-CLI/Chat-verbs:

1. **`mkweblet`** (lines 641-704) — creates the full chain (handle + guest + content + weblet).
2. **`open`** (lines 705-774) — opens the weblet in an iframe.
3. **Host interface additions** (lines 776-795) — new methods on the host interface.

§the-verbs-IS-named-with-shell-friendly-conciseness (`mkweblet` not `make-weblet-application`); §the-discipline-IS-CLI-ergonomic + §the-cluster-has-similar-conciseness-discipline-elsewhere.

§First-explicit-observation in library: **§CLI-verb-naming-IS-shell-friendly-concise (`mkweblet` instead of `make-weblet-application`) — §sibling-pattern to UNIX conventions (`mkdir` not `make-directory`)**.
