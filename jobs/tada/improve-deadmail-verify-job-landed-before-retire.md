Inbox is empty. Work is complete.

---

## Completion report

**Job:** `improve-deadmail-verify-job-landed-before-retire`

**Problem:** `scripts/jobs/deadmail.sh` retired a dead-mail entry (`git rm` + CAS push) immediately after `post-job.sh` returned 0. But `post-job.sh` can report "posted" while its push fails to land on `origin/journal2` under contention — and the gardener fleet is the highest-contention producer set on the board. When that race fired, the dead-mail entry was deleted while the promoted job never reached the board, permanently dropping the message intent deadmail exists to preserve.

**Fix:** Added a `verify_posted()` guard mirroring `comment-watcher.sh`'s. After `post-job.sh` succeeds, it ensures/fetches a dedicated verify clone (`GARDEN_DEADMAIL_VERIFY_CLONE`, default `$GARDEN_STATE/deadmail/verify`) and confirms `origin/$JOURNAL_BRANCH:jobs/{todo,doin,tada}/$base.md` is reachable via `git cat-file -e` **before** the `git rm`/retire loop. If the job is not reachable, it logs and `continue`s, leaving the dead-mail entry for the next tick. Re-promote is safe because `post-job.sh` is idempotent by basename.

**Changed:** `scripts/jobs/deadmail.sh` — one new `verify_posted()` function plus a guard `if ! verify_posted "$base"` ahead of the existing retire loop. Script-level only; no agent involved.

**Verification:** `bash -n` clean; shellcheck reported only pre-existing/benign findings (intentional literal-backtick `printf`s, sourced `common.sh`, `GARDEN_TAG` used by `common.sh`) — no new warnings from my changes.

**Landing:** Per the garden-infra norm, developed in an isolated worktree off `origin/main2` (not the deployed root checkout — I reverted an initial accidental root edit). Committed and pushed `HEAD:main2`; confirmed commit `b29e007c0` is reachable on `origin/main2` and is its tip. Scratch worktree removed; root tree clean.

**Follow-ups:** None. The change inherits the same configurability and clone-pluggability the other watchers use, so existing tests (`run-test.sh`) can exercise it via the standard `GARDEN_STATE`/`JOURNAL_REMOTE` env. A dedicated subtest asserting the no-retire-on-lost-push path could be added later but is not required by this job.
