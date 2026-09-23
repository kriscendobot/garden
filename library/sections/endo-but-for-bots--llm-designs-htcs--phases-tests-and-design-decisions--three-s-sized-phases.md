---
title: Three S-sized phases
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments, tooling]
status: current
parent: endo-but-for-bots--llm-designs-htcs--phases-tests-and-design-decisions
---

| Phase | Scope |
|---|---|
| **Phase 1 — Permits and sampling (S)** | Extend `packages/ses/src/permits.js` with entries for `TextEncoder` and `TextDecoder` on `universalPropertyNames`. Update the whitelist pass if any new shape is required. |
| **Phase 2 — Tests and changeset (S)** | Add the six test cases (see [[endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown]] § Test plan). Add a changeset under `.changeset/` describing the newly tamed intrinsics and the behavior on hosts without them. |
| **Phase 3 — Downstream audit (S)** | Grep the monorepo for `Buffer.from(` and `.toString('utf` in code that runs under SES. These call sites become candidates for migration to `TextEncoder` / `TextDecoder` per the project's *"prefer Uint8Array + TextEncoder/TextDecoder over Buffer"* convention. |

All three phases are sized **S**. The total surface is small because
the codecs have **no exposed iterator prototype** and **no static
ambient-authority methods** — the integration is *just permits +
tests*.
