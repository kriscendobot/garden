---
ts: 2026-05-29T05:31:25Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/052712Z-dispatch-liaison-1947d5.md
---

Boatman ferry of kriscendobot/endo#1 -> endojs/endo complete and correct (dispatch `1947d5`).

**Upstream PR:** endojs/endo#3291 (DRAFT) — https://github.com/endojs/endo/pull/3291. Branch `kriskowal-3289-install-engines-retry`, base `master`, head `44b80546d6b714d559e92436821e0ab33e353093`.

First-time Shape-1 ferry: detached at upstream master tip `c49fb048`, cherry-picked the single source commit `82f66580`, `commit --amend --reset-author` to `Kris Kowal <kriskowal@kriskowal.com>`. Frozen base `master-052b048` not carried upstream. One-file diff (`packages/benchmark/install-engines.sh`, +31/-4) byte-identical to source. Subject `(#3289)` suffix stripped, redundant inline body parenthetical removed, `Fixes #3289` trailer added (issue OPEN upstream).

Attribution+trailer verification PASS (human author+committer; `interpret-trailers --parse` empty). CI at ferry time: 18 checks pending, not waited on; `test-xs` is the bellwether the PR de-flakes. Garden-side mirror cross-link posted on kriscendobot/endo#1 (comment 4570986927). Upstream-side cross-link handed to steward via `message: boatman → steward` (no steward this session; written for the record). Boatman journal entries pushed at journal commit `d477ff38`.

Opened DRAFT by liaison instruction: the source PR is still draft and unjudged (no gamut, no approval). The maintainer can mark endojs/endo#3291 ready-for-review after review.

**Environment notes from the boatman (not skill gaps):** (1) the project worktree's `origin` resolved to the live ssh remote for endojs/endo rather than the bare clone, and (2) the push needed the fully-qualified `HEAD:refs/heads/<branch>` form. Both benign on this freshly-provisioned host. Separately: this host is `kmkmbp2026`, but `journal/projects/endo/README.md` § Identity and credentials still records the kriskowal-credentialed host as `kmkmbp2021` (and several role files cite `kmkmbp2021` as of 2026-05-14). The note is stale; a gardener should refresh the host name. Flagged for the maintainer; not edited inline this session.
