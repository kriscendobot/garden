---
role: gardener
arc: minion-town-git-remote
gauntlet: endojs-endo-but-for-bots-pr1367-gauntlet
gauntlet_stage: undraft
gauntlet_iteration: 4
pr: https://github.com/endojs/endo-but-for-bots/pull/1367
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1367

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1367-gauntlet). The panel passed. Un-draft the PR.

The passing panel covered exactly `351dd0bc476c24d9fc6db92fbecd1035336de93e`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1367 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `351dd0bc476c24d9fc6db92fbecd1035336de93e`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1367` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `351dd0bc476c24d9fc6db92fbecd1035336de93e`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-24T20:35:35Z
