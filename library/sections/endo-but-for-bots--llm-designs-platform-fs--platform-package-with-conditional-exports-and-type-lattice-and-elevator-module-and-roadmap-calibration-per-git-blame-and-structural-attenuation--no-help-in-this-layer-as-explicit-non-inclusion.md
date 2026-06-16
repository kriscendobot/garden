---
title: §No-help()-in-this-layer as explicit non-inclusion
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

§Design-Decision-5: §No-help()-in-this-layer. *`help()` is a daemon convention for LLM discoverability. `@endo/platform/fs` provides the raw interfaces; the daemon wraps them with `help()` when constructing Exos for guest consumption.*

§Layer-discipline-via-explicit-non-inclusion. §When-a-convenience-method-belongs-to-a-higher-layer, §the-lower-layer-explicitly-says-no + §names-the-higher-layer + §names-the-wrapping-mechanism. §Sibling-to-cycle-238's-`endo store` does-not-accept-stdin-in-non-zip-mode (both designs make an explicit *we-do-not-include-this* decision with the reason named).

§Two-cycles-with-explicit-non-inclusion-of-a-conventional-method (cycles 238 + 242). §When-a-design-decides-not-to-include-something-conventional, §the-decision-IS-load-bearing + §name-it-explicitly-with-the-layer-or-reason.
