---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/daemon/src/networks/tcp-netstring.js
source_line_range: 1-191
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 446 chat-lane ingest. 191-line
  packages/daemon/src/networks/tcp-netstring.js, the TCP
  network backend for the Endo daemon. One-hundred-and-
  thirty-sixth consecutive non-garden source after the
  pivot (310-446). Ninety-fourth AUTHORED conformant
  single-body section doc in post-refactor era.

  Single most structurally interesting move: §the-named-
  make-powers-context-as-network-module-shape -- the file
  exports `make(powers, context)`, not `main(powers)`.
  This is the NETWORK MODULE shape (not a runlet). The
  `context` parameter carries the module's lifecycle:
  `context.whenCancelled()` and `context.addDisposalHook()`
  tie the module into the daemon's teardown sequence.
  §the-named-context-as-lifecycle-carrier as tier-3 meta-
  pattern; the context parameter is what distinguishes a
  long-lived network module from a transient runlet.

  §The-named-greeter-vs-gateway-as-server-client-role-
  discriminator -- server-side CapTP uses localGreeter
  (identity-introduction endpoint); client-side uses
  localGateway (capability-provision endpoint). Both call
  remoteGreeter.hello after connecting but with different
  local capabilities. §the-named-asymmetric-bootstrap-
  endpoints as tier-3 meta-pattern.

  §The-named-protocol-constant-as-namespace-and-
  discriminator -- line 18: `const protocol =
  'tcp+netstring+json+captp0';`. One string serves as
  address scheme, log prefix, and routing filter.

  §The-named-makeSocketPowers-as-node-capability-adapter --
  Node net+fsp passed in, servePort+connectPort returned.
  §the-named-node-capability-adapter-at-boundary.

  §The-named-lazy-server-start-via-started-promise --
  async bind wrapped in promise IIFE assigned to `started`;
  `await started` on line 184 gates the return.

  §The-named-operator-requested-bind-address -- `E(powers).
  request('SELF', 'Please select a host:port...',
  'tcp-netstring-json-captp0-host-port')`. Configuration is
  operator-requested at activation time.

  §The-named-generator-as-connection-counter -- immediately-
  invoked generator yields monotonically increasing
  integers; both accept and connect loops call .next().

  §The-named-promise-set-for-graceful-drain --
  connectionClosedPromises Set accumulates in-flight
  connection close promises; Promise.all drains on shutdown.

  §The-named-network-service-interface-contract --
  Far('TcpNetstringService', { addresses, supports, connect
  }) is the three-method contract the daemon's network
  registry expects.

  §The-named-two-layer-framing-stack -- makeNetstringWriter
  wraps bytes in netstring framing; mapWriter(..
  messageToBytes) encodes messages as bytes; symmetric
  decode is makeNetstringReader + mapReader(..
  bytesToMessage).

  §The-named-todo-comments-as-honest-gaps-in-source recurs
  (sibling to cycle 391 daemon-lore WIP acknowledgment).

  Closes six citation arcs: cycle 445 (1, adjacent forward;
  chat-reference named three-backend ladder; tcp-netstring
  closes TCP rung in source) + cycle 392 (2, setup-ws-relay
  is the runlet that installs the caplet; tcp-netstring is
  the caplet; both show install/run separation) + cycle 391
  (3, daemon-lore program-shape vocabulary; make+context
  extends it) + cycle 367 (N, Far()) + cycle 321 (N, E())
  + cycle 326 (N, pure-naming-as-discipline). Pushes
  citation-arc-closures-in-pivot to NINE-HUNDRED-AND-EIGHT
  (902 + 6 net new).
---

191-line `packages/daemon/src/networks/tcp-netstring.js` — the TCP network backend for the Endo daemon. Closes the TCP rung of the three-backend connectivity ladder named in cycle 445 chat-reference (TCP requires an open port; libp2p needs no open port; ws-relay is relay-mediated). Chat-lane after cycle 445 designs-lane chat-reference. **Single most structurally interesting move**: §the-named-make-powers-context-as-network-module-shape — *the file exports `make(powers, context)`, not `main(powers)`; this is the NETWORK MODULE shape, not a runlet; the `context` parameter carries lifecycle via `whenCancelled()` and `addDisposalHook()`; the distinction between runlet (main, transient) and module (make+context, long-lived) now has two concrete instances in the library (cycle 392 setup-ws-relay.js vs cycle 446 tcp-netstring.js).* §the-named-context-as-lifecycle-carrier as tier-3 meta-pattern. §the-named-greeter-vs-gateway-as-server-client-role-discriminator (server CapTP bootstrap is localGreeter; client CapTP bootstrap is localGateway; asymmetric endpoints enable the hello handshake); §the-named-asymmetric-bootstrap-endpoints. §the-named-protocol-constant-as-namespace-and-discriminator (`'tcp+netstring+json+captp0'` as address scheme + log prefix + routing filter). §the-named-makeSocketPowers-as-node-capability-adapter (Node net+fsp wrapped at boundary; returns servePort+connectPort); §the-named-node-capability-adapter-at-boundary. §the-named-lazy-server-start-via-started-promise (async bind in IIFE promise; `await started` gates return). §the-named-operator-requested-bind-address (`E(powers).request('SELF', ...)`; activation-time configuration). §the-named-generator-as-connection-counter (immediately-invoked generator for connection numbering). §the-named-promise-set-for-graceful-drain (connectionClosedPromises Set; Promise.all drains on shutdown). §the-named-network-service-interface-contract (Far with addresses/supports/connect three-method contract). §the-named-two-layer-framing-stack (netstring framing + message encoding; symmetric decode). §the-named-todo-comments-as-honest-gaps-in-source recurs. Six citation arcs closed; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-EIGHT (902 + 6 net new).

## Section list

- [endo-but-for-bots--packages-daemon-src-networks-tcp-netstring-js--make-powers-context-as-network-module-shape-and-greeter-gateway-as-server-client-discriminator](../sections/endo-but-for-bots--packages-daemon-src-networks-tcp-netstring-js--make-powers-context-as-network-module-shape-and-greeter-gateway-as-server-client-discriminator.md)
