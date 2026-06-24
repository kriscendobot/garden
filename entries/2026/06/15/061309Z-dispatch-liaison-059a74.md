---
ts: 2026-06-15T06:13:09Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/15/054807Z-dispatch-liaison-991878.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--059a74`) to re-ferry the **retconned** bots#401 onto endojs/endo#3300. Shape-2 recompute, **structure-only** (net content identical).

State: bots#401 retconned to 4 clean commits (all endolinbot, base master-4a04d07, head `f5d63b525`): per-package .sh cleanups (`d762ce7e8` compartment-mapper/neutralize.sh, `4dec008e9` nat/npm-audit-fix.sh, `0bdb4a70b` top-level scripts) + `f5d63b525` chore(shellcheck): add yarn lint:sh and fold it into yarn lint. #3300 head `d797661b` (5 commits, MERGEABLE, **CHANGES_REQUESTED** by turadg, NO approval - gibson042's earlier APPROVE superseded). Verified net content BYTE-IDENTICAL (76 lines both, file sets identical) -> the retcon is a pure regroup; the git-blob pipeline turadg flagged is already dropped.

Boatman brief (Shape 2): fetch origin (exact refs/heads/master); detach at current endo master `315533fff`; cherry-pick bots#401's 4 commits via `refs/pull/401/head`; the .sh-cleanup + shellcheck-add commits may conflict from the 4a04d07->315533fff base gap (resolve mechanically / re-derive via shellcheck; the ci.yml/package.json/shellcheck.sh hunks - STOP if ambiguous); normalize author+committer of all 4 to `Kris Kowal <kriskowal@kriskowal.com>`; strip `(#401)` suffixes + Co-Authored-By/Generated-with/Refs trailers (use `commit --amend -F <file>` for multi-para bodies, not inline -m); RUN `interpret-trailers --parse` EMPTY; verify net diff matches bots#401 (76 content lines, same file set); force-with-lease against `d797661b` to `kriskowal-shellcheck-ci`; confirm MERGEABLE; leave title/body unchanged; edit cross-link 4645026707 to new head. `identity_switch_authorized: true`. Do NOT re-request turadg's review.

Expected report: new #3300 head, force-with-lease, 4-commit structure all Kris Kowal + trailers-empty + (#401)-stripped, conflict outcome, net-diff-matches-bots#401, mergeable + reviewDecision, CI, edited cross-link.
