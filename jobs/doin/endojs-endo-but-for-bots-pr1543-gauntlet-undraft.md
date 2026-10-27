---
role: gardener
gauntlet: endojs-endo-but-for-bots-pr1543-gauntlet
gauntlet_stage: undraft
gauntlet_iteration: 6
pr: https://github.com/endojs/endo-but-for-bots/pull/1543
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1543

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1543-gauntlet). The panel passed. Un-draft the PR.

The passing panel covered exactly `81e5e47ae3d16223e94692e9f6fd0bf821621dc9`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1543 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `81e5e47ae3d16223e94692e9f6fd0bf821621dc9`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1543` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `81e5e47ae3d16223e94692e9f6fd0bf821621dc9`; otherwise use the applicable
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
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T01:41:25Z
