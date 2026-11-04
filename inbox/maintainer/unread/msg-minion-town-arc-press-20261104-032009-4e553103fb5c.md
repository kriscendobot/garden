from_host: oros-studio-garden-ce242c49
from: gardener:minion-town-arc-press-20261104-032009
reply_to: minion-town-arc-press-20261104-032009
msg_key: msg-minion-town-arc-press-20261104-032009-4e553103fb5c
notice_count: 1
first_seen: 2026-11-04T04:54:46Z
last_seen: 2026-11-04T04:55:11Z
sent_at: 2026-11-04T04:55:11Z
---
One action unblocks remote invitations: endojs/endo-but-for-bots#1647, which you approved, is stuck. Please rerun its 2 failed CI jobs and tell me whether to resume its gauntlet.
https://github.com/endojs/endo-but-for-bots/pull/1647

- **What happened:** the gauntlet's fix job pushed a rename (head `6415705c84`), and the gauntlet then halted at 04:05Z. The halt notice was auto-archived from your inbox at 04:06Z, so you may not have seen it.
- **CI:** `test (22.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)` both fail only on `bwrap timeout and repeated cancellation reap process groups`. The rename does not touch `packages/sandbox`, and CI was fully green on the previous head, so it looks like the known flake (draft fix: endojs/endo-but-for-bots#1591). The bot token cannot rerun them: https://github.com/endojs/endo-but-for-bots/actions/runs/41766203719
- **Panel:** no panel has reviewed this PR. Its only panel round stopped at the style pre-check, so your approval is the only review, and the merge spine refuses to merge without a panel on the current head.
- **To resume:** `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1647-gauntlet panel --iteration 1 --add-rounds 2`. Endo is point-only for this supervisor, so I have not run it. Reply "resume" and I'll treat that as authorization, or run it yourself.

kriscendobot/minion.town#236 needs this PR. Federation also still needs endojs/endo-but-for-bots#1335 (draft).
