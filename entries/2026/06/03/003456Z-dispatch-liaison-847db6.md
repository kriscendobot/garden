---
ts: 2026-06-03T00:34:56Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/003405Z-result-liaison-c68245.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--847db6`) for stage 2 of retcon-and-referry: **Shape-2 recompute** of the retconned endo-but-for-bots#387 onto endojs/endo#3294, replacing #3294's amended 3-commit structure with the clean retconned structure. The maintainer said "it's good to go" — this is the merge-ready finalization.

Source (retconned): bots#387 head `57b9e8f8b`, 3 commits on frozen base master-814dfa1:
- `82f7aae17` fix(benchmark): install xs/v8 via direct download instead of esvu
- `ebdcdff7b` chore(hex): point run-benches.sh at the ~/.engines binary cache
- `57b9e8f8b` chore: Update yarn.lock

Upstream: endo#3294, branch `kriskowal-3289-wget-engines`, current head `983551383` (the prior 0xPatrick+yarn.lock+Feedback-responses structure). Recompute onto endo master `3c5753b67`, force-with-lease.

Attribution (maintainer's standing rule: substantive direct-download work -> 0xPatrick, chores -> Kris Kowal):
- `fix(benchmark)` -> author `0xPatrick <patrick@0xpatrick.dev>`, committer `Kris Kowal <kriskowal@kriskowal.com>`.
- `chore(hex)` -> `Kris Kowal <kriskowal@kriskowal.com>` author+committer. (Judgment call: a per-package chore consequent to the benchmark change; flagged to maintainer, easily flipped to 0xPatrick if preferred.)
- yarn.lock -> regenerate on endo master via yarn install (do NOT cherry-pick the frozen-base lockfile); commit `chore: Update yarn.lock`, Kris Kowal.

Net-content invariant: the result's benchmark subtree must remain `98060f1e` (matches the live mirror) and the overall net diff vs endo master must equal the source's net diff. gibson042 APPROVED on #3294 expected to persist (endo master unprotected); verify post-push. Update cross-link 4599031642 to the new head. `identity_switch_authorized: true`.

Expected report: new #3294 head, 3-commit structure with verified attribution (0xPatrick on benchmark, Kris Kowal on hex + yarn.lock), benchmark subtree == 98060f1e, net-diff-matches-source confirmation, force-with-lease push, MERGEABLE + gibson042-APPROVED-persists, CI, edited cross-link.
