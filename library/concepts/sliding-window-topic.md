---
id: sliding-window-topic
aliases: ["sliding window topic", "sliding-window topic", "ordered collection window", "window over ordered collection", "derived topic", "view operator", "frb view", "view(start, length)", "windowed topic", "collection-change propagation", "range-change topic", "windowing over a sorted collection"]
topics: [change-propagation, reactive-bindings, data-structures]
status: current
---

# sliding-window-topic

A **derived, incrementally-maintained window over an ordered collection** that behaves as a change-propagation topic: it reacts both to changes in the underlying collection's *content* and to changes in the *window's own position and length*, and it emits the resulting deltas rather than recomputing the window from scratch. The grounded precedent is FRB's **`view(start, length)`** operator; the named future direction is its temporal counterpart over a pubsub topic.

## The grounded precedent: FRB `view` over a SortedSet

`kriskowal/frb`'s windowing operator projects a sliding window from a large ordered source (such as a `SortedSet`) as an array, reacting to collection changes *and* to the window's `start`/`length`:

```javascript
var controller = {index: SortedSet([1,2,3,4,5,6,7,8]), start: 2, length: 4};
bind(controller, "view", {"<-": "index.view(start, length)"}); // [3,4,5,6]
controller.length = 3;       // [3,4,5]
controller.start = 5;        // [6,7,8]
controller.index.add(0);     // [5,6,7]  (content shifts the window)
```

Three properties make this a change-propagation topic, not a one-shot slice:

- **Two change sources.** The window updates when the *collection* changes (an `add`/`delete` shifts what falls inside the window) and when the *window parameters* change (`start`/`length` are themselves observed). This is the same multi-source structure the pubsub design later names for a collection-change topic.
- **Incremental, identity-stable output.** Like every FRB array-producing binding, the output array's identity is never replaced — only the affected elements are spliced in place. The window is maintained by delta, not regenerated. See [[frb-incremental-update]].
- **Ordered substrate.** The window is meaningful only over an ordered collection (a `SortedSet`, backed by a sorted structure); position-based windowing presupposes a total order. This is why the FRB-over-Endo-Exo reactive-collections direction centers on a splay-tree / sorted-array-set interface — a window/topic over an ordered collection needs an ordered, incrementally-mutable structure underneath.

## The named future direction: collection-change propagation over a topic

The notifier-pubsub-migration design (#507, now at revision 5, ingested as a library source: [endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation.md)) includes a *Future evolution: collection-change propagation* section that names the FRB shape — **a `ChangesPubSub<Splice<T>>` over range-change records `{ plus, minus, index }`, incremental transform adapters (`topic.map(fn)` incremental rather than full re-broadcast), and automatic subscription / unsubscription managed by the binding graph** — as the future direction for `@endo/pubsub` topics. It is **explicitly out of scope** for the first iteration; naming it keeps the substrate's value-type open, since the kits and adapters are parameterized on `T` and a future `T = SpliceChange<U>` is the migration onto FRB shape. Read together with the FRB `view` precedent, the through-line is explicit: a sliding-window-over-an-ordered-collection is an FRB derived view *synchronously*, and the same range-change deltas can be carried *temporally* over a change-topic so a remote subscriber maintains its own copy of the window incrementally. The async window is the temporal rotation (gtor's space→time axis) of the synchronous FRB `view`.

## The grounded bridge: the `research-frb-endo-exo-collections` investigation

The `research-frb-endo-exo-collections` job (completed 2026-06-24; deliverable `journal/projects/endo/drafts/frb-reactive-exo-collections.md`, status `draft-for-maintainer-triage`) read FRB's `observers.js` directly and established the concrete shape that connects the FRB `view` to a pubsub topic. Key source-grounded findings (all citing the draft and `kriscendobot/frb` at `131db347`):

- **The ordered-set observable contract** an operator needs from its source: `add` / `delete` / `has`, ordered iteration with `slice(start, length)` (or index access), and a **range-change notification** emitting `(plus, minus, index)` on mutation (FRB's `addRangeChangeListener` / `observeRangeChange` protocol). Both `SortedSet` (a **splay tree** in `kriskowal/collections`) and `SortedArraySet` (a **sorted array** with binary-search insertion) satisfy this one contract, so a window operator is written once and works over either backing store. The choice is a performance knob: splay tree for skewed-locality membership churn, sorted array for dense iteration and O(1)-locate index-windowing.
- **`makeViewObserver` (`observers.js` l.817) is the sliding window.** Its body observes `input`, `start`, and `length`, and on every `rangeChange(plus, minus, index)` runs a **five-branch splicer** (shrink-before, grow-before, shrink-within, grow-within, full-replace) that injects/removes only the elements that crossed the window boundary, never recomputing the slice. This is O(delta) and identity-stable, which is exactly what makes a *delta* topic (not just a snapshot topic) possible.
- **The proposed `makeWindowTopic` operator** (a concrete `@endo/reactive-collection` primitive in the draft) wires `makeViewObserver` to a pubsub topic: `lossless: true` forwards each frozen `{ plus, minus, index }` delta over a `makeChangeTopic` (the subscriber replays every range-delta the `view` already computed); `lossless: false` forwards the whole window array over a `makeLatestTopic`. It exposes both facets of agent synchronization — `query()` is the synchronous **pull** snapshot, `subscribe()` is the **push** `Reader` over deltas/snapshots. Every FRB observer returns an explicit canceler (`makeViewObserver` returns `once(cancelViewObserver)`), so subscription lifetime is already a first-class returnable value, which is what makes a hardened lift feasible.

The draft's honest gaps carry forward to this page: it is a `draft-for-maintainer-triage`, not a landed design; FRB is CommonJS/pre-SES and depends on the `collections` shim, so the draft recommends reimplementing just the ~40-line `view` splicer against a SES-clean ordered set rather than hardening the whole shim surface. Treat `makeWindowTopic` as a proposed shape, not shipped API.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [frb--readme--tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | `view(start, length)` projects a sliding window over a SortedSet, reacting to content and window-position changes; output identity never replaced. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | Typed range-change records propagate through the observer tree — the deltas a windowed topic would carry. |
| [frb--readme--tutorial-maps-and-lookups](../sections/frb--readme--tutorial-maps-and-lookups.md) | Sorted/ordered collection operators FRB windows depend on. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation.md) | The design-side naming of the FRB collection-change-propagation direction as the out-of-scope future of `@endo/pubsub` topics. |

Primary journal citation (the grounded research):

- `projects/endo/drafts/frb-reactive-exo-collections.md` (`research-frb-endo-exo-collections`, completed 2026-06-24) — the FRB operator survey grounded in `observers.js`; the splay-tree / sorted-array-set ordered-set observable contract; `makeViewObserver`'s five-branch splicer; the proposed `makeWindowTopic` operator with `query()` pull + `subscribe()` push; the SES-cleanliness gap. `draft-for-maintainer-triage`, not a landed design.

## See also

- [[change-propagation]] — the through-line; windows-as-topics are one of its named threads.
- [[endo-pubsub]] — the package whose design names collection-change propagation as future evolution.
- [[frb-incremental-update]] — the delta-not-recompute mechanism that keeps the window cheap and identity-stable.
- [[generic-collections]] — the ordered-collection substrate (SortedSet, sorted maps/sets) windows project over.
- [[changes-versus-latest]] — a window emits *changes* (range-change deltas); the whole-window snapshot is its *latest* face.

## Common confusions

- **A window is not a one-shot slice.** `Array.prototype.slice` returns a fresh array detached from its source; an FRB `view` (or a collection-change topic) is a *live* projection that keeps tracking both the content and the window parameters.
- **Ordered substrate is required.** Position-based windowing needs a total order; this is grounded for FRB's `SortedSet`. The splay-tree / sorted-array-set interface for the Endo/Exo reactive-collections direction is grounded in the `research-frb-endo-exo-collections` draft (`SortedSet` is a splay tree, `SortedArraySet` a sorted array; both satisfy one ordered-set observable contract). That draft is `draft-for-maintainer-triage`, not a landed design — cite it as a proposal, not shipped API.
- **`makeWindowTopic` is proposed, not shipped.** Neither `@endo/pubsub` (#513) nor the notifier-pubsub-migration design (#507) ships a window-topic operator; the FRB-shaped collection-change extension is explicitly out of scope for the current pubsub iteration. `makeWindowTopic` is a concrete shape proposed in the research draft, gated on a SES-clean reimplementation of FRB's `view` splicer. Do not present it as existing API.
