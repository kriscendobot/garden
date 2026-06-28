# Implement kriskowal's inventory-grouping taxonomy directive on endo-but-for-bots PR #405

Map: **build/fix** on `endojs/endo-but-for-bots` PR #405 (OPEN, mergeable) via the gamut
(researcher → builder/fixer → judge panel). Bot fork; standing comment authorization.
COMMUNICATE ON THE PR, NOT THE MAINTAINER INBOX (the issue/PR comms directive): reply to
kriskowal with inline + a top-level summary comment on #405; the liaison already posted an
acknowledgment there (issue-comment 4825094575).

## The directive (kriskowal on PR #405)
https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4819835663
Replace the current 4-group taxonomy (Handles / Hubs / Workers / Everything Else) with:
- **Directories**: directories, readable trees, mounts, scratch mounts
- **Agents**: guests
- **Personas**: hosts
- **Values**: marshal
- **Capabilities**: all others
AND hide groups that are empty (e.g. Workers when there are no workers) — FULL empty-group
hiding (the PR already does partial CSS-based hiding of the 4-group version).

## Scope (cross-package, as the surveying gardener mapped)
- `packages/space-chat` — the inventory grouping logic (the bucket mapping).
- `packages/chat` — CSS + tests for the new buckets + empty-group hiding.
- `packages/cli` — `endo list --grouped` bucket set + tests.
- `packages/daemon` — type annotation only if the new buckets need new types.
The PR already implements the 4-group version + partial empty-group hiding; this RESHAPES the
buckets to the 5 above and completes empty-group hiding.

## Note
This is NOT a rebase (the garden classifier mis-tagged it; PR is already mergeable). A separate
garden-infra fix for that classifier bug was flagged by the surveying gardener. Run the actual
feature change here through builder/fixer + the judge panel, push to the PR branch, and post the
top-level summary comment on #405 per the comms norm.

---
claim:
  host: endolinbot
  gardener: 86
  claimed_at: 2026-06-28T06:15:59Z
