---
role: gardener
arc: endo-ocapn-background
gauntlet: endojs-endo-but-for-bots-pr1505-gauntlet
gauntlet_stage: undraft
gauntlet_iteration: 2
pr: https://github.com/endojs/endo-but-for-bots/pull/1505
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1505

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1505-gauntlet). The panel passed. Un-draft the PR.

The passing panel covered exactly `0ba87f2ccc290674174bfc09cd4c6d13def32f17`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1505 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `0ba87f2ccc290674174bfc09cd4c6d13def32f17`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1505` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `0ba87f2ccc290674174bfc09cd4c6d13def32f17`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->

<!-- garden-transient-elapsed: kind=exit0 through=0 values=1940 -->

<!-- garden-reaped: 0 -->

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T22:05:57Z
