---
kind: dispatch
role: shepherd
host: endolinbot
posture: liaison
short_id: 9d2f88
dispatch_root: dispatches/shepherd--9d2f88
repo: endojs/endo-but-for-bots
branch: feat/cli-http-client-mk-phase-1
pr_number: 286
slot: 1
---

Shepherd stage for slot 1 PR #286 (cli-http-client Phase 1). Cleaner
flagged that no CI workflow has been triggered for this PR since open;
other recent kriscendobot draft PRs on llm base do enqueue CI normally.
Shepherd brief: diagnose why CI isn't running (workflow gate? branch
filter? draft-PR rule? empty-commit push needed?), drive checks to
green so the judge can verify before un-drafting.
