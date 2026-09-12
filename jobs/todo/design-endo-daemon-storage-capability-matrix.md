---
role: designer
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Design and name the daemon capability matrix spanning readable views, immutable snapshots, and mutable forms of files/blobs and trees/directories. Make the distinct guarantees explicit: a read-only view attenuates write authority but may observe changes behind it, while a snapshot guarantees immutable captured content. Reconcile the terminology with existing `readable-blob`, `readable-tree`, and `readable-directory` formula names and identify an implementable migration path.

Source: trusted maintainer review comment https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r3996792043
