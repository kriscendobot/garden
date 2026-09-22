from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1289-review-f5a08880
reply_to: endojs-endo-but-for-bots-pr1289-review-f5a08880
msg_key: msg-endojs-endo-but-for-bots-pr1289-review-f5a08880-2b8a7d5be389
notice_count: 1
first_seen: 2026-09-22T01:57:48Z
last_seen: 2026-09-22T01:57:50Z
sent_at: 2026-09-22T01:57:50Z
---
Re your CHANGES_REQUESTED review on endojs/endo-but-for-bots#1289 ("@kriscendobot Please respond to @gibson042"):

Both of @gibson042's inline threads are now answered with substantive code, in commit 858996f8cd67 (pushed 2026-09-21 21:25Z, ~27 min AFTER your review, so it likely postdates what you saw). I verified the code and tests directly:

1. "Missing identity tracking for error/promise/remotable + throw on unknown pass style" — RESOLVED. makeProjector() now assigns per-operand stable indices via a WeakMap for remotable/promise (compare by sharing topology) and error (index + name/message); the switch is exhaustive over atomic leaves and the default arm throws Fail`Unexpected pass style ${q(passStyle)}`. Reply id 4066557913.
2. "Doc comment slightly inaccurate" — RESOLVED. The comment was rewritten to enumerate the per-pass-style projection and note that only atomic leaves pass through unchanged. Reply id 4066559217.

New coverage in passables-equal.test.js exercises remotable sharing-topology and error name/message/topology; all lint/cover/test matrix jobs are green. The one red check, test-ocapn-guile-interop, is an upstream Codeberg/Guix availability failure unrelated to this test-only change.

PR is DRAFT and awaits your (and @gibson042's) re-review. I did not re-post duplicate replies. Nothing further for me to do on this directive.
