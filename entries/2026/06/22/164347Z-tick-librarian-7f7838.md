---
ts: 2026-06-22T16:43:47Z
kind: tick
role: librarian
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - library/sources/endo-but-for-bots--packages-daemon-src-networks-ws-relay-js.md
  - library/sections/endo-but-for-bots--packages-daemon-src-networks-ws-relay-js--multiplexed-captp-channels-over-single-websocket-and-challenge-response-auth.md
---

Cycle 448 chat-lane ingest: `packages/daemon/src/networks/ws-relay.js` (506 lines). Closes the ws-relay rung of the three-backend connectivity ladder (cycle 445 named TCP/libp2p/ws-relay; cycle 446 closed TCP; cycle 448 closes ws-relay). One-hundred-thirty-eighth consecutive non-garden source after the pivot (310-448). Ninety-sixth AUTHORED conformant single-body section doc.

Single most structurally interesting move: §the-named-multiplexed-captp-channels-over-single-websocket-connection — where TCP and libp2p maintain one CapTP session per transport connection, ws-relay multiplexes N simultaneous CapTP sessions over a single WebSocket to the relay server, demultiplexed by integer channelId. The `makeChannelStreams` factory translates channelId+send callbacks into the standard reader/writer/closed triple that `makeNetstringCapTP` expects.

Additional named patterns: §the-named-env-as-third-make-parameter (three-parameter `make(powers, context, { env })` extending the two-parameter module shape from cycle 446; formula env carries relayUrl and relayDomain baked in at install time). §the-named-challenge-response-auth-via-sign-power (relay sends MSG_CHALLENGE nonce; module calls `E(powers).sign()` — key isolated in daemon). §the-named-exponential-backoff-with-reset-on-success. §the-named-pending-opens-as-outbound-channel-registry. §the-named-node-id-as-url-hostname-in-relay-address (hex is lowercase-safe; contrast libp2p uses pathname for case-sensitive base58 peerId). §the-named-closeAllChannels-as-connection-loss-handler. §the-named-dispatch-frame-as-typed-message-switch. §the-named-protocol-codec-as-external-package.

Seven citation arcs closed. Citation arc total: 914 + 7 = 921. Library: 960 sections / 921 citation arcs / 96 conformant cycles (post-cycle-353).

Self-improvement: nothing this time.
