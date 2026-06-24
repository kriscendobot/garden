---
ts: 2026-06-02T18:00:10Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--48226c
cycle: 119
---

# Cycle 119 — daemon-capability-bus.md (Kris Kowal, endo-but-for-bots) — chat→designs pivot

Ingested `designs/daemon-capability-bus.md` (526 lines, In Progress
status) from `endojs/endo-but-for-bots@100774ffa` (branch `origin/llm`)
as designs-lane after chat-lane exhaustion. **Twentieth-comment-style
design ingest.** One cohesion-honest section:

- **daemon-as-message-router-with-envelope-protocol-and-handle-
  rewriting** — the whole design hangs off one thesis (*the daemon
  **is** the capability bus*). Three architecture diagrams (current
  *flat-supervisor*, target *daemon-routes-handle-tagged-envelopes-
  between-manager-and-workers*, future *out-of-scope wasm + platform-
  I/O*); the four-tuple CBOR envelope `[handle, verb, payload, nonce]`
  on fd 3/4; fixed handle topology (daemon = 0, manager = 1, workers
  = 2+); **symmetric handle rewriting** (worker N sees stamped "1" =
  manager; manager sees stamped "N" = worker N; no sender field
  needed); **CapTP-over-envelope encapsulation** (CapTP frames ride
  inside `"deliver"` payloads, transparent to the CapTP layer);
  five-file `bus-*.js` decomposition (manager + worker entries +
  powers for Node, plus XS variants in the unified `endor` binary);
  *`bus-daemon-node-powers.js`'s `makeWorker` no longer forks — it
  sends `[0, "spawn", {command, args}, rid]` to the daemon*; spawn-
  tree deadlock-prevention discipline inherited from `endo-engo`
  (sync calls only child→ancestor or to control plane); unbounded
  incremental syscall migration (Phase 4 logging + Phase 5
  candidates: fs/net/crypto); two-layer ocap discipline stacked
  (envelope-level handles + CapTP-level object capabilities).

## Why one section

The 526-line design's many argument clusters (three architectures,
envelope protocol, handle rewriting, CapTP encapsulation, five-module
decomposition, spawn-tree, phases, security, upgrade) all argue *one
structural claim*: the daemon as message router with handle-tagged
envelopes. The pieces compose; they do not stand independently. The
cohesion-honest count is one.

## Provenance

- Created 2026-02-25 by Kris Kowal; updated 2026-04-11; status *In
  Progress*. Last touched 2026-05-02 in commit `100774ffa` (docs):
  *Endor architecture, SQLite, makeArchive, and supporting designs*.
- Phases 0-3 (scaffold, envelope protocol, worker spawning, native
  XS worker) are complete; the Go daemon and Rust daemon both pass
  the full daemon test suite with parity to the Node.js-only path.
  Phases 4-5 (syscall migration starting with logging) are
  open-ended follow-on work.

## Pairing

Pairs structurally with cycle 105's
`daemon-capability-bank.md` — both designs are *worldview shifts*
about how capabilities are structured, but at different layers:

- **Capability-bank** (application layer): *capabilities are shared
  resources, not per-agent-attached*. The bank holds capability
  objects; agents reach them via discovery, attenuation, and
  grants.
- **Capability-bus** (transport layer): *the daemon routes handle-
  tagged messages between subprocesses, and capabilities are
  addressed by handle*. The bus is what carries the bank's
  capability invocations between processes.

Both designs treat capabilities as routable, addressable objects
rather than JavaScript-stack-attached values.

## Rotation note

Cycle 119 was scheduled for **chat-lane** (cycle 118's pivot was
papers → comments). Chat-lane is now **exhausted** — all 20 chat-*
designs upstream are ingested. Papers-lane has been blocked for
**13+ consecutive cycles** (97/100/102/104/106/108/110/112/113/114/
116/117/118) due to lack of PDF-fetching infrastructure. Cycle 119
pivots to designs-lane.

## Counts

- 621 → **622** sections (+1).
- 163 → **164** source documents (+1).
- Topic pages updated: `daemon.md` (+1 row), `capability-security.md`
  (+1 row).
- Keywords index extended with ~45 capability-bus-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 120 wakes in 1500s. Rotation lands on **comments-lane**. If
blocked, papers-lane is nominally next (still blocked); designs-lane
remains as a fallback.
