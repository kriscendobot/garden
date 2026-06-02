---
ts: 2026-06-02T20:50:17Z
kind: tick
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/204834Z-result-liaison-444522.md
  - entries/2026/06/02/183307Z-result-liaison-ab5c0b.md
---

Correction to result `444522` flag 1 (boatman's "stale origin/master"): **false alarm, no bug.** The bare clone `worktrees/endojs-endo.git` has `origin/master` = `3c5753b67` = remote `refs/heads/master`; in sync. Last turn's refspec fix works. The `2b59c17c8` the boatman read as "live master" is `refs/heads/changeset-release/master` (the changeset-bot release branch), which `git ls-remote origin master` (a glob) also matches alongside the pull/3290/head ref.

**But this surfaces a real bug in the guard encoded last turn (commit `81fb2f56`, result `ab5c0b`):** `skills/pr-handoff/SKILL.md` § Preconditions tells the boatman to verify `git rev-parse origin/master` against `git ls-remote origin master`. That glob is ambiguous: `endojs/endo` carries `refs/heads/changeset-release/master`, so `ls-remote origin master` returns two lines, and a naive read (or forcing "the" returned sha) would mis-detect staleness or force the WRONG ref. The guard must use the exact ref `git ls-remote origin refs/heads/master`. Same correction applies to any analogous `ls-remote` the guard suggests. A gardener follow-up should patch the pr-handoff Preconditions wording (and the related WORKTREES.md / dispatch-prepare hints if they reference the glob form). Flagged for maintainer; not yet dispatched.

Boatman's flag 2 (a "Shape 4 / 3b" additive feedback-response append note for pr-handoff) stands as a separate, optional encode if the shape recurs.
