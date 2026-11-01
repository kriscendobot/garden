---
posted_at: 2026-11-01T19:50:45Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
The gate blocked a fully successful weave at 19:33:48Z (job weave-endojs-endo-but-for-bots-pr1561-pr1563-pr1625-onto-pr1560-20261101). That job pushed all heads and moved the PR bases before the gate ran, and its `## Follow-ups` section only held maintainer notes (changeset decision, CI not yet reported, retargeting after merge). The handler exited rc=1 and the job was left in doin for the reaper, which risks re-running a completed force-push weave. Narrow the "substantive follow-up" heuristic so it ignores purely advisory maintainer notes. Alternatively, when the gate blocks after the work was already done, route the unresolved follow-ups to the maintainer inbox through message-user.sh and record the job complete. Do not leave it in doin. Add a regression test using this report shape.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T20:29:41Z
