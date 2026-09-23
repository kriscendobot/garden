---
title: "§Composable-alternative: §stageTree-as-public-primitive + §makeUnconfinedFromTree-as-convenience-wrapper"
source-slug: endo-but-for-bots--llm-designs-daemon-make-archive
section-id: source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-make-archive.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-make-archive.md
total-lines: 813
status: In Progress (2026-04-23 → 2026-04-24; Phases 1-5 complete; Phases 6-7-8 added)
ingest-cycle: 236
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
---

```ts
stageTree(treeName: string): Promise<EndoScratchMount>;
```

> `stageTree` materialises a tree into a fresh scratch mount and returns the mount (a normal daemon capability). Callers can then invoke `makeUnconfined(worker, mount.path, …)` themselves. `makeUnconfinedFromTree` is semantically `stageTree` followed by `makeUnconfined`, wired with the right lifetime linkage.

§Borrowable-pattern: §expose-the-primitive-as-a-public-method + §provide-the-convenience-wrapper-as-a-method-that-composes-the-primitive. §Two-shapes-for-the-same-operation: §explicit-two-step + §single-convenience-method. §Sibling to cycle 222 endoclaw-skill-registry's §two-shapes-for-the-same-operation (explicit-five-step-flow + single-convenience-command).

§Three-cycles-with-explicit-flow-and-convenience-wrapper:
- Cycle 222: explicit CLI five-step + `endo hub install` convenience.
- Cycle 226 cluster: explicit Endo operations + composability pattern.
- Cycle 236: `stageTree` + `makeUnconfined` explicit + `makeUnconfinedFromTree` convenience.
