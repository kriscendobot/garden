Inbox empty. Work complete.

## Completion report

**Job:** `improve-pr-feedback-preflight-recheck-head` — move the "re-check the live thread before pushing queued feedback work" responsibility off an agent self-improvement note and into a script that runs every time.

**What I did**

1. **New `scripts/jobs/gardening/pr-feedback-preflight.sh`** (modeled on `scholar-preflight.sh`): a no-LLM gate a PR-feedback consumer runs *before* editing. Given `<repo> <pr> <comment-id> [<reviewer-login>]` it gathers an evidence corpus — recent commit messages on the PR branch HEAD plus `pulls/<pr>/comments` inline replies (each prefixed `in_reply_to=<id>`) — and detects a peer's already-landed resolution via three deterministic signals:
   - `in_reply_to=<cid>` — a reply on the same inline thread,
   - the comment id cited word-bounded (a commit/reply citing the comment id or URL),
   - `Addressed @<reviewer>` / `@<reviewer>'s review` (only when a reviewer login is supplied).
   
   **Exit codes:** `0` = proceed, `2` = no-op (peer already resolved), any other = fail-open → proceed (a transient never silently skips real work; the push CAS stays the backstop). The evidence fetch is indirected through `GARDEN_PREFLIGHT_EVIDENCE` so the match logic stays testable; the default uses `gh`+`jq` (guarded by `require_tools`).

2. **Wired it into `comment-watcher.sh`** — added a shared `preflight_instruction` helper and injected the "BEFORE you edit, run the preflight" block into `write_job_body`'s non-mechanical paths: the `review` job body and the generic attention/triage path (gated to skip the mechanical verbs rebase/retcon/refresh/shepherd/gauntlet). Threaded the comment id through to `write_job_body`.

3. **Wired it into `mention-watcher.sh`** — same instruction on the `attention` path only; threaded `cid` through.

4. **New hermetic test `scripts/jobs/test/pr-feedback-preflight-test.sh`** (13 cases): each resolution signal, word-boundary non-collision, reviewer-gating, both fail-open paths, and the usage guard.

**Verification**
- All three scripts parse (`bash -n`).
- New test: 13/13 pass.
- `comment-watcher-test.sh`: 127/127. `mention-watcher-test.sh`: 19/19.
- Job-body rendering confirmed: review + attention paths emit the exact preflight command; mechanical verbs do not.
- Double-space style gate: clean.

**One bug caught and fixed mid-work:** my first mention-watcher edit used `[ "$verb" = attention ] && preflight_instruction …` as the block's last statement, which returns 1 for non-attention verbs and tripped the watcher's `set -e` (mention-watcher-test died in case A). Switched to an `if`-`fi`; suite went green.

**Committed and pushed** `83222fe42` to `origin/main2` (clean push, first attempt).

**Follow-ups:** none required. Optional future polish — the existing `feedback_recheck_thread_before_pushing_queued_infra` self-improvement note could now cross-reference this script as the enforced read-side mechanism, but that's a doc nicety, not a gap.
