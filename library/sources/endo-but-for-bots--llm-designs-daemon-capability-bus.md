---
source: designs/daemon-capability-bus.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 100774ffa0193df27dc87c7df6095afda419a57f
source_date: 2026-05-02
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twentieth-comment-style design ingest. The 526-line *In Progress*
  design (created 2026-02-25, updated 2026-04-11) records a
  worldview shift: the Endo daemon stops being a Node.js process
  supervising Node.js workers, and becomes a *language-agnostic
  message router* — a standalone Go or Rust binary that speaks one
  wire protocol to every subprocess.

  Cohesion-honest count is one section. The whole document hangs
  off one thesis (*the daemon **is** the capability bus*) with a
  tightly-coupled toolkit:
    (a) three architecture diagrams (current / target / future)
        showing workers as direct children of the daemon, not the
        manager;
    (b) the four-tuple CBOR envelope format on fd 3/4 + handle
        topology (0 = daemon, 1 = manager, 2+ = workers);
    (c) *handle rewriting* — the symmetric trick where the handle
        field always denotes the local-side identity of the peer;
    (d) *CapTP-over-envelope* — CapTP frames ride inside `"deliver"`
        envelope payloads, transparent to the CapTP layer;
    (e) five `bus-*.js` modules (manager + worker entries + powers
        for Node, plus the unified `endor` binary's XS variants);
    (f) the spawn-tree deadlock-prevention discipline inherited
        from `endo-engo` (sync calls only child→ancestor or to
        control plane);
    (g) the *unbounded* incremental syscall migration arc that
        progressively moves Node.js I/O into the daemon as new
        envelope verbs.

  The single most structurally interesting move is the *handle
  rewriting*: the daemon delivers messages with the handle field
  rewritten to the local-side identity of the peer (worker N sees
  incoming messages stamped "1" = manager; manager sees incoming
  messages stamped "N" = worker N). Both sides identify their
  counterpart without an explicit sender field.

  Pairs structurally with cycle 105
  ([[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]).
  Capability-bank's thesis is *capabilities are shared resources,
  not per-agent-attached*; capability-bus's thesis is *the daemon
  routes handle-tagged messages between subprocesses, and
  capabilities are addressed by handle*. Both designs treat
  capabilities as routable, addressable objects.

  Cycle 119 was scheduled for chat-lane (cycle 118's pivot was
  papers→comments). Chat-lane is *exhausted* — all 20 chat-*
  designs upstream are ingested. Papers-lane has been blocked 13+
  consecutive cycles. Cycle 119 pivots to designs lane.
---

> Abstract: `daemon-capability-bus.md` is the *worldview-shift*
> design that moves the Endo daemon out of Node.js and into a
> dedicated Go or Rust binary — a language-agnostic *message
> router* whose only job is to deliver handle-tagged CBOR envelopes
> between subprocesses. The new topology: workers are children of
> the daemon, not of the manager; the manager *requests* worker
> creation through the envelope protocol. The daemon runs no
> JavaScript itself.
>
> The wire format is a four-tuple `[handle, verb, payload, nonce]`
> CBOR array on fd 3/4. The handle topology is fixed: daemon = 0,
> manager = 1, workers = 2+. The most structurally interesting
> mechanism is *symmetric handle rewriting* — the handle field
> always denotes the local-side identity of the peer (worker N sees
> incoming messages stamped "1" = manager; manager sees stamped "N"
> = worker N). No sender field needed.
>
> CapTP rides inside `"deliver"` envelope payloads, transparent to
> the CapTP layer. Other verbs (`"init"` / `"spawn"` / `"spawned"`
> / `"ready"` / `"log"` / future syscalls) carry control-plane
> operations. The §Phase 4-5 incremental syscall migration is
> unbounded: Node.js I/O progressively moves into the daemon as new
> envelope verbs, so workers can be fully OS-sandboxed.
>
> Phases 0-3 (scaffold, envelope protocol, worker spawning, native
> XS worker) are complete; the Rust daemon and the native Rust/XS
> worker live in the same `endor` binary. Phases 4-5 (syscall
> migration starting with logging) are open-ended follow-on work.
>
> The five `bus-*.js` modules form the *manager-and-worker
> entries-and-powers* surface. `bus-daemon-node-powers.js` is the
> key structural move: its `makeWorker` no longer forks — it sends
> `[0, "spawn", {command, args}, rid]` to the daemon. The Rust
> daemon and the manager (whether Node.js or XS-hosted) and the
> worker (whether Node.js or XS-hosted) all speak the same wire
> protocol.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [daemon-as-message-router-with-envelope-protocol-and-handle-rewriting](../sections/endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting.md) | daemon, capability-security | current |

The 526-line design hangs off one thesis (*the daemon **is** the
capability bus*) with a tightly coupled toolkit: three architecture
diagrams + four-tuple envelope format + handle topology + handle
rewriting + CapTP-over-envelope encapsulation + five `bus-*.js`
modules + spawn-tree deadlock prevention + unbounded syscall-
migration arc. Each piece needs the others to be understood;
splitting would manufacture artificial boundaries.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@100774ffa` (the
  branch `origin/llm`) via the local bare-clone.
- Last touched 2026-05-02 by Kris Kowal in commit "docs(designs):
  Endor architecture, SQLite, makeArchive, and supporting designs".
- Created 2026-02-25; updated 2026-04-11; status *In Progress*.
- **Twentieth-comment-style design ingest.** Pairs with cycle 105's
  `daemon-capability-bank.md` — both designs are *worldview shifts*
  about how capabilities and their carriers are structured, at
  different layers (bus = transport layer; bank = application layer).
- Cycle 119 was scheduled for chat-lane (cycle 118's pivot was
  papers→comments). **Chat-lane is exhausted** — all 20 chat-*
  designs upstream are ingested. **Papers-lane has been blocked for
  13+ consecutive cycles**. Cycle 119 pivots to designs lane.
- Cohesion-honest one-section count. The 526-line design's many
  argument clusters (three architectures, envelope protocol, handle
  rewriting, CapTP encapsulation, five-module decomposition, spawn-
  tree, phases, security, upgrade) all argue *one structural claim*:
  the daemon as message router with handle-tagged envelopes. The
  pieces compose; they do not stand independently.
