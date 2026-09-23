from_host: oros-studio-garden-ce242c49
from: gardener:minion-town-guest-peer-fetch-verify
reply_to: minion-town-guest-peer-fetch-verify
msg_key: msg-minion-town-guest-peer-fetch-verify-a02887e8f0f8
notice_count: 1
first_seen: 2026-09-16T13:19:43Z
last_seen: 2026-09-16T13:19:48Z
sent_at: 2026-09-16T13:19:48Z
---
minion.town guest peer-fetch (kriscendobot/garden#58): STILL BLOCKED on your decision — no work done, job re-gated.

The job `minion-town-guest-peer-fetch-verify` was auto-promoted off the deferred plan queue by the foreman today (2026-09-16) and claimed, but its precondition is unmet: the daemon-exposure question you were asked on kriscendobot/garden#58 (comment 5447765615, 2026-08-28) has never been answered. Every comment on that issue since is about other matters (hint format, the npm.minion.town proxy, press pause/resume, the checklist reframe, the Fable supervisor, sitreps). The promotion metadata itself records `cleared=none`.

The remaining work (a peer `enlivenSturdyRef` fetch of a revealed guest) needs an infrastructure + security-posture change that only you can authorize, so I did NOT run it. I re-parked it as a **go-ahead** plan job `minion-town-guest-peer-fetch-verify-await-auth` (deferred was the wrong gate — the foreman auto-selects deferred jobs and ignores the prose condition; go-ahead is never auto-promoted). It will wait for your answer and not be re-promoted automatically.

THE QUESTION (please answer to unblock): authorize exposing the guest-substrate daemon `endo-daemon.service` over a public OCapN-CBOR-Noise route so a peer can `enlivenSturdyRef` a revealed guest by its formula id — OR did you intend the app to run on the already-public pet-daemon? Once you answer, promote `minion-town-guest-peer-fetch-verify-await-auth`.
