---
title: §Eight numbered Security Considerations — the richest Security section ingested
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

Lines 838-886 carry **eight numbered Security Considerations**:

1. **Readable trees are immutable** — prevents §time-of-check/time-of-use attacks.
2. **Path traversal prevention** — single-segment-name + multi-segment-lookup-chain via `E()`; §no-path-string-parsing-discipline.
3. **Content type inference is conservative** — unknown extensions → `application/octet-stream` (browsers won't execute as script); §inferred-by-extension-only-no-content-sniffing-to-avoid-MIME-confusion-attacks.
4. **Guest isolation** — `NONE` power level for fully sandboxed weblet.
5. **Chrome/weblet barrier** — close tab rendered by Chat's host frame above the iframe; prevents §UI-deception-attacks.
6. **MessagePort CapTP isolation** — MessagePort transferred from Chat to iframe; weblet cannot discover other weblets' ports.
7. **Origin isolation** — distinct hostname (Mode A) OR distinct port (Mode B); prevents §cross-weblet-cookie-localStorage-and-DOM-access.
8. **No ambient network access** — weblets have no inherent network capabilities; explicit-capability-grant-discipline.
9. **Zip bomb mitigation** — per-blob size limit + bounded by finite number of entries in the archive.

§First-explicit-observation in library: **§eight-numbered-Security-Considerations — the-richest-Security-section-cycle-ingested + §each-consideration-IS-a-named-attack-class-and-named-defense + §the-section-IS-the-design's-threat-model-record**.

§Sibling-pattern to cycle 269's eleven Design Decisions + cycle 271's ten Design Decisions; §three-cycles-with-numbered-rationale-sections-of-comparable-depth (269 + 271 + 275); §each-design-NAMES-its-attack-classes-and-defenses-as-numbered-items.
