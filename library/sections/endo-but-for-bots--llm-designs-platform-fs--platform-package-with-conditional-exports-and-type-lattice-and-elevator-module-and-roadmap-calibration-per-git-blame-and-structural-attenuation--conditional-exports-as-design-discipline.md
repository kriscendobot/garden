---
title: §Conditional-exports as design discipline
source-slug: endo-but-for-bots--llm-designs-platform-fs
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/platform-fs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/platform-fs.md
total-lines: 787
ingest-cycle: 242
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation
---

The package's `package.json` defines §three-exports — `./fs`, `./fs/lite`, `./fs/node` — with the `"node"` condition gating `./fs`. §`@endo/platform/fs` resolves via the `"node"` condition (a bundler targeting `"browser"` would get a different implementation or an error). §`@endo/platform/fs/lite` is always platform-agnostic. §`@endo/platform/fs/node` is the explicit-request bypass that ignores condition resolution.

§Three-export-paths-with-one-condition-gate: §the-default-path-condition-gated + §the-lite-path-always-available + §the-explicit-platform-path-bypasses-condition-resolution. §When-a-package-must-work-on-multiple-platforms-but-default-to-one, §provide-three-export-paths-not-one + §make-the-lite-subset-always-available + §reserve-future-platform-paths-in-the-package.json-comment ("Future: browser, endo-go, endo-rust").

§`@endo/platform/fs/node` re-exports everything from `@endo/platform/fs/lite` plus the Node.js-specific factories. So §the-condition-gated-default-IS-a-superset-of-the-lite-module. §Superset-by-construction.
