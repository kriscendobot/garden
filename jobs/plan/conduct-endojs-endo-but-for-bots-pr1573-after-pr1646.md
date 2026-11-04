---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: build-api-key-agents-p1-provider-registry
posted_at: 2026-11-04T04:23:37Z
---

---
role: conductor
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct endojs/endo-but-for-bots PR #1573 after the Node pin lands

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1573 (head `feature/api-key-provider-registry`, base `llm`, last head 50a020ea4b7).
Directive: kriskowal's APPROVED review on #1573, "Please conduct" (2026-11-04T00:31:46Z).

The first attempt, `endojs-endo-but-for-bots-pr1573-conduct`, stalled with CI red on `test-xs` only. The red comes from `llm` itself: `.node-version` is `lts/*`, which now resolves to Node 26. https://github.com/endojs/endo-but-for-bots/pull/1646 pins it to 24. This job is promoted when #1646 merges or closes.

1. Confirm `.node-version` on `llm` no longer resolves to Node 26, or that `test-xs` is otherwise green on `llm`. If #1646 closed without a fix, stop and message the maintainer; do not merge on red.
2. Confirm #1573 is still open, approved, and not already merged.
3. Merge per roles/conductor/AGENT.md through `ci-wait-merge.sh`, which rebases onto current `llm` and waits for CI on the new head. Do not merge on red.

Known flake not from this diff: `bwrap timeout and repeated cancellation reap process groups` in `packages/sandbox` (open fix #1591). Rerun that job once before stalling.

Merging #1573 promotes the parked `weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573`. Pinned to endolin because the oros-studio PAT gets a 403 on PR writes to endojs.
