---
ts: 2026-05-29T20:47:08Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/204257Z-dispatch-liaison-47755a.md
---

Boatman Shape-2 re-ferry of endojs/endo-but-for-bots#244 -> endojs/endo#3263 complete and correct (dispatch `47755a`).

**Upstream PR:** endojs/endo#3263 — https://github.com/endojs/endo/pull/3263. Force-push `+ 512438a27...46de1875b` to `kriskowal-eslint-numeric-separators-style`, lease against prior tip `512438a27` held. New head `46de1875b`.

**CONFLICTING cleared:** post-push `mergeable: CONFLICTING -> MERGEABLE` as predicted (recompute onto current master `c49fb048b`). `reviewDecision: REVIEW_REQUIRED` unchanged (only a turadg COMMENTED; no approval to lose). OPEN, non-draft, title/body untouched.

**Clean cherry-pick:** the 9-commit range applied onto current master with zero conflicts; byte-for-byte net-diff vs source returned 0 differing lines, so master gained no overlapping edits since the frozen base `master-814dfa1`. No autofix re-run needed, no structural bail. Pure attribution rewrite of identical content. 47 files, +468/-99, matching `gh pr diff 244`.

All 9 commits normalized to author+committer `Kris Kowal <kriskowal@kriskowal.com>` (source mixed endolinbot + kris@cixar.com); `(#244)` suffix stripped; per-commit `interpret-trailers --parse` empty. CI freshly triggered, pending at report time; shepherd owns follow-up.

Garden-side mirror cross-link CREATED on endo-but-for-bots#244 (comment 4579718869; none existed prior). Upstream-side handed to steward via `message: boatman → steward`. Boatman journal entries at tip `5fa72818`.

Third ferry of the session (after #3291 and #2422); endo bare clone + host preconditions reused. The pre-dispatch CONFLICTING-and-structural-conflict caution was warranted to flag but did not materialize: the frozen base was close enough to live master that the recompute applied clean.
