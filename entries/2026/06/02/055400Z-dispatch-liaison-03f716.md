---
ts: 2026-06-02T05:54:00Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/053340Z-dispatch-liaison-d942ee.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--03f716`) to **re-ferry** endojs/endo-but-for-bots#387 onto its upstream PR endojs/endo#3294 to clear the yarn.lock CONFLICTING state (Shape 2, recompute + regenerate-lockfile).

Context: the first ferry (dispatch `d942ee`) opened #3294 cleanly, but endo master then advanced to `3c5753b67` (#3292 "chore: dependency maintenance" rewrote yarn.lock, merged 2026-06-01), leaving #3294 CONFLICTING on yarn.lock only. The maintainer asked to "weave then ferry #387". Investigation: the bot-side #387 has **zero drift** (frozen base `master-814dfa1` == current endo-but-for-bots master, #387 MERGEABLE/CLEAN), so a bot-side weave is a no-op; the conflict lives entirely in the gap between #3294 and endo's advanced master, resolvable only inside the re-ferry (where endo current master + push access coincide). So the lockfile resolution folds into the ferry: recompute onto endo current master, regenerate yarn.lock.

**Bot-side attribution regression noted:** since the first ferry, #387 was force-pushed to a clean 2-commit shape (`03165ef12` substantive, `c786ba635` yarn.lock) and the substantive commit's author changed from `0xpatrickbot` to `endolinbot` — the 0xPatrick credit was dropped on the bot side during the rebase. The maintainer's standing decision (verified dispatch `d942ee`) is that this work is 0xPatrick's; the re-ferry re-applies author `0xPatrick <patrick@0xpatrick.dev>`, committer `Kris Kowal <kriskowal@kriskowal.com>` regardless of the bot-side author line. Flagged to the maintainer; a separate bot-side fix on #387 may be warranted.

Boatman brief: fetch origin and confirm master is `3c5753b67` (NOT the stale bare-clone `c49fb048b`); cherry-pick `03165ef12` onto current master with author `0xPatrick <patrick@0xpatrick.dev>` / committer kriskowal; regenerate yarn.lock via `yarn install` and commit as a separate `chore: Update yarn.lock` (kriskowal) rather than cherry-picking the old-base `c786ba635` (generated-lockfile resolution per conflict-resolution + yarn-lock-separate-commit skills); verify trailers empty; force-push `--force-with-lease` to existing branch `kriskowal-3289-wget-engines` (prior tip `e0d7a8622`); confirm #3294 CONFLICTING->MERGEABLE; **edit the existing garden-side cross-link in place** (comment 4599031642, currently `...head e0d7a8622`) to the new head SHA via PATCH. `identity_switch_authorized: true`.

Expected report: new #3294 head SHA, force-push confirmation, post-push mergeable (expect MERGEABLE), 0xPatrick-author-preserved verification, lockfile-regen confirmation, CI status, edited cross-link comment.
