---
title: §Type-lattice as 2×3 axis table
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

The §central-design-challenge is distinguishing §three-roles-an-object-can-play (Readable / Snapshot / Mutable) along §two-axes (Blob / Tree):

```
                     Blob                          Tree
                ┌─────────────┐             ┌──────────────┐
  Mutable       │    File     │             │   Directory   │
  Readable      │ ReadableBlob│             │ ReadableTree  │
  Snapshot      │ SnapshotBlob│             │ SnapshotTree  │
```

§Six-named-types in a §2x3-axis-table (3 roles × 2 kinds). §The-type-lattice-IS-the-design-vocabulary. §Sibling-to-cycle-236's-three-axis-table (Method × Source × Confinement) and cycle-241's-2x3-axis-table-for-handler-protocol — §three-cycles-with-axis-tables-as-design-vocabulary (cycles 236 + 241 + 242).

§Snapshot-extends-Readable: §a-SnapshotBlob-IS-A-ReadableBlob (has all read methods plus `sha256()`). §The-extends-relationship-is-structural-subtyping-enforced-by-interface-guards. §When-a-content-addressed-type-IS-a-readable-type-plus-an-identity-method, §use-extends-not-a-new-shape.

§Mutable-attenuates-to-Readable via `readOnly()`: §A-File-can-produce-a-ReadableBlob-via-readOnly + §A-Directory-can-produce-a-ReadableTree-via-readOnly. §The-attenuation-is-structural-not-behavioral: §the-returned-object-simply-lacks-mutation-methods-not-has-them-throw.

§Structural-attenuation-not-behavioral-attenuation as named design discipline. §Sibling-to-cycle-238's-the-controller-and-client-cap-split (both designs choose structural attenuation: the readable view simply omits write methods rather than including them as throw-stubs). §Two-cycles-with-explicit-structural-attenuation-discipline (cycles 238 + 242).
