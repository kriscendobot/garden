Role: weaver

For endojs/endo-but-for-bots PR #340 (https://github.com/endojs/endo-but-for-bots/pull/340, head claude/endo-daemon-ocapn-FkmHO, base llm): rebase the branch onto the current llm tip and resolve conflicts. PR #806 (crossed-hello race fix, touching the same ocapn-noise code) merged to llm on 2026-07-26 as 2b4a01e7 — prefer the llm-side (merged #806) semantics where they overlap. The stacked PRs #684 -> #688 -> #693 base on this branch, so keep the patch stack coherent and comment on #340 with the resulting head. This is bot-repo work.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: hermit
  claimed_at: 2026-07-26T17:36:29Z
