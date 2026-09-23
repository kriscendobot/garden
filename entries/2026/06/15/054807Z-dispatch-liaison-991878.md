---
ts: 2026-06-15T05:48:07Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/14/081236Z-dispatch-liaison-fd70dd.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--991878`) for a **Shape-3 fast-forward append** of bots#401's new commit onto endojs/endo#3300. No force-push. Addresses turadg's CHANGES_REQUESTED.

Context: after my fold-in ff-append (89a46187c), **turadg reviewed and requested changes** (CHANGES_REQUESTED on 89a46187c, 2026-06-14T16:05). The bot's new commit `bde80b9f1 chore(shellcheck): rename to lint:sh, fold into yarn lint, drop git-blob pipeline` addresses it (the git-blob-pipeline simplification gibson042/turadg raised + lint:sh naming). #3300 is CHANGES_REQUESTED (no approval at risk).

State: #3300 head `89a46187c` (4 commits, MERGEABLE, CHANGES_REQUESTED by turadg). New commit `bde80b9f1` (endolinbot) touches ci.yml (+11/-6... net -? actually 11 changed), package.json, scripts/shellcheck.sh. Verified clean ff-append: all 3 files' parent blobs == #3300 head's.

Boatman brief (pr-handoff § Shape 3): fetch #3300 head `89a46187c` (branch `kriskowal-shellcheck-ci`) and bots#401 tip via `refs/pull/401/head` (verify FETCH_HEAD==`bde80b9f1`); detach at `89a46187c` (NOT master); cherry-pick `bde80b9f1`; `--reset-author` to `Kris Kowal <kriskowal@kriskowal.com>`; **strip the `(#401)` subject suffix**; RUN `interpret-trailers --parse` EMPTY; use `commit --amend -F <file>` for any multi-para body (avoid inline -m backtick escaping); pre-flight `merge-base --is-ancestor origin/kriskowal-shellcheck-ci HEAD`; push WITHOUT force (remote `89a46187c..<new>`, no `+`); leave title/body unchanged; edit cross-link 4645026707 to new head. `identity_switch_authorized: true`. Do NOT re-request turadg's review (routes via steward; not requested here).

Expected report: new #3300 head, fast-forward (no `+`), Kris Kowal + trailers-empty + (#401)-stripped, 3-file scope, mergeable + reviewDecision, CI, edited cross-link.
