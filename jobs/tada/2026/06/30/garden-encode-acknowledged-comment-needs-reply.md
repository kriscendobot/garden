Done. Completion report below.

## Completion report

**Job:** Encode "an acknowledged comment gets at least a reply comment, not just a reactji" (kriskowal directive, 2026-06-30, re endo-but-for-bots #58 comment 4848100199 — a status question that got only a 👀).

**Landed** on `main2` as `0b6929e3a` (pushed, rebase CAS clean on first attempt).

### What changed

1. **`scripts/jobs/comment-watcher.sh`** — added a single `post_reply` chokepoint that enforces every feedback-loop guard so no call site can forget one: reactable conversation surfaces only (issue/PR conversation + inline review comments), never `author==bot`, trusted senders only, idempotent by comment-id. Wired it into:
   - `ack_or_log_slide` — a trusted non-actionable comment now gets the 👀 **and** an engaging reply, never a silent reactji-and-slide.
   - the actionable job-post success site — an actionable comment gets a reply naming the active job (`On it — I've posted a job (\`base\`)…`); skipped for `review`/`finalize` whose response is the job itself / review threads.
   - new `GARDEN_COMMENT_REPLY` indirection + header docs.

2. **`scripts/jobs/handlers/comment-reply-gh.sh`** (new) — reply-comment poster, idempotent via a hidden `<!-- garden-reply:<cid> -->` marker checked before posting (conversation reply for issue/PR comments; inline thread reply for review comments).

3. **`scripts/jobs/handlers/comment-claude.sh`** — reader now routes a question/status-request to `attention` (whose job deliverable *is* the substantive reply, as the #58 question did), reserving `skip` for chatter/thanks (which still gets a light reply).

4. **`skills/reactji-acknowledgment/SKILL.md`** — encoded the rule (new "Rule: an acknowledged comment gets AT LEAST a reply" section) plus a 2026-06-30 field note, so it lives in the always-read procedure as well as the code.

5. **`scripts/jobs/test/comment-watcher-test.sh`** — added a stubbed reply poster (`CW_REPLY_LOG`) wired through all four runners, plus REPLY1–REPLY5: trusted non-actionable → reply (not a silent slide); re-poll → no double-reply; the bot's own comment → no reply (spiral guard); untrusted → no reply; actionable → job **and** reply, idempotent on re-poll.

### Verification
- `comment-watcher-test.sh`: **146 passed, 0 failed** (existing 141 + 5 new).
- `comment-claude-fallback-test.sh`: 8 passed, 0 failed (reader prompt change didn't regress).
- `bash -n` clean on all four scripts. The lone shellcheck note (`GARDEN_TAG appears unused`) is the same false positive as the sibling `comment-reactji-gh.sh` — it's consumed by the sourced `common.sh` logger.

### Follow-ups / notes
- The real reply handler defers on a transient list-failure (re-polls next tick) rather than risk a double-reply — a missed reply is recoverable, a duplicate is the spiral. No outstanding gaps.
- The source already drops the bot's own comments (`a27a6da74`); `post_reply`'s `author==bot` refusal is defense in depth and is what the REPLY3 test pins directly.
