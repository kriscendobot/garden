---
role: gardener
gauntlet: kriscendobot-minion.town-pr167-gauntlet-20261013
gauntlet_stage: undraft
gauntlet_iteration: 1
pr: https://github.com/kriscendobot/minion.town/pull/167
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — kriscendobot/minion.town PR #167

You are the FINAL stage of a staged gauntlet (kriscendobot-minion.town-pr167-gauntlet-20261013). The panel passed. Un-draft the PR.

The passing panel covered exactly `8368f8c66ac60b810242b7210e2529fb12ad5008`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/kriscendobot/minion.town/pull/167 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `8368f8c66ac60b810242b7210e2529fb12ad5008`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/kriscendobot/minion.town/pull/167` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `8368f8c66ac60b810242b7210e2529fb12ad5008`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->
