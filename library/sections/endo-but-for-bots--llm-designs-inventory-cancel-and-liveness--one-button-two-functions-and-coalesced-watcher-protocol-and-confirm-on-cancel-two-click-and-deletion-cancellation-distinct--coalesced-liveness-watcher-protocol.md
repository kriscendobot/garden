---
title: §Coalesced liveness watcher protocol
source: endo-but-for-bots designs/inventory-cancel-and-liveness.md
source-slug: endo-but-for-bots--llm-designs-inventory-cancel-and-liveness
ingest-cycle: 206
ingest-date: 2026-06-06
lane: designs
status: Not Started (2026-02-14 created; 2026-03-13 updated)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-capability-bank (Dependency named in design)
  - endo-but-for-bots--llm-designs-workers-panel (cycle 147; sibling-feature also showing liveness)
  - endo-but-for-bots--llm-designs-formula-inspector (cycle 145; sibling — both surfaces inventory items)
  - endo-but-for-bots--llm-designs-retention-path-notation (cycle 38 + cycle 200 attempt; §non-throwing-API-and-error-shape sibling pattern)
  - endo-but-for-bots--llm-designs-patterns-diagnostic-feedback (cycle 198; §non-throwing-matcher mirror; similar §single-stream-with-server-filtering shape)
  - endo--packages-cache-map (cycle 203; §bounded-size-collection with set-membership-API sibling pattern)
  - endo--packages-eventual-send (E.sendOnly is the key API in cycle 146 E.js)
keywords:
  - one-button-two-functions (cancel IS indicator)
  - five-state-color-coding (Live / Settled / Pending / Not-incarnated / Cancelled)
  - coalesced-liveness-watcher-protocol
  - client-mutates-watched-set
  - E.sendOnly-fire-and-forget-watch-unwatch
  - watch + unwatch + watchAll three-method API
  - server-filters-transitions-by-watched-set
  - single-CapTP-async-iterator-carries-all-transitions
  - confirm-on-cancel via two-click-3-second-timeout
  - deletion-vs-cancellation-distinct (naming vs lifecycle)
  - disabled-for-special-names (AGENT / SELF / HOST uppercase)
  - pinned-capabilities-survive-pet-name-deletion (PINS directory retention)
  - watcher-scoped-to-agent's-own-pet-store (capability discipline)
  - additive-API-old-clients-unaffected
  - design-consolidation (live-reference-indicator + inventory-cancel-and-liveness merged)
  - five-Design-Decisions canonical format
  - ASCII-visual-layout-diagram for UI
  - amber-pulsing for pending state
  - hollow-border-for-cancelled
  - thirteen Dependencies + Affected-Packages-table
  - N+1 subscription problem
  - cycle 206 designs-lane
  - fortieth consecutive designs/chat alternation cycle 166-206
parent: endo-but-for-bots--llm-designs-inventory-cancel-and-liveness--one-button-two-functions-and-coalesced-watcher-protocol-and-confirm-on-cancel-two-click-and-deletion-cancellation-distinct
---

### §The N+1 subscription problem

> The inventory renders N items. Each needs liveness status. A naive implementation opens N subscriptions [...] For 200 pet names, this is 200 concurrent remote iterators.

§N+1-subscription-problem-named-explicitly. §Each-async-iterator is §a-long-lived-remote-reference. §200-pet-names = 200-iterators is §unsustainable.

### §The solution: §watched-set-protocol

```js
const watcher = await E(powers).makeIncarnationWatcher();
await E(watcher).watch(id1);
await E(watcher).watch(id2);
await E(watcher).unwatch(id1);
for await (const transition of E(watcher).followTransitions()) {
  updateIndicator(transition.id, transition.status);
}
```

§Single-CapTP-async-iterator carries §all-transitions. §The-watch/unwatch-methods are §fire-and-forget-`E.sendOnly()`-calls. §No-round-trip-latency on watch-set updates.

§The-server-filters-transitions-by-watched-set. §The-client-mutates-the-watched-set; §the-server-streams-only-relevant-transitions.

§Three-method-API on the watcher exo:
- §`watch(id)` — add to watched set.
- §`unwatch(id)` — remove from watched set.
- §`watchAll(ids)` — batch add for initial load (avoid N individual messages on initial render).
- §`followTransitions()` — async iterator delivering filtered transitions.

§Plus-help() per Endo convention.

§Borrowable-pattern: §coalesced-watcher-protocol with §client-mutates-watched-set + §server-filters-transitions + §single-async-iterator-carries-all-results. §A-canonical-solution to §the-N+1-subscription-problem for §inventory-like-surfaces.

§Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §non-throwing-matcher (cycle 198 mirrors a boolean API with a string-or-undefined; cycle 206 mirrors a per-item iterator with a single-iterator-with-filter). §Different-shape, §same-principle: §collapse-many-API-instances-into-one.

### §Daemon-side implementation

```js
const IncarnationWatcherI = M.interface('IncarnationWatcher', {
  watch: M.call(M.string()).returns(M.undefined()),
  unwatch: M.call(M.string()).returns(M.undefined()),
  watchAll: M.call(M.arrayOf(M.string())).returns(M.undefined()),
  followTransitions: M.call().returns(M.remotable('AsyncIterator')),
  help: M.call().returns(M.string()),
});
```

§InterfaceGuard-with-five-methods. §Sibling-pattern to cycles 134/136/142/148/150 §pass-style-cluster's §interface-guard-validation discipline.

§The-watcher-exo-maintains: §`watchedIds: Set<string>` + §`transitionTopic: topic/publisher`.

§Four-lifecycle-hooks publish transitions:
1. §`provide(id)`-completes → publish `{id, status: 'live'}`.
2. §`context.cancel(reason)`-called → publish `{id, status: 'cancelled'}`.
3. §Promise-settles → publish `{id, status: 'settled'}`.
4. §`watch(id)`-called → immediately publish current status (initial value).

§The-watcher-is-scoped-to-the-agent's-own-formulas. §It-cannot-observe-formulas-outside-the-agent's-pet-store. §Capability-discipline.
