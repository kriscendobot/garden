---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-10-15T13:28:39Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-3
claim: b3a15fac5edf7bdc
---
PR #1392, base origin/build/sturdyref-ses-accommodation-a10a201.

**Verdict:** approve

**Findings:**
- No curator findings. The public `@endo/pass-style` surface adds `parcel` to `PassStyle`, adds `ParcelObject` through its existing type re-export, and admits it to `Passable`; the `major` changeset correctly communicates this exhaustive-union break. The patch changes in `@endo/marshal`, `@endo/parcel`, and `@endo/patterns` do not add or rename entry-point exports.

Self-improvement: nothing this time.
