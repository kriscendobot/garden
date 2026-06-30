## Completion report — `endojs-endo-but-for-bots-pr57-rebase`

**Disposition: declined-and-deferred (no rebase performed) + root-cause garden fix landed.**

### What this job actually was
The job mapped a "rebase" directive sourced from comment `4840040541` on PR #57. Re-fetching that comment (treated as untrusted data) showed it was authored by **kriscendobot — the bot itself**, at 2026-06-30T05:01:10Z: *"I've parked the restage of this PR pending #475 ... I'm holding until #475 settles."* Its semantic intent is **not to rebase**; the comment-watcher's verb classifier keyed on the word "restage/rebase" and spawned a directive job from the bot's own park-acknowledgment. A self-feedback loop.

### Why no rebase was done
- PR #57 is stacked on PR #475 (`feat/narrow-bytearray-to-uint8`). Reconfirmed live: **#475 is still DRAFT, CHANGES_REQUESTED, DIRTY**, and its own fix job (`endojs-endo-but-for-bots-pr475-a8a47b48`) is in `doin/` right now (lint + conflicts + requested tests in flight).
- Both erights (the senior contributor, comment 04:56:19Z) and the bot's own committed plan say to restage **only after #475 settles**. Rebasing onto a still-moving, conflicting base now is explicitly contraindicated.
- The legitimate future restage intent is **already preserved**: `jobs/plan/port-ebfb-pr57-onto-475-restage.md` (gate: go-ahead, posted 05:00:57Z) captures erights' directive with the full precondition. Completing this spurious job loses nothing.
- No new PR comment posted: the bot already acknowledged the park on the thread; a duplicate would be noise.

### Root-cause fix (landed on main2: `a27a6da74`)
The comment-watcher's source (`scripts/jobs/handlers/comment-source-gh.sh`) emitted the bot's own comments/reviews; the watcher had no self-author skip. Added `select((.user.login // "") != $bot)` to **all three surfaces** (issues/comments, pulls/comments, pulls/N/reviews) — the `bot` arg was already plumbed in but unused for filtering. Trusted external senders remain gated downstream; only the bot's own login is dropped at the source. Verified: `bash -n` clean, and a jq fixture confirms the bot row is dropped while a trusted-sender (erights) row is kept.

(Note for transparency: I first mistakenly edited the deployed root checkout `/home/kris/scripts/...`; I reverted it clean and re-applied the change in my job worktree, where it was committed and pushed.)

### Follow-ups
- The restage will happen when `jobs/plan/port-ebfb-pr57-onto-475-restage.md` is promoted (once #475 is updated and its changes resolve). No action needed from this job.
- The main2 fix awaits the normal deliberate-deploy cycle to reach running watchers; until then, the leader's running comment-watcher may still occasionally self-trigger on bot comments.

**Self-improvement:** Landed the fix directly (the lesson was a concrete code defect, not a role/skill change). The broader pattern — the bot must never ingest its own comments as directives — is now documented in the source handler's header.
