---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-06T20:15:16Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1173 — REJECT (closed)

project: endojs-endo-but-for-bots

`@vitejs/plugin-react` 4.7.0 → 6.1.1 (major, 4→6) in `packages/chat` devDependency. Verdict **REJECT**, executed: PR **closed** 2026-09-06 with structured verdict comment (issuecomment-5561881939). Base ref `llm`.

**Why REJECT (not a maturity/advisory block):** plugin-react@6.x peer-requires `vite ^8.0.0` and imports the `vite/internal` subpath (vite-8-only export). `packages/chat` pins `vite ^6.0.0` → resolves `vite@6.4.2`, which has no `./internal` export. Chat build fails `ERR_PACKAGE_PATH_NOT_EXPORTED` loading `vite.config.js`. Real PR-caused failure: `browser-tests` green on base `llm`, red on head f507f3a2a7 (run 34056813344). Absorbing it requires a separate `vite 6→8` major migration of a *different* package — a project design decision outside this bump's scope (step-6 edges b/c), so not landed under a dep-bump commit.

**Transitive set:** bump *shrinks* the tree. Only new resolution: `@vitejs/plugin-react@6.1.1`. `@rolldown/pluginutils@1.0.1` already present (dedupes); `@babel/parser@7.29.3`/`@babel/traverse@7.29.0` same-version re-keys. v6 removes the Babel toolchain (`@babel/core`, jsx-transform plugins, `react-refresh@0.17.0`, `gensync`, `lru-cache`, `yallist`, `@types/babel__*`, old `@rolldown/pluginutils@1.0.0-beta.27`). No new package, no 24h-fresh version, no license change.

**Advisories (both sides):** none. OSV npm + GitHub advisory feed empty for outgoing 4.7.0 and incoming 6.1.1. No CVE forces the upgrade; staying on 4.7.0 leaves no known hole.

**Supply chain:** 6.1.1 published 2026-08-28 via npm trusted publishing (GitHub Actions OIDC, `trustedPublisher`) + SLSA attestation — a strengthening. Maturity floor 2026-09-04 already passed; maturity not the blocker.

Terminal verdict — no open ledger row, no recheck one-shot, no embargo. Reopen appropriate once `packages/chat` migrates to `vite ^8`.
