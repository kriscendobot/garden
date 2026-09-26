Inbox empty. Work complete.

## Completion report

**Root cause.** The PR-comment watcher (`scripts/jobs/comment-watcher.sh`) violated the invariant *"an ack implies a posted job."* It posted the 👀 reactji **before** posting the job (the old "Reactji FIRST, then post" block). When a post fails to land (`POST LOST`), the head-of-line cursor stays **frozen below the comment** so the directive re-polls next tick — and each re-poll re-fired the reactji while `base_live`/`verify_posted` still couldn't see any job on the board. So a directive whose post kept failing got acked once per tick with zero jobs landing. That is exactly the endojs/endo-but-for-bots #600 incident: `pr600-rebase` was acked **five times at ~04:30Z on 2026-07-18** and never reached the board (confirmed by the reporting press tada `xs2rust-endor-press-20260718-080504`, which had to cover the rebase's intent itself). The underlying post failure was most consistent with post-job's CAS retry exhausting/deduping under the content-data-planes merge (#789) contention window — but whatever made the post fail, the watcher's ack-before-post ordering is what turned a transient drop into five reassuring-but-false receipts. (I confirmed the leader is `endolin-garden2`; this claim host `endolin-garden` is a follower whose watcher is `exec-condition`-skipped, so the 04:30Z tick logs weren't reachable here — the fix rests on the code path, which is unambiguous, plus the press-tada confirmation.)

**Fix (`scripts/jobs/comment-watcher.sh`).**
- Added an `ack_reactji <surface> <cid>` chokepoint (skips the unreactable `pr-review-body`, idempotent since 👀 twice is a GitHub no-op).
- Removed the pre-post reactji; the watcher now **posts → verifies → then acks**. The reactji fires only in the `verify_posted`-confirmed branch and the identity-dedup branch (where a peer's live job exists). The `POST LOST` branch never acks, so a comment whose post never lands is never acked — the withheld 👀 plus the loud repeating `POST LOST` log is now the "something is wrong" signal instead of five false receipts.
- Updated the file-header pipeline description and the stale "reactji already acked it" dedup comment.

**Self-checks (`scripts/jobs/test/comment-watcher-test.sh`).**
- New **AK** case reproduces #600: five failing ticks against a lying poster emit **zero** reactji and keep the cursor frozen; then the tick whose post lands acks exactly once (ack deferred, never lost).
- Tightened **D** to assert no reactji on a lost post.
- Full suite: **234 passed, 0 failed** (no regressions); `bash -n` clean; only a pre-existing unrelated SC2034 warning.

**Shipped.** Committed and pushed to `main2` (`2d20011616`, CAS push landed first attempt).

**Follow-ups (optional, out of scope here):** a directive that `POST LOST`es for many consecutive ticks still only logs — a durable per-comment repeated-failure counter that alerts the maintainer after N ticks would close the "silently retrying forever" gap, but that's additional scope beyond the ordering invariant this job targeted.
