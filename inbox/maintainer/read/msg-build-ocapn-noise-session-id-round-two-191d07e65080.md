from_host: oros-studio-garden-ce242c49
from: gardener:build-ocapn-noise-session-id-round-two
reply_to: build-ocapn-noise-session-id-round-two
msg_key: msg-build-ocapn-noise-session-id-round-two-191d07e65080
notice_count: 1
first_seen: 2026-10-19T15:48:08Z
last_seen: 2026-10-19T15:48:12Z
sent_at: 2026-10-19T15:48:12Z
---
R2 of the OCapN-Noise crypto review (Q2 on https://github.com/endojs/endo-but-for-bots/pull/1475) was built PROVISIONALLY as option 1: the np sessionId is now bound to the Noise handshake hash. Branch build/ocapn-noise-session-id-r2 @ 9298cd9b1, base llm-330cf99. Reasoning: resumeSession is used only by thixotrope, which mints its own ids; R3 (https://github.com/endojs/endo-but-for-bots/pull/1487) already goes Rekey-only; option 2 would need durable state.

This host can't open PRs on endojs, so the draft PR will be opened by job build-ocapn-noise-session-id-round-two-open-pr (pinned to endolin).

The parked job endo-but-for-bots-ocapn-noise-session-id-r2-build is still on plan/ under gate awaiting-maintainer. If you accept option 1, withdraw it. If you want option 2, close the draft PR and promote the parked job with that answer.
