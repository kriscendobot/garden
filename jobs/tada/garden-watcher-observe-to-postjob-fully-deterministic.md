Work complete. Here is my completion report.

---

## Completion report: `garden-watcher-observe-to-postjob-fully-deterministic`

**Landed on `main2`** as commit `6f14bab03`.

### What I did

**Diagnosis confirmed.** The only GitHub watcher with an LLM in its observe→post-job path was `comment-watcher.sh`. Its ambiguous branch (`classify` rc==2 — a trusted @-mention/comment with no recognized verb) called `handlers/comment-claude.sh` as `… 2>/dev/null || echo skip`, so any API error / rate-limit / quota / blank output defaulted to `skip` and dropped the comment with only a 👀. That's how the ambiguous #503 ("Please apply this feedback") and #405 directives were lost.

**Audit result.** `mention-watcher.sh` and `issue-inbox-watcher.sh` already invoke **no** claude in their observe→post-job paths (ambiguous → deterministic `attention`/issue job). No change needed — verified by re-running their tests (19/0 and 25/0).

### What changed
- **`comment-watcher.sh`**: the rc==2 ambiguous branch now sets `VERB=attention` — a deterministic generic triage job carrying the comment context, idempotent by comment id. The verb/triage decision moves into the worked job (a gardener reads the comment and routes it, or replies + no-ops for chatter). The deterministic verb table and all trust/dedup gates are unchanged; only the LLM step is removed.
- Added a **defense-in-depth SELF guard**: the bot's own comment mints nothing (prevents a self-triggered work spiral now that ambiguous → always-a-job).
- Removed the `GARDEN_COMMENT_FALLBACK` indirection and **deleted** the now-dead `handlers/comment-claude.sh` + `test/comment-claude-fallback-test.sh`.
- Updated header/classify docs and `skills/reactji-acknowledgment/SKILL.md` to reflect the deterministic path.
- **Tests** (`comment-watcher-test.sh`): G/REPLY1 now assert a trusted ambiguous comment posts an `attention` job (not an LLM skip); REPLY3 asserts the bot's own comment mints nothing; K re-authored to a non-bot sender so it still exercises the verb-gate; **new DET case** wires the dead fallback env var to a NEVER-CALL sentinel and proves a trusted ambiguous comment STILL posts a job while the sentinel is never touched.

### Verification
- `comment-watcher-test.sh`: **157 passed, 0 failed** (including the DET "LLM unavailable → still a posted job" case and the new SELF-guard assertions).
- `mention-watcher-test.sh`: 19/0. `issue-inbox-watcher-test.sh`: 25/0. `shellcheck -S error` clean. Bash `-n` clean.

### Follow-ups (non-blocking)
- The trusted-conversation reply branch inside `ack_or_log_slide` is now effectively unreachable (that path only fires for untrusted/review-body drops). It's harmless defensive code; a future cleanup could prune it, but I left it since the task scoped to removing only the LLM step.
