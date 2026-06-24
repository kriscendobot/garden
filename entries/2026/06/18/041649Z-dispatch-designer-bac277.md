---
ts: 2026-06-18T04:16:49Z
kind: dispatch
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/designer--bac277
short_id: bac277
refs:
  - entries/2026/06/18/040719Z-dispatch-researcher-1f66eb.md
  - entries/2026/06/18/041346Z-result-researcher-1f66eb.md
---

# dispatch: designer — fs-interface-reconciliation (researcher-refined)

Researcher 1f66eb refined the prompt. Headline finding:
prior work is TWO designs, not one:
1. `designs/daemon-capability-filesystem.md` (cycle 170;
   966-line Reference vision; three-layer + four-backends).
2. `designs/platform-fs.md` (cycle 242; lands canonical
   2×3 type lattice — Readable/Snapshot/Mutable × Blob/Tree;
   exports interfaces from `packages/platform/src/fs/
   interfaces.js`).

**The new design is the future-VFS-layer that platform-fs
explicitly defers to** (per its §Relationship-to-existing-
interfaces section).

Most of the method catalog is already named on
`MountInterface` (`has, list, lookup, write, remove, move,
makeDirectory, readOnly, snapshot, help`). Designer adopts
these names or supersedes with migration map — does NOT
parallel-derive.

Open library gaps surfaced: no dedicated section for
`@endo/endo-fs` package (scattered keyword pointers only);
no concept page for `name-hub-as-vfs-backing` or
`endo-directory-as-vfs-backing`. Library writeback queued.

Base llm. DRAFT PR.
