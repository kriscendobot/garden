---
posted_at: 2026-11-17T18:50:20Z
role: gardener
gauntlet: endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2
gauntlet_stage: undraft
gauntlet_iteration: 3
pr: https://github.com/endojs/endo-but-for-bots/pull/1591
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1591

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2). The panel passed. Un-draft the PR.

The passing panel covered exactly `8708f561946b89bc0258281c3acdba590786b04e`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1591 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `8708f561946b89bc0258281c3acdba590786b04e`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1591` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `8708f561946b89bc0258281c3acdba590786b04e`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->
