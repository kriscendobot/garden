---
role: fixer
---

Fix `endojs/endo-but-for-bots` PR #682 (design: `@endo/reminder` message-scheduler plugin, M3 scheduled-execution) on branch `design/endo-reminder` to resolve kriskowal's CHANGES_REQUESTED review on `designs/endo-reminder.md`: (1) correct the persistence-atomicity claim to write-then-move-within-a-directory rather than relying on write atomicity; (2) note that incarnation-on-start relies on the user placing the scheduler under `@pins` per the README; and (3) revise the capability-retention path to use `storeValue` and gate the send-by-SturdyRef behavior on SturdyRef progress, replying inline with the relevant in-flight SturdyRef issues/PRs (the #697–#704 bridge stack) or identifying gaps in those plans.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  claimed_at: 2026-07-13T15:07:50Z
