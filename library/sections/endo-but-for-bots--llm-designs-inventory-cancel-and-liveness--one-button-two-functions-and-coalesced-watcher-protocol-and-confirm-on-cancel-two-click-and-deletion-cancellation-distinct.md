---
title: §One-button-two-functions (cancel-IS-indicator) + §five-state-color-coding (Live=Green / Settled=Blue / Pending=Amber-pulsing / Not-incarnated=Gray / Cancelled=Hollow-border) + §coalesced-liveness-watcher-protocol with client-mutates-watched-set + §E.sendOnly-fire-and-forget-watch-unwatch + §watchAll-batch-for-initial-load + §confirm-on-cancel-two-click-3-second-timeout instead of modal + §deletion-and-cancellation-are-distinct (naming-vs-lifecycle) + §disabled-for-special-names (AGENT/SELF/HOST) + §pinned-capabilities-survive-pet-name-deletion + §additive-API-old-clients-unaffected + §design-consolidation-with-live-reference-indicator — endo-but-for-bots designs/inventory-cancel-and-liveness.md
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
---

# inventory-cancel-and-liveness — §one-button-two-functions + §coalesced-liveness-watcher-protocol + §confirm-on-cancel-two-click + §deletion-and-cancellation-distinct + §design-consolidation

## Source

- `endo-but-for-bots designs/inventory-cancel-and-liveness.md` — 322 lines
- Status: **Not Started** (created 2026-02-14; updated 2026-03-13)
- Author: Kris Kowal (prompted)
- Cycle 206 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 205's chat-lane @endo/evasive-transform; §fortieth consecutive designs/chat alternation cycle 166-206)

## Single most structurally interesting move

§One-button-two-functions (the cancel button IS the liveness indicator — single circular 12-14px element whose fill color shows incarnation state, click cancels) + §coalesced-liveness-watcher-protocol (single watcher with mutable watched-set replacing N+1 subscriptions) + §E.sendOnly-fire-and-forget-watch-unwatch (no round-trip latency on watch-set updates) + §confirm-on-cancel-via-two-click-3-second-timeout instead of modal dialog + §deletion-and-cancellation-are-distinct-operations (naming-operation vs lifecycle-operation).

§The-design-collapses-two-distinct-affordances-into-one (indicator + cancel button) while §preserving-a-third-distinct-affordance (remove button stays separate). §The-load-bearing-distinction: §deletion-removes-the-pet-name; §cancellation-terminates-the-incarnation; §pinned-capabilities-survive-name-deletion via PINS directory.

## §One-button-two-functions

| State | Fill | Meaning |
| --- | --- | --- |
| Live | Green | Incarnation exists and is running |
| Settled | Blue | Promise resolved to a durable value |
| Pending | Amber, pulsing | Promise not yet settled |
| Not incarnated | Gray | Formula exists but not currently provided |
| Cancelled | Hollow (border only) | Incarnation was cancelled |

§The-button-is-always-visible (it is the indicator). §A-tooltip-on-hover shows the state in text. §Click-cancels-the-incarnation via `E(powers).cancel(...petNamePath)`.

§Five-states-with-five-distinct-visual-treatments. §Amber-pulsing for §pending (the only animated state — signals "in progress, please wait"). §Hollow-border for §cancelled (the only non-filled state — signals "no longer active"). §The-default-state-before-watcher-delivers-first-status is gray (neutral).

§Borrowable-pattern: §one-button-two-functions as §a-UI-density-discipline when §the-affordance-and-the-status-display-are-conceptually-related. §Five-state-color-coding with §one-pulsing-state + §one-non-filled-state as §canonical-shape.

## §Confirm-on-cancel via two-click 3-second timeout

> Cancelling a live incarnation is consequential — it terminates a running worker, breaks dependent formulas, and cannot be undone (the formula must be re-provided). The button requires a confirmation gesture:
>
> - **Single click**: the button enters a "confirm" state — it grows slightly and changes to a warning color (red border). A tooltip reads "Click again to cancel."
> - **Second click within 3 seconds**: executes the cancel.
> - **Click elsewhere or timeout**: reverts to the indicator state.
>
> This prevents accidental cancellation while keeping the interaction lightweight (no modal dialog).

§Two-click-confirmation with §3-second-timeout is §a-lightweight-alternative-to-modal-dialogs. §The-confirmation-is-in-the-same-element (no popup, no separate UI). §Click-elsewhere-or-timeout-reverts — §the-user-can-back-out-by-doing-nothing.

§Borrowable-pattern: §two-click-confirmation-with-timeout-revert for §destructive-actions-that-deserve-confirmation-but-not-interruption. §Sibling-pattern to cycle 197 panic's §default-erroneous-exit (both designs balance §safety against §interruption-of-flow).

## §Deletion-and-cancellation-are-distinct (naming vs lifecycle)

> - **Deletion** (× button) removes the pet name from the pet store. This is a naming operation: it says "I no longer want this name."
> - **Cancellation** (indicator button) terminates the live incarnation. The pet name remains. The formula can be re-provided later. This is a lifecycle operation: it says "stop this thing."

§Two-affordances-for-two-operations with §named-semantic-difference. §The-pattern: §naming-operation removes label; §lifecycle-operation terminates the underlying thing.

§The-load-bearing-edge-case: §pinned-capabilities. §"For pinned capabilities, removal of a pet name never causes cancellation because the PINS directory retains the formula. If other names still reference the same formula, removal deletes only the name — the incarnation continues and remains visible under the other names."

§Pin-as-GC-anchor — §the-PINS-directory keeps formulas alive against §pet-name-deletion. §Sibling-pattern to cycle 175 harden-selector's §pin-on-first-install discipline (different domain but same §pin-as-anchor concept).

§Borrowable-pattern: §two-distinct-affordances-for-two-distinct-operations + §named-semantic-difference-in-design + §pin-as-anchor for the §special-case.

## §Disabled-for-special-names

> **Disabled for special names**: `AGENT`, `SELF`, `HOST`, and other uppercase system names cannot be cancelled. The button renders the indicator light but is not interactive (no hover effect, no click handler).

§Uppercase-system-names cannot be cancelled (they are §the-substrate-of-the-agent — cancelling AGENT would terminate the agent itself). §The-indicator-still-renders but §the-click-handler-is-absent.

§Borrowable-pattern: §disabled-but-still-shown for §uncancellable-substrate-capabilities — §the-user-can-see-state-without-being-tempted-to-break-the-substrate.

## §Coalesced liveness watcher protocol

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

## §Watcher lifecycle management

> 1. On mount, create the watcher: `const watcher = await E(powers).makeIncarnationWatcher()`.
> 2. Start consuming `E(watcher).followTransitions()` in a background loop.
> 3. When an inventory item is rendered, call `E.sendOnly(watcher).watch(id)`.
> 4. When an inventory item is removed from the DOM, call `E.sendOnly(watcher).unwatch(id)`.
> 5. On unmount, the watcher's CapTP reference is dropped and the daemon garbage-collects it.

§Five-step-client-side-lifecycle. §Steps-3-4 are §E.sendOnly (fire-and-forget); §step-1 awaits the watcher creation (one round-trip per session, not per item).

§For-nested-inventories: §"the same watcher instance is shared. The nested inventory adds its items' identifiers to the same watched set." §Watcher-shared-across-the-component-tree.

§Borrowable-pattern: §single-watcher-per-component-tree + §per-item-watch/unwatch-fire-and-forget + §automatic-GC-on-unmount via CapTP reference drop.

## §ASCII-visual-layout diagram

```
┌─ inventory row ───────────────────────────────┐
│ ▶  my-worker           ℹ  (●)  ×             │
│ ▶  api-key             ℹ  (●)  ×             │
│    pending-result      ℹ  (◉)  ×  ← pulsing  │
│ ▶  old-service         ℹ  (○)  ×  ← hollow   │
└───────────────────────────────────────────────┘
```

§ASCII-art-as-design-prose. §Four-rows-show-three-states (filled / pulsing / hollow). §Sibling-pattern to cycle 200 worker-rust-xs's §ASCII-architecture-diagram-with-three-process-boxes — both designs use ASCII for §visual-layout-without-rendering-tool-dependency.

§Borrowable-pattern: §ASCII-art-as-design-prose for §UI-mockup-in-Markdown-design-docs.

## §Five Design Decisions canonical format

1. **§One-button-two-functions** — cancel button IS the indicator; remove button stays separate.
2. **§Coalesced-watcher-over-per-item-subscriptions** — avoids N+1; scales to hundreds.
3. **§Fire-and-forget-watch/unwatch** via E.sendOnly() — no round-trip wait.
4. **§Confirm-on-cancel-instead-of-dialog** — two-click pattern; lightweight; prevents accidents.
5. **§Deletion-and-cancellation-are-distinct** — × removes name; indicator cancels incarnation; cancellation may occur as deletion side-effect via GC.

§Five-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200-hardened-url-shim/200-worker-rust-xs/202/203/204). §Each-decision-names-the-rationale.

## §Additive API; §old clients unaffected

> - New daemon API methods are additive.
> - The existing `cancel` CLI command already exercises the underlying mechanism.
> - Old clients that don't call the status APIs are unaffected.

§Additive-API-discipline — §no-breaking-changes; §existing-clients-continue-to-work. §Sibling-pattern to cycle 201 immutable-arraybuffer's §modern-shim-practice-frowns-on-conditional-installation (both designs §preserve-existing-behavior-while-extending).

§The-existing-`cancel`-CLI-command-already-exercises-the-underlying-mechanism — §the-design-leverages-existing-capability rather than §inventing-new-authority.

§Borrowable-pattern: §additive-API + §reuse-existing-mechanism for §UI-features that surface §capabilities-already-on-the-daemon.

## §Design consolidation in the Prompt section

> (Consolidated with live-reference-indicator, which proposed status dots with a cancel popover, daemon API options, and security/scaling/upgrade considerations.)

§Two-designs-merged into one. §`live-reference-indicator` was §a-prior-design that proposed §similar-status-dots-with-cancel-popover. §The-merge produced §inventory-cancel-and-liveness as §the-consolidated-design.

§Design-consolidation-as-design-evolution. §Sibling-pattern to cycle 204 weblet-next's §removed-feature-preservation-document-genre — both designs reflect §design-lifecycle-events (consolidation vs removal).

§Borrowable-pattern: §Prompt-section-named-consolidation as §design-evolution-record (when two designs merge into one, the merged design names the merger).

## §Upgrade considerations named

> - The daemon may need to persist incarnation events for crash recovery of status state.
> - Workers that were alive before the upgrade will need to report their status upon first query.

§Two-named-upgrade-concerns. §Crash-recovery-of-status-state and §pre-upgrade-worker-status-reporting are §honest-named-considerations.

§Borrowable-pattern: §Upgrade-Considerations-section with §named-concerns as §a-design-discipline.

## §Borrowable patterns (tier-1)

1. **§One-button-two-functions** for §UI-density when §the-affordance-and-the-status-display-are-conceptually-related.
2. **§Five-state-color-coding** (Live / Settled / Pending / Not-incarnated / Cancelled) with §one-pulsing-state + §one-non-filled-state as §canonical-shape.
3. **§Confirm-on-cancel-via-two-click-3-second-timeout** for §destructive-actions-deserving-confirmation-but-not-interruption.
4. **§Deletion-and-cancellation-are-distinct** — §naming-operation vs §lifecycle-operation with §two-distinct-affordances.
5. **§Pin-as-GC-anchor** — pinned capabilities survive pet name deletion via PINS directory.
6. **§Disabled-but-still-shown** for §uncancellable-substrate-capabilities (uppercase system names like AGENT/SELF/HOST).
7. **§Coalesced-watcher-protocol** with §client-mutates-watched-set + §server-filters-transitions + §single-async-iterator-carries-all-results as §canonical-solution-to-N+1-subscription-problem.
8. **§Three-method-API**: watch + unwatch + watchAll (batch optimization for initial load).
9. **§E.sendOnly-fire-and-forget** for §state-update-without-round-trip-latency.
10. **§watch(id)-immediately-publishes-current-status** as §initial-value-on-subscribe pattern.
11. **§Watcher-scoped-to-agent's-own-pet-store** as §capability-discipline.
12. **§Single-watcher-per-component-tree** + §per-item-watch/unwatch + §automatic-GC-on-unmount.
13. **§ASCII-art-as-design-prose** for §UI-mockup-in-Markdown-design-docs.
14. **§Five-Design-Decisions canonical format** with §each-decision-names-the-rationale.
15. **§Additive-API** + §reuse-existing-mechanism for §UI-features-that-surface-existing-capabilities.
16. **§Design-consolidation-recorded-in-Prompt-section** for §design-evolution-events where two designs merge into one.
17. **§Upgrade-Considerations-section** with §named-concerns as §a-design-discipline.
18. **§Four-lifecycle-hooks** for publishing watcher transitions (provide / cancel / settle / initial-on-watch).
19. **§InterfaceGuard-with-named-methods** as §canonical-shape for Endo exos.

## §Synthesis-target

Slot machine library §casino-operator-dashboard:

- §One-button-two-functions borrowable for §game-state-indicator-and-stop-button (single circular element showing game status, click stops the game).
- §Five-state-color-coding borrowable for §game-state-display (Idle / Running / Paused / Settling-Payout / Suspended).
- §Confirm-on-cancel-two-click borrowable for §stopping-a-running-game (consequential — players may be mid-bet).
- §Deletion-and-cancellation-distinct borrowable for §removing-game-from-dashboard vs §stopping-current-game-session.
- §Coalesced-watcher-protocol borrowable for §dashboard-with-N-games — single watcher streams all transitions, client mutates watched set as games are scrolled in/out of view.
- §E.sendOnly-fire-and-forget borrowable for §UI-state-updates-that-don't-need-acknowledgment.
- §ASCII-art-as-design-prose borrowable for §game-UI-mockups-in-design-docs.

## §Cycle 206 meta-observations

§The-fortieth-consecutive-designs/chat-alternation-cycle 166-206.

§Papers-lane-blocked 100+ consecutive cycles (since cycle ~106). §Centennial-milestone for papers-lane-block. §The-rotation-discipline gracefully pivots away from papers-lane every cycle.

§Library-reaches-711-sections at cycle 206.

§The-coalesced-watcher-protocol is §a-novel-pattern not previously named in the library at this fidelity. §Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §non-throwing-matcher (different shape; same §collapse-many-API-instances-into-one principle).

§Design-consolidation-in-Prompt-section is §a-new-shape of §design-evolution-record — joins the family (cycles 178/180/183/184/188/192/196/197/198/200/200/204 + this cycle 206). §The-family-has-many-shapes: revised-scope / NOTE-TO-REVIEWERS / inline-quote-blocks / historical-note / three-revision-pivots / Reference-status-at-landing / Comparison-section / Prompt-section-preserves-discard / removed-feature-preservation / and now §Prompt-section-named-consolidation.

§Thirteenth-honest-design-evolution-record family member with §a-new-shape.
