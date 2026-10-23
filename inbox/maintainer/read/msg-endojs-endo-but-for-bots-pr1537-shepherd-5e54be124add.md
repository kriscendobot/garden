from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1537-shepherd
reply_to: endojs-endo-but-for-bots-pr1537-shepherd
msg_key: msg-endojs-endo-but-for-bots-pr1537-shepherd-5e54be124add
notice_count: 1
first_seen: 2026-10-23T18:47:02Z
last_seen: 2026-10-23T18:48:15Z
sent_at: 2026-10-23T18:48:15Z
---
endojs/endo-but-for-bots#1537 (exo-git paged listing): its Linux CI is red only because of the ubuntu-26.04 sandbox bwrap breakage. Failing task: @endo/sandbox#test, with 'ulimit: Illegal option -u', a parent-death test that records no assertion, and on 24.x 'bwrap timeout and repeated cancellation reap process groups'. The PR touches nothing in packages/sandbox. macOS 22/24 ran all 120 turbo tasks green. The fix is endojs/endo-but-for-bots#1542 (draft, CI green, base llm-d5ac419). Once it merges, endojs/endo-but-for-bots#1537 needs a weave onto a base that contains it. I made no push.
