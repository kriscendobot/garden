---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T20:09:28Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1270

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1270 terminal REJECT

Package: `@vitest/browser` 4.1.11 → 5.0.0.

Verdict: **REJECT (incompatible)**, executed. The structured verdict was posted as
issue comment 5655799918 and the bot-owned PR was closed at
2026-09-13T20:09:12Z.

Live declaration re-verification at head
`b7dfcc9f8e9a914030fe8b03e0fbc12b3fd375a1` returned:

`incompatible peer vitest ^4.1.11 5.0.0 packages/preact-container/package.json`

`packages/preact-container/package.json` still declares `vitest` at `^4.1.11`,
while `@vitest/browser@5.0.0` requires peer `vitest` exactly `5.0.0`; the ranges
have an empty intersection. Per the watcher's terminal preflight contract, the
full lockfile/source/advisory/install/test chain was intentionally not run.

Terminal disposition: no maturity floor and no recheck scheduling. A future
proposal can be reconsidered after the project aligns `vitest` and
`@vitest/browser` on a mutually compatible major.

Self-improvement: nothing this time.
