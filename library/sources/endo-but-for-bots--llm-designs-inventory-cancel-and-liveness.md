---
title: "inventory-cancel-and-liveness — circular cancel-and-indicator button + coalesced watcher protocol"
source-slug: endo-but-for-bots--llm-designs-inventory-cancel-and-liveness
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-cancel-and-liveness.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-cancel-and-liveness.md
total-lines: 322
status: Not Started (2026-02-14 created; 2026-03-13 updated)
ingest-cycle: 206
ingest-date: 2026-06-06
lane: designs
---

# inventory-cancel-and-liveness.md

A 322-line **Not Started** design (2026-02-14 / updated 2026-03-13) adding §a-cancel-button-with-liveness-indicator to each inventory row + §a-coalesced-liveness-watcher-protocol to scale to hundreds of pet names without N+1 CapTP subscriptions. §Consolidated-with-live-reference-indicator (a prior design proposing similar status dots with a cancel popover).

## Key design moves

- **§One-button-two-functions** — single circular 12-14px element whose fill color shows incarnation state; click cancels. §Five-state-color-coding (Live=Green / Settled=Blue / Pending=Amber-pulsing / Not-incarnated=Gray / Cancelled=Hollow-border).
- **§Confirm-on-cancel via §two-click-3-second-timeout** instead of modal dialog. Lightweight; prevents accidents.
- **§Deletion-and-cancellation-are-distinct** — × button removes the pet name (naming operation); indicator button cancels the incarnation (lifecycle operation). §Pinned-capabilities-survive-pet-name-deletion via PINS directory.
- **§Disabled-for-special-names** (AGENT / SELF / HOST uppercase) — button renders but is not interactive.
- **§Coalesced-liveness-watcher-protocol** — single watcher with mutable watched-set replaces N+1 subscriptions; client controls what it watches; server filters transitions.
- **§Three-method-API**: `watch(id)` + `unwatch(id)` + `watchAll(ids)` (batch for initial load) + `followTransitions()`.
- **§E.sendOnly-fire-and-forget-watch-unwatch** — no round-trip latency on watch-set updates.
- **§Server-filters-transitions-by-watched-set** — single CapTP async iterator carries all transitions filtered server-side.
- **§watch(id)-immediately-publishes-current-status** as §initial-value-on-subscribe pattern.
- **§Watcher-scoped-to-agent's-own-formulas** as §capability-discipline.
- **§Four-lifecycle-hooks** for publishing transitions: provide-completes (live) + context.cancel (cancelled) + promise-settles (settled) + watch-called (current-status initial).
- **§Single-watcher-per-component-tree** with §per-item-watch/unwatch + §automatic-GC-on-unmount.
- **§InterfaceGuard-with-five-methods** (watch / unwatch / watchAll / followTransitions / help).
- **§ASCII-visual-layout-diagram** for the inventory row mockup.
- **§Five Design Decisions canonical format** — one-button-two-functions / coalesced-watcher / fire-and-forget-watch-unwatch / confirm-on-cancel-not-dialog / deletion-and-cancellation-distinct.
- **§Additive-API** — old clients unaffected; existing `cancel` CLI command exercises the underlying mechanism.
- **§Upgrade-Considerations-section** with named concerns (crash-recovery-of-status-state + pre-upgrade-worker-status-reporting).
- **§Design-consolidation-in-Prompt-section** — `live-reference-indicator` design folded in.

## The N+1 subscription problem

> The inventory renders N items. Each needs liveness status. A naive implementation opens N subscriptions. [...] For 200 pet names, this is 200 concurrent remote iterators.

§Coalesced-watcher-protocol is §the-canonical-solution: single async iterator + client-mutated watched-set + server-side filter.

## Ingest scope

Cycle 206 (designs-lane): full ingest of the 322-line design as one section.

## Related material in the library

- **`daemon-capability-bank.md`** (Dependency named in design): capability lifecycle observable via the watcher.
- **cycle 147 workers-panel**: sibling-feature also showing liveness at the worker layer.
- **cycle 145 formula-inspector**: sibling-feature — both surfaces inventory items with per-item detail.
- **cycle 38 / cycle 200 retention-path-notation (already-ingested)**: §non-throwing-API-and-error-shape sibling pattern.
- **cycle 198 patterns-diagnostic-feedback**: §non-throwing-matcher mirror; similar §collapse-many-API-instances-into-one principle (cycle 198 via mirroring API shape; cycle 206 via server-side filtering of a single stream).
- **cycle 203 cache-map**: §bounded-size-collection with set-membership-API sibling pattern.
- **cycle 175 endo--packages-harden-make-selector**: §pin-on-first-install discipline sibling — both designs use §pin-as-anchor for §preventing-unintended-GC.
- **cycle 197 panic**: §default-erroneous-exit asymmetry sibling — both designs balance §safety against §interruption-of-flow.
- **cycle 201 immutable-arraybuffer**: §modern-shim-practice-frowns-on-conditional-installation sibling — both designs §preserve-existing-behavior-while-extending.
- **cycle 200 worker-rust-xs**: §ASCII-architecture-diagram-with-three-process-boxes sibling — cycle 206 uses ASCII for §inventory-row-mockup.
- **cycle 204 weblet-next**: §design-lifecycle-events sibling — both designs reflect design evolution (cycle 204 is removal-archaeology; cycle 206 is consolidation).
- **`@endo/eventual-send`** (E.sendOnly): the key API for fire-and-forget watch/unwatch (cycle 146 E.js covered the implementation).
