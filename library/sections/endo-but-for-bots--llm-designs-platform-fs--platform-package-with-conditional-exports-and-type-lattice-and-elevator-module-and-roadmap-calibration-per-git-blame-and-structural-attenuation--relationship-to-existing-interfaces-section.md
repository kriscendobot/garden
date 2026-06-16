---
title: §Relationship-to-existing-interfaces section
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

§Three-related-existing-interfaces enumerated:

- §EndoNameHub-/-EndoDirectory — `ReadableTree` is structurally compatible with the read surface; `Directory` is structurally compatible with the mutation surface. §But-`@endo/platform/fs`-types-do-NOT-include-formula-system-concepts (identify, locate, followNameChanges); §the-design-stops-at-the-filesystem-boundary.
- §EndoReadable — the existing daemon type maps directly to `SnapshotBlob`. §The-daemon-can-type-alias-EndoReadable-=-SnapshotBlob-or-keep-both-during-migration.
- §daemon-capability-filesystem.md — the `Dir` and `File` interfaces correspond to `Directory` and `File` here. §`subDir()`-is-not-in-this-design-because-it-is-a-VFS-namespace-concern-not-a-storage-concern + §it-belongs-in-a-future-VFS-layer-that-composes-`@endo/platform/fs`-primitives.

§Three-named-existing-types-with-explicit-mapping-or-non-mapping. §When-a-new-design-overlaps-with-existing-types, §enumerate-each-overlap-explicitly + §name-which-overlaps-are-aliases-vs-which-are-deliberate-omissions. §The-design-doesn't-pretend-the-existing-types-don't-exist — it names them and maps them.

§Stops-at-the-filesystem-boundary as named design discipline. §When-a-design-could-be-extended-into-an-adjacent-concern, §explicitly-name-the-boundary-and-defer-the-extension + §name-the-future-layer-that-would-extend-it.
