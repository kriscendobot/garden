---
role: gardener
arc: garden-book
gauntlet: kriscendobot-garden-book-pr16-gauntlet
gauntlet_stage: undraft
gauntlet_iteration: 2
pr: https://github.com/kriscendobot/garden-book/pull/16
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — kriscendobot/garden-book PR #16

You are the FINAL stage of a staged gauntlet (kriscendobot-garden-book-pr16-gauntlet). The panel passed. Un-draft the PR.

The passing panel covered exactly `9c98898f97d32926edd1c71225ed4d53ba78f1e0`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/kriscendobot/garden-book/pull/16 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `9c98898f97d32926edd1c71225ed4d53ba78f1e0`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/kriscendobot/garden-book/pull/16` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `9c98898f97d32926edd1c71225ed4d53ba78f1e0`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->
