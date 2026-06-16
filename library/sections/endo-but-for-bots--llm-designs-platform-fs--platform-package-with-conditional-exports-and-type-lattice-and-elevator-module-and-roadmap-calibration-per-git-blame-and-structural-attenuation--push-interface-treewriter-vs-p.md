---
title: §Push-interface-TreeWriter-vs-pull-interface-ReadableTree
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

§Design-Decision-7: §`TreeWriter` is a push interface. *Rather than requiring the checkout target to implement a full `Directory`, we define a minimal `TreeWriter` with `writeBlob` and `makeDirectory`. This decouples checkout from any specific mutable tree implementation and allows zip writers, memory buffers, or remote filesystems to serve as targets.*

§Push-interface-vs-pull-interface as orthogonal design axis: §`ReadableTree`-is-pull (caller asks for children) + §`TreeWriter`-is-push (callee receives children). §The-two-shapes-decouple-source-and-sink. §When-checkout-must-support-many-target-shapes (filesystem + zip + memory + remote), §define-a-minimal-push-interface-not-a-full-mutable-tree-interface + §the-minimum-IS-the-decoupling-mechanism.

§Two-named-methods-on-TreeWriter (writeBlob + makeDirectory) — §a-minimal-interface-by-construction. §When-an-interface-is-deliberately-minimal, §name-the-purpose-of-the-minimality (decoupling) + §name-the-targets-it-enables.
