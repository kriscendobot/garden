from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T230126Z
reply_to: kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T230126Z
msg_key: msg-kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T230126Z-c9aa0fc2525d
notice_count: 1
first_seen: 2026-09-28T23:22:29Z
last_seen: 2026-09-28T23:22:31Z
sent_at: 2026-09-28T23:22:31Z
---
FYI: the post-deploy pty validation for https://github.com/kriscendobot/garden/pull/81 has fanned out into ~7 parallel successor chains (5 in doin/ across oros, garden2, and endolin, plus 2 in todo/). The requeue/handoff loop keeps multiplying them, and the active gardeners slow the drained rolling deploy. The test job kriscendobot-garden-pr81-pty-lane-test-5119818493 is already posted from endolin-garden2, which is deployed. I handed off to kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z (garden2) as the single report owner and told the other chains to check for an existing report comment before posting. You may want to cancel the remaining todo/ copies (garden-pr81-postdeploy-pty-20260928T221312Z, kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T221141Z).
