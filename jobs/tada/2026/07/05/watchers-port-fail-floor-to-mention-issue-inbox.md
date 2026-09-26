Inbox is empty. The work is complete and pushed. Here's my report.

---

**Job complete: ported comment-watcher's `fail_floor` to the mention- and issue-inbox watchers.**

## What I did

Both `mention-watcher.sh` and `issue-inbox-watcher.sh` handled an un-confirmable dispatch with `failed=1; break` — the exact head-of-line block that comment-watcher fixed after the #594 postmortem. One item whose post/delivery couldn't be verified froze the scalar high-water cursor *and* abandoned every chronologically-later item in the batch, tick after tick, since each tick re-polls from the same frozen cursor and breaks at the same front item.

## What changed

**`scripts/jobs/mention-watcher.sh`**
- Added `fail_floor=""` + a `slide()` helper (`slide() { [ -z "$fail_floor" ] && hw="$1"; return 0; }`) that freezes the cursor once the first failure is recorded.
- Converted all four `hw="$created"` cursor-advances to `slide "$created"`.
- The **POST-LOST** site and the **trust-INDETERMINATE** site now record `fail_floor=<first-failed created_at>` and `continue` instead of `break`, so later independent mentions are still classified/posted this tick while the failed item re-polls next tick.
- **Bonus (as the job suggested):** replaced the source's `2>/dev/null` with an `ERRF` capture — echo stderr on failure, and degrade a transient network blip to a skipped tick (`is_transient_net_error`) instead of a `die` → systemd restart storm. This closes the silent-blindness gap (the 2026-06-24 jq-outage signature).

**`scripts/jobs/issue-inbox-watcher.sh`**
- Same `fail_floor`/`slide()` port. Both `break` sites (POST LOST for a new issue, COMMENT DELIVERY LOST) now freeze the floor and continue; all five `hw="$created"` slides converted. (No trust-indeterminate case here — `is_maintainer` is binary allowlist-only.)

**Tests** — extended both suites for the held-floor case:
- `mention-watcher-test.sh`: case **G** (earlier lost post doesn't block a later mention) and case **H** (earlier *indeterminate* trust row doesn't block a later mention); added an `MW_INDETERMINATE` knob to the trust stub. **25/25 pass.**
- `issue-inbox-watcher-test.sh`: case **K** (earlier lost issue-post doesn't block a later comment delivery; cursor frozen at floor). **28/28 pass.**
- Verified the new cases genuinely discriminate: a temporary revert to the old `break` makes case G's "later mention still posted" assertion **fail**, confirming the test catches the bug.

Syntax-checked both scripts; shellcheck shows only pre-existing warnings (none in the new code).

## Pushed
Commit `a95c0fe7a` is on `origin/main2` (rebase-CAS, landed first attempt). No follow-ups; the two watchers now share comment-watcher's head-of-line-safe cursor semantics.
