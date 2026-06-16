---
title: §Three named attack classes named explicitly
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

The Security section names **three attack classes** by name:

1. **§time-of-check/time-of-use attacks** (line 843) — prevented by immutability.
2. **§MIME confusion attacks** (line 855) — prevented by extension-based inference.
3. **§UI deception attacks** (line 865) — prevented by chrome/weblet barrier.
4. **§cross-weblet cookie/localStorage/DOM access** (line 876) — prevented by origin-isolation.
5. **§zip bombs** (line 882) — prevented by per-blob size limit.

§First-explicit-observation in library: **§named-attack-classes-as-named-threat-model-vocabulary — §five-named-attack-classes (TOCTOU + MIME-confusion + UI-deception + cross-origin-DOM + zip-bomb) + §each-class-IS-a-named-named-threat-the-design-defends-against + §the-design-IS-an-explicit-threat-model**.

§Sibling-pattern to cycle 259's three-named-non-exposures (Page interface) and cycle 261's three-named-non-exposures (HttpClient) — but here the attacks are named as well as the defenses.

§First-explicit-observation in library: **§the-attacks-named-as-well-as-the-defenses-IS-the-discipline-of-an-explicit-threat-model — §sibling-pattern to many security-engineering conventions**.
