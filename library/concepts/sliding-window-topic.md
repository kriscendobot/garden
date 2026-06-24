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

The notifier-pubsub-migration design (#507, revision 4) includes a *Future evolution: collection-change propagation* section that names the FRB shape — **range-change records, incremental transforms, and automatic subscription / unsubscription** — as the future direction for `@endo/pubsub` topics (out of scope for the first iteration). Read together with the FRB `view` precedent, the through-line is explicit: a sliding-window-over-an-ordered-collection is an FRB derived view *synchronously*, and the same range-change deltas can be carried *temporally* over a change-topic so a remote subscriber maintains its own copy of the window incrementally. The async window is the temporal rotation (gtor's space→time axis) of the synchronous FRB `view`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [frb--readme--tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | `view(start, length)` projects a sliding window over a SortedSet, reacting to content and window-position changes; output identity never replaced. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | Typed range-change records propagate through the observer tree — the deltas a windowed topic would carry. |
| [frb--readme--tutorial-maps-and-lookups](../sections/frb--readme--tutorial-maps-and-lookups.md) | Sorted/ordered collection operators FRB windows depend on. |

(The `research-frb-endo-exo-collections` investigation — Endo/Exo reactive collections, the splay-tree / sorted-array-set interface, sliding-window topics over an ordered collection — is in-flight and not yet ingested as a library source; this concept page should gain its citations when that research lands.)

## See also

- [[change-propagation]] — the through-line; windows-as-topics are one of its named threads.
- [[endo-pubsub]] — the package whose design names collection-change propagation as future evolution.
- [[frb-incremental-update]] — the delta-not-recompute mechanism that keeps the window cheap and identity-stable.
- [[generic-collections]] — the ordered-collection substrate (SortedSet, sorted maps/sets) windows project over.
- [[changes-versus-latest]] — a window emits *changes* (range-change deltas); the whole-window snapshot is its *latest* face.

## Common confusions

- **A window is not a one-shot slice.** `Array.prototype.slice` returns a fresh array detached from its source; an FRB `view` (or a collection-change topic) is a *live* projection that keeps tracking both the content and the window parameters.
- **Ordered substrate is required.** Position-based windowing needs a total order; this is grounded for FRB's `SortedSet`. The specific splay-tree / sorted-array-set interface for the Endo/Exo reactive-collections direction is in the in-flight research and not yet ingested — do not assert its details from this page.
