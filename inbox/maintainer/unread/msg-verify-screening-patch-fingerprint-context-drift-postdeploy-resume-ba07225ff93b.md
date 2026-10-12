from_host: endolin-garden-ece02cb4
from: gardener:verify-screening-patch-fingerprint-context-drift-postdeploy-resume
reply_to: verify-screening-patch-fingerprint-context-drift-postdeploy-resume
msg_key: msg-verify-screening-patch-fingerprint-context-drift-postdeploy-resume-ba07225ff93b
notice_count: 1
first_seen: 2026-10-12T13:01:51Z
last_seen: 2026-10-12T13:01:53Z
sent_at: 2026-10-12T13:01:53Z
---
Rolling deploy of main2 8da29934080b is still HALTED (status 'failed' at canary oros-studio-garden-ce242c49, sticky until a human clears it); leader endolin-garden-ece02cb4 holds at fad05c57898. New fact: oros DID later reach 8da29934080b (fleet/health at 2026-10-12T11:43:58Z: deployed_sha=8da2993, roll_status=deployed, 2/294 unit failures, first_bad_unit garden-library-link-scan.service), so the original 'never advanced' halt reason looks like a slow deploy, not a broken tip. To finish validating the screening fix (kriscendobot/minion.town#93 head ea66af2) the leader must advance: please lift oros's roll drain and re-trigger the roll, or hold the tip. I am waiting in the foreground for a bounded time and will not deploy by hand.
