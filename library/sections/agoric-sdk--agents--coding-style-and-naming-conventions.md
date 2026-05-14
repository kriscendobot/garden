---
title: Coding Style & Naming Conventions
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, typescript-conventions, capability-security]
status: current
notes: The `@agoric/*` vs `@aglocal/*` namespace rule is a published-vs-internal boundary that capability-conscious refactors need to respect. The `performance.now() vs Date.now()` rule is repeated across the agoric-sdk corpus. The ambient-authority discipline (keep ambient I/O in entrypoints, pass capabilities into modules) is the same principle codified more generally in endo--pkg-ses-docs-secure-coding-guide.
---

> Abstract: ESM-by-default JS+TS targeting Node ^20.9 or ^22.11. dprint enforces Prettier-compatible formatting (single quotes, trailing commas). ESLint via `eslint.config.mjs`. Crucial naming distinction: `@agoric/*` packages are publishable and may not import `@aglocal/*` packages (which are private). For duration measurement prefer `performance.now()`; reserve `Date.now()` for wall-clock semantics (timestamps, IDs, protocol deadlines). Ambient-authority discipline: confine `process.env`, `console`, filesystem, network to entrypoints; pass capabilities (e.g., `io.console`) explicitly into shared modules; never call `@endo/init` inside a module (only at an entrypoint's start).

## Coding Style & Naming Conventions
- ESM by default; JS and TypeScript both used. Target Node ^20.9 or ^22.11.
- dprint enforced (Prettier-compatible options include single quotes and trailing commas).
- ESLint configured via `eslint.config.mjs` (includes AVA, TypeScript, JSDoc, and repository-specific rules).
- Package names: publishable packages use `@agoric/*`; private/local packages use `@aglocal/*` (verify with `yarn lint:package-names`).
- `@aglocal` packages are private and never published; `@agoric` packages are published and may only depend on published packages, so `@agoric` packages must never import `@aglocal` packages.
- For elapsed duration measurement (benchmarks, latency logs, monotonic timeout windows), prefer `performance.now()` over `Date.now()`. Use `Date.now()` for wall-clock timestamps, IDs, and protocol deadlines.
- Entrypoints vs modules
    - Keep ambient authority (e.g., `process.env`, `console`, filesystem, network) in entrypoints
    - pass explicit capabilities (e.g., `io.console`) into shared JS modules.
    - Never `@endo/init` in modules; best practice is at the beginning of an entrypoint

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
