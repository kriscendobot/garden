---
role: fixer
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: orchestrate.sh reports a child "failed" after it later reached a clean tada

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR). Maintainer-approved (kriskowal, 2026-09-23 muster).

## Evidence
Orchestration `minion-town-claude-inference-exploration-20260922` (parallel, 2 children) finished
**complete-with-failures**, naming `build-minion-town-claude-agent-sdk-inference-20260922` as failed:
its terminal record says `failure detected` (`scripts/jobs/orchestrate.sh` ~862-864). But that child's
tada report (`jobs/tada/2026/09/22/build-minion-town-claude-agent-sdk-inference-20260922.md`) is
CLEAN. It delivered draft kriscendobot/minion.town#106 with CI green and carries NO
`orchestration-failed: true` marker. The maintainer inbox also got a
`...-child-...-failed` notice for it, archived 2026-09-23. So the orchestrator reported, and paged
about, a success. The only 2026-09-22 journal history is on branch `journal2-archive-20260923`
(sha 9480f75dac). Reconstruct from there why the child was classed failed, most likely a
transient doomed/requeue/vanished reading that was latched into the failed list and never re-evaluated.

Related shape seen today: finished jobs that exited without complete-job get doomed, and the
orchestrator halts on them (`comment-latency-watch` halted on a design that had landed; the
liaison withdrew it and promoted the build by hand, and the orchestrator logged "halt record
superseded — parked children progressed"). The superseding path exists for halts, but apparently not
for the final disposition of a parallel run.

## Ask
1. Find the exact path that recorded this child as failed. Fix it so a child's FINAL disposition
   is re-derived from the board at terminal time: a child that has a tada report without
   `orchestration-failed: true` is **done**, and any earlier failure reading is superseded (note that
   in the terminal record, e.g. "recovered after transient failure"). The terminal status should then
   be `complete` if every child ended done.
2. When a previously notified failure is superseded by a clean tada, close the failure notice
   (the watchdog/doom notice `--recovered` pattern) instead of leaving a stale page.
3. Do not weaken real failure detection: vanished-without-tada, `orchestration-failed: true`,
   doomed-and-still-parked, and the stall limit must still fail.
4. Tests in the orchestrate test suite: a parallel child that goes doomed, is re-promoted, and then
   tadas cleanly gives a terminal status of complete; a child whose tada has `orchestration-failed: true`
   still fails; a vanished child still fails. Run the orchestrate suites and push.
5. Complete the job via the normal completion path when done.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T20:35:59Z
