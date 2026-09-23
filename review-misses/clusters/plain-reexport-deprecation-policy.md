---
slug: plain-reexport-deprecation-policy
category: packaging-exports
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-1c83e1bb
prs: [475]
---

A plain backward-compatibility re-export (`export { orig as alias } from '…'`) is authored instead of deprecating the alias and migrating importers to the original export; the endo re-export policy (deprecate plain re-exports, point importers at the source) is not encoded in any seat brief, skill, or gate.
