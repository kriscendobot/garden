---
role: gardener
arc: unallocated
gauntlet: endojs-endo-but-for-bots-pr1355-gauntlet-20261007
gauntlet_stage: undraft
gauntlet_iteration: 1
pr: https://github.com/endojs/endo-but-for-bots/pull/1355
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1355

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1355-gauntlet-20261007). The panel passed. Un-draft the PR.

The passing panel covered exactly `3c06675b1bef346d90e0f41ee2570ababc2fd508`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1355 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `3c06675b1bef346d90e0f41ee2570ababc2fd508`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1355` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `3c06675b1bef346d90e0f41ee2570ababc2fd508`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->
