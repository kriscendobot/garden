---
title: Vite resolve.conditions, resolve.mainFields, and resolve.dedupe
source: docs/config/shared-options.md
source_repo: vitejs/vite
source_commit: 9beae37d7221b25463a011feb40b0303ca328d87
source_date: 2026-07-17
source_authors: [Vite documentation contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Vite's shared (client-side) resolution reads `package.json` through `resolve.conditions` (default `['module', 'browser', 'development|production']`, the `defaultClientConditions`), `resolve.mainFields` (default `['browser', 'module', 'jsnext:main', 'jsnext']`, the `defaultClientMainFields`), and `resolve.dedupe`. `exports` conditions take precedence: if an entry resolves from `exports`, `mainFields` is ignored entirely. `import`, `require`, and `default` are always applied on top of the configured conditions.

These options govern how Vite resolves a bare package import in its default (client) context; SSR overrides them (see the SSR-options section).

**`resolve.conditions`** — additional conditions matched against a package's `exports`. Default `['module', 'browser', 'development|production']` (`defaultClientConditions`). Conditions should be listed most-specific-first. `development|production` is a special token replaced with `production` when `process.env.NODE_ENV === 'production'`, else `development`. `import`, `require`, and `default` are *always* applied when their requirements are met, on top of the configured list; a `style` condition is added when resolving style imports (`@import 'my-library'`), plus `sass`/`less` for the respective preprocessors.

**`resolve.mainFields`** — the legacy entry chain, default `['browser', 'module', 'jsnext:main', 'jsnext']` (`defaultClientMainFields`). This takes **lower** precedence than conditional exports: if an entry point resolves from the `exports` field, `mainFields` is ignored.

**`resolve.dedupe`** — a list of dependency names Vite must always resolve to a single copy (from project root), a fix for duplicated copies from monorepo hoisting or linked packages. (Note: for SSR ESM build outputs from `build.rolldownOptions.output`, dedupe does not work; the documented workaround is CJS outputs.)

Source: [docs/config/shared-options.md](https://github.com/vitejs/vite/blob/9beae37d7221b25463a011feb40b0303ca328d87/docs/config/shared-options.md) at commit `9beae37`.
