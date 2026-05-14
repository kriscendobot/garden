---
title: Phases, downstream audit, and three design decisions
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments, tooling]
status: current
---

## Three S-sized phases

| Phase | Scope |
|---|---|
| **Phase 1 — Permits and sampling (S)** | Extend `packages/ses/src/permits.js` with entries for `TextEncoder` and `TextDecoder` on `universalPropertyNames`. Update the whitelist pass if any new shape is required. |
| **Phase 2 — Tests and changeset (S)** | Add the six test cases (see [[endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown]] § Test plan). Add a changeset under `.changeset/` describing the newly tamed intrinsics and the behavior on hosts without them. |
| **Phase 3 — Downstream audit (S)** | Grep the monorepo for `Buffer.from(` and `.toString('utf` in code that runs under SES. These call sites become candidates for migration to `TextEncoder` / `TextDecoder` per the project's *"prefer Uint8Array + TextEncoder/TextDecoder over Buffer"* convention. |

All three phases are sized **S**. The total surface is small because
the codecs have **no exposed iterator prototype** and **no static
ambient-authority methods** — the integration is *just permits +
tests*.

## The convention this design enables

Phase 3's grep target — `Buffer.from(` and `.toString('utf` —
implicitly names the codebase convention this design supports:
**prefer `Uint8Array` + `TextEncoder` / `TextDecoder` over Node's
`Buffer`** for code that runs under SES. Once the codecs are
permitted, SES code can portably do UTF-8 byte work without falling
back to the Node-specific `Buffer` global; the audit step in phase 3
is the migration sweep that follows.

## Design decisions

### 1. Universal, not start-only

> *`TextEncoder` and `TextDecoder` are powerless. They belong on
> `universalPropertyNames` (one identity-equal constructor across
> all compartments), unlike `URL` which needs an
> `initialGlobalPropertyNames` / `sharedGlobalPropertyNames` split to
> keep `createObjectURL` on the start compartment.*

This is the discriminating decision between this design and
[[endo-but-for-bots--llm-designs-hurl--integration-shared-vs-start]] —
URL had to land in the *initial* + *shared* split because its `URL`
constructor includes the powered `createObjectURL` static; the text
codecs do not, so the *universal* placement applies.

### 2. Tame inside SES, not as an external shim

> *Centralizing the permits avoids duplicating SES's whitelisting
> machinery in a per-package shim.*

The same discipline as hurl: keep the taming inside `packages/ses/`
rather than scattering per-intrinsic permit logic across consumer
packages. Per-package shims would have to re-implement the whitelist
walk on their own, with no shared invariant ensuring they agree.

### 3. No polyfill in this design

> *XS users continue to lack `TextEncoder` and `TextDecoder`. A
> separate polyfill design can layer cleanly on top when there is
> demand.*

The design explicitly defers the polyfill question. The shim handles
*presence on a host that provides the codecs*; the absence path
(XS) degrades gracefully. If a future design wants to add a JS
polyfill so XS gets the codecs too, it can land independently.

This decision matches the broader **shim vs polyfill split**
convention: a *shim* tames a host-provided intrinsic; a *polyfill*
provides an intrinsic the host lacks. SES already supports both
shapes, and the design space allows them to be designed and shipped
independently. See
[[endo-but-for-bots--llm-designs-hurl--problem-and-hazards]] for the
parallel discussion in the URL case (where the design also defers
polyfill).
