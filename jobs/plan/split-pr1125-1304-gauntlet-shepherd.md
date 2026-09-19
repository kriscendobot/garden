---
gate: deferred
priority: normal
role: gardener
tier: mentor
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-18T00:03:11Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T00:03:11Z
---

---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T21:58:04Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet + shepherd for endojs/endo-but-for-bots#1304 (slice 1/3 of the #1125 split)

PR #1304 is slice 1/3 (read-only directory attenuation) of the three-PR stack that replaced the retired
#1125. Head branch `bot/build/1125-readonly-directory-attenuation`, base branch `llm-387ea66`. Run its gauntlet AND drive its
CI to green, and do NOT complete this job until the gauntlet terminates
(panel-clean + CI-green + un-drafted) — this is a supervised, blocking gauntlet.

Stack-cascade discipline (load-bearing — this is why the stack's gauntlets are
serial, not parallel):
- Before touching #1304, ensure its base branch `llm-387ea66` is current. This is the base of the stack; no rebase needed.
- Only after the base is settled, initiate the gauntlet:
  `scripts/jobs/gardening/post-gauntlet.sh endojs-endo-but-for-bots-pr1304-gauntlet https://github.com/endojs/endo-but-for-bots/pull/1304`
  then supervise it to termination (the staged gauntlet.sh driver walks
  clean→panel→fix→un-draft; its clean/fix stage is the shepherd loop that drives
  CI green). Poll jobs/gauntlet/endojs-endo-but-for-bots-pr1304-gauntlet.md and its
  tada; if CI needs more than the gauntlet's clean stage, post/supervise a shepherd.
- Local verification note: the daemon integration tests fail LOCALLY only because
  the per-job worktree path exceeds the ~104-char unix-socket limit (endo.sock
  ENOENT); this is environmental, not a code defect — CI has short paths. tsc +
  eslint are the local green signal.

Report the gauntlet outcome (rounds, must-fix, final CI state, un-draft status).
