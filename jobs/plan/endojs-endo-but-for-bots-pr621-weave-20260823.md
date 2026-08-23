---
gate: go-ahead
budget_hold: true
park_reason: over-token-budget
parked_for_budget_at: 2026-08-23T04:05:15Z
budget_window_seconds: 604800
budget_resets_at: 2026-08-29T04:00:00Z
posted_by: producer
posted_at: 2026-08-23T04:05:15Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# pin the merge base / weave endojs/endo-but-for-bots PR #621

Map: **weaver** (pin the merge base) → refresh PR #621 onto the current live `llm` tip.

PR: https://github.com/endojs/endo-but-for-bots/pull/621
Head branch: `design/endoclaw-oauth-foundation` (currently `ee359efb57f259bdb99b88f756e1024a138a6b97`)
Current (frozen) base: `llm-28dffa9` at `28dffa95907bed08a713d4b25dbae8000ab693c0`

## Why

Maintainer (kriskowal) directed **"Conduct."** (merge) on 2026-08-22, then poked
2026-08-23. CI is green on the current head and the PR carries kriskowal's
2026-08-01 APPROVED review, but the PR sits on a frozen snapshot `llm-28dffa9`
that is now **747 commits behind live `llm`** (live tip `1ceed5892103...`; head is
6 commits ahead / 747 behind, status diverged). The conductor's `safe-rebase`
would fail closed `needs weave` on the near-certain `designs/README.md` conflict,
so weave first.

## Task

Refresh the PR onto current live `llm`, following the established pattern used on
this PR's prior rebases (kriscendobot, 2026-07-20 and 2026-07-24):

1. Recreate a fresh frozen-base snapshot `llm-<newsha>` at the current live `llm`
   tip (or retarget the base to live `llm` — pick per weaver/frozen-base
   convention), and repoint PR #621's base to it.
2. Rebase the six OAuth-foundation design commits onto that base with
   `--force-with-lease` against the expected head anchor `ee359efb`.
3. Resolve the `designs/README.md` conflicts by the established convention:
   preserve the current live-`llm` design-index entries AND incorporate the PR's
   expanded OAuth caretaker-attenuation index/roadmap entries (see the 07-20 /
   07-24 rebase comments for the exact shape).
4. Confirm CI converges green on the rebased head.

## After the weave lands (hand-off note, NOT part of this job)

The rebase invalidates kriskowal's 2026-08-01 approval (commit IDs change), so the
conductor's exact-head approval gate will stall `merge blocked: no maintainer
approval`. A **fresh maintainer approval on the rebased head** is required before
a `conduct #621` job can merge. Surface that to the maintainer in the completion
report; do not attempt to merge from this weave job.

Commenting on endojs/endo-but-for-bots is covered by the repo's standing
authorization; a rebase-explanation top-level comment is appropriate per the
weaver's usual practice.
