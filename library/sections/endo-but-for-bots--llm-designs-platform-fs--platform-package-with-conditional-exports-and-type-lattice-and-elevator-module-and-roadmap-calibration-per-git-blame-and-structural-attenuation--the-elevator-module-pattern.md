---
title: §The-"elevator"-module pattern
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

`@endo/platform/fs/node` is the §elevator-module — §it-does-`import fs from 'node:fs'`-so-that-the-lite-module-never-has-to. The name *elevator* names the architectural role: §the-elevator-takes-platform-powers-up-to-the-platform-agnostic-layer-without-the-platform-agnostic-layer-knowing-the-platform.

§The-elevator-module as named architectural pattern. §When-a-platform-agnostic-module-needs-platform-powers, §define-an-elevator-module-that-does-the-platform-import-and-passes-powers-down + §dependency-injection-of-platform-powers-into-platform-agnostic-code. §First-explicit-observation of §the-elevator-module-as-named-architectural-pattern in library.

§Sibling-to-cycle-188's-`@endo/init/node-async-local-storage-patch.js` (a Node-specific module that patches a Node-specific shape so SES-locked-down code can use it portably) — §two-different-shapes-of-platform-bridge-discipline in library: §cycle-188's-monkey-patch-the-platform-shape + §cycle-242's-elevator-module-as-platform-import-isolator.
