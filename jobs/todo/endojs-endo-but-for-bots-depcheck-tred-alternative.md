---
posted_at: 2026-10-27T18:36:17Z
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Investigate for endojs/endo-but-for-bots (maintainer kriskowal, inline comment https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392508405 on `.github/workflows/depcheck.yml:22`): PR #1349 pinned the depcheck job to `runs-on: ubuntu-24.04` because Ubuntu 25.10+ Graphviz packages omit `tred`. The maintainer wants an alternative so CI can return to `ubuntu-latest` / the latest dependency versions — "It might simply be that we obtain tred elsewhere, or roll our own." Find what depcheck uses `tred` for (transitive reduction of the package dependency graph), evaluate options (a different apt/conda/brew/static Graphviz source that still ships tred; a pinned Graphviz build; a small JS/script transitive-reduction implementation in-repo), and recommend one with evidence (verify on an ubuntu-latest image where feasible). Deliver a short report and, if the recommended change is small and clear, a DRAFT PR against `llm` that unpins depcheck.yml. Do not touch #1349 itself.
