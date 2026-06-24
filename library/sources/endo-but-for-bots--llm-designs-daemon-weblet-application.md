---
title: "daemon-weblet-application.md — Weblet Applications from Zip Archives (additive template extension)"
source-slug: endo-but-for-bots--llm-designs-daemon-weblet-application
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-weblet-application.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-weblet-application.md
total-lines: 985
ingest-cycle: 275
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `daemon-weblet-application.md`

A 985-line design (Status Not Started; Created 2026-02-25). **Introduces additive template extension as a named deviation shape** — adds five extra sections beyond the canonical-template's seven (Security + Scaling + Test Plan + Compatibility + Upgrade Considerations). §Three-cycles-with-template-deviation-in-the-cluster (263 subtractive-fragment + 273 subtractive-guide + 275 additive-extension).

## Key moves

- **§The design adds five extra sections beyond the canonical template** — Security Considerations + Scaling Considerations + Test Plan + Compatibility Considerations + Upgrade Considerations; §three-named-template-deviation-shapes (subtractive-fragment + subtractive-guide + additive-extension).
- **§Five numbered deliverables enumerated at the top of the Problem Statement** — formula for readable tree + zip extraction operation + formula for weblet + gateway integration + chat and CLI verbs.
- **§Explicit Prerequisites section naming required merges or prior work** — `kriskowal-zip-compression` branch named as required-merge prerequisite.
- **§Named branch as prerequisite** — the design names a named git branch (not just a prior design).
- **§Two named gateway isolation modes with A and B labels** — Mode A (virtual host on unified server) + Mode B (dedicated port on 127.0.0.1).
- **§Eight numbered Security Considerations** — the richest Security section ingested.
- **§Named attack classes as named threat-model vocabulary** — TOCTOU + MIME-confusion + UI-deception + cross-origin-DOM + zip-bomb.
- **§The attacks named as well as the defenses** — the discipline of an explicit threat model.
- **§The chrome/weblet barrier as named UI deception defense** — *"The weblet cannot obscure, relocate, or impersonate the close control"*.
- **§Four cycles with named non-exposures as design feature not limitation** (259 Page + 261 HttpClient + 271 XS-worker + 275 weblet) — the discipline now canonical across four different substrates.
- **§Two named formula types introduced by one design** — readable-tree + readable-tree-weblet.
- **§Six named sub-sections per formula type** — Formula-shape + Incarnated-interface + What-is-absent + help() + Relationship-to-EndoDirectory + Relationship-to-the-capability-filesystem.
- **§A `#### What is absent` sub-section** as named design discipline.
- **§Two named CapTP transports with primary and fallback shape** — MessagePort (iframe primary) + WebSocket (external browser fallback).
- **§CLI verb naming IS shell-friendly concise** — `mkweblet` instead of `make-weblet-application`; UNIX convention sibling.
- **§Explicit Affected packages section** — five packages enumerated.
- **§The `## Maybe` section as named place for tentative test items**.

## Section files

- [§Canonical template instantiation + §five deliverables at top + §eight Security Considerations + §two gateway isolation modes + §additive template extension](../sections/endo-but-for-bots--llm-designs-daemon-weblet-application--canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension.md) — structural pattern observations (985-line file ingested in pattern-scope).

## Ingest scope

Cycle 275 (designs-lane after cycle 274's chat-lane iter-helpers.js). 985-line file ingested in pattern-scope. **First-explicit-observations (twelve plus secondary)**: the-design-adds-five-extra-sections-beyond-the-canonical-template + three-named-template-deviation-shapes + five-numbered-deliverables-at-the-top + explicit-Prerequisites-section + named-branch-as-prerequisite + two-named-gateway-isolation-modes-with-A-and-B-labels + eight-numbered-Security-Considerations + named-attack-classes-as-named-threat-model-vocabulary + the-attacks-named-as-well-as-the-defenses + the-chrome/weblet-barrier-as-named-UI-deception-defense + two-named-formula-types-introduced-by-one-design + six-named-sub-sections-per-formula-type. Plus: a-`#### What is absent`-sub-section + two-named-CapTP-transports + CLI-verb-naming-IS-shell-friendly-concise + explicit-Affected-packages-section + the-`## Maybe`-section.
