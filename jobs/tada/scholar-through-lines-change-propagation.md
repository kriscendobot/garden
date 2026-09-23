All work landed and cleaned up. Final report:

---

**Job `scholar-through-lines-change-propagation` — complete.**

Wore the scholar role and curated the **change-propagation through-lines** into the library on `journal2` (commit `53d1c9be`, landed at `origin/journal2` `2a8383b4`). Every claim is grounded in source — I read the gtor README via `gh` (commit `d2a238fc`), the already-ingested FRB sections (esp. `view`/windowing and the incremental-update concept), and the #513/#507 pubsub result entries (builder, designer revisions 1 & 4, researcher refinement). I did **not** theorize propagators from memory; see the honesty flag below.

**Through-lines identified**
1. **One idea, three faces** — FRB observers (sync/in-process), @endo/pubsub topics (async/cross-vat), propagators (multi-directional constraint) all propagate the *delta, not a snapshot*; gtor names the axes they differ on (producer/consumer dual · singular/plural · spatial/temporal · push/pull · broadcast/unicast).
2. **changes vs latest** — lossless order-significant deltas (signal / `makeChangeTopic` / notifier-lossless) vs lossy convergent current-value (behavior / `makeLatestTopic` / notifier-lossy); gtor shows they're two faces of one signal; forward-lossless = changes + one-shot snapshot (composition), matching #507's `makeUpdateTopic` retirement.
3. **Ordered-collection windows as derived topics** — FRB `view(start,length)` over a `SortedSet` is the synchronous precedent for the "collection-change propagation" future direction #507 names for pubsub.
4. **Core tension** — idempotent convergence (latest/behavior/propagator-cell) vs order-significance (changes/stream).

**Grounding honesty** — Propagators are only *partially* grounded in the corpus. The one in-corpus instance of multi-directional constraint propagation is FRB two-way (`<->`) bindings; the fuller Sussman/Radul lattice-merge propagator model is named as adjacent external lineage, not asserted from a garden source. Every concept page flags this in *Common confusions*.

**Curated**: topic `change-propagation`; 4 concept pages (`change-propagation` keystone, `changes-versus-latest`, `endo-pubsub`, `sliding-window-topic`); gtor source index + 2 keystone sections (`reactivity-taxonomy`, `signals-and-behaviors`); index updates to `topics/README`, `concepts/README`, `sources/README`; **51 keyword shortcuts**. Synthesis delivered to the maintainer inbox (routes to the bulletin).

**Follow-ups**
- Posted `scholar-ingest-gtor` (full ingest of the remaining ~20 gtor sections; async-linked-list-queue substrate first — it underlies pubsub).
- Noted (not yet posted): ingest `@endo/pubsub` README + `notifier-pubsub-migration.md` as proper sources once #513/#507 stabilize; wire the in-flight Endo/Exo reactive-collections research into `sliding-window-topic` when it lands.

**Process note**: did the work in an isolated worktree off `origin/journal2` because the shared `/home/kris/journal` tree was mid-commit by another gardener; CAS-pushed with fetch+rebase (one retry — a peer push had advanced origin). One gotcha worth flagging for the fleet: `git push … | tail` masks the push exit code, so a rejected push reads as success — push without piping when you need the real exit status.
