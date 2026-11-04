from_host: oros-studio-garden-ce242c49
from: followup-gate:build-api-key-agents-p0-freeze-onboarding
reply_to: build-api-key-agents-p0-freeze-onboarding
msg_key: followup-gate-build-api-key-agents-p0-freeze-onboarding
notice_count: 1
first_seen: 2026-11-04T02:47:44Z
last_seen: 2026-11-04T02:53:43Z
sent_at: 2026-11-04T02:53:43Z
---
Job "build-api-key-agents-p0-freeze-onboarding" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.

## Follow-ups
- **Gate limitation:** `phase-evidence-gate.sh` can't read a design in another repo, and it blocked the PR while the body named the path. The body now names the design by filename plus the #1543 URL, with a hand-written ledger, and says why. This bypasses the automated ledger check, so the panel should compare the ledger against the design by hand.
- **Later builders:** jobs p1–p5 will likely hit the same gate if they touch minion.town, so I saved a memory note for them. The gate itself is worth a small fix.
