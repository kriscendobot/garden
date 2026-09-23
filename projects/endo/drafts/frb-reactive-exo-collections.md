---
created: 2026-06-24
updated: 2026-06-24
author: gardener
status: draft-for-maintainer-triage
job: research-frb-endo-exo-collections
topics: [reactive-bindings, endo, exo, pubsub, collections]
---

# Reactive Exo collections: FRB operators → sliding-window topics for agent synchronization

*A research-and-design investigation, commissioned by the maintainer via the
liaison. The brief: investigate using FRB (Functional Reactive Bindings)
operators to build Endo/Exo collections that expose **query** and
**subscriber** facilities so agents can synchronize state — with the specific
structure of interest being a splay-tree / sorted-array-set whose operators
produce **topics watching a sliding window** of an arbitrary ordered
collection, kept consistent incrementally.*

Every concrete claim below is grounded in source read while drafting. The
sources are named inline and collected under **Provenance** at the foot. Where
a relationship could not be verified from source, the document says so
explicitly (see **§7 Propagators** and the open questions).

---

## 0. Executive summary

The pieces the maintainer wants to compose already exist as separate, real
artifacts:

1. **FRB** (`kriscendobot/frb` @ `131db347`, fork of `kriskowal/frb`) is a
   library of **incremental, observable collection operators** — `map`,
   `filter`, `sorted`, `sortedSet`, `group`, `flatten`, `enumerate`,
   `range`, and crucially **`view(start, length)`**, which projects an
   incrementally-maintained **sliding window** over a large ordered collection
   (the README's own example windows a `SortedSet`). FRB's operators consume
   and emit **typed range deltas** (`(plus, minus, index)`) rather than
   recomputing, and the identity of every output collection is stable across
   its lifetime.

2. **`@endo/pubsub`** (PR #513, branch `feat/endo-pubsub`, incubating on the
   `llm` roadmap branch) is a brand-new, **hardened** local-layer topic
   library with exactly two delivery disciplines — **`makeChangeTopic`**
   (lossless deltas) and **`makeLatestTopic`** (lossy latest-wins) — over a
   shared async-promise linked list (the Sink/Spring primitive). Each topic
   exposes a `Writer<T>` publisher and a `subscribe()` that yields independent
   `Reader<T>` cursors.

3. **`@endo/exo-pubsub`** (design PR #507, `design/notifier-pubsub-migration`)
   is the proposed **Exo lift**: the same two topic topologies exposed as
   CapTP-passable exo refs with `InterfaceGuard`s, mirroring how
   `@endo/exo-stream`'s `PassableReader`/`PassableWriter` lift
   `@endo/stream`'s local `Reader`/`Writer`.

The contribution this design proposes is the **bridge operator** that the
maintainer named: a hardened Endo module that takes any FRB-style observable
ordered collection (concretely a `collections` `SortedSet` / `SortedArraySet`)
plus a window spec `(start, length)`, drives FRB's `view` observer over it,
and **republishes the window's range-deltas as an `@endo/pubsub` change-topic**
— then lifts that to a passable **exo collection** whose facets are
`query()` (a snapshot pull) and `subscribe()` (a delta push). That is the
unit of agent synchronization: an agent holds a remotable handle to a window
over a peer's ordered collection and stays consistent incrementally.

The single most important source fact for this design: **FRB's `view`
operator already is the sliding-window machinery, and it already reacts to
both content mutation and window-position mutation.** We are not inventing the
window; we are giving its delta stream a passable, subscribable skin.

---

## 1. FRB operator survey (grounded in `observers.js`)

FRB self-describes as *functional, generic, reactive, synchronous,
incremental, unwrapped* (library concept `frb-incremental-update`). Its
execution model has four layers (concept `frb-compiled-observer-tree`):
collection-change events → a compiled tree of small observer functions →
binders → a declarative graph. The two facts that matter for reactive
collections:

- **Typed range deltas, not recompute.** A change to a source collection
  enters as a `rangeChange(plus, minus, index)` record — `plus` inserted,
  `minus` removed, at `index` — and each operator splices only the affected
  elements into its output in their proper positions
  (`observers.js` passim; e.g. `makeReversedObserver` reflects the index and
  `swap`s, lines 550–568). `sum`/`average` fold only the delta. This is the
  `frb-incremental-update` invariant.
- **Stable output identity.** Every array-producing operator writes into an
  output array it owns and never reassigns; subscribers can hold the output
  forever. (README: "the identity of the bound collection never changes".)

### 1.1 The operator catalogue (`observers.js` exports)

The relevant collection operators, all present in the fork:

| Operator | Maker | What it maintains incrementally |
|---|---|---|
| map / filter | `makeMapBlockObserver`, `makeFilterBlockObserver` | element-wise projection / predicate selection |
| **sorted** | `makeSortedBlockObserver` (l.464) | output kept in order via `collections` **`SortedArray`** (l.471) |
| **sortedSet** | `makeSortedSetBlockObserver` (l.505) | a uniqued, ordered set backed by `collections` **`SortedSet`** (a splay tree; l.522) |
| group / groupMap | `makeGroupBlockObserver`, `makeGroupMapBlockObserver` | partition into keyed buckets |
| flatten / concat | `makeFlattenObserver` (l.571), `makeConcatObserver` | nested arrays → one flat array, reacting to inner+outer |
| reversed | `makeReversedObserver` (l.550) | two-way reversal |
| enumerate | `makeEnumerateObserver` (l.866) | `[index, value]` pairs, reindexed on splice |
| range | `makeRangeObserver` (l.895) | `[0..length)` integers from an observed length |
| **view** | `makeViewObserver` (l.817) | **a sliding window `(start, length)` over a source** |
| sum / average / min / max | `makeSumObserver`, `makeAverageObserver`, `makeMinBlockObserver`, `makeMaxBlockObserver` | folded aggregates (min/max use an internal heap) |
| has / get / keys / values / entries / toMap | `makeHasObserver`, `makeGetObserver`, … | map/lookup projections (`has` is recompute-cheap, not delta) |

### 1.2 The dependency on `collections` (the splay tree / sorted array)

`observers.js` lines 5–6 require `collections/sorted-array` and
`collections/sorted-set` directly. In `kriskowal/collections`:

- **`sorted-set`** is a **splay tree** — a self-adjusting binary search tree
  giving amortized-log access with recently-touched elements near the root.
- **`sorted-array`** / **`sorted-array-set`** keep a plain **sorted array**
  with binary-search insertion — O(log n) find, O(n) splice, but cache-friendly
  iteration and trivially windowable by index.

This is precisely the maintainer's "splay tree backed by a sorted array (or a
sorted-array-set interface)": the two are interchangeable implementations of
the same *ordered-set* contract (`add`, `delete`, `has`, ordered iteration,
range slicing), and FRB consumes them through that contract. The choice
between them is a performance knob — splay tree for skewed-locality access,
sorted array for dense iteration and cheap index-windowing.

### 1.3 The `view` operator is the sliding window (`makeViewObserver`, l.817)

`array.view(start, length)` produces an output array that **stays equal to
`source[start : start+length]` as the source mutates and as `start`/`length`
themselves change.** Read the body (lines 818–863): it observes `input`,
`start`, and `length`; on every `rangeChange(plus, minus, index)` of the
source it runs a five-branch splicer (shrink-before, grow-before,
shrink-within, grow-within, full-replace) that **injects/removes only the
elements that crossed the window boundary** — never recomputing the slice.
The README's own example (library section
`frb--readme--tutorial-windowing-and-structure`) windows a `SortedSet`:

```js
var controller = {index: SortedSet([1,2,3,4,5,6,7,8]), start: 2, length: 4};
bind(controller, "view", {"<-": "index.view(start, length)"}); // [3,4,5,6]
controller.length = 3;    // [3,4,5]      (window shrinks)
controller.start = 5;     // [6,7,8]      (window slides)
controller.index.add(0);  // [5,6,7]      (content shift moves the window)
```

That last line is the crux: **inserting into the underlying ordered collection
incrementally shifts the window**, and `view` emits exactly the resulting
range-deltas. This is the operator the maintainer described as "produce topics
watching a sliding window of an arbitrary other ordered collection." It exists;
what it lacks is a *topic* skin (it emits to an in-process output array via the
`collections` range-change protocol, not to a passable subscriber).

### 1.4 Teardown (relevant to hardening)

Every observer returns a **canceler**; nested observers wrap theirs in
`once(...)` and `autoCancelPrevious(...)` so that when a source is replaced the
orphaned listeners cancel and the new graph is observed
(`makeViewObserver` returns `once(cancelViewObserver)` at l.856; concept
`frb-compiled-observer-tree`). This explicit-canceler discipline is what makes
a hardened lift feasible: subscription lifetime is already a first-class,
returnable value, not an implicit GC dependency.

---

## 2. The Endo-implements / Exo-lifts-to-passable layering

The maintainer's constraint: *the machinery lives at the Endo level as plain
hardened modules; the Exo layer lifts it to passable/remotable.* The garden
already has the exact precedent for this split in `@endo/stream` →
`@endo/exo-stream`, and PR #513 / #507 reproduce it for pubsub. The proposed
reactive collection follows the same three-tier shape.

```
┌─ Exo layer (passable, CapTP-remotable) ─────────────────────────────┐
│  @endo/exo-pubsub        (design #507): TopicPublisher / TopicSubscriber exos,│
│                           each method under an InterfaceGuard; subscriber     │
│                           conforms to PassableReader so CapTP rides method    │
│                           calls with no adapter.                              │
│  @endo/exo-stream        (landed): PassableReader / PassableWriter lift       │
│                           local Reader<T>/Writer<T> to exo refs.              │
│  »» PROPOSED: ReactiveWindowExo — a remotable window-over-collection facet    │
│     { query(): snapshot, subscribe(): TopicSubscriber } built from the local  │
│     reactive collection below.                                                │
├─ Endo local layer (hardened JS, async-iterator-shaped, NOT passable) ─┤
│  @endo/pubsub            (#513): makeChangeTopic (lossless) /                 │
│                           makeLatestTopic (lossy); makePubSub Sink/Spring;    │
│                           makeCancelKit. All harden()ed.                      │
│  @endo/stream            (landed): local Reader<T>/Writer<T>, pump, makePipe. │
│  »» PROPOSED: @endo/reactive-collection — drives an FRB view observer over a  │
│     collections SortedSet/SortedArraySet and republishes its range-deltas as  │
│     a makeChangeTopic; exposes query()+subscribe() locally.                   │
├─ Foundation ────────────────────────────────────────────────────────┤
│  FRB observers (kriscendobot/frb)  +  collections (SortedSet splay tree,      │
│  SortedArraySet sorted array).  Incremental range-delta engine.              │
└──────────────────────────────────────────────────────────────────────┘
```

### 2.1 How the lift works (from `@endo/pubsub` + the #507 design)

The lift is **iterator-shaped duality**, verified in #513's source and README:

- `@endo/pubsub`'s `makeChangeTopic()` returns `{ publisher, subscribe }`
  where `publisher` is a local `Writer<TValue, TReturn>` and each
  `subscribe()` is a local `Reader<TValue, TReturn>` (read
  `change-topic.js`; the publisher is `makeStream(nullSpring, pub)` and the
  subscriber wraps a `makePubSub` spring cursor). These are **plain JS async
  iterators — explicitly not passable over CapTP** (PR #513 body, "Layering").
- The exo lift (#507) wraps each side in an exo whose methods carry an
  `InterfaceGuard`, exactly as `@endo/exo-stream`'s `PassableReader` /
  `PassableWriter` wrap `@endo/stream`'s `Reader` / `Writer`. Because a
  `Reader`'s entire surface is `next`/`return`/`throw` returning passable
  `IteratorResult`s, "CapTP rides method calls without ceremony" (#507 body):
  every `next()` is one CapTP round-trip that delivers the next passable delta.

**What lives where, concretely:**

| Concern | Endo local module | Exo lift |
|---|---|---|
| Ordered storage | `collections` SortedSet/SortedArraySet | — (stays local; only deltas cross) |
| Incremental window | FRB `view` observer | — |
| Delta delivery discipline | `@endo/pubsub` change/latest topic | `@endo/exo-pubsub` topic exo |
| Cursor / backpressure | Sink/Spring linked list, per-subscriber cursor | rides `Reader.next()` CapTP calls |
| Capability boundary | none (in-process) | `InterfaceGuard` per method; separate publisher/subscriber exos |
| Cancellation | `makeCancelKit` | exo method + `E.whenSevered` (#450) |

The **passable representation that crosses the wire is the delta**, not the
collection: a subscriber receives a stream of `{plus, minus, index}`-shaped
records (or whole snapshots for the lossy variant), each a Passable. The
ordered collection itself never serializes — agents synchronize by replaying
deltas into their own local mirror collection. This is the same posture as
`@agoric/notifier`'s subscription-pair (cited in `change-topic.js`'s own
doc-comment) and the in-tree `formulaChangeTopic` precedent (§6).

---

## 3. Hardening constraints (SES `harden`, no ambient authority)

The reactive/observer code path has specific hardening hazards; `@endo/pubsub`
already addresses most of them and the proposed modules must follow suit.

1. **Everything `harden()`ed at the boundary.** `@endo/pubsub` imports
   `harden` from `@endo/harden` and freezes every returned object —
   `pub`/`sub` (`pub-sub.js`), `publisher`/`subscriber`, `makeCancelKit`'s
   `{cancel, cancelled}`. The frozen-value distinction is deliberate: a
   published value is **frozen** before it enters the linked list
   (`freeze({value, promise})` in `pub-sub.js`) so a subscriber cannot mutate
   a value another subscriber will read. The reactive-collection module must
   freeze each delta record before publishing it; FRB's in-process arrays are
   *not* frozen (FRB predates SES), so the bridge is the freeze boundary.

2. **No subscription leaks.** A topic must not let a slow/hostile subscriber
   wedge the producer or leak memory in the producer's state.
   `makeChangeTopic` gets this right by construction: the back-pressure side is
   `nullSpring` ("the producer is not blocked by any subscriber's drain
   rate"), and **an undrained subscriber accumulates nodes in its own cursor
   closure, not in the producer** (`change-topic.js` doc-comment; PR #513
   body). The proposed window-topic inherits this: a stalled remote agent
   cannot back-pressure the source collection's mutators.

3. **Deterministic teardown, not GC-dependent.** A subscription's lifetime
   must be an explicit, revocable capability. FRB observers already return
   cancelers (§1.4); `@endo/pubsub` adds `makeCancelKit` for consumer-driven
   teardown "without disturbing the topic itself or peer subscribers"
   (README). For the **exo** layer, severance is the missing piece that #450
   (`E.whenSevered`) fills: when a remote subscriber's CapTP session aborts,
   the publisher side must cancel that subscriber's FRB sub-observer and drop
   its cursor — otherwise a severed peer leaks a live `view` observer forever.
   **This is the single hardest correctness obligation of the whole design**
   and the place where #450 is load-bearing rather than incidental.

4. **No ambient authority.** The modules take their collection, comparator,
   and clock (none needed — all logic is synchronous-on-mutation) as explicit
   parameters. The only authority a subscriber receives is its own `Reader`;
   the only authority a publisher holds is its own `Writer` and the source
   collection. This matches the #507 coherence requirement: "publishers and
   subscribers are separate exos with capability discipline at the boundary."

5. **Terminal disposition is sealed.** Both `@endo/pubsub` variants seal a
   `terminal` (`return`/`throw`) once and convert every later `next()` to a
   sticky terminal (`change-topic.js`, `latest-topic.js`). A reactive
   collection that is torn down (source revoked) `return()`s its topic so all
   subscribers — including ones that subscribe *after* teardown — observe a
   clean end rather than hanging. The late-subscriber synthesis branch in
   `change-topic.js` is exactly this case handled correctly.

---

## 4. The sorted-set / sorted-array-set interface and its window-topic operators

### 4.1 The collection contract (what an operator needs)

An operator that produces a window-topic needs from its source only the
**ordered-set observable contract**:

- `add(value)` / `delete(value)` / `has(value)` — membership mutation/query.
- ordered iteration and **`slice(start, length)`** (or index access) — to
  realize a window.
- a **range-change notification** — emits `(plus, minus, index)` on mutation.
  In `collections`, this is the `addRangeChangeListener` protocol that FRB's
  `observeRangeChange` consumes (`observers.js`); a `SortedSet` reports the
  index at which an element was inserted/removed in sort order.

Both `SortedSet` (splay) and `SortedArraySet` (sorted array) satisfy this, so
**an operator is written once against the contract and works over either
backing store.** The sorted-array variant makes index-windowing O(1) to locate
(binary search gives the index, slice is contiguous); the splay tree makes
locality-skewed membership churn cheaper. A design that exposes both lets the
agent pick per workload.

### 4.2 The window-topic operator (the proposed primitive)

```js
// @endo/reactive-collection  (Endo local layer, hardened)
import harden from '@endo/harden';
import { makeChangeTopic, makeLatestTopic } from '@endo/pubsub';
// FRB observer makers (from kriscendobot/frb)
import { makeViewObserver, observeRangeChange } from 'frb/observers.js';

/**
 * Given an observable ordered collection and an observable window spec,
 * yield a topic whose subscribers see the window's contents kept consistent
 * incrementally as the collection and/or the window spec mutate.
 *
 * `lossless: true`  -> makeChangeTopic: subscriber replays every range-delta.
 * `lossless: false` -> makeLatestTopic: subscriber sees the latest full window.
 */
export const makeWindowTopic = (
  observeCollection,   // FRB observer over a SortedSet / SortedArraySet
  observeStart,        // FRB observer over the window start (an integer)
  observeLength,       // FRB observer over the window length
  { lossless = true } = {},
) => {
  const { publisher, subscribe } = lossless
    ? makeChangeTopic()    // deltas: {plus, minus, index}
    : makeLatestTopic();   // snapshots: the whole window array
  const observeView = makeViewObserver(
    observeCollection, observeStart, observeLength,
  );
  // The view observer emits an output array; we attach a range-change
  // listener that forwards each frozen delta (or snapshot) to the publisher.
  const cancelView = observeView((output) => {
    if (lossless) {
      return observeRangeChange(output, (plus, minus, index) => {
        publisher.next(harden({ plus: [...plus], minus: [...minus], index }));
      });
    } else {
      return observeRangeChange(output, () => {
        publisher.next(harden([...output]));   // latest full window
      });
    }
  }, /* scope */ {});

  return harden({
    subscribe,                         // () => Reader<delta|snapshot>
    query: () => harden([...currentWindowSnapshot()]),  // synchronous pull
    [Symbol.for('teardown')]: () => { cancelView(); publisher.return(); },
  });
};
```

`query()` is the **pull** facet (a synchronous snapshot of the current window);
`subscribe()` is the **push** facet (a `Reader` over deltas/snapshots).
Together they are the maintainer's "query + subscriber facilities."

### 4.3 Why `view` is the right FRB operator (not a bespoke window)

The five-branch splicer in `makeViewObserver` (§1.3) already handles every way
a window can change relative to a mutation: the mutation lands before the
window (shift the window's contents), inside it (splice), or after it (no-op).
A naive "re-slice on every change" implementation would be O(window) per
mutation and would replace the output identity. `view` is O(delta) and
identity-stable, which is what makes a *delta* topic (not just a snapshot
topic) possible: the lossless `makeChangeTopic` variant forwards exactly the
range-deltas `view` already computes.

---

## 5. Query + subscriber model for agent synchronization

The synchronization pattern, end to end:

1. **Host agent** holds an ordered collection (e.g. a sorted set of message
   ids, or a CRDT-ish log) and one or more `makeWindowTopic` operators over
   windows of interest (`[latest 50]`, `[unread]`, `[since cursor]`).
2. It lifts each window-topic to a **`ReactiveWindowExo`** (the Exo layer)
   and grants a remote agent a remotable handle.
3. **Remote agent** calls `E(windowExo).query()` once to get a snapshot,
   seeds a local mirror collection, then `E(windowExo).subscribe()` to get a
   `Reader`. It `for await`s deltas and replays each into its mirror.
4. The mirror stays consistent **incrementally** — one CapTP round-trip per
   delta, payload sized to the change, never the whole collection.
5. On severance (#450 `E.whenSevered`), the remote drops its mirror; the host
   cancels the per-subscriber view observer and frees the cursor.

The **two delivery disciplines map onto two synchronization regimes**:

- **`makeChangeTopic` (lossless)** → *replicated log* semantics. The remote
  reconstructs the host's window exactly, delta by delta. Right for ordered
  message streams, append-mostly collections, anything where every
  intermediate state matters. This is the direct descendant of
  `@agoric/notifier`'s *subscription*.
- **`makeLatestTopic` (lossy)** → *latest-snapshot* semantics. The remote sees
  the current window whenever it drains; intermediate windows are skipped.
  Right for a "current view" pane, a dashboard, a presence list — anywhere a
  slow consumer should skip to now rather than catch up. This is the
  descendant of `@agoric/notifier`'s *notifier*. (Both lineages named in
  #507's body and in `change-topic.js` / `latest-topic.js` doc-comments.)

This is why the maintainer wants **both** variants: a window-topic over the
*same* collection can be subscribed losslessly by an agent that needs the full
history and lossily by an agent that needs only the current frame, without the
producer doing anything different.

---

## 6. Relationship to the recent pubsub-topics work (cited)

| Work | Where | Relationship to this design |
|---|---|---|
| **`@endo/pubsub`** | PR #513, `feat/endo-pubsub`, base frozen-`llm` | The local-layer delivery engine this design builds on. Provides `makeChangeTopic`/`makeLatestTopic`/`makeCancelKit`/`makePubSub`. **Hard dependency.** |
| **`@endo/exo-pubsub`** | design PR #507, `design/notifier-pubsub-migration` | The Exo lift pattern. The proposed `ReactiveWindowExo` is an `@endo/exo-pubsub` topic exo whose published values are window-deltas. **Hard dependency on the lift convention.** |
| **`E.whenSevered`** | design PR #450, `design/presence-severance-observation` | The teardown signal for remote subscribers (§3.3). Without it, a severed peer leaks a live `view` observer. **Load-bearing for hardening.** |
| **`formulaChangeTopic`** | `designs/daemon-cross-peer-gc.md` (cited by #507) | In-tree precedent for a lossless change-topic over a daemon-internal collection; named in `change-topic.js`'s own doc-comment as the model for "producer not vulnerable to consumers." The reactive collection generalizes it from formula-state to arbitrary ordered collections. |
| **`retention-accumulator` coalescing** | `designs/daemon-cross-peer-gc.md` (cited by #507) | A delta-coalescing pattern; relevant to a future optimization where many small window-deltas to a slow remote are merged. Noted as future work, not in the MVP. |
| **construction-time notifiers** | `journal/projects/endo/drafts/construction-time-notifiers.md` | Adjacent garden design on a *shared notifier primitive* (naugtur/kriskowal review thread on SES module instances): "create all notifiers ahead of time… connect notifiers in a loop." The reactive-collection's per-window topic is a consumer of the same primitive family; worth keeping the topic abstraction compatible with that notifier-linking idea. |

---

## 7. Propagators (relationship — partly unverifiable from source)

The brief asks how this relates to **propagators** (constraint/dataflow
propagation, in the Sussman/Radul sense: a network of cells and propagators
that incrementally re-establish consistency as data arrives, possibly
multi-directionally).

**What is verifiable from source:** FRB *is* a propagator network in the
one-directional and two-directional senses. The `frb-compiled-observer-tree`
concept describes exactly this: "each node in the tree consumes the typed
delta from its child and emits a delta to its parent, so a deep query chain
propagates one change without recomputing intermediate results." A FRB
two-way `bind` (`"<->"`) is a bidirectional constraint between two cells —
`reversed()` (§1, `makeReversedObserver`) maintains `backward === forward
reversed` in both directions, and the README's algebraic-inversion machinery
(`compile-binder.js`) solves simple equations to propagate backward. So FRB is
a **synchronous, incremental, partially-bidirectional propagator over
collections** — and the window-topic is the mechanism for **extending that
propagation across an agent boundary** (the delta that a propagator would push
to an adjacent cell is instead published to a remote subscriber's mirror).

**What is NOT verifiable:** I found **no propagator package** in `endo`,
`endo-but-for-bots`, or the garden library. A search of the endo-but-for-bots
PRs and the `designs/` tree on `llm` for `propagat*`/`constraint`/`dataflow`
returned only unrelated hits (`#264` import-attributes *propagation*, `#353`
live-export *propagation* — neither is the Sussman sense). So the
"relationship to propagators" is at present a **conceptual/architectural
analogy, not a relationship to an existing artifact.** If the maintainer has a
specific propagator design in mind (a `@endo/propagator` package, or an
agoric-sdk one), it was not discoverable from the sources I could read, and
this should be confirmed before the design commits to that framing. The honest
statement: *the reactive collection is propagator-shaped, and a future
`@endo/propagator` could be built on the same FRB delta substrate, but no such
package exists to integrate with today.*

---

## 8. Proposed module shape (concrete)

Three new packages, mirroring the `stream`/`exo-stream` and
`pubsub`/`exo-pubsub` split, incubating on `llm` (per the #513 precedent):

1. **`@endo/reactive-collection`** (Endo local, hardened, depends on
   `frb` + `collections` + `@endo/pubsub`):
   - `makeOrderedSet({ backing: 'splay' | 'sorted-array', compare })` —
     thin hardened facade over `collections` `SortedSet`/`SortedArraySet`
     exposing the observable ordered-set contract (§4.1) with frozen deltas.
   - `makeWindowTopic(observeCollection, observeStart, observeLength,
     { lossless })` — §4.2.
   - `makeQueryTopic(observeCollection, observeQuery, { lossless })` — the
     generalization: any FRB filter/sorted/map chain (not just `view`) as the
     "query," republished as a topic. `view` is the windowing special case.
2. **`@endo/exo-reactive-collection`** (Exo lift, depends on
   `@endo/reactive-collection` + `@endo/exo-pubsub` + `@endo/eventual-send`):
   - `makeReactiveWindowExo(localWindowTopic)` → remotable
     `{ query(): Passable[], subscribe(): TopicSubscriberExo }`, each method
     `InterfaceGuard`ed; subscriber conforms to `PassableReader`.
   - Wires `E.whenSevered` (#450) on each subscriber to cancel its
     view-observer on remote teardown.
3. *(optional, later)* **`@endo/propagator`** — deferred pending §7
   confirmation; would expose FRB's two-way binder as a passable constraint
   cell.

**Boundary invariants:** the ordered collection never serializes; only frozen
deltas/snapshots cross CapTP; every subscriber is independently cancelable;
the producer is never back-pressured by a subscriber; teardown is explicit and
severance-driven.

---

## 9. Open questions

1. **Propagator artifact (§7).** Does a `@endo/propagator` (or agoric-sdk)
   design exist that I could not see, or is "propagators" purely the
   architectural lens? This determines whether package #3 is real or analogy.
2. **FRB packaging.** FRB is CommonJS, pre-SES, and depends on
   `collections@~0.1.23` which monkeypatches `Object`/`Array` shims
   (`observers.js` uses `output.swap`, `Object.compare`, `Object.equals`).
   Consuming it inside a hardened Endo package needs either (a) an ESM/SES port
   of the *observer makers only* (not the whole query language), or (b) a
   reimplementation of just the `view` splicer (~40 lines, §1.3) against a
   SES-clean ordered-set. **Recommendation: reimplement the `view` splicer;
   do not try to harden the whole `collections` shim surface.** This is the
   biggest practical risk and deserves a focused spike.
3. **Delta representation on the wire.** Index-based deltas (`{plus, minus,
   index}`) assume the remote mirror shares the host's sort order. For a
   `SortedSet` the order is the comparator, which both sides must agree on —
   pass the comparator's identity, or make deltas value-keyed rather than
   index-keyed? Value-keyed is more robust across comparator drift but loses
   the O(1) splice locality.
4. **Coalescing for slow remotes.** Should the lossless exo subscriber
   optionally coalesce deltas (the `retention-accumulator` pattern from
   `daemon-cross-peer-gc`) when a remote lags, or always stay strictly
   lossless? Probably a per-subscription policy.
5. **Lossy window snapshots can be large.** `makeLatestTopic` over a 10k-row
   window ships the whole window each drain. For large windows the lossy
   variant may want a *bounded-delta* mode (ship deltas but cap the backlog,
   then fall back to a snapshot) — a third discipline between the two #513
   variants. Worth raising against #507's two-variant model.
6. **Two-way windows.** FRB `view`/`reversed` support two-way binding. Does an
   agent ever *write through* a window-topic to mutate the host's collection,
   or are these strictly read-replicas? If write-through is wanted, the exo
   needs a guarded `propose(delta)` facet and a conflict policy — a much larger
   design.

---

## Provenance (everything read while drafting)

- **FRB source** — `kriscendobot/frb` @ `131db347355789cf2dbb79e49b10881d9716b449`
  (fork of `kriskowal/frb`), cloned to read directly:
  `observers.js` (operator makers; `makeViewObserver` l.817–863,
  `makeSortedSetBlockObserver` l.504–544, `makeSortedBlockObserver` l.464,
  `makeRangeObserver` l.895, `makeReversedObserver` l.550, `makeFlattenObserver`
  l.571, `SortedArray`/`SortedSet` requires l.5–6); `package.json`
  (`collections@~0.1.23` dependency).
- **`@endo/pubsub`** — PR #513 `feat/endo-pubsub`, source read via GitHub API:
  `change-topic.js`, `latest-topic.js`, `pub-sub.js`, `cancel-kit.js`,
  `README.md`; PR body.
- **`@endo/exo-pubsub`** — design PR #507 `design/notifier-pubsub-migration`,
  PR body (the lift convention, `PassableReader`, InterfaceGuard coherence,
  the `daemon-cross-peer-gc`/`formulaChangeTopic`/`retention-accumulator`
  cross-references).
- **`E.whenSevered`** — design PR #450 `design/presence-severance-observation`,
  PR body (severance taxonomy; CapTP `whenAborted` triple verification).
- **Garden library** (`journal/library/`): concepts `frb-incremental-update`,
  `frb-compiled-observer-tree`; section
  `frb--readme--tutorial-windowing-and-structure` (the `view` over `SortedSet`
  example).
- **Adjacent garden draft** —
  `journal/projects/endo/drafts/construction-time-notifiers.md`
  (shared-notifier-primitive thread).
- **Propagator search** — `endojs/endo-but-for-bots` PR list and `designs/`
  tree on `llm` searched for `propagat*`/`constraint`/`dataflow`: no
  Sussman-sense propagator artifact found (§7).

## Prompt (verbatim)

> Investigate potential uses of operators in FRB … to construct Endo and Exo
> collections that provide query and subscriber facilities for synchronization
> between agents. … the implementation should exist at the Endo level and be
> lifted to passable at the Exo layer … these must be hardened … a splay tree
> backed by a sorted array (or a sorted-array-set interface) and operators
> thereon that produce topics watching a sliding window of an arbitrary other
> ordered collection … query + subscriber (pubsub) facilities … how that
> relates to recent pubsub-topics work … and to propagators.

*Status: draft for maintainer review. Recommended next step — a designer
dispatch (with researcher precedence) to formalize §8's package #1
(`@endo/reactive-collection`) into a design PR against the `llm` branch,
coherent with #507's exo-pubsub design, and a focused spike on open question
#2 (FRB `view` splicer reimplementation vs. hardening the `collections`
shim).*
