---
ts: 2026-05-18T04:25:32Z
kind: result
role: fixer
worktree: dispatches/fixer--190fbc/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/18/040700Z-result-builder-1ecc43.md
---

PR endojs/endo-but-for-bots#280 broadened to drop both Node 18 and Node 20 per maintainer kriskowal's comment ("Drop 18 too. That's in flight upstream already. Consider cherry-picking that as a basline. Also, be sure to rebase and resolve conflicts.").

Cherry-pick source: endojs/endo#3084, commit `010cc15fe` ("ci: remove unsupported Node (18) from matrix"). Did not cherry-pick the sibling commit `9d1369bf5` ("ci: unpin Node version in non-matrix jobs") since the dispatch brief named the matrix-drop changes specifically and the unpin commit is an orthogonal aesthetic concern.

Conflicts resolved (union semantics, drop both 18 and 20):

- Cherry-pick into our drop-20 commit: 4 conflicts in `.github/workflows/ci.yml` (test, cover, test262, viable-release matrices). Each side had a different remove-this-version edit on the same matrix line; the resolution kept both removals.
- Additional hand-edit in the same cherry-picked commit: `test-async-hooks` matrix (string-form versions) lost its `'18'` entry. The upstream commit did not touch this matrix because it iterates string-form versions; without the hand-edit, Node 18 would have stayed in the async-hooks lane.
- Rebase onto current `origin/master`: 2 conflicts (`ci.yml` and `ocapn-guile-interop.yml`) where the `setup-node` action pin had advanced upstream on the same lines the drop-20 commit was changing for Node 22. Resolution took the new pin SHA together with the Node-22 label and version.

Total conflict count: 7 (4 cherry-pick + 2 rebase + 1 hand-edit for the matrix the upstream commit did not cover).

Final commit list (2 commits, in order):

1. `2ec645b45` — `chore(ci): drop Node.js 20 from the test matrix` (endolinbot-authored, this fork)
2. `d652c2221` — `ci: remove unsupported Node (18) from matrix` (Turadg Aleahmad author preserved, endolinbot committer; provenance noted in body)

Final head: `d652c2221219e7313220363331c1cbdd572df620`.

PR updates:

- Title: `chore(ci): drop Node.js 18 and 20 from the test matrix`.
- Body: rewritten to describe the two-commit structure, the cherry-pick source, and the union conflict resolution.
- Ack comment posted: https://github.com/endojs/endo-but-for-bots/pull/280#issuecomment-4474333268 (names the cherry-pick source SHA and explains the unpin commit was intentionally not picked up).

CI on the new head: all matrix lanes restricted to 22.x and 24.x as intended, with no 18 or 20 jobs at all. Most lanes still pending at the time of this entry; `test-async-hooks (22, ubuntu-latest)`, `test262 (24.x, ubuntu-latest)`, `test-hermes`, `check-action-pins`, and the early `build` job already pass.

Self-improvement: nothing this time.
