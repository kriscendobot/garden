# Scholar: continue pursuing the change-propagation open questions (maintainer-endorsed)

Wear the **scholar** role. The change-propagation synthesis
(`scholar-through-lines-change-propagation`, maintainer msg `20260624T231841Z-f0e8dc`)
surfaced open questions; **the maintainer agrees with them and encourages continuing
to pursue them**. Continue the curation, keeping the scholar's discipline: ground every
claim in source, flag what is NOT grounded, cite everything. Library home is the
existing `change-propagation` topic + concepts on `journal2`.

## The endorsed directions to pursue

1. **Ingest the missing pubsub sources as proper library sources.** The `endo-pubsub`
   concept currently cites only journal entries. Promote to source pages: the
   **`@endo/pubsub` README** and **`designs/notifier-pubsub-migration.md`** (locate
   them in `endojs/endo-but-for-bots`). Do this as #513/#507 stabilize — note if they
   are still in flux and ingest the stable parts, flagging the rest.
2. **Fold the Endo/Exo reactive-collections research into `sliding-window-topic`.**
   When `research-frb-endo-exo-collections` lands (the splay-tree / sorted-array-set
   interface and sliding-window-topic operators), wire its findings into the
   `sliding-window-topic` concept's citations — it is the future-direction #507 named
   for pubsub, and FRB's `view(start,length)` over a SortedSet is its synchronous
   precedent.
3. **Continue the gtor ingest.** gtor was a partial ingest (2 of ~20 keystone
   sections); `scholar-ingest-gtor` was posted for the rest (Promise Queues/Buffers —
   the async-linked-list substrate under pubsub — first). Ensure that proceeds and
   extend the change-propagation concepts as those sections land.
4. **Deepen the through-lines** as the sources arrive: the changes-vs-latest duality
   (lossless order-significant deltas vs lossy convergent current-value; forward-lossless
   as composition), ordered-collection windows as derived topics, and the core tension
   between idempotent convergence and order-significance. **Preserve the honesty flag**:
   propagators are only partially grounded in our corpus (FRB two-way bindings are the
   one in-corpus multi-directional-constraint instance); the fuller Sussman/Radul
   lattice-merge propagator model is adjacent EXTERNAL lineage — cite it as external,
   never assert it from a garden source.

## Reporting

Surface a synthesis update through the **bulletin** (a `message-user` summary) when
meaningful progress lands, with the full curation in the library. This is an ongoing
pursuit — a solid pass now, and post follow-on `scholar-*` jobs for anything that must
wait on #513/#507/#345 or the FRB research to stabilize.

## Definition of done

The pubsub README + notifier-pubsub-migration design ingested as sources (or the
stable parts, with the rest flagged), the change-propagation concepts deepened with
the honesty flags intact, follow-on scholar jobs posted for what must wait, and a
bulletin synthesis update. Report what was curated and what remains pending upstream
stabilization. Ground every claim in source; flag what you cannot ground.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 44
  claimed_at: 2026-06-25T14:50:54Z
