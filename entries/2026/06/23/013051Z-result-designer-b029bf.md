---
ts: 2026-06-23T01:30:51Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/designer--b029bf/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/507
---

Revision 2 of `designs/notifier-pubsub-migration.md` (PR #507) folds in
kriskowal's two reviews (CHANGES_REQUESTED 4549104173 + COMMENTED
4549119967, 10 inline comments total).

**Lease anchor:** `2c769e58f` (revision 1 tip; force-with-lease honored).
**New HEAD:** `25dea2f1e` on `design/notifier-pubsub-migration`.

**Commits pushed (four coherent chunks):**

- `9a57cd43a` design(notifier-pubsub): layering: name @endo/pubsub as
  local sibling (review comment 3456272597 on line 32)
- `243e170c3` design(notifier-pubsub): three topic-shape revisions per
  kriskowal review (comments 3456276874 / 3456279253 / 3456282122 on
  lines 113 / 183 / 218)
- `19d7b4a95` design(notifier-pubsub): wire-protocol + cancellation +
  evolvability (comments 3456285367 / 3456289153 / 3456291373 /
  3456303692 on lines 398 / 411 / 422 / 443; also folded in the two
  affirmation acknowledgments on lines 431 / 437)
- `25dea2f1e` design(notifier-pubsub): consistency sweep for revision 2
  (mermaid diagram + usage examples + InterfaceGuard updated for
  PassableReader/PassableWriter framing and cancellation contract;
  cross-design citations updated to reflect presence-severance not
  landed and durable-pubsub deferred)

**Revisions section by section:**

1. **Layering** (line 32): rewrote the problem statement's duality
   paragraph and added a new §**Layering: local pubsub and exo pubsub**
   subsection. `@endo/stream` and `@endo/exo-stream` named as different
   layers; `@endo/exo-pubsub` composes with `@endo/exo-stream` and
   explicitly not with `@endo/stream`. Named `@endo/pubsub` as the
   implied local sibling; sketched the lift/drop relationship.
   Cited the earlier `makePubSub` + `makeTopic` work in `@endo/stream`
   itself (commit `cbbd57c03` *feat(stream): Introduce pubsub topics*,
   removed during the `@endo/harden` refactor) as the design-consistency
   anchor for that future local-layer sibling. This was the
   earlier-work-on-@endo/stream the maintainer cited; I confirmed it
   via `git log -p` on packages/stream/index.js.

2. **Latest-topic replay semantic** (line 113): added a
   §**Replay-on-subscribe semantic** subsection distinguishing
   never-emitted (wait for first publish) vs. previously-emitted
   (resolve immediately to latest, then wait). Also names the
   terminated-before-subscribe case.

3. **`makeUpdateTopic` eliminated entirely** (line 183): section
   retitled §`makeUpdateTopic` (eliminated). No shim, no
   compatibility surface. Anti-design row added for "ship a
   deprecated-on-arrival shim" with the reason "a shim with the
   hazardous shape is the hazard." Snapshot-then-deltas migration is
   by explicit composition. Migration plan drops from three phases
   to two.

4. **Cross-layer composition does not work** (line 218): removed the
   `pump` / `makePipe` import-and-compose example. Renamed
   §**Producer-as-Writer<T>** → §**Producer as a passable
   PassableWriter<T>** and §**Subscriber-as-Reader<T>** →
   §**Subscriber as a passable PassableReader<T>**. Mermaid diagram
   updated to use `E(publisher).next(...)` and `PassableReader` labels.

5. **Durable pubsub deferred** (line 398): Open-questions item rewritten
   as "Resolved: not relevant at this layer. Durable pubsub is a
   separate concern that requires durable exos." `daemon-cas-management`
   cross-design cite updated accordingly.

6. **Back-pressure / wire protocol** (line 411): new top-level
   §**Back-pressure and wire protocol** section. Producer side carries
   one chain-head reference per subscriber (not a queue); CapTP ferries
   cells eagerly via promise-pipelining; consumer-side backlog
   accumulates in the consumer process's heap. The earlier draft's
   `subscriberQueueLimit` construction option is removed.

7. **Cancellation-promise argument** (line 422): new top-level
   §**Subscriber cancellation** section. `subscribe()` takes a required
   `cancelled: Promise<never>` argument; pattern guard enforces
   presence at the CapTP boundary. Includes a
   *Why a cancellation promise and not `E.whenSevered(presence)`*
   subsection acknowledging #450 hasn't landed. Cross-design row for
   presence-severance, Open-questions item, all usage examples, and the
   `LatestTopicHubI` InterfaceGuard all updated.

8. **Affirmation on synchronizing collections** (line 431):
   inline-acknowledgment only; framing preserved. Noted that the
   collection-shape direction fits into the §**Method-name evolvability**
   room.

9. **"Good." affirmation** (line 437): line preserved unchanged.

10. **Method-name evolvability** (line 443): new top-level
    §**Method-name evolvability** section. Current iteration:
    single-shape-per-topic factories. Future iteration: a single topic
    Exo could expose `subscribeLatest()` / `subscribeChanges()` as
    distinguished methods, mirroring the `streamBase64()` ↔ `stream()`
    byte-stream migration pattern. Design only commits to *leaving
    room*; does NOT introduce the multi-method shape in this iteration.

**Inline replies posted:** 10 of 10 (one per inline comment).
**Summary comment posted:** [issuecomment-4774783956](https://github.com/endojs/endo-but-for-bots/pull/507#issuecomment-4774783956).

**Files touched:**
- `designs/notifier-pubsub-migration.md` (the design)

The PR remains DRAFT per the dispatch's "Do NOT un-draft" instruction.
No code in `packages/` was generated; deliverable is prose-only design
revision.

**Open questions remaining:**

- *`@agoric/notifier` caller survey across agoric-sdk +
  endo-but-for-bots + endo* — Phase 2 work (designer-performed
  research); anchored to a *to be filed* tracking issue once Phase 1
  ships.
- *Final method names for distinguished latest / changes accessors on
  a future topic Exo* — left open as a future-iteration concern; the
  current iteration only leaves room for the shape, does not commit to
  spelling.

Self-improvement: nothing this time. The dispatch prompt was complete
and the maintainer's guidance was concrete on every point; the
designer role file's *Editorial-pass directives* and
*Verify the brief's line-to-section mapping against actual comment
line numbers* norms covered the workflow. The
`gh api .../pulls/N/comments --paginate` pattern for fetching the full
inline-comment bodies (filtering by `pull_request_review_id`) is
already covered by the `feedback_fetch_all_inline_comments_per_review`
auto-memory and was followed here.
