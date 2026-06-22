---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/captp/README.md
source_line_range: 1-66
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 429 designs-lane ingest. 65-line README.md for
  @endo/captp — the capability transfer protocol that
  underlies every cross-vat capability passing the
  cluster has framed. "A minimal CapTP implementation
  leveraging Agoric's published modules." Seventy-seventh
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-nineteen consecutive non-
  garden sources after the pivot (310-429). §one-
  hundred-and-nineteen-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-
  CapTP-has-mutual-suspicion-by-default-TrapCaps-opts-out
  — lines 40-42: "not for mutually-suspicious CapTP
  parties, but instead for clear 'guest'/'host'
  relationship, such as user-space code and synchronous
  devices." The cluster's accumulated ocap framings
  (cycles 409, 423, 425's three ocap patterns) assume
  the capability-security default of MUTUAL SUSPICION
  — neither side trusts the other; all interactions
  are mediated through capabilities. CapTP normally
  implements that default. TrapCaps EXPLICITLY OPTS
  OUT for trusted guest/host relationships, enabling
  synchronous blocking that mutually-suspicious parties
  cannot safely use. §the-named-ocap-default-is-mutual-
  suspicion-but-opt-out-permitted as tier-3 meta-
  pattern; not all ocap relationships are mutually
  suspicious; some are explicitly trusted; the
  discipline accommodates BOTH and the OPT-OUT MUST
  BE EXPLICIT.

  §the-named-TrapCaps-as-async-host-sync-guest-bridge —
  lines 33-65. The "specialized and advanced use case"
  where a guest can synchronously block until a host's
  asynchronous answer resolves. Sync-on-guest, async-on-
  host. §the-named-async-to-sync-bridge-via-shared-
  memory as tier-3 meta-pattern.

  §the-named-makeCapTP-as-bootstrap-plus-transport-
  pattern — line 17: `makeCapTP('myid', myconn.send,
  myBootstrap)` returns `{ dispatch, getBootstrap,
  abort }`. Three pieces: own id + send function +
  bootstrap object. Returns: incoming handler +
  remote-bootstrap accessor + connection-teardown.
  Each side exposes ONE bootstrap object; from that
  everything else is reachable via E(). §the-named-
  single-bootstrap-as-CapTP-entry-point as tier-3
  meta-pattern.

  §the-named-CapTP-transport-agnostic-via-send-function
  — lines 7-10: "myconn is not part of the CapTP
  library, it represents a connection object that you
  have created." CapTP is layered ABOVE the transport.
  Any send(obj) function suffices: netstring,
  WebSocket, in-memory channel, whatever. §the-named-
  CapTP-decoupled-from-wire-format as tier-3 meta-
  pattern; cycle 401's "CapTP transport-agnostic"
  framing confirmed at source level.

  §the-named-Loopback-as-async-barrier-without-network
  — lines 27-31. makeLoopback "creates an async
  barrier between 'near' and 'far' objects" within
  the SAME address space. For testing and isolation
  without an actual network. §the-named-loopback-as-
  in-process-CapTP as tier-3 meta-pattern; sibling
  to cycle 403's mock-internals-real-externals
  framing — Loopback is "mock CapTP with real
  in-process objects," the inverse of the simulator.

  §the-named-Trap-as-sync-counterpart-to-E — lines
  49-51: "use the returned Trap(target) proxy maker
  much like E(target), but it will return a
  synchronous result." E() returns promise; Trap()
  returns value. §the-named-E-async-Trap-sync-proxy-
  pair as tier-3 meta-pattern.

  §the-named-Trap-throws-if-target-not-marked — line
  51: "Trap will throw an error if target was not
  marked as a TrapHandler by the host." Asymmetric
  authorization — the host MUST opt in to sync
  behavior per-target via makeTrapHandler. §the-
  named-explicit-per-target-sync-authorization as
  tier-3 meta-pattern.

  §the-named-SharedArrayBuffers-for-sync-trap-
  transport — line 45-46: "such as the one based on
  SharedArrayBuffers in src/atomics.js." The sync
  transport uses SharedArrayBuffer + Atomics for
  inter-thread/inter-realm synchronous communication.
  §the-named-SAB-Atomics-for-sync-bridge as tier-3
  meta-pattern.

  §the-named-async-iterator-driven-sync-transfer —
  lines 53-61: "consider the trapHost as a maker of
  AsyncIterators which don't return any useful value.
  These specific iterators are used to drive the
  transfer of serialized data back to the guest."
  The host produces async iterators; the guest's
  startTrap() drives them; data transfers
  synchronously to the guest from the guest's
  perspective. §the-named-iterator-pump-as-sync-
  primitive-builder as tier-3 meta-pattern.

  §the-named-loopback-cant-unwrap-promises-in-trap —
  lines 63-65: "The Loopback implementation provides
  partial support for TrapCaps, except it cannot
  unwrap promises. Loopback TrapHandlers must return
  synchronously, or an exception will be thrown."
  Loopback's sync illusion is BREAKABLE — promise
  unwrapping in TrapCaps requires real SAB-based
  transport. §the-named-loopback-sync-illusion-
  breaks-on-promise as tier-3 meta-pattern.

  §the-named-abort-for-explicit-CapTP-teardown —
  line 17 + 24. The abort function tears down the
  connection. Explicit lifecycle management. §the-
  named-explicit-CapTP-lifecycle-via-abort as tier-3
  meta-pattern.

  §the-named-Agoric-modules-referenced — line 3:
  "leveraging Agoric's published modules." The CapTP
  implementation depends on Agoric's published
  ecosystem (presumably eventual-send, marshal,
  pass-style). §the-named-Agoric-published-modules-
  as-dependency-base as tier-3 meta-pattern;
  references the broader Agoric ecosystem outside
  the @endo/ packages the cluster has been reading.

  §the-named-CapTP-is-minimal-implementation — line
  3: "A minimal CapTP implementation." The word
  "minimal" suggests there are richer CapTP
  implementations elsewhere; this is the Endo
  baseline. §the-named-minimal-CapTP-as-Endo-
  baseline as tier-3 meta-pattern.

  §the-named-myid-as-CapTP-side-identifier — line
  17's first argument 'myid'. Each CapTP side has
  an identifier. Used for routing or debugging?
  Probably both. §the-named-CapTP-side-id-as-
  routing-key as tier-3 meta-pattern.

  §the-named-getBootstrap-as-remote-entry-point —
  line 21: `E(getBootstrap()).method(args)`. The
  guest's path to the host's exposed surface is:
  getBootstrap (returns promise for bootstrap) → E
  (apply method asynchronously). The bootstrap is
  the ROOT of the remote object graph. §the-named-
  bootstrap-as-root-of-remote-graph as tier-3 meta-
  pattern.

  §the-named-CapTP-as-substrate-of-cluster-vocabulary
  — CapTP is the protocol that makes all the
  cluster's framings POSSIBLE across vat boundaries:
  cycle 401's transcript threading, cycle 408's
  role-cardinality-reduction at provider boundary,
  cycle 409's define-endow attenuation flow, cycle
  423's pass-by-presence vs pass-by-copy, cycle
  425's three ocap patterns. ALL of these depend on
  CapTP as the wire-level capability transfer
  protocol. §the-named-CapTP-as-foundation-of-
  cluster-framings as tier-3 meta-pattern.

  §the-named-seventy-seven-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 428 (1, adjacent
  forward; CopySet's distributed-equality semantics
  built on CapTP's identity-preservation across
  vats) + cycle 425 (5, three-ocap-patterns
  vocabulary now has a structural EXCEPTION via
  TrapCaps opt-out; mutual-suspicion-vs-trusted
  axis named) + cycle 423 (5, marshal's pass-by-
  presence-vs-copy classification is the CONTENT
  CapTP serializes; CapTP is the WIRE PROTOCOL) +
  cycle 408 (3, role-cardinality-reduction at
  provider boundary parallels CapTP's bootstrap-
  reduction-to-one-entry-point) + cycle 401 (5,
  cycle 401 framed Lal as using CapTP transport-
  agnostic via netstring or WebSocket — cycle 429
  confirms in source) + cycle 403 (3, mock-
  internals-real-externals framing has Loopback
  as inverse: mock-CapTP-with-real-in-process-
  objects) + cycle 326 (75) + cycle 322 (75) +
  cycle 318 (3, Endo idiom — E and eventual send
  underlie CapTP) + cycle 387 (3, branded-types
  via TrapHandler marking as a kind of brand on
  the host side). Pushes citation-arc-closures-in-
  pivot to SEVEN-HUNDRED-AND-FIFTY-TWO (742 + 10
  net new).
---

65-line README.md for @endo/captp — the capability transfer protocol underlying every cross-vat capability passing the cluster has framed. Designs-lane after cycle 428 chat-lane patterns/src/keys/copySet.js. **Single most structurally interesting move**: §the-named-CapTP-has-mutual-suspicion-by-default-TrapCaps-opts-out — *lines 40-42 articulate that TrapCaps is "not for mutually-suspicious CapTP parties, but instead for clear 'guest'/'host' relationship, such as user-space code and synchronous devices." The cluster's accumulated ocap framings (cycles 409, 423, 425) assume the capability-security default of MUTUAL SUSPICION. TrapCaps EXPLICITLY OPTS OUT for trusted relationships, enabling synchronous blocking. Not all ocap relationships are mutually suspicious; some are explicitly trusted; the discipline accommodates both.* §the-named-ocap-default-is-mutual-suspicion-but-opt-out-permitted as tier-3 meta-pattern. §the-named-TrapCaps-as-async-host-sync-guest-bridge; §the-named-async-to-sync-bridge-via-shared-memory. §the-named-makeCapTP-as-bootstrap-plus-transport-pattern (id + send + bootstrap → {dispatch, getBootstrap, abort}); §the-named-single-bootstrap-as-CapTP-entry-point. §the-named-CapTP-transport-agnostic-via-send-function (cycle 401 framing confirmed at source level); §the-named-CapTP-decoupled-from-wire-format. §the-named-Loopback-as-async-barrier-without-network; §the-named-loopback-as-in-process-CapTP (sibling to cycle 403's mock-internals-real-externals — inverse: mock-CapTP-with-real-objects). §the-named-Trap-as-sync-counterpart-to-E; §the-named-E-async-Trap-sync-proxy-pair. §the-named-Trap-throws-if-target-not-marked; §the-named-explicit-per-target-sync-authorization. §the-named-SharedArrayBuffers-for-sync-trap-transport; §the-named-SAB-Atomics-for-sync-bridge. §the-named-async-iterator-driven-sync-transfer; §the-named-iterator-pump-as-sync-primitive-builder. §the-named-loopback-cant-unwrap-promises-in-trap; §the-named-loopback-sync-illusion-breaks-on-promise. §the-named-abort-for-explicit-CapTP-teardown; §the-named-explicit-CapTP-lifecycle-via-abort. §the-named-Agoric-modules-referenced; §the-named-Agoric-published-modules-as-dependency-base. §the-named-CapTP-is-minimal-implementation; §the-named-minimal-CapTP-as-Endo-baseline. §the-named-myid-as-CapTP-side-identifier; §the-named-CapTP-side-id-as-routing-key. §the-named-getBootstrap-as-remote-entry-point; §the-named-bootstrap-as-root-of-remote-graph. §the-named-CapTP-as-substrate-of-cluster-vocabulary; §the-named-CapTP-as-foundation-of-cluster-framings (CapTP makes ALL of the cluster's cross-vat framings possible: transcript threading, role-cardinality-reduction, define-endow attenuation, pass-by-presence vs pass-by-copy, three ocap patterns). §the-named-seventy-seven-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-FIFTY-TWO.
