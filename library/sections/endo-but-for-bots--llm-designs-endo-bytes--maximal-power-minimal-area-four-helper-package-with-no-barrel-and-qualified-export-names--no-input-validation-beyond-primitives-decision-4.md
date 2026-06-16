---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_path: designs/endo-bytes.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Designer (dispatched per kriskowal review)
topics:
  - tooling
  - patterns
  - pass-style
genre: §endo-but-for-bots-design
cycle: 172
lane: designs
status: current
title: §No-input-validation-beyond-primitives (Decision 4)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *Inputs are not validated beyond what the underlying
> primitives do; passing a non-`Uint8Array` to
> `concatBytes` will fault at the `.length` read or the
> `.set()` call. Adding a `passStyleOf`-style guard would
> add a `@endo/pass-style` dependency to a leaf utility
> package, which we want to avoid.*

§Leaf-utility-stays-leaf. §Don't-add-pass-style-dependency
because it would §inflate-the-dependency-graph for §a-leaf-
package-that-thousands-of-consumers-might-pull-in.

§Let-the-primitives-fault: §.length-on-non-array-is-
undefined; §.set-on-non-array-throws. §Native-errors-are-
informative-enough.

§Cycle-167-where/index.js does the same: §no-input-
validation-beyond-what-the-OS-API-provides.
