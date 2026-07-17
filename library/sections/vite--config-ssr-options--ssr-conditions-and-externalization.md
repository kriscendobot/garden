---
title: Vite SSR conditions and dependency externalization
source: docs/config/ssr-options.md
source_repo: vitejs/vite
source_commit: 01337adca3e588a88ec47ab1736e18db14d38237
source_date: 2026-06-08
source_authors: [Vite documentation contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: For SSR builds Vite swaps its client resolution for a server-oriented set: `ssr.resolve.conditions` defaults to `['module', 'node', 'development|production']` (`defaultServerConditions`) — `node` instead of the client's `browser` — and `ssr.resolve.externalConditions` defaults to `['node', 'module-sync']` for externalized imports. `ssr.external`/`ssr.noExternal` decide which dependencies are bundled versus left as runtime `require`s; by default all dependencies are externalized except linked ones.

Server-side rendering flips Vite's default resolution from browser-oriented to node-oriented:

**`ssr.resolve.conditions`** — the conditions applied to non-externalized dependencies during the SSR build. Default `['module', 'node', 'development|production']` (`defaultServerConditions`); for `ssr.target === 'webworker'` it uses the client `['module', 'browser', 'development|production']` instead. The key difference from client resolution is `node` in place of `browser`.

**`ssr.resolve.externalConditions`** — conditions used when Vite imports an *externalized* direct dependency during SSR (including `ssrLoadModule`). Default `['node', 'module-sync']`. To keep dev and build consistent, Node must be run with the same `--conditions` flag values in both.

**`ssr.external` / `ssr.noExternal`** — externalization is the decision to leave a dependency as a runtime import rather than bundling it. By default all dependencies are externalized except linked ones (kept internal for HMR). `ssr.external` (string list or `true`) forces externalization; `ssr.noExternal` (string/RegExp/list or `true`) forces bundling. Explicitly-listed `ssr.external` entries take priority over `ssr.noExternal`; if both are `true`, `ssr.noExternal` wins (nothing externalized). With `ssr.target: 'node'`, Node built-ins are externalized by default. `ssr.resolve.mainFields` defaults to `['module', 'jsnext:main', 'jsnext']` and, like the client, is ignored when `exports` resolves an entry.

Source: [docs/config/ssr-options.md](https://github.com/vitejs/vite/blob/01337adca3e588a88ec47ab1736e18db14d38237/docs/config/ssr-options.md) at commit `01337ad`.
