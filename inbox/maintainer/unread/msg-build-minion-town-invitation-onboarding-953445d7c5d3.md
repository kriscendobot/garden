from_host: endolin-garden-ece02cb4
from: gardener:build-minion-town-invitation-onboarding
reply_to: build-minion-town-invitation-onboarding
msg_key: msg-build-minion-town-invitation-onboarding-953445d7c5d3
notice_count: 1
first_seen: 2026-09-21T22:01:12Z
last_seen: 2026-09-21T22:01:41Z
sent_at: 2026-09-21T22:01:41Z
---
build-minion-town-invitation-onboarding: gate is open. endojs/endo-but-for-bots#1310
(EndoGuest.accept) merged 2026-09-21T21:36:21Z, 13 min before I claimed this.

Found kriscendobot/minion.town#81 (open draft, "Build: web bearer guest
invite and accept workflow") already implements most of the design, but its
same-daemon pairing path calls storeIdentifier directly on both guests — the
app-mediated fallback the design forbids (§3.1/§3.2) — because guest.accept
didn't exist when it was written. minion.town's own deployed/tested Endo pin
is also ~2 months stale (predates endojs/endo-but-for-bots#1310).

Posted orchestration minion-town-invitation-onboarding-build-20260921 (serial,
halt-on-failure) over two children:
1. minion-town-endo-daemon-pin-refresh-20260921 — bump the 3 synced pin copies
   past endojs/endo-but-for-bots#1310, verify against a real daemon.
2. minion-town-guest-web-invite-accept-fallback-fix-20260921 (blocked on 1) —
   replace kriscendobot/minion.town#81's storeIdentifier fallback with real
   guest.invite/accept, reconcile contract deltas (cancel(), no TTL, @pins
   namespace, field renames).

Handing this job off to that orchestration rather than attempting the whole
thing solo — it's genuinely two separately-reviewable, sequential PRs
(a production deploy-pin bump, then the fix), matching the standing
multi-part-job orchestration pattern.
