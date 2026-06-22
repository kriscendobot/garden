---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/daemon/src/networks/ws-relay.js
source_line_range: 1-506
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 448 chat-lane ingest. 506-line
  packages/daemon/src/networks/ws-relay.js, the WebSocket relay
  network backend for the Endo daemon. One-hundred-and-thirty-
  eighth consecutive non-garden source after the pivot (310-448).
  Ninety-sixth AUTHORED conformant single-body section doc in
  post-refactor era.

  Single most structurally interesting move: §the-named-
  multiplexed-captp-channels-over-single-websocket-connection
  -- where TCP and libp2p each maintain one CapTP session per
  transport connection, ws-relay multiplexes N simultaneous
  CapTP sessions over a single WebSocket to the relay server,
  demultiplexed by integer channelId. This is the defining
  structural characteristic that distinguishes relay-mediated
  from direct networking. §the-named-multiplexed-captp-channels-
  over-single-websocket-connection as tier-3 meta-pattern.

  §The-named-env-as-third-make-parameter -- make(powers,
  context, { env } = {}) is a three-parameter signature
  extending the two-parameter form from cycle 446 (tcp-
  netstring); formula env is the third parameter carrying
  relayUrl and relayDomain baked in at install time, contrasting
  with tcp-netstring's E(powers).request() activation-time
  config.

  §The-named-challenge-response-auth-via-sign-power -- relay
  sends MSG_CHALLENGE nonce; module calls E(powers).sign(toHex(
  domain + nonce)) using the daemon's sign capability; the key
  stays isolated in the daemon; the module holds a power not
  a secret.

  §The-named-makeChannelStreams-as-channel-to-stream-adapter
  -- factory translates channelId+sendDataFn+sendCloseFn into
  the standard reader/writer/closed triple that makeNetstringCapTP
  expects; makes the two-layer framing stack composable over a
  relay channel.

  §The-named-exponential-backoff-with-reset-on-success --
  reconnectDelay doubles on retry up to 30s cap; resets to
  1s on MSG_AUTH_OK; the module recovers quickly after a long
  outage ends.

  §The-named-pending-opens-as-outbound-channel-registry --
  two-phase channel-open: encodeOpen sent, MSG_OPENED awaited;
  CapTP starts only after relay confirms the channel.

  §The-named-node-id-as-url-hostname-in-relay-address --
  ws-relay+captp0://<nodeId>?relay=<url>; nodeId is the URL
  hostname because hex is lowercase-safe (contrast with libp2p
  which puts peerId in pathname to avoid URL lowercasing).

  §The-named-closeAllChannels-as-connection-loss-handler --
  WebSocket close drains all active channels atomically; coarser
  than tcp-netstring's per-connection drain.

  §The-named-dispatch-frame-as-typed-message-switch --
  dispatchFrame switch(type) over eight relay message-type
  constants; each case calls a dedicated handler.

  §The-named-protocol-codec-as-external-package -- frame
  encode/decode functions imported from @endo/relay-server/
  protocol.js; relay server and relay client share one codec.

  Closes seven citation arcs: cycle 447 (1, adjacent forward;
  cli-reference named three-backend ladder; ws-relay closes
  ws-relay rung in source) + cycle 446 (2, tcp-netstring
  established make+context two-parameter shape; ws-relay
  shows three-parameter extension with env) + cycle 392 (3,
  setup-ws-relay.js installs this caplet; both sides now in
  library) + cycle 391 (4, daemon-lore program-shape vocabulary;
  ws-relay extends module shape with env parameter) + cycle
  385 (5, chat README CapTP-over-WebSocket; ws-relay IS it) +
  cycle 321 (N, E()) + cycle 326 (N). Pushes citation-arc-
  closures-in-pivot to NINE-HUNDRED-AND-TWENTY-ONE (914 + 7
  net new).
---

506-line `packages/daemon/src/networks/ws-relay.js` — the WebSocket relay network backend for the Endo daemon. Closes the ws-relay rung of the three-backend connectivity ladder named in cycle 445 chat-reference (TCP → libp2p NAT traversal → relay-mediated). Chat-lane after cycle 447 designs-lane cli-reference. **Single most structurally interesting move**: §the-named-multiplexed-captp-channels-over-single-websocket-connection — *where TCP and libp2p maintain one CapTP session per transport connection, ws-relay multiplexes N simultaneous CapTP sessions over a single WebSocket to the relay server, demultiplexed by integer channelId; the `makeChannelStreams` factory translates channelId+send callbacks into the standard reader/writer/closed triple.* §the-named-env-as-third-make-parameter (`make(powers, context, { env } = {})` — three-parameter form; formula env carries relayUrl and relayDomain baked in at install time; contrasts with tcp-netstring's activation-time request). §the-named-challenge-response-auth-via-sign-power (relay sends MSG_CHALLENGE nonce; module calls `E(powers).sign(toHex(domain+nonce))`; key stays in daemon; module holds power not secret). §the-named-exponential-backoff-with-reset-on-success (reconnectDelay doubles on retry up to 30s; resets to 1s on MSG_AUTH_OK). §the-named-pending-opens-as-outbound-channel-registry (two-phase channel-open: `encodeOpen` sent, `MSG_OPENED` awaited; CapTP starts only after relay confirms). §the-named-node-id-as-url-hostname-in-relay-address (`ws-relay+captp0://<nodeId>?relay=<url>`; nodeId as hostname because hex is lowercase-safe; contrast libp2p uses pathname). §the-named-closeAllChannels-as-connection-loss-handler (WebSocket drop drains all active channels atomically). §the-named-dispatch-frame-as-typed-message-switch (`dispatchFrame` switch over eight message-type constants). §the-named-protocol-codec-as-external-package (codec in `@endo/relay-server/protocol.js`; relay server and client share one codec). Seven citation arcs closed; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-TWENTY-ONE (914 + 7 net new).

## Section list

- [endo-but-for-bots--packages-daemon-src-networks-ws-relay-js--multiplexed-captp-channels-over-single-websocket-and-challenge-response-auth](../sections/endo-but-for-bots--packages-daemon-src-networks-ws-relay-js--multiplexed-captp-channels-over-single-websocket-and-challenge-response-auth.md)
