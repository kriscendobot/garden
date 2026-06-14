---
ts: 2026-06-14T08:18:14Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/14/081236Z-dispatch-liaison-fd70dd.md
---

Boatman Shape-3 fast-forward append of bots#401's `fold shellcheck into the CI lint job` commit onto endojs/endo#3300 complete (dispatch `fd70dd`).

#3300 new head `89a46187c`, fast-forward `32d76f46b..89a46187c` (no `+`). 4 commits, MERGEABLE, draft=false. Appended commit author+committer Kris Kowal, trailer gate EMPTY, fork-side ref stripped from body. Scope: `.github/workflows/shellcheck.yml` deleted (-44) + `.github/workflows/ci.yml` +9 (shellcheck folded into the lint job). Cross-link 4645026707 -> `...head 89a46187c`. CI re-triggered (lint job now carries shellcheck).

**gibson042's APPROVED persists** (ff append never dismisses; anchored to reachable 32d76f46b). This append is the REVIEW-FEEDBACK RESPONSE the reviewers explicitly asked for: turadg ("include it in the lint job"), kriskowal ("rolling shellcheck into the lint CI job ... I'll drive that direction"), gibson042 (APPROVED, "this should run as part of repo-level linting"). So no re-review-flag concern: delivering the fold-in fulfills the approval's stated intent. Choosing ff-append over a recompute deliberately preserved the approval anchor.

Boatman operator note (sub-threshold, in result): prefer `commit --amend -F <file>` over inline `-m` for multi-paragraph bodies with backtick code spans (single-quote escaping left \ artifacts; caught pre-push, nothing shipped).
