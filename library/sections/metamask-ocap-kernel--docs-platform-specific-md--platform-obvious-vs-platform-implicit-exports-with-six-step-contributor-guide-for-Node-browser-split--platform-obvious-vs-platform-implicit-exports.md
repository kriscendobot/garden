---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Platform-obvious-vs-platform-implicit-exports
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *Platform-obvious exports: Modules like `kernel-store/
> sqlite/nodejs` clearly target Node.js environments.
> Platform-implicit exports: Modules like `kernel-store/
> sqlite/wasm` target browser environments through
> WebAssembly.*

§The-naming-convention-tells-platform. Two flavors:

- **§Obvious**: the path segment says `nodejs` or `browser`.
- **§Implicit**: the path segment says the *mechanism*
  (`wasm`) — readers infer the platform.

§Mechanism-named-not-platform-when-platform-is-implied.
§Reader-must-know-WASM-implies-browser — there's a §reader-
literacy-prerequisite. The doc explicitly calls this out,
which is §discipline-by-disclosure.

§Synthesis-target: Endo's per-package conditional exports
(via `package.json` `"browser"` field or similar) hide the
platform choice from the reader; this naming convention
exposes it. §Surface-the-choice-don't-hide-it could be
borrowed.
