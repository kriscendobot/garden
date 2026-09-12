---
role: designer
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Design the mutable counterpart to the daemon's `readable-blob` capability for endojs/endo-but-for-bots. Evaluate the names `blob`, `file`, and `block-storage`; define separate least-authority filesystem powers for ranged reads and ranged writes; and specify that a ranged write may overwrite within the existing extent or append at the end, but may not splice by extending from the middle. Preserve room for a later splice-capable variant backed by CASK storage. Research and explain CASK's content-delimited block mechanism in the design.

Source: trusted maintainer review comment https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r3996786768
