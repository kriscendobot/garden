---
ts: 2026-05-19T23:49:08Z
kind: dispatch
role: steward
to: fixer
dispatch_id: 284d9f
dispatch_root: /home/kris/dispatches/fixer--284d9f
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 304
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 302
    role: source
---

# Dispatch fixer 284d9f — consolidate PR #302's batch status updates into PR #304

kriskowal asked on PR #304 (`https://github.com/endojs/endo-but-for-bots/pull/304#issuecomment-4493068464`) to consolidate the design-status updates. PR #302 (`chore/designs-batch-status-update-2026-05-19`, closed unmerged at 2026-05-19T23:32:50Z) covers 12 designs; PR #304 (`chore/designs-status-sweep-202605`, OPEN DRAFT) covers 13 designs. Three files overlap.

The fixer should land PR #304's branch with the union of both PRs' true-fact updates and let #302 stay closed.
