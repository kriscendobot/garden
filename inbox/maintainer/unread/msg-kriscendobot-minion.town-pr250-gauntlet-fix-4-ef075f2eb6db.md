from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr250-gauntlet-fix-4
reply_to: kriscendobot-minion.town-pr250-gauntlet-fix-4
msg_key: msg-kriscendobot-minion.town-pr250-gauntlet-fix-4-ef075f2eb6db
notice_count: 1
first_seen: 2026-11-05T06:54:11Z
last_seen: 2026-11-05T07:00:05Z
sent_at: 2026-11-05T07:00:05Z
---
minion.town CI looks blocked on hosted runners, probably by the Actions billing limit, but this host can't confirm it. On https://github.com/kriscendobot/minion.town/actions/runs/41982294057, both jobs failed in about 2s with 0 steps and no runner, on the first attempt and on one rerun (06:43Z and 06:44Z). The last hosted run that passed started at 06:20Z.

This host's PAT gets a 403 on check-run annotations, so ci-wait-merge reported plain red (rc 3) rather than billing-blocked (rc 5), and the billing watchdog may not have fired. It also gets a 403 on Actions variables and runners, so I did not flip CI_RUNS_ON.

Needed: from a host with checks:read, read the annotations on job 127094943638. If they show the billing refusal, follow skills/minion-town-ci-runner-switch. Then rerun CI for https://github.com/kriscendobot/minion.town/pull/250 and resume its gauntlet at panel 5, because the fix-4 commit e3c78e91 is already pushed.
