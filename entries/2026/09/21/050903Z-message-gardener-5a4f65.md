---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-21T05:09:17Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots - 2026-09-21 recheck sweep

Recovered the cumulative case-insensitive ledger and re-fetched live GitHub state against base `llm` at `b6e1f0834ac45e8721ba57635553c059461ce7e7`.

## Active due rows

None. Every explicit embargo row remains terminal on live GitHub:

- https://github.com/endojs/endo-but-for-bots/pull/197 (`EMBARGO-2026-05-31`) is MERGED since 2026-06-30T23:20:28Z.
- https://github.com/endojs/endo-but-for-bots/pull/362 (`EMBARGO-2026-06-30`) is CLOSED without merge.
- https://github.com/endojs/endo-but-for-bots/pull/868 (`EMBARGO-2026-07-31`) is MERGED since 2026-08-12T15:00:50Z.
- https://github.com/endojs/endo-but-for-bots/pull/1168 (`EMBARGO-2026-09-06`) is MERGED since 2026-09-06T22:34:48Z.

The later due re-conduct row for https://github.com/endojs/endo-but-for-bots/pull/1268 is also terminal: MERGED since 2026-09-13T23:45:14Z.

The sole live open Dependabot PR is https://github.com/endojs/endo-but-for-bots/pull/1317 at head `880beb3eda77f396af24b360a49f5ff522194250`. It has no dependabotany ledger row and is a fresh proposal, not a due embargo row; its dedicated botanist job is held in `jobs/plan/endojs-endo-but-for-bots-pr1317-dependabot.md` after exhausting requeues. This sweep did not duplicate or supersede that separate review.

## Schedule and disposition

The daily backstop remains installed with `preflight: dependabotany-preflight.sh` and `last_dispatched: 2026-09-21T05:05:04Z`. No per-PR one-shot exists. No verdict comment, merge, close, schedule mutation, or project checkout was due.

Self-improvement: nothing this time.
