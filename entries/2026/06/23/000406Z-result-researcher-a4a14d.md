---
ts: 2026-06-23T00:04:06Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
---

Refinement for the proposed designer dispatch on the `notifier-pubsub-migration` design. The downstream prompt asks the designer to propose migrating `@agoric/notifier` from `agoric-sdk` into Endo with three redesigned topic shapes (`makeLatestTopic` lossy, `makeChangeTopic` lossless deltas, `makeUpdateTopic` retired or composed), Producer-as-`Writer<T>` / Subscriber-as-`Reader<T>` composition with `@endo/stream`, and tight coherence with the exo-streams discipline.

The library carries strong material on three of the four load-bearing surfaces:

1. The current `@agoric/notifier` shape and lossiness semantics is fully indexed (six sections from `agoric-sdk--pkg-notifier-readme`); the designer can lift the canonical "fully lossless / forward-lossless / lossy" framing and the producer/consumer-pair vocabulary directly.
2. The `@endo/stream` Reader/Writer symmetry and its `makeQueue` / `makePipe` / `pump` / `prime` primitives are deeply indexed (the `endo--packages-stream-index-js` and `endo--packages-stream-README-md` blocks). The "async-singly-linked-list-queue primitive" the prompt names from endo#1444 maps to the `functional-async-queue` / `promise-chain cons-cells` pattern in `makeQueue`.
3. The `@endo/exo-stream` package and its CapTP-friendly conversion functions are indexed as the [exo-stream concept](concepts/exo-stream.md); this is the canonical bridge from local iterators to remote-passable stream objects and is the right source of the "exo-streams discipline" framing the maintainer named.

Two project-side designs on the `llm` branch are direct cross-references for the new design: `designs/daemon-message-streaming.md` (StreamWriter / StreamReader exo interfaces, four-event-type taxonomy, CapTP-rides-method-calls discipline) and `designs/daemon-cross-peer-gc.md` (the `formulaChangeTopic` single-mutation-surface pattern and the retention-accumulator subscriber lifecycle). The exo-streams discipline citation lives in the [`exo-stream` concept page](concepts/exo-stream.md) and points at `packages/exo-stream/` already on the `llm` branch.

The refinement section the orchestrator inlines verbatim:

```markdown
## Library and project references

### Library concepts and sections

- [`concepts/exo-stream.md`](../../journal/library/concepts/exo-stream.md) — the canonical bridge from local async iterators to remote-passable `PassableReader` / `PassableWriter` exo refs. The maintainer's "exo-streams discipline" rooting. Read first.
- [`sources/endo--packages-stream-README-md`](../../journal/library/sources/) section family — `@endo/stream`'s symmetric Reader/Writer type, parity invariant, back-pressure-via-acks. The `Reader<T>` / `Writer<T>` framing the downstream prompt requires.
- [`sections/endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities`](../../journal/library/sections/) — the source implementation. `makeQueue` is the "async-singly-linked-list-queue" the prompt names; `makePipe = two-queues-cross-wired`; `pump` is the reader-to-writer bridge.
- [`sections/agoric-sdk--pkg-notifier-readme--type-differences`](../../journal/library/sections/) (+ three child sections: type-differences, lossiness, use-cases) — the canonical lossy / forward-lossless / fully-lossless taxonomy for the three topic shapes.
- [`sections/agoric-sdk--pkg-notifier-readme--publishkit-and-related-types`](../../journal/library/sections/) — frame: `makePublishKit` / `makeNotifierKit` / `makeSubscriptionKit` triad; PublishKit is the current recommended shape, NotifierKit and SubscriptionKit are already deprecated.
- [`sections/agoric-sdk--pkg-notifier-readme--distributed-asynchronous-iteration`](../../journal/library/sections/) — the formal semantics: non-final values + Finish / Fail termination, full ordering across all consumers.
- [`sections/agoric-sdk--pkg-notifier-readme--distributed-operation`](../../journal/library/sections/) — the load-bearing distributed-systems properties: producer-not-vulnerable-to-consumers, consumers-mutually-independent, `getSharable*Internals` adapter pattern for remote AsyncIterable consumption. Direct source of the "compose with `pump` / `makePipe`" framing.
- [`concepts/retention-accumulator.md`](../../journal/library/concepts/retention-accumulator.md) — coalesce-then-deliver microtask-batched delta primitive. Precedent for `makeChangeTopic`'s lossless-deltas semantics with subscriber-coalescing.
- [`sections/endo--packages-marshal-src-marshal-js--*`](../../journal/library/sections/) — `@endo/marshal` is the package whose Parcel/symlink interaction with `@agoric/notifier` motivated endo#1035. The dual-format-body-discriminator section is the most relevant for wire-format concerns.
- [`topics/exo.md`](../../journal/library/topics/exo.md) and [`sections/endo--agents--exo-this-context`](../../journal/library/sections/) — the Exo class API (`makeExo` / `defineExoClass` / `defineExoClassKit`) and `M.interface` guards. Required for the "exos not plain factories + InterfaceGuard for every method" constraint from the prompt's *Exo-streams coherence* section.
- [`topics/streams.md`](../../journal/library/topics/streams.md) — the topic index for the streams family; useful for ad-hoc lookups during design.

### Project context

- [`projects/endo-but-for-bots/README.md` § Rules of engagement](../../journal/projects/endo-but-for-bots/README.md) — design PRs land on `llm` branch; design-PR convention applies; standing relaxation authorizes the DRAFT PR open without per-action authorization in the dispatch prompt.
- [`projects/endo-but-for-bots/README.md` § Authority structure](../../journal/projects/endo-but-for-bots/README.md) — every commenter on this repo is maintainer-equivalent; treat erights, kumavis, jcorbin, danfinlay, 0xpatrick reviews as authoritative.
- Related designs on the `llm` branch's `designs/` tree (cite by relative path from the new design):
  - `designs/daemon-message-streaming.md` — StreamWriter / StreamReader exo interfaces with `append` / `setPhase` / `end` / `abort` (four-event taxonomy); CapTP-rides-method-calls discipline; persistence model (durable-on-end / partial-on-abort). The strongest precedent in-tree for how an exo-shaped streaming interface looks on this codebase.
  - `designs/daemon-cross-peer-gc.md` — the `formulaChangeTopic` single-mutation-surface pattern; `followRetentionSet` async-iterator follower lifecycle; how retention-accumulator subscribers feed deltas. Direct precedent for `makeChangeTopic`'s subscriber API.
  - `designs/daemon-cas-management.md` — content-store as supervisor-owned subsystem with typed retain/release and background mark-sweep GC; relevant if `makeChangeTopic` needs durable storage of unread deltas.
- `packages/exo-stream/` (already on the `llm` branch per `concepts/exo-stream.md`) — the package source the new design extends; cite by relative path. Upstream PR `endojs/endo#3036` is the migration guide.

### Why each reference is relevant

- `exo-stream` concept page + `@endo/exo-stream` package source: the maintainer's "coherent and consistent with the design of exo-streams" load-bearing constraint roots here. The four conversion functions (`readerFromIterator` / `writerFromIterator` / `iterateReader` / `iterateWriter`) define what "an exo-shaped stream looks like."
- `@endo/stream` README + index.js sections: the `Reader<T>` / `Writer<T>` framing the prompt requires for producer-as-`Writer<T>` composition. `makeQueue`'s functional-async-queue idiom IS the "async-singly-linked-list-queue" the prompt names from endo#1444.
- `agoric-sdk--pkg-notifier-readme` section family: the lossy / forward-lossless / fully-lossless taxonomy maps directly to `makeLatestTopic` / `makeChangeTopic` (and is the right vocabulary to retire or recast `makeUpdateTopic` under). PublishKit's "single publisher serves both" flexibility is the precedent for unifying the three topic shapes behind one publisher API.
- `daemon-message-streaming.md`: the closest in-tree precedent for an exo-shaped streaming interface; cite for InterfaceGuard shape, persistence model, and CapTP-rides-method-calls coherence.
- `daemon-cross-peer-gc.md`: `formulaChangeTopic` is an actual in-tree "change topic" instance; lift its event-source enumeration and subscriber-lifecycle treatment.
- `retention-accumulator` concept: precedent for backpressure-friendly delta coalescing (relevant Open Question 9c in the prompt).
- `endo--packages-marshal-README-md` source: explains why the Parcel/symlink interaction in endo#1035 was load-bearing — `@agoric/notifier`'s dependency on `@endo/marshal` while living in agoric-sdk was the structural problem the migration resolves.
- `topics/exo.md`: the Exo class API surface the new pubsub interfaces must conform to (`defineExoClass` for stateful topics; `M.interface` guards for every method).
- Project README sections: confirm the PR-open authorization, the `llm` branch convention, and the maintainer-equivalent commenter rule the designer should expect on review.

### Open questions

- **`makeLatestTopic` / `makeChangeTopic` / `makeUpdateTopic` are not in the library.** No prior Endo design proposes these exact names. The prompt's hint summary from endo#1444 is the canonical material; the designer drives nomenclature. Now keyword-shortcutted as open questions in `library/keywords.md`.
- **`@endo/notifier` vs absorption into `@endo/exo-stream`.** No prior position in the library; the designer decides as part of the migration scope section.
- **`async-singly-linked-list-queue` primitive name.** The library indexes the implementation (`functional-async-queue promise-chain cons-cells`) but not by this name. Surface as a synonym in the design if the new name is adopted; otherwise the existing names are precedent.
- **No prior in-tree pubsub design.** The closest precedents are `daemon-message-streaming` (per-message stream) and `daemon-cross-peer-gc`'s `formulaChangeTopic` (single-topic subscriber follower); neither is a general-purpose pubsub. The new design is the library's first.
- **Per-call-site notifier-caller survey across `agoric-sdk` + `endo-but-for-bots` + `endo`.** No indexed inventory; the designer would discover this during the migration-plan section. The agoric-sdk project README marks the project as *passive standing watch* (no active engagement), so the caller-survey is research the designer performs, not material the researcher can hand off.
```

### Library writeback

Added 32 keyword shortcuts to `library/keywords.md` near the `@endo/stream` cluster covering the notifier vocabulary: `@agoric/notifier`, `makePublishKit` / `makeNotifierKit` / `makeSubscriptionKit`, PublishKit / NotifierKit / SubscriptionKit, the three publisher/consumer pair shapes, IterationObserver / Publisher / Subscriber interfaces, `subscribeAfter` / `getUpdateSince` / `subscribeEach` / `subscribeLatest`, the three lossiness modes (fully lossless / forward-lossless / lossy), sampling-subset / suffix-subset terminology, Finish/Fail termination, `getSharable{Subscription,Notifier}Internals`, the producer-not-vulnerable-to-consumers + consumers-mutually-independent distributed properties, plus three explicit *open question* markers for the proposed `makeLatestTopic` / `makeChangeTopic` / `makeUpdateTopic` names (load-bearing for the new design but absent from the library), and a `formulaChangeTopic` shortcut to the dcpg event-sources section. The notifier corpus was previously indexed only at the section-file level with no keyword entry points; the next library-lookup caller on any of these terms now resolves cleanly.

### Open questions

Beyond the in-section opens listed above:

- The library does not carry a concept page for `@endo/exo-stream` discipline as a *design constraint* on neighboring packages. The exo-stream concept page covers the API surface but not the "every neighbor package follows this discipline" implication the maintainer named. A future librarian or scholar engagement could draft a `concepts/exo-streams-discipline.md` consolidating the constraint; the new notifier-pubsub-migration design will likely produce material worth ingesting for that concept page.

Self-improvement: nothing this time. The library carried strong primary material; the keyword index had a gap on the notifier family that this engagement filled. No structural lesson at the role or skill level beyond the standard "researcher fills keyword gaps it encounters" discipline.
