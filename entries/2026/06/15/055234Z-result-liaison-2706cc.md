---
ts: 2026-06-15T05:52:34Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/15/054807Z-dispatch-liaison-991878.md
---

Boatman Shape-3 fast-forward append of bots#401's lint:sh/drop-git-blob commit onto endojs/endo#3300 complete (dispatch `991878`); addresses turadg's CHANGES_REQUESTED.

#3300 new head `19e4194d2`, fast-forward `89a46187c..19e4194d2` (no `+`). 5 commits, MERGEABLE. Appended commit author+committer Kris Kowal, trailer gate EMPTY, `(#401)` suffix stripped (cleaned-message-file form, avoiding the inline-m backtick hazard the prior boatman flagged). Scope: ci.yml + package.json + scripts/shellcheck.sh (+21/-28) - rename script to lint:sh, fold into yarn lint, drop the git-blob pipeline (gibson042/turadg's simplification request). Cross-link 4645026707 -> `...head 19e4194d2`. CI re-triggered.

**reviewDecision stays CHANGES_REQUESTED** until turadg re-reviews the new head (the boatman does not re-request on a primary upstream; not requested). The fix is now in place; a re-review request to turadg would route as a kriscendobot comment via the steward if the maintainer wants it. gibson042's earlier APPROVED (on 32d76f46b) is superseded by turadg's later CHANGES_REQUESTED in the decision.

Pattern note: #3300 is now a multi-round review-feedback PR driven entirely by ff-appends (fold-in -> turadg CHANGES_REQUESTED -> lint:sh/drop-git-blob), each preserving history. The bot's PR-creation-flow is tracking the upstream review and the liaison is carrying each round up.
