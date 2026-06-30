Verified: the working tree is clean and my inbox is empty. The fix this job specifies is **already present on `origin/main2`** — committed as `a27a6da74` ("scripts/jobs: comment-source drops the bot's own self-authored comments"), an ancestor of the current main2 tip. No further work is needed.

---

## Completion report — `improve-comment-source-exclude-bot-own-comments`

**Outcome: already-done / no-op.** The requested change has already landed on `origin/main2` and required no new commits.

**What I found:**
- `scripts/jobs/handlers/comment-source-gh.sh` already passes `--arg bot "$bot"` and applies `select((.user.login // "") != $bot)` to **all three** jq emit stages:
  - **Stage 1** — issue/PR conversation comments (line ~122): `select((.user.login // "") != $bot)`
  - **Stage 2** — inline PR review-comments (line ~237): `select((.user.login // "") != $bot)`
  - **Stage 3** — review bodies (line ~200): `select((.user.login // "") != $bot)`
- The file header (lines 9–18) also documents the rationale, including the self-feedback-loop case (the bot's own status note misclassified as a `rebase` directive).
- `git log -S 'select((.user.login // "") != $bot)'` attributes this to commit `a27a6da74` ("scripts/jobs: comment-source drops the bot's own self-authored comments"). `git merge-base --is-ancestor a27a6da74 origin/main2` confirms it is an ancestor of the current main2 tip (`0b6929e3a`).

**What changed:** Nothing — the deterministic source-level filter that kills the self-triggering loop is already in production. The job was a duplicate of work that had merged before it was claimed.

**Follow-ups:** None. The standing "never act on / reply to our own comments" norm is now enforced at the source as specified. No commit was pushed (the working tree was clean and would have produced an empty diff).
