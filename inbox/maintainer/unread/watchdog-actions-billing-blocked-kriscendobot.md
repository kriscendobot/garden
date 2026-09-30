from_host: endolin-garden2-5bcdff64
from: watchdog:ci-wait-merge
sent_at: 2026-09-30T12:47:06Z
watchdog_key: actions-billing-blocked-kriscendobot
notice_count: 1
first_seen: 2026-09-30T12:47:06Z
last_seen: 2026-09-30T12:47:06Z
---
GitHub Actions is refusing to START jobs for the 'kriscendobot' account: "recent account payments have failed or your spending limit needs to be increased". Latest: kriscendobot/minion.town#142 (head debd2aa7e5d; checks: test, Claude harness (amd64), Claude harness (arm64)). This is an ACCOUNT BILLING block, not a code failure: no push can fix it, so I am not treating it as CI red. Fix Billing & plans for 'kriscendobot', then rerun the failed runs (gh run rerun <id> --failed) and resume whatever parked on it (a gauntlet: scripts/jobs/gauntlet.sh --resume-from-stage <g> <clean|fix> [--iteration N]).
