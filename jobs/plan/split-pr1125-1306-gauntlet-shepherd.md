---
gate: orchestrated
orchestrated_by: split-pr1125-stack-gauntlets
priority: normal
posted_by: producer
posted_at: 2026-09-17T21:53:25Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet + shepherd for endojs/endo-but-for-bots#1306 (slice 2/3 of the #1125 split)

PR #1306 is slice 2/3 (guest provisioning (pins, networks, names)) of the three-PR stack that replaced the retired
#1125. Head branch `bot/build/1125-guest-provisioning`, base branch `bot/build/1125-readonly-directory-attenuation`. Run its gauntlet AND drive its
CI to green, and do NOT complete this job until the gauntlet terminates
(panel-clean + CI-green + un-drafted) — this is a supervised, blocking gauntlet.

Stack-cascade discipline (load-bearing — this is why the stack's gauntlets are
serial, not parallel):
- Before touching #1306, ensure its base branch `bot/build/1125-readonly-directory-attenuation` is current. Slice 1304 ran its gauntlet/merge just before this one, so `bot/build/1125-readonly-directory-attenuation` may have advanced or merged. Rebase `bot/build/1125-guest-provisioning` onto the current tip of its base (fetch endojs `bot/build/1125-readonly-directory-attenuation`; if 1304 merged to llm, repoint this PR's base to the pinned llm snapshot and rebase onto it), resolve any conflicts, and force-push with scripts/jobs/gardening/safe-push-pr-head.sh --mode rewrite. A fix the prior slice's gauntlet pushed MUST be inherited here, not reverted.
- Only after the base is settled, initiate the gauntlet:
  `scripts/jobs/gardening/post-gauntlet.sh endojs-endo-but-for-bots-pr1306-gauntlet https://github.com/endojs/endo-but-for-bots/pull/1306`
  then supervise it to termination (the staged gauntlet.sh driver walks
  clean→panel→fix→un-draft; its clean/fix stage is the shepherd loop that drives
  CI green). Poll jobs/gauntlet/endojs-endo-but-for-bots-pr1306-gauntlet.md and its
  tada; if CI needs more than the gauntlet's clean stage, post/supervise a shepherd.
- Local verification note: the daemon integration tests fail LOCALLY only because
  the per-job worktree path exceeds the ~104-char unix-socket limit (endo.sock
  ENOENT); this is environmental, not a code defect — CI has short paths. tsc +
  eslint are the local green signal.

Report the gauntlet outcome (rounds, must-fix, final CI state, un-draft status).
