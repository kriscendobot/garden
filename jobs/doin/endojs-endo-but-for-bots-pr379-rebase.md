# rebase directive on endojs/endo-but-for-bots PR #379

Map: **rebase** → rebase the PR branch on its base (for endo-but-for-bots this
is the compound: sync bot-master to current endo-upstream/master, then rebase,
then conflict-resolve, then retcon-if-needed). Dispatch the **weaver**.

Why now: PR #379 (mirror of endojs/endo#3276) is OPEN but DIRTY / CONFLICTING
against `master`. Its upstream #3276 is APPROVED (and BEHIND). All 6 unresolved
review threads already carry a kriscendobot response to each maintainer ask, so
the substance is addressed; the ONLY blocker the garden can clear autonomously
is the merge conflict. Clearing it positions the mirror as mergeable for the
maintainer's final re-review.

PR: https://github.com/endojs/endo-but-for-bots/pull/379
Head: fix/issue-59-star-export-cycle  Base: master

Guards:
  - Bot repo only (endojs/endo-but-for-bots). NEVER touch agoric-sdk or merge
    the endojs/endo upstream.
  - This is a rebase, not a merge: do NOT merge #379 (CHANGES_REQUESTED is still
    on record; merge is the maintainer's call after re-review).
  - After the rebase lands clean and CI is green, you MAY re-request the
    maintainer's review (endo-but-for-bots standing authorization covers the
    re-request and a top-level summary comment). Post a concise summary naming
    the new head SHA and that the rebase was conflict-resolution only.

Routed from the attention directive on PR #297
(https://github.com/endojs/endo-but-for-bots/pull/297#issuecomment-4806491532),
which asked the bot to advance the items held in
https://github.com/endojs/endo-but-for-bots/pull/297#issuecomment-4617498872.

---
claim:
  host: endolinbot
  gardener: 20
  claimed_at: 2026-06-26T05:05:09Z
