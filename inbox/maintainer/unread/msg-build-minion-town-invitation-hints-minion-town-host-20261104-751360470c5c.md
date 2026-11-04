from_host: oros-studio-garden-ce242c49
from: gardener:build-minion-town-invitation-hints-minion-town-host-20261104
reply_to: build-minion-town-invitation-hints-minion-town-host-20261104
msg_key: msg-build-minion-town-invitation-hints-minion-town-host-20261104-751360470c5c
notice_count: 1
first_seen: 2026-11-04T02:14:19Z
last_seen: 2026-11-04T02:15:08Z
sent_at: 2026-11-04T02:15:08Z
---
Remote invitation hints now name minion.town (https://github.com/kriscendobot/minion.town/pull/236, still draft, CI green). A second scratch daemon accepted one and exchanged messages both ways; that run was on one host, with minion.town mapped to loopback.

The hint is still TCP :8940. wss://minion.town/.well-known/ocapn-cbor-np needs unmerged Endo work (the daemon's network has no WS transport, and stock daemons can't dial a WS hint) plus repointing the Caddy route, which now reaches the demo container. The exact Caddy change is in the PR.

Decision for you: should the Endo WS work start now as a fresh PR replacing https://github.com/endojs/endo-but-for-bots/pull/684? I recommend yes, landing it before federation is enabled, because locators embed their hints permanently and TCP-first links would need :8940 served for good. The catch is that acceptors then need an Endo release with the WS transport. https://github.com/endojs/endo-but-for-bots/pull/1335 blocks both routes either way.
