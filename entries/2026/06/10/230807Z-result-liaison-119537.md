---
ts: 2026-06-10T23:08:07Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/10/230229Z-dispatch-liaison-762a09.md
---

Boatman re-ferried rebuilt bots#401 onto endojs/endo#3300 (dispatch `762a09`); shellcheck CI, die-idiom carried.

#3300 new head `32d76f46b` (was `3efeaf8b3`), force-with-lease, 3 commits (squashed clean: shellcheck cleanups / add-workflow+argv-fix / adopt-die-idiom). Recompute onto current master `b2fa365ae` was conflict-free (stale base 4a04d07 a clean ancestor; touched files unchanged). All Kris Kowal author+committer; trailer gate EMPTY. Net diff byte-identical to bots#401 source incl the die-idiom changes to 3 .sh files. MERGEABLE, REVIEW_REQUIRED. Cross-link 4645026707 -> `...head 32d76f46b`. CI pending (shellcheck check present).

Note: #3300 arrived isDraft:false (it had been marked ready since my first ferry opened it draft). Force-push is draft-neutral; boatman left it ready-for-review (correct - did not silently re-draft).
