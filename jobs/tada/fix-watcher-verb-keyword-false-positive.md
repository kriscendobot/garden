Inbox empty. Work complete.

---

## Completion report — `fix-watcher-verb-keyword-false-positive`

**Root cause.** `classify()` in `scripts/jobs/comment-watcher.sh` mapped a review to a deterministic verb (`rebase`/`retcon`/`refresh`/`shepherd`) via a bare word-boundary grep over the *whole* lowercased body. The verb firing anywhere — including as the PR's **subject matter** — minted a verb job. endo-but-for-bots #526 ("clean-rebase git code-mode eval scenario") got a bogus `…-pr526-rebase` job from a `CHANGES_REQUESTED` body that only critiqued the rebase eval *design* and never asked for a git rebase (branch was already CLEAN). The actual design feedback was lost.

**Fix.**
- **comment-watcher.sh**: Gated the verb scan. A keyword now counts as a directive only when the body *also* reads as an imperative (`reads_as_directive`) **or** @-mentions the bot. A bare keyword in prose falls through to the existing `[CHANGES_REQUESTED]` → `return 2` (triager/claude reads the body) path instead of short-circuiting. The imperative reading is computed once and reused by the trusted-plain-directive branch (no behavior change there). True directives ("please rebase #N") are unaffected.
- **mention-watcher.sh**: Shares the pattern. Since every line there is already an @-mention (so @-mention can't discriminate directive from topic), added the same `reads_as_directive` helper and gated its verb scan on the imperative reading alone — a verb-as-topic @-mention now falls to `attention` (a gardener re-fetches and reads the body) rather than minting a bogus verb job. No drop: `attention` is still actionable.

**Tests (all green).**
- `comment-watcher-test.sh`: 30/30. New H (verb-as-topic in a `CHANGES_REQUESTED` review body → no `pr526-rebase/-shepherd/-refresh` job, routed to the reader, no reactji), I (verb-as-topic in a plain comment → dropped, cursor slides), J (explicit "please rebase" still mints the verb — no regression). All 22 pre-existing assertions still pass.
- `mention-watcher-test.sh`: 19/19. New F (trusted @-mention naming a verb as topic → `attention`, not `rebase`). All 16 pre-existing still pass.

`shellcheck` shows only pre-existing infos/warnings (`SC1091`/`SC2034`/`SC2015`), none introduced. The verb-table grep pattern exists only in these two files.

**Delivery.** Built in an isolated worktree off `origin/main2`; committed the four files with explicit pathspecs (no `git reset --hard`); fast-forward pushed `HEAD:main2` as `194b0a49`. Worktree removed.

**Follow-ups.** None required. Worth noting: the lost #526 design feedback was never actioned — the original misclassified job did the wrong thing and the real ask (folder-per-eval structure, deeper scenarios) was dropped. If that PR is still open, it may need a fresh triage pass so the design feedback actually lands.
