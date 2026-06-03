---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
---

# Content-address store as supervisor-owned subsystem with typed content, retain/release, and background mark/sweep GC

> *The CAS is a shared resource accessed by all workers. A
> dedicated worker would require every CAS operation to cross
> the envelope bus twice (request + response), adding latency to
> module loading and snapshot operations.*
>
> — `designs/daemon-cas-management.md` §Supervisor-owned vs. worker-owned

`daemon-cas-management.md` (398 lines, *In Progress* status,
created 2026-04-17) makes the daemon's content-addressable store
(CAS) a *first-class subsystem of endor* (cycle 119's Rust
supervisor). Phases 1-4 are implemented in `rust/endo/src/cas.rs`;
Phase 5 (JS manager integration replacing `makeContentStore()`)
remains.

## The §four-requirements frame

The §What is the Problem Being Solved section identifies four
gaps with the current flat-directory CAS:

1. **Typed content** — distinguish directory trees from blobs,
   compartment-map archives from snapshots, so higher-level
   operations can dispatch on type.
2. **Read/write verbs** — workers can store and retrieve content
   *through the envelope bus*, without direct filesystem access.
3. **Retain/release protocol** — reference-counted GC roots
   workers can hold to keep content alive.
4. **Off-thread garbage collection** — background sweep that
   removes unreferenced content *without blocking the main
   supervisor loop*.

The §current-state: *the daemon's content-addressable store
(CAS) at `{statePath}/store-sha256/` is currently a flat
directory of opaque blobs*. *Workers write snapshots to it and
read them back, but the supervisor has no structured API for CAS
operations and no awareness of what kind of content each hash
represents.* And *there is no garbage collection — blobs
accumulate forever*.

## The single most structurally interesting move — §supervisor-
owned vs worker-owned

The §Supervisor-owned vs. worker-owned subsection is the
design's *load-bearing architectural choice*. The §four reasons
the supervisor wins:

1. *The CAS is a shared resource accessed by all workers. A
   dedicated worker would require every CAS operation to cross
   the envelope bus twice (request + response), adding latency to
   module loading and snapshot operations.*

2. *The supervisor already owns the filesystem paths and creates
   the CAS directory.*

3. *GC requires knowledge of which handles are alive — the
   supervisor has this information; a worker would need to
   query for it.*

4. *The supervisor can run GC on a background thread without
   blocking the routing loop.*

The §future-worker-option discipline:

> *The worker-role option is preserved as a future alternative
> for deployments where the supervisor should remain minimal
> (e.g., embedded systems). The envelope verbs are identical in
> either case — only the handler location differs.*

The §verbs-are-the-same-interface discipline: the wire protocol
doesn't change based on who handles the verbs. The supervisor-
ownership decision is *operational*, not *architectural*; the
verbs would work either way.

## The §four content-types

The §Content types table:

| Type | Description |
|------|-------------|
| `blob` | Opaque byte sequence (default) |
| `snapshot` | XS machine snapshot (has signature header) |
| `tree` | Directory tree (JSON manifest + child hashes) |
| `archive` | Compartment-map archive (has `compartment-map.json`) |

The §`.meta` sidecar JSON: `{ "type": "blob", "refs": 0 }`. The
§sidecar-not-database discipline (Design Decision 2): *a SQLite
metadata table would be faster for large stores but adds a
dependency and crash-recovery complexity. Sidecar files are
atomic (write-rename), human-readable, and sufficient for the
expected store size (thousands of entries, not millions)*.

The §type-field-is-advisory discipline (Design Decision 4):

> *Content is self-describing (snapshots have signatures,
> archives have manifests). The type field avoids re-parsing but
> is not authoritative — a consumer should validate the content
> regardless.*

The §self-describing-content-as-source-of-truth invariant: the
`.meta` `type` is an *optimization*, not a *security claim*.

## The §tree-representation with structural sharing

The §Tree representation section shows the JSON shape:

```json
{
  "entries": {
    "compartment-map.json": { "type": "blob", "hash": "sha256:abc123...", "size": 4096 },
    "app-v1.0.0":           { "type": "tree", "hash": "sha256:def456..." },
    "app-v1.0.0/index.js":  { "type": "blob", "hash": "sha256:789abc...", "size": 1234 }
  }
}
```

The §flat-entries-map (Design Decision 5):

> *Tree entries use flat paths with hash references. This
> enables structural sharing between archives that share
> dependencies. The flat `entries` map (not nested objects)
> keeps the JSON simple and the hash stable.*

Two §benefits of flat-paths-with-hash-references:

1. **§Structural sharing** — two archives that share a
   dependency *share the dependency's tree and blob hashes*.
   Content-addressing makes this automatic.

2. **§Stable hash** — *nested objects would change hashes
   based on internal structure*. Flat paths are
   serialization-stable.

Trees are themselves content-addressed (the tree's hash is the
SHA-256 of its JSON serialization), so a tree is a *root for
walking* the content graph.

## The §seven envelope verbs

All CAS verbs are control messages (to handle 0) handled by the
supervisor:

| Verb | Payload | Response |
|------|---------|----------|
| `cas-store` | `{data, type}` | `cas-stored` with `{hash}` |
| `cas-fetch` | `{hash}` | `cas-content` with bytes |
| `cas-has` | `{hash}` | `cas-exists` with `{exists}` |
| `cas-retain` | `{hash}` (nonce: 0, fire-and-forget) | — |
| `cas-release` | `{hash}` (nonce: 0, fire-and-forget) | — |
| `cas-store-tree` | tree entries (inline or by hash) | `cas-stored` with root hash |
| `cas-gc` | — | mark/sweep results |

The §streaming-variants `cas-store-stream` and
`cas-content-stream` use the existing frame protocol for chunked
transfer. *This avoids buffering large blobs in a single
envelope*.

The §fire-and-forget retain/release (nonce: 0) means workers
don't await acknowledgement. The §worker-lifecycle integration:
*The supervisor automatically retains hashes for suspended
workers and releases them on resume or cancellation*. Workers
don't have to clean up their own retains across suspension.

## The §mark/sweep GC algorithm

The §Garbage collection section names a three-step algorithm:

1. **Mark**: scan all live references:
   - Suspended workers: their snapshot hashes
   - Explicit retain counts in `.meta` files
   - Any hash referenced by the JS manager's formula store
     (communicated via a `cas-gc-roots` verb at GC start)

2. **Sweep**: iterate `store-sha256/`, delete entries with zero
   retain count that are not in the live set. *For tree entries,
   recursively check children before deleting the tree*.

3. **Report**: log freed space and entry count.

The §reference-counting-not-tracing discipline (Design Decision
3):

> *Reference counting is simple and deterministic. The retain/
> release protocol maps naturally to worker lifecycles. A
> tracing GC would require enumerating all live references from
> the JS formula store, which is possible but more complex.*

But the §Mark step does also collect roots from the JS manager
(*Any hash referenced by the JS manager's formula store*) — a
*hybrid* shape. The base mechanism is reference-counting; the JS
side contributes roots that count as references for the GC's
purposes.

The §GC concurrency:

> *GC is concurrent — it holds a read lock on the CAS index
> during mark and takes brief write locks during sweep. New
> stores during GC are safe because newly stored content starts
> with refs=0 and will be collected in the next cycle if
> unreferenced.*

The §new-stores-are-safe-during-GC discipline: there's no need
to block stores during GC because *newly stored content starts
with refs=0* — if no one retains it, the next GC cycle will
clean it up. The §eventual-consistency-of-GC pattern: a single
sweep doesn't need to be globally synchronized; missed content
gets caught next time.

The §three-trigger mechanism:
- `cas-gc` control verb from the JS manager
- Configurable timer (e.g., every 10 minutes)
- Explicit `endor gc` CLI subcommand

## The §off-thread GC implementation

> *GC runs on a dedicated `std::thread` (or
> `tokio::spawn_blocking`) to avoid blocking the supervisor's
> routing loop.*

The §non-blocking-GC discipline: GC could take seconds for a
large store; doing it on the routing thread would freeze
all worker messages. Off-thread (or via `spawn_blocking`)
keeps the routing latency under GC load.

## §The ContentStore Rust struct

```rust
pub struct ContentStore {
    dir: PathBuf,
    refs: RwLock<HashMap<String, u32>>,
}

impl ContentStore {
    pub fn store(&self, data: &[u8], content_type: &str) -> io::Result<String>;
    pub fn fetch(&self, hash: &str) -> io::Result<Vec<u8>>;
    pub fn has(&self, hash: &str) -> bool;
    pub fn retain(&self, hash: &str);
    pub fn release(&self, hash: &str);
    pub fn gc(&self, live_roots: &HashSet<String>) -> io::Result<GcReport>;
}
```

The §in-memory-ref-count-cache-flushed-to-meta discipline: `refs`
is `RwLock<HashMap>` — fast reads, occasional writes. The cache
syncs to `.meta` files on flush. The §two-level-persistence: the
hot path doesn't touch the filesystem; cold flushes are atomic
write-rename.

## The §five implementation phases

The §Implementation phases section breaks the work into five
phases:

1. **ContentStore struct + basic verbs** (cas-store / cas-fetch
   / cas-has).
2. **Retain/release + metadata** (.meta sidecar + ref counts).
3. **Tree type** (tree JSON + store_tree + list_tree +
   fetch_from_tree).
4. **Garbage collection** (mark/sweep + cas-gc verb + endor gc
   CLI).
5. **JS manager integration** (replacing `makeContentStore()`
   in `daemon_bootstrap.js` with Rust CAS verbs).

The §Status block confirms phases 1-4 are *Implemented*;
phase 5 is *Remaining*.

## §Three dependencies

The §Dependencies table:

| Design | Relationship |
|--------|-------------|
| `daemon-content-store-gc` | **Supersedes**: this design replaces the JS-side GC approach with a Rust-native implementation |
| `daemon-xs-worker-snapshot` | **Integrates**: snapshots become typed CAS entries with retain/release |
| `daemon-endor-architecture` | **Extends**: supervisor gains CAS management responsibility |

The §supersedes-replaces relationship: this design *replaces* an
earlier JS-side GC approach. Cycle 78's `daemon-content-store-gc`
(if I've already ingested it — checking) was the JS approach;
this design moves it to Rust.

The §integrates-with-snapshot: snapshots (cycle 113's
familiar-daemon-bundling notes XS snapshots) become first-class
CAS entries with retain/release.

The §extends-endor-architecture: the (still-unindexed)
`daemon-endor-architecture` design is the broader Rust
supervisor frame.

## Related sections

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-as-message-router design that this CAS design
  rides on. The CAS verbs are control messages (handle 0)
  routed through cycle 119's envelope protocol.
- cycle 78
  [[endo-but-for-bots--llm-designs-daemon-content-store-gc--sweep-time-refcount-and-mount-cleanup]]
  — the *superseded* JS-side GC design this Rust CAS replaces.
- cycle 113
  [[endo-but-for-bots--llm-designs-familiar-daemon-bundling--esbuild-single-file-bundle-with-side-effect-mitigations]]
  — the Familiar bundling whose §worker-resolve-relative-to-
  bundle-location idiom uses XS snapshot files (now typed CAS
  entries per this design's §integrates-with-snapshot).
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — the §streaming-variants `cas-store-stream` and
  `cas-content-stream` echo the §streaming-on-CapTP discipline.
