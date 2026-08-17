---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement, the garden itself (main2, pushed directly per CLAUDE.md
Conventions).

DEFECT: the reaper's one-hop model reroute demotes a job to a tier that cannot
perform its role, which converts a single transient failure into a guaranteed
doom, spending the job's remaining requeue cycles on a model that was never going
to succeed.

WORKED EVIDENCE — job `proposal-compartments-xs-source-phase-design`, a DESIGNER
job posted 2026-08-17T04:34Z, doomed 05:33Z after 5 cycles:

  04:35  requeue  elapsed_s=3   source=none
  04:44  requeue  elapsed_s=93  source=none
  04:53  requeue  elapsed_s=4   source=none
  05:04  requeue  elapsed_s=2   source=none   (peer host)
  05:13  requeue  elapsed_s=5   source=none   (peer host)
  05:24  requeue  elapsed_s=49  source=none
  05:33  doom-notice (requeue-exhausted)

Handler log at the last cycle: "handler for
'proposal-compartments-xs-source-phase-design' exited 0 WITHOUT the completion
signal (exit-0-unsatisfying: quota/API/clean-but-unfinished)", on `hermit/1`
(served local Qwen) and earlier on `cleric/1`. Its parked frontmatter now reads
`tier: minion`, `model-burned: mentor`, empty `fallback-tier:`.

TWO DISTINCT BUGS, please address both.

1. NO CANONICAL FLOOR. `reroute_job_model` (scripts/jobs/common.sh) advances the
   pin down the fallback chain without regard to the job's ROLE. But
   skills/model-selection is explicit that `designer` and `builder` ride the
   latest Opus, and CLAUDE.md repeats it. Demoting a designer job to `minion`
   (Anthropic Opus 4.x, Codex below Sol, served local Qwen) makes success
   impossible, so the remaining four cycles were pure waste. The reroute should
   respect a per-role floor: reroute ACROSS providers at the same tier where
   possible, and refuse to demote BELOW a role's canonical tier, surfacing the job
   for a human instead of dooming it silently.

2. BURNING A TIER THAT WAS NEVER SERVED. This is the subtler one. Per
   skills/model-selection § "The anthropic automatic-work cost ceiling", the
   Claude handler SERVES AN AUTOMATIC MENTOR JOB AT THE MINION MODEL, because the
   standing ceiling for automatic fleet work is Opus 4.8. So when this job was
   nominally at `tier: mentor` and claimed by an Anthropic worker, it was actually
   executed at the minion model. The reroute then recorded `model-burned: mentor`
   on the strength of that failure. But mentor was never actually tried: the
   evidence for "mentor cannot do this job" was never collected. A tier should not
   be burned on the basis of a failure that occurred while the job was being
   served at a DIFFERENT, lower tier. Either the burn must record the tier
   actually served, or the ceiling downshift must suppress the burn.

AUDIT: several other jobs are parked in `jobs/plan/` behind go-ahead gates with
doom signatures `requeue-exhausted` or `elapsed-constancy`, including
`endojs-endo-but-for-bots-pr282-pin-rebase-reconcile` (elapsed-constancy, 4
requeue cycles, 2 confirmations),
`endojs-endo-but-for-bots-pr340-shepherd-20260816`,
`endojs-endo-but-for-bots-pr856-weave`, `weave-base-update-and-pin-alias`,
`endojs-endo-but-for-bots-pr1006-dependabot`, and
`endojs-endo-but-for-bots-pr897-weave`. Check each for the same signature: a
`model-burned:` line plus a role whose canonical tier is above the tier it ended
on. Report which were mis-doomed by this mechanism rather than by genuinely broken
handlers, since those are cheap to recover and are currently indistinguishable
from real failures.

Deliverable: a contained fix on main2 if the change is clear, otherwise a design.
Include a regression test. Related in-flight work worth reading first so you do
not overlap: `garden-requeue-rediscover-prior-work` (duplication arising from
requeues) and `garden-orchestration-halt-record-accuracy` (halt records that
misreport what happened).
