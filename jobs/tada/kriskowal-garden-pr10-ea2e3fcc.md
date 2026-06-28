Inbox empty. Work complete.

---

## Completion report — kriskowal-garden-pr10-ea2e3fcc

**Directive (kriskowal, garden#10):** "Please allow an empty reply section. If the reply is empty, just move the message from unread to read."

**Root cause.** The maintainer answers gardeners with `scripts/jobs/maintainer-reply.sh <msgid> [body-file]`, which always forwarded the body to `inbox-send.sh` and then archived. With a blank body, `inbox-send.sh` substituted the literal string `"(empty message)"` and delivered *that* into the doer's inbox — so there was no way to dismiss a message that needs no answer without spamming the doer.

**Change** (worktree off `origin/main2`, pushed as commit `a082bafa9`):
- `scripts/jobs/maintainer-reply.sh` — now resolves the reply body itself (body-file, else stdin, else empty). If the result is blank or whitespace-only, it calls `maintainer-archive.sh` (unread → read) and delivers **nothing**, then exits 0. A bare acknowledgment no longer requires a `reply_to`. A non-empty reply takes the original path (delivered via a temp body-file, then archive). Header comment documents the new behavior.
- `skills/message-bus/SKILL.md` and `roles/liaison/AGENT.md` — documented that an empty reply to `maintainer-reply.sh` is equivalent to a bare archive.

**Verification.** `bash -n` clean; shellcheck shows only the two pre-existing benign findings shared by every sibling script (unfollowable `common.sh` source; `GARDEN_TAG` consumed by `common.sh`). Smoke-tested the body-resolution + empty-detection block across six cases (no-arg/tty, whitespace-only file, real file, empty pipe, whitespace pipe, real pipe) — all classify correctly. Worktree torn down.

**Follow-ups / notes.**
- This landed on `main2` (dev branch). It reaches the deployed root checkout only via the deliberate `deploy-garden.sh`, as expected — no live deploy was performed.
- Inline non-file body strings as `$2` are still treated as "no body-file" (fall through to stdin, then empty), matching the documented `<body-file>` contract and the original `inbox-send.sh` behavior; not a regression.

**Self-improvement:** A `git push ... 2>&1 | tail` in a retry loop masks the push's exit status (pipeline status is `tail`'s), so a rejected non-fast-forward push reads as success and the CAS loop silently no-ops. Always `set -o pipefail` (or test `git push` un-piped) in journal/main2 CAS push loops — worth a line in the job-board/worktree push guidance.
