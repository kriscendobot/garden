Inbox empty. Work complete.

---

## Completion report

**Job:** `garden-comment-watcher-verb-imperative-gate` — gate `comment-watcher.sh` `classify()`'s fixed verb table on an imperative cue.

**What I found (and an important wrinkle):** The job framed this as applying the 194b0a49 discipline to "a different table." It's actually the *same* table: commit 194b0a49 already gated `comment-watcher.sh`'s `classify()` — but the later jq-outage commit **1a52c9bb silently clobbered it**. 1a52c9bb was built off a pre-194b0a49 base and not re-applied on the clean base (the classic concurrent-gardener shared-file clobber my memory warns about), so the un-gated `for v in rebase retcon refresh shepherd` table reappeared on `origin/main2` HEAD. Both the gate code *and* its H/I/J regression tests were lost (those test slots now hold jq-outage tests). So this job restores a regression, not just a one-off fix.

**What I changed** (committed `261603cb`, pushed to `origin/main2`):
- `scripts/jobs/comment-watcher.sh` — restored the gate: compute `mentions_bot` (@-mention of the bot) and `imperative` (`reads_as_directive`, pure-string) once; the verb table fires only when one holds. Bare verbs in prose fall through to the untouched @-mention / CHANGES_REQUESTED / trusted-plain-directive `return 2` paths. Added a regression note anchoring the canonical case to endo-but-for-bots **#513 issue-comment 4800685785** (future-tense "rebase ... will pick it up. No action needed until #528 merges") alongside the prior #526 case, and noting the clobber lineage.
- `scripts/jobs/test/comment-watcher-test.sh` — added tests **K/L/M**: K (the #513 future-tense "rebase" mints no job), L (a CHANGES_REQUESTED body discussing a "clean-rebase eval scenario" routes to the reader, not a verb job), M (an @-mention with a bare verb still fires the table). Full suite: **33 passed, 0 failed**.

**Process:** Built in an isolated worktree off `origin/main2`, explicit pathspecs, pushed `HEAD:main2` (base was current, fast-forward). Note: the sandbox mounts `/tmp` `noexec`, so the test harness (which directly execs `cursor-get.sh`) fails there with rc 126 — I relocated the worktree under `/home/kris` to run it. Mention for any future infra job: don't put runnable garden worktrees in `/tmp`.

**Follow-ups worth flagging to the maintainer:**
1. **Systemic clobber risk.** 1a52c9bb silently reverting 194b0a49 is the second instance of a concurrent gardener wiping a peer's shared-file hunk by not rebasing onto the clean base. The convention exists but isn't enforced; a pre-push check (reject if the target file moved under you since your base) would catch this class. I can post that as a separate infra job if wanted.
2. The bogus `endojs-endo-but-for-bots-pr513-rebase` job referenced in the spec was already verified and closed no-op by another gardener; nothing left to do there.
