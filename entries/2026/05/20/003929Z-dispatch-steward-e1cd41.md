---
ts: 2026-05-20T00:39:29Z
kind: dispatch
role: steward
to: fixer
dispatch_id: e1cd41
dispatch_root: /home/kris/dispatches/fixer--e1cd41
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 304
    role: target
---

# Dispatch fixer e1cd41 — git-blame completion dates for PR #304 (kriskowal CHANGES_REQUESTED)

kriskowal CHANGES_REQUESTED on PR #304 at 2026-05-19T23:31:29Z (review state, not separately reactable):

> We need the completion dates to reflect the real completion date for roadmap calibration purposes. Please use git blame to find the completion date. Better yet, also look through blame to count the time it was under active development as well.

This was issued *before* the consolidate-with-#302 comment (23:33Z) and got eclipsed by it during the prior steward cycle — the consolidation fixer 284d9f addressed only the consolidation ask. This dispatch closes the date-from-blame gap.

PR #304's branch `chore/designs-status-sweep-202605` currently carries the consolidated union of #304 and #302 (head `da9b45263`). About 22 unique designs are touched, of which the subset marked Complete / In Progress / Reference is the surface that wants real dates.

Note: PR #304 is still DRAFT. Land the date work as one or more focused commits; the PR will become un-draftable once date precision matches the maintainer's roadmap-calibration bar.
