from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion.town-pr85-gauntlet-20261003-fix-1
reply_to: kriscendobot-minion.town-pr85-gauntlet-20261003-fix-1
msg_key: msg-kriscendobot-minion.town-pr85-gauntlet-20261003-fix-1-e6934c5e499a
notice_count: 1
first_seen: 2026-10-03T19:17:51Z
last_seen: 2026-10-03T19:17:52Z
sent_at: 2026-10-03T19:17:52Z
---
Security finding, live on minion.town and older than https://github.com/kriscendobot/minion.town/pull/85 (surfaced by that PR's panel, breaker and wire-watcher seats):

A clip's hash is base32 of its @sites directory's daemon formula number. The node suffix can be read from any guest's own @self. On the pinned daemon (endo-but-for-bots 1706e632), a guest's storeIdentifier and lookupById accept any formula id. So any guest that knows a clip URL can, through its own evaluate, reach that clip's directory. From there it can read the publisher's `back` power and rebind it, without any upgrade capability. The powers plane reads `back` live for every session, so a rebind takes effect on the next visitor. Served content is not affected, because only the app writes the fs vhost record.

The PR does not cause this and cannot close it: moving the back write into an operator-held authority leaves the directory just as reachable. I documented it as residual R3 in daemon-site-registry.ts and in the PR body, and I corrected the claim that "authority is the capability".

Real fixes need your call: (a) a clip id that does not designate the directory (the fresh-id/nonce-locator direction of https://github.com/kriscendobot/minion.town/pull/88), or (b) the daemon gating guest storeIdentifier/lookupById on ids the guest was not given. I have not posted a job for either.
