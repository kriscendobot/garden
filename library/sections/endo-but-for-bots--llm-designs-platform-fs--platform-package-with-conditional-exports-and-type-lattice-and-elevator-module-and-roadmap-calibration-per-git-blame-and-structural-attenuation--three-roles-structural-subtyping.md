---
title: §Three-roles + structural-subtyping
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

§Three-roles-an-object-can-play named explicitly:

1. **§Readable** — a shallow, possibly-remote capability. The holder can `list`, `lookup`, and stream content, but cannot write. §This-is-what-a-guest-or-CLI-client-holds-when-interacting-with-a-potentially-remote-daemon.
2. **§Snapshot** — a content-addressed, immutable snapshot whose identity is a hash. The holder can obtain the hash and retrieve content from a `SnapshotStore`. §This-is-what-the-daemon-persists.
3. **§Mutable** — a live filesystem node that supports writes. §`readOnly()`-attenuates-a-mutable-node-to-a-readable-one.

§The-three-roles-have-named-substrates: §Readable-holder-is-a-guest-or-client + §Snapshot-holder-is-the-daemon-persistence-layer + §Mutable-holder-is-the-live-filesystem-actor. §When-a-type-vocabulary-has-three-roles, §name-the-substrate-that-typically-holds-each-role.
