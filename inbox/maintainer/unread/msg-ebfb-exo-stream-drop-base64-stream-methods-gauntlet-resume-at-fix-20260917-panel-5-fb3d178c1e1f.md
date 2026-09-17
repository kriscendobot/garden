from_host: oros-studio-garden-ce242c49
from: gardener:ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-5
reply_to: ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-5
msg_key: msg-ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-5-fb3d178c1e1f
notice_count: 1
first_seen: 2026-09-17T05:11:14Z
last_seen: 2026-09-17T05:11:28Z
sent_at: 2026-09-17T05:11:28Z
---
FLEET-WIDE GitHub credential regression — bot PAT lost write access.

While running gauntlet panel round 5 on endojs/endo-but-for-bots#1100, the panel
DECIDED cleanly (panel.sh exit 0, disposition **must-fix**, 30 seats fanned:
15 must-fix / 7 comment / 8 approve; durably recorded in the panel-run record
bc4aa7a2ab73.md). But I could NOT post the verdict: every GitHub write as
kriscendobot returns HTTP 403 "Resource not accessible by personal access token":
  - gh pr review --request-changes  → 403 (addPullRequestReview)
  - gh pr review --comment          → 403
  - POST /pulls/1100/reviews (REST) → 403
  - POST /issues/1100/comments      → 403 (plain PR comment also blocked)

Round 4's review was posted fine ~1h ago (2026-09-17T03:39Z) by the same
kriscendobot identity, so the fine-grained PAT appears to have been rotated or
downgraded (lost Pull requests: write / Issues: write on endojs/endo-but-for-bots).
Collaborator level still shows pull/push/triage=true, so git-contents pushes may
still work, but no PR/issue/review writes do.

Impact: the ENTIRE fleet's ability to post reviews/comments/undraft on GitHub is
blocked until the token is restored. This gauntlet (and any other) cannot advance.

Action needed: restore the kriscendobot fine-grained PAT's Pull requests + Issues
write permission on endojs/endo-but-for-bots (and confirm the wrapper resolves it),
then this panel-5 stage can be resumed to post the recorded must-fix verdict.

I am NOT emitting the job-complete signal (deliverable unposted); the stage will
requeue and resume cheaply (seats are cached in the panel record) once the token
is fixed.
