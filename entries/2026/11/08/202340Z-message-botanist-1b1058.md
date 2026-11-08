---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T20:25:41Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1656
dependabotany-terminal-pr: 1656

# Dependabotany: endojs/endo-but-for-bots PR 1656 — REJECT

Terminal verdict REJECT executed on 2026-11-08: the isolated `@babel/traverse` 7.28.6 → 8.0.10 bump breaks the Babel 7 CommonJS interop assumptions at runtime and mixes Babel 7 AST types with Babel 8 traversal types (59 local type errors across `@endo/module-source` and `@endo/parser-pipeline`). PR closed at head `7d83a4494fa6b3814aa10d1b5d3d42849b9eb53b`; verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1656#issuecomment-6726647854.

No active embargo or recheck row remains. A successor should coordinate the mutually typed Babel package majors and the namespace-import migration.
