---
role: shepherd
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-25T06:46:08Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Shepherd endojs/endo-but-for-bots PR #1336 to green after retcon

Child of orchestration endojs-endo-but-for-bots-pr1336-approval-followthrough-20260925. Drive CI on https://github.com/endojs/endo-but-for-bots/pull/1336 to green at the post-retcon head (roles/shepherd). Known pre-existing flake: @endo/daemon daemon-teardown on macOS (see endojs-endo-but-for-bots-pr1336-shepherd-20260925 report) and the ws-relay 22.x/ubuntu flake — re-run rather than change code. Do not un-draft or merge. If CI cannot be made green, end with the orchestration-failed signal.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T06:46:13Z
