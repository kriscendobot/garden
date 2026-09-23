---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-10T16:25:24Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-10 daily backstop sweep

project: endo-but-for-bots

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260810-162001`.
Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every open row against live GitHub, npm, OSV, source, base, and CI
state at 2026-08-10T16:24Z. The open Dependabot set remains exactly the eight
ledgered rows. No terminal disposition was available at this tick.

## PR #923: EMBARGO-2026-08-10 holds until the exact floor

- Head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76` is unchanged from the fully
  reviewed 2026-08-05 head, so the reviewed 36-direct-update / 124-added-artifact
  moved set and source assessment remain applicable. A fresh immutable install
  at that head completed with `YARN_ENABLE_SCRIPTS=false`; Yarn explicitly
  reported all build scripts disabled.
- The exact maturity floor is still **2026-08-10T20:37:45.880Z**, derived from
  `ws@8.21.2` published at `2026-08-03T20:37:45.880Z` plus seven days. This tick
  ran at 16:24Z, about 4h13m before the floor, so MERGE-NOW is not yet permitted.
  Live npm still serves 8.21.2 at the reviewed integrity
  `sha512-54dMVAo4WIe6SKy3vBgN+9bJZqqQ8IMRevAkOLQALhi49qkkQDQfWdAZ8KQlXiEabw88ARXXdUrlvtbKQX+aKw==`;
  its release/tag remains published, non-draft, non-prerelease, and OSV plus the
  GitHub advisory query return no advisory for it. No live source-maturity signal
  overturns the embargo.
- The stale-base blocker has worsened slightly: the head is now 127 commits
  behind / 2 ahead and remains `CONFLICTING/DIRTY`. Live `llm` specifies
  `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` at `^0.84.0`, while
  the PR still proposes `^0.82.1`; merging this head would partially revert both
  manifests. This shape cannot be conducted as-is after maturity. The 21:15Z
  one-shot must require a regenerated/rebased head (then re-enumerate the moved
  set and floor) or render a terminal rejection of the stale shape.
- The incoming `dompurify@3.4.8` remains affected by
  GHSA-55q2-fjhq-7xh7, GHSA-c2j3-45gr-mqc4, GHSA-cmwh-pvxp-8882, and
  GHSA-vxr8-fq34-vvx9. OSV still reports 18 advisories on outgoing 3.2.7, so the
  bump is directionally better; the prior source read's unreachability argument
  for Monaco's consumed path remains applicable. `monaco-editor@0.56.0` still
  pins 3.4.8, while current 3.4.13 clears all four. The terminal recheck must
  disclose the residuals and repeat this check after any regenerated lockfile.
- Existing CI remains terminal green at the unchanged head: 24 checks, zero
  pending and zero failed. There is no current maintainer approval and no
  auto-merge request. The active precise one-shot remains scheduled for
  **2026-08-10T21:15:00Z**; the daily backstop remains active.

## Seven terminal MERGE-NOW rows remain approval-held

Ran PRs #867, #868, #912, #913, #914, #915, and #916 through the full conductor
spine `scripts/jobs/gardening/ci-wait-merge.sh --merge`. Every rollup was
terminal green (25, 24, 26, 23, 24, 23, and 23 checks respectively), then the
current-head maintainer-approval gate failed closed. Live verification shows all
seven remain OPEN, `autoMergeRequest=null`, with unchanged heads. #868 remains
`CONFLICTING/DIRTY` and also needs a weave after approval; the other six are
mergeable. No merge or auto-merge was issued.

Self-improvement: nothing this time.
