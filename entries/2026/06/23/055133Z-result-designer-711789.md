---
ts: 2026-06-23T05:51:33Z
kind: result
role: designer
worktree: dispatches/designer--711789/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - PR https://github.com/endojs/endo-but-for-bots/pull/511
  - PR #500 issue comment 4775973308
---

# designer 711789: sturdy-refs via FinalizationRegistry (design 1 of 2)

Drafted `designs/sturdy-refs-finalization-registry.md` on branch
`design/sturdy-refs-via-finalization-registry` from `origin/llm`
(SHA `65b0abe`), opened DRAFT PR #511 against frozen base `llm-65b0abe`.

This is **design 1 of 2** in a pair of competing plans. The base
problem (pass-style `'sturdyref'` category, parsed locator, HandledPromise
registration, OCapN serialization, daemon ingestion) is shared with
the parallel design (designer 2, branch
`design/sturdy-refs-via-endor-syscall`). The axis assigned to this
design was **petname-daemon-leaning**: source implicit retention from a
daemon-side `FinalizationRegistry` over per-worker SturdyRef holders;
the user exercises agency by disincarnating the worker that holds the
SturdyRef.

## What landed

- `designs/sturdy-refs-finalization-registry.md` (~5 screens, mermaid
  retention diagram, full *Compared to the alternative* table).
- Row in `designs/README.md` summary table and *Recently added*
  paragraph.

## Key library-lookup findings that shaped the design

- `@endo/ocapn` already has the wire-level SturdyRef machinery:
  `packages/ocapn/src/client/sturdyrefs.js` minting, `OcapnSturdyRefCodec`
  in `packages/ocapn/src/codecs/descriptors.js` serializing, the
  `'sturdyref'` discriminator in `ocapnPassStyleOf` routing. The design
  promotes the off-band `sturdyRefDetails` WeakMap into `@endo/pass-style`
  and adds a first-class `'sturdyref'` pass-style category;
  `ocapnPassStyleOf` becomes a thin shim.
- `HandledPromise` exposes `resolveWithPresence` for promise->presence
  resolution (`packages/eventual-send/src/handled-promise.js:296`) but
  no shape for SturdyRef-style dispatch where the target is not a
  presence and routing happens through an off-band locator. The design
  adds `HandledPromise.registerSturdyRefHandler(handler)` as a sibling
  singleton path; `@endo/ocapn`'s client registers once at construction.
- Daemon already has retention-graph machinery: `retentionEdges`,
  `addRetention`/`removeRetention` in `packages/daemon/src/graph.js`,
  the retention-accumulator, and the not-yet-shipped inspector designed
  in `daemon-retention-paths.md`. The new `'sturdyRefHeld'` edge label
  slots in without schema changes.
- `FinalizationRegistry` is already used at the captp boundary
  (`packages/captp/src/finalize.js:5`, `makeFinalizingMap`). The
  lockdown / GC-side-channel discipline is documented there; the design
  inherits the same posture, only used at the daemon/worker boundary
  and never inside guest code.
- Searched `endojs/endo` issues for sturdy / SturdyRef / OCapN / locator /
  pass-style: closest prior art is #1587 (pass-style for OCapN
  conformance) and #2167 (locator format); both cited.
- Existing locator parsed shape: `packages/daemon/src/locator.js`
  `parseLocator` returns `{ formulaType, node, number }`; OCapN's
  `OcapnPeerCodec` returns `{ type, transport, designator, hints }`.
  The design's `ParsedLocator` is the common shape both reduce to:
  `{ transport, designator, hints, secret, formulaType? }`. Pure data,
  pass-by-copy.

## Open questions surfaced

1. `WeakMap` vs `Map` for the off-band locator map in `@endo/pass-style`.
2. Daemon accepts **remote** SturdyRefs as pet-name-path substitutes?
   Design defaults to local-only.
3. `listSturdyRefHolders` on `EndoHost` only, or also (read-only) on
   subagents?
4. `M.sturdyRef()` interface guard primitive in `@endo/patterns`.
5. CLI `endo sturdy-ref-holders <locator>` verb paralleling
   `endo paths`.
6. Interaction with caretaker / `getRedirector` revocation pattern.

## Explicit comparison points (vs ocap-kernel endor-syscall design)

The design's *Compared to the alternative* section has a 13-row table.
Crux rows:

- **Where retention is observed**: daemon-side via FinalizationRegistry
  (this) vs guest-side via explicit `retain`/`release` syscall (other).
- **Failure mode if the guest is buggy**: none here (worst case: worker
  pinned, recover by disincarnate); other design leaks until worker dies
  if guest forgets `release`.
- **Surface added to endor protocol**: none here; two new syscalls
  there.
- **Compatibility with confined guests**: this design's confined guest
  needs no special capability; other design's guest must hold the
  endor `retain`/`release` calls.
- **Cost on SES lockdown**: uses already-vetted FinalizationRegistry;
  other has no new lockdown surface.
- **Revocation latency**: indeterminate (GC) here vs bounded (explicit
  release) there.
- **Side-channel risk**: GC timing observable at daemon/worker
  boundary here; none there.

The maintainer's anti-pattern ("we should strive to avoid taking the
advantages of either approach with the disadvantages of the other") is
addressed in *Composition with the daemon's existing model*: this
design preserves revocation-by-deletion (every SturdyRef still resolves
through `formulaForId`; deleting the formula is unchanged) and *mostly*
preserves implicit retention (the guest does not call any retain/release
API; FinalizationRegistry observes). The deferred cost is revocation
latency, which the user can force to zero by disincarnating.

## Self-improvement

Tracked the off-band `WeakMap` pattern (the established Endo idiom for
"opaque tagged value plus closely-held lookup") as the design's load-
bearing mechanism. Worth a future `journal/library/concepts/` page
("off-band identity map") once a second instance lands — `caretaker`
revocation tables and the SturdyRef-details map already share the
shape; a third instance would tip into a concept page. Below the
self-improvement threshold today; recorded here so a future similar
observation has the context.

Self-improvement: nothing this time.
