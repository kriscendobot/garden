---
ts: 2026-05-20T05:43:45Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 053048Z-dispatch-liaison-7927a4
---

# Result: groom 7927a4 — designs/README.md roadmap pass (PR #312 open)

Groom dispatch `7927a4` complete. Deliverable: draft [endojs/endo-but-for-bots#312](https://github.com/endojs/endo-but-for-bots/pull/312) — `docs(designs): groom roadmap (milestones + summary, 2026-05-20)`, branch `groom/roadmap-2026-05-20`, head `40904b806`. One commit, +137 / -77 on `designs/README.md`. Groom self-report at `journal/entries/2026/05/20/054215Z-result-groom-7927a4.md`.

## Pre-flight finding

Dispatch-named HEAD `68246ad92` was **91 commits behind** `origin/llm@2d12449a0`. Groom ran from current tip per procedure step 2.

## Per-milestone totals (before → after)

| Milestone | Prior | Reconciled |
|---|---|---|
| M½ | 1 | 1 |
| M1 | 8 | **10** (absorbed `endo-gateway`) |
| M2 | 6 | 6 |
| M3 | 8 | **11** (absorbed `cli-store-verb-text-modes`, `cli-edit-verb`, `exo-zip-package`) |
| M4 | 10 | **11** (absorbed `daemon-retention-paths` net of `retention-path-notation` flip) |
| M5 | 6 | 6 |
| M6 | 2 | 2 |
| **Total** | 41 | **47** |

The 2026-05-19 sweep had decremented mechanically from a 2026-05-08 baseline without absorbing later additions.

## Other deltas

- **Status flips since prior snapshot**: none.
- **New rows added in this pass**: none — the four side-branch designs the dispatch named (`forge-gap-analysis` PR #310, `patterns-diagnostic-feedback` PR #307, `familiar-release` PR #231, `chat-rename-dismiss-to-clear`) are either not yet merged into `llm`, already accounted for, or surface as open questions below.
- **Dep-graph cycles**: none.
- **Velocity recalibration**: per-size multipliers unchanged from 2026-05-14 (S 0.7, M 1.2, L 1.3). Cumulative S bucket: 18 → 25 observations. Open-PR backlog grew ~14 → ~30; review-queue carry stays 2 weeks but may widen next pass.
- **Gantt**: re-anchored M½ to 2026-05-20 (was 2026-03-06); downstream cascade. M1 target Late July → early August; M3 Late October → early November; M4 Mid December → mid January 2027; M6 Q3 → Q4 2027.

## Open questions surfaced (non-blocking)

1. **`familiar-release.md` exists in `designs/` but is not in the Summary table.** Should land as a row; the design predates this README's absorbing of side-branch designs from open PRs.
2. **Several design files lack frontmatter Status.** A future pass could surface and fill these uniformly.

Flagged in the groom result entry rather than a separate `message` entry.

## Self-improvement (carried from groom)

The dispatch-worktree's bare-clone snapshot can lag the live branch tip; the groom procedure's step 2 caught the 91-commit gap, but a future role-author may want a one-line note in the procedure that **dispatch-named HEAD SHAs are hints, not contracts** — always re-anchor to current `origin/<branch>` before computing deltas.

## Teardown

Dispatch root `/home/kris/dispatches/groom--7927a4/` torn down by the liaison after this entry lands.
