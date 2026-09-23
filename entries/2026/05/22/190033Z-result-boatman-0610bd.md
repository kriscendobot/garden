---
ts: 2026-05-22T19:00:33Z
kind: result
role: boatman
project: endo
repo: endojs/endo
refs:
  - entries/2026/05/22/185432Z-dispatch-liaison-f5f4b6.md
---

Re-ferried `endojs/endo-but-for-bots#253` over `endojs/endo#3258` (`chore: enforce general package uniformity across workspace`). Source PR #253 had been rebased to 6 new commits on current master (`6804b7dc`); upstream #3258 was APPROVED but CONFLICTING. Recompute-from-master, force-push-with-lease.

Procedure: detached at `origin/master` (`6804b7dc8aafe56a0812039d77f2b01a625b7a0e`), set local `user.name`/`user.email` to `Kris Kowal <kriskowal@kriskowal.com>`, cherry-picked the 6 source commits in order with `commit --amend --reset-author --no-edit` after each. No conflicts, yarn.lock untouched.

New upstream head: `cc41c384b1424b3e210bc43cadaf93f2dbcadaff`. 6 commits, oldest to newest:

1. `8bff398d669d9c4c3cd1f2f21f9c85bbaa08b7c2` ci: enforce general package uniformity across workspace
2. `b205fa5261717da81489bd262feef5dd77ed7fda` chore: align SECURITY.md across packages
3. `46efeffe66d0b64336a3b2f3a8231d2ec6d70c1c` chore: add LICENSE to packages that were missing it
4. `11b787880a11569a1947c2d31b36c4d33b043bc7` chore(packages): fix repository/bugs fields and document type exception
5. `3b598c40ef126887a57c680820c7be469789692e` chore(packages): fill in descriptions for ocapn and ocapn-noise
6. `cc41c384b1424b3e210bc43cadaf93f2dbcadaff` chore(packages): align .author on SES-heritage packages to 'Endo contributors'

Attribution verified: all 6 commits author and committer `Kris Kowal <kriskowal@kriskowal.com>`. Trailer-strip discipline (`git interpret-trailers --parse`) reports no trailers on any commit. Path-restricted tree-identity check: 21 paths in `git diff origin/master..HEAD --name-only`, and `git diff f5ad0c1e HEAD -- $PATHS` is empty (byte-identical to source).

Pre-flight: refetched `origin/chore/security-md-uniformity`, still at `e98151eda59f3e92651b3aed3aa165ef714f77e7`. Force-pushed with `--force-with-lease=chore/security-md-uniformity:e98151eda59f3e92651b3aed3aa165ef714f77e7`; push succeeded (`e98151eda...cc41c384b` forced update).

Post-push state on `endojs/endo#3258`: title untouched (`chore: enforce general package uniformity across workspace`), `state: OPEN`, `mergeable: MERGEABLE` (CONFLICTING -> MERGEABLE achieved), `reviewDecision: APPROVED` (preserved across the rewrite, as expected for an unprotected branch), `headRefOid: cc41c384b1424b3e210bc43cadaf93f2dbcadaff`. `mergeStateStatus` is `BLOCKED`, attributable to CI gating, not approval state.

Source-side cross-link posted under kriskowal on `endojs/endo-but-for-bots#253`: https://github.com/endojs/endo-but-for-bots/pull/253#issuecomment-4521941630. No comment on the upstream #3258 (identity discipline preserved).

Self-improvement: nothing this time.
