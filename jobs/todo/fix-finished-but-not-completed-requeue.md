---
role: fixer
priority: urgent
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: jobs that finish their work but end without completing get requeued, then die on resume

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR). This is blocking the
maintainer-directed carry of endojs/endo-but-for-bots#1100: its gauntlet halted on exactly this on
2026-09-17 and is about to again.

## Pattern (six instances on 2026-09-23 alone)
A worker's `claude -p` session does the work (commits, pushes, opens the PR), then ends normally
(`stop_reason: end_turn`, `subtype: success`, `terminal_outcome: complete-candidate`) WITHOUT writing
the completion (no tada). The gardener records `outcome: requeue`. The next claim RESUMES that
session, which dies in seconds as `transient-failure` (no stop reason, no turns). The reaper then
dooms the job (`requeue-exhausted`) or a gauntlet burns its `max_stage_retries`. Rescue happens only
when a later FRESH session re-derives the state and completes ("a prior attempt already committed and
pushed; only the completion signal was never emitted").

Instances (usage records in `journal2:usage/<base>.jsonl`; tada reports under `jobs/tada/`):
- `ebfb-exo-stream-pr1100-gauntlet-20260923-clean`: 56 turns/299s complete-candidate → requeue, then
  resume died after 14s transient-failure → stage retry 1 (live NOW, leader).
- `design-comment-latency-watch`: designed, landed, opened kriscendobot/garden#110, then requeued twice,
  resume died at 67s; doomed, and the orchestration halted (the liaison withdrew it by hand).
- `fix-comment-watcher-blockquote-address-drop`: landed 4ebf34044e, later doomed requeue-exhausted.
- `harden-garden-container-no-privileged-no-sudo`, `fix-orchestrate-latched-child-failure`,
  `fix-latency-contention-watch-false-alarm-flood`: each pushed its commit, then was requeued and
  rescued by a second fresh claim.

## Ask
1. Root-cause both halves, reading `scripts/jobs/gardener.sh` and the handler and completion path:
   (a) why a successful end_turn session with pushed work does not produce a completion. Does the
   model believe completion is automatic, does the prompt fail to demand it, or does a completion
   marker fail to parse or is it written in the wrong place? Check the role prompts and the
   `<<<GARDEN-…>>>` marker conventions.
   (b) why resuming a finished session dies in seconds. A resumed session with nothing new to do
   should instead be given an explicit "you already finished; verify and complete" continuation
   prompt, or be started FRESH.
2. Fix (b) deterministically: on a `complete-candidate` requeue, the next attempt must get a
   continuation prompt that says the previous session ended without completing and asks it to verify
   the deliverable and complete now. Never do a bare resume of a finished session. It must also not
   count against doom or stage-retry budgets as a non-productive exit when the prior session did
   productive work (commits pushed, PR opened).
3. Fix (a) at the prompt and handler level so completion is emitted in the first session. Consider a
   deterministic post-session check: if the session ended `end_turn` and the job's deliverable is
   observably present (pushed commit, PR recorded via `pr(<base>)`), prompt it once more, in the same
   process, to write its completion before exiting.
4. Tests covering: complete-candidate → continuation prompt (not a bare resume); a productive
   complete-candidate does not consume the doom or stage-retry budget; a genuinely non-productive exit
   still does. Run the gardener, reaper, and gauntlet suites, then push to `main2`.
5. Complete THIS job via the normal completion path. (Yes, really.)
