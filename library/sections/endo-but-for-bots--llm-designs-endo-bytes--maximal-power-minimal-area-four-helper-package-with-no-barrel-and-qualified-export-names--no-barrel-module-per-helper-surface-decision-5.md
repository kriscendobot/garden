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
title: §No-barrel-module-per-helper-surface (Decision 5)
parent: endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names
---

> *Each export gets its own surface module at the package
> root, which re-exports from the matching implementation
> file under `src/`. Consumers import from `@endo/bytes/
> <helper>.js` directly.*

§No-index.js-aggregate. §No-root-export. §Per-helper-
surface-module.

§Why-no-barrel:

1. §Tree-shaking-friendliness: a consumer importing only
   `concatBytes` doesn't drag in `bytesFromText`'s
   TextEncoder allocation.
2. §Per-helper-surface-area-is-easy-to-audit.
3. §The-discipline-kriskowal-asked-for-during-PR-142-
   implementation-review.

§Each-surface-module-is-a-thin-re-export (one line):

```js
// packages/bytes/concat.js
export { concatBytes } from './src/concat.js';
```

§Synthesis-target: future utility packages can follow §per-
helper-surface-without-barrel pattern.
