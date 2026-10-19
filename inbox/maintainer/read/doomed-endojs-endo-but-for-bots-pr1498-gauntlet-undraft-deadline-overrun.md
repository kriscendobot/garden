from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-19T13:13:29Z
doom_base: endojs-endo-but-for-bots-pr1498-gauntlet-undraft
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-10-19T13:13:29Z
last_seen: 2026-10-19T13:13:29Z
---
GAUNTLET stage PARKED in jobs/plan/ after a deterministic handler wall hit on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
The reaper applied neither its ordinary split route nor a generic retry. Gauntlet endojs-endo-but-for-bots-pr1498-gauntlet owns the disposition through max_stage_retries; deterministic wall failures are surfaced to that driver immediately.
Original stage base: endojs-endo-but-for-bots-pr1498-gauntlet-undraft

--- original stage body ---
---
role: gardener
arc: endo-ocapn-background
gauntlet: endojs-endo-but-for-bots-pr1498-gauntlet
gauntlet_stage: undraft
gauntlet_iteration: 3
pr: https://github.com/endojs/endo-but-for-bots/pull/1498
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1498

You are the FINAL stage of a staged gauntlet (endojs-endo-but-for-bots-pr1498-gauntlet). The panel passed. Un-draft the PR.

The passing panel covered exactly `f92173c6d5d18656dcdf0a89957c6c183ed9b508`. A different head has no passing
panel and MUST NOT be un-drafted.

1. Advisory appellate pass (advisory only — it never blocks the un-draft): a light
   `claude -p` review for anything the panel systematically missed; record it, do not
   gate on it.
2. Immediately before any mutation, fetch fresh metadata with
   `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1498 --json isDraft,state,headRefOid`. Require state OPEN and
   headRefOid exactly `f92173c6d5d18656dcdf0a89957c6c183ed9b508`. If the metadata is unreadable/malformed, do
   NOT run `gh pr ready`; report `undraft=metadata-unreadable`. If the head
   differs, do NOT run `gh pr ready`; report `undraft=head-mismatch`.
3. If the matching head is already ready, this stage is a NO-OP. Otherwise run
   `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1498` to un-draft (kind=feature — a probe never reaches this stage).
4. Fetch `isDraft,headRefOid` again. Emit `undraft=done` only when isDraft is
   false and headRefOid still equals `f92173c6d5d18656dcdf0a89957c6c183ed9b508`; otherwise use the applicable
   failure marker below. The deterministic driver independently repeats this gate
   before accepting `undraft=done`.

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: undraft=done -->
  <!-- gauntlet-stage-result: undraft=head-mismatch -->
  <!-- gauntlet-stage-result: undraft=metadata-unreadable -->
