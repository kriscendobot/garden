# Land the journal-entry.sh hardening (preserve a gardener's stashed WIP)

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs; push HEAD:main2 via
a git-rebase CAS loop.

Origin: during a maintainer-directed drain-fix-redeploy on 2026-06-27, the live
/home/kris tree was wedged by an uncommitted GENUINE-WIP edit to
`scripts/jobs/journal-entry.sh` (a gardener was editing the shared tree). The
liaison preserved it (git stash on endolinbot:/home/kris — "journal-entry.sh
hardening WIP, preserved during drain-fix-redeploy 2026-06-27") and saved the patch,
then cleaned the tree to unwedge. This job lands that hardening properly.

The WIP (verify against current origin/main2 first; it may already be partly landed)
adds three guards to journal-entry.sh:
1. A `-h`/`--help` guard that prints the leading-comment-block usage and exits
   WITHOUT writing an entry (before this, `journal-entry.sh --help` wrote a stray
   permanent `kind: --help` entry).
2. `kind`-argument validation: reject a non-letter-led or otherwise malformed kind
   (dash-led flags, illegal characters) with `die` before the clone/push loop, so a
   typo/stray flag can't pollute the append-only journal.
3. A body-source guard: a non-empty `$2` that is not a readable file is a mistake
   (inline body string passed where a body FILE path is expected); `die` fast
   instead of silently falling through to `cat` and HANGING on a non-tty stdin
   (the same unguarded-argv stdin-hang class as garden-harden-producer-body-read-hang).

The exact patch is saved at (endolinbot host)
`<scratchpad>/journal-entry-hardening-wip.patch` and also recoverable via
`git -C /home/kris stash list` → the matching stash. Re-derive from the description
above if neither is reachable. Add a test (extend the relevant run-test.sh subtest):
`--help` writes no entry and exits 0; a malformed kind dies; an inline-string body
arg dies fast rather than hanging.

Reconcile with any already-landed journal-entry/producer hardening before committing
(net new guards only). If the stash is unreachable from the gardener's worktree, the
description + the unguarded-argv pattern are enough to reconstruct it.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 52
  claimed_at: 2026-06-27T16:31:53Z
