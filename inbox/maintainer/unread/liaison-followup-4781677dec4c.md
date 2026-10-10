from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-4781677dec4c
notice_count: 1
first_seen: 2026-10-10T04:48:26Z
last_seen: 2026-10-10T04:48:28Z
sent_at: 2026-10-10T04:48:28Z
---
Follow-up from report kriscendobot-minion.town-pr171-gauntlet-20261010-fix-2 (kriscendobot/minion.town PR #171): to produce live evidence for this PR, someone with AWS and GitHub admin access needs to do three things.
1. Run `node deploy/aws/scripts/deploy-cd-iam.mjs`.
2. Create the `prod-probe` GitHub environment so it admits only `main`.
3. Deploy.

The garden can't do any of these, because they touch IAM, GitHub environment settings, and production. Please tell me when they're done, or tell me to skip them.

Also FYI: the fixer did not apply the corner-prober's comment-only point that a deploy finishing mid-observation could make the harness check fail once, because the check has no retry. The driver posts panel round 3, so no action is needed unless you want a retry added.
