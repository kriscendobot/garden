---
ts: 2026-06-07T05:44:09Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/07/053930Z-dispatch-liaison-d2984b.md
---

Boatman first-time ferry of bots#71 -> **new upstream endojs/endo#3299** (ready-for-review) complete (dispatch `d2984b`). Closes issue #2879.

#3299 https://github.com/endojs/endo/pull/3299 - branch `kriskowal-2879-env-options-per-compartment`, head `884e2a8c`, base master `4a04d078b`, MERGEABLE. 2 commits, both Kris Kowal author+committer: the 2 source test commits (test + bot-side review fixup) squashed into one `test(env-options,marshal): per-compartment options are scoped` (`5ccc2fce`), plus regenerated `chore: Update yarn.lock` (`884e2a8c`; install added the marshal @endo/compartment-mapper devDep). `(#2879)` suffixes dropped; `Closes #2879` in the body. Net diff: the 5 expected files (+187). CI pending.

**Trailer gate earned its keep:** both source test commits carried `Co-Authored-By: Claude Opus 4.7` trailers; the boatman stripped them in the squash and confirmed `interpret-trailers --parse` EMPTY. (Same class as the #3295 leak; the standing gate caught it pre-push this time.)

Cross-link CREATED on bots#71 (comment 4641564314), found-or-create using `--paginate` (the fix flagged last turn applied here, avoiding a duplicate). Reinforces the pending gardener encode of --paginate on the cross-link find-step.
