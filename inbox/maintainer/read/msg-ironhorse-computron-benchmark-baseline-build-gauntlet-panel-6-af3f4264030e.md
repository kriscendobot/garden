from_host: oros-studio-garden-ce242c49
from: gardener:ironhorse-computron-benchmark-baseline-build-gauntlet-panel-6
reply_to: ironhorse-computron-benchmark-baseline-build-gauntlet-panel-6
msg_key: msg-ironhorse-computron-benchmark-baseline-build-gauntlet-panel-6-af3f4264030e
notice_count: 1
first_seen: 2026-09-16T09:24:59Z
last_seen: 2026-09-16T09:25:08Z
sent_at: 2026-09-16T09:25:08Z
---
BLOCKER — bot GitHub PAT lost write scope for PRs/Issues.

Job: ironhorse-computron-benchmark-baseline-build-gauntlet-panel-6 (gauntlet PANEL round 6 on endojs/endo-but-for-bots#1283).

The panel RAN fine (panel.sh exit 0, disposition **must-fix**, durably recorded at panel-runs/endojs-endo-but-for-bots-1283/8528976561cc.md). But I could NOT post the verdict — every write to the repo 403s "Resource not accessible by personal access token":
  - gh pr review (GraphQL addPullRequestReview) → 403
  - REST POST .../pulls/1283/reviews → 403
  - gh pr comment (GraphQL addComment) → 403
  - REST POST .../issues/1283/comments → 403

Diagnosis: kriscendobot's fine-grained PAT can push commits (Contents:write — repo shows push:true) but has only READ on Pull requests + Issues, so it can create no review and no comment. This blocks EVERY panel-verdict / PR-comment / reactji write across the fleet on this repo (and likely others), not just this stage. gh-credential-guard.sh is dated 2026-09-15 — a recent token rotation likely narrowed the scope.

Fix: widen the bot PAT's "Pull requests" and "Issues" permissions to Read+Write (and re-store via gh auth), then the retried panel round will post cleanly.

I completed this stage as panel=panel-error (sensor/actuator failure, not a review verdict) so the driver retries the round under its bounded stage-retry budget rather than advancing a fixer against a verdict that never landed. Retries will keep failing identically until the PAT scope is fixed.
