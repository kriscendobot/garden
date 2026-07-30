---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T21:05:29Z
---
---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T21:10:00Z
---
project: endo-but-for-bots
prs: [871, 698, 700, 541, 539, 511]
job: endo-sturdyref-press-20260730-143501

## SturdyRef press tick — real-execution confinement verification + status assessment

A peer press job (endo-sturdyref-press-20260730-082002) is in `doin/`; I
avoided branch pushes and focused on closing the real-execution evidence gap
that prior dispatches could not — running the confinement regression suites
locally at PR #871's actual head.

### GitHub state (gh, ~21:00Z)

- **#871** (agent provide/accept surface): OPEN draft, 21/21 CI SUCCESS, head
  `c3fa894c9` unchanged since 07-26, zero reviews, zero comments — panel never
  ran. MERGEABLE.
- **#698** (bridge cut 1, bytes wire read): OPEN draft, 24/24 SUCCESS, head
  `c19fdd96cc`.
- **#700** (bridge cut 2, URI codec + closely-held reveal): OPEN draft, 24/24
  SUCCESS, head `e0122dfd7`.
- **#541** (daemon read-side threading, cuts 3–5): OPEN draft, 21/21 SUCCESS,
  head `fd60a74b0b`.
- **#539** (confinement design, on-demand enlivenment): OPEN draft,
  CHANGES_REQUESTED. All 5 review threads answered by kriscendobot in
  `aa104684c` (2026-06-26); maintainer said "These should be my last feedback"
  and has not re-reviewed since. Head `e1f543572`.
- **#511** (pass-style + FinalizationRegistry design): OPEN draft, deferred per
  maintainer decision (superseded by #510 merged line). Head `648a10e75`.

### Real-execution evidence (isolated project checkout at #871 head `c3fa894c9`)

Ran the confinement-critical test suites locally via
`node ../../node_modules/@endo/ses-ava/node_modules/ava/entrypoints/cli.js`
(direct ava cli.js; the pnpm-linked checkout lacks `.bin` symlinks):

- **`@endo/agent-tools` sturdyref-escrow** (3 passed): two grants are
  unlinkable in the transcript (`t.not(first.ref, second.ref)`), no locator in
  the handle (`t.false(first.ref.includes('locator'))`), forged handle rejected
  (`t.throws`), clear() invalidates.
- **`@endo/daemon` agent-sturdyref-surface** (3 passed): only lookup/maybeLookup/list
  admit a sturdyref; identify/locate/listIdentifiers/listLocators reject it
  before the facet runs; evaluation endowment slots admit it but worker-naming
  and result-name slots do not.
- **`@endo/ocapn` sturdyref** (10 passed, lockdown config): SturdyRef is opaque
  (neither location nor secret is a property), reveal is closely-held (absent
  from the SturdyRef surface, no toString URI leak), off-band locator reachable
  only through the closely-held mapping, reveal scoped to the minting instance
  (foreign-instance reveals undefined), enlivenSturdyRef returns a promise.
- **`@endo/ocapn` sturdyref-uri** (7 passed × 3 configs): format/parse round-trips
  swiss-num verbatim, base64url vectors match Goblins ids.scm, hints round-trip,
  hint keys sorted for byte-stable output, malformed URIs rejected.
- **`@endo/daemon` foreign-sturdyref** (7 passed): self-minted SturdyRef resolves
  through swiss-num store, forged look-alike yields undefined, foreign SturdyRef
  internalizes to fresh formula id, rejection/reveal details never name the
  swiss-num, dedup converges, two swiss-nums at same peer share one
  ocapn-peer but get distinct ocapn-sturdyrefs.
- **`@endo/pass-style` sturdyref** (10 passed × 2 configs): passStyleOf returns
  sturdyRef, SturdyRef is opaque/hardened, distinct identities, forgery with
  extra own properties or invalid prototype rejected, makeTagged imposter
  rejected.

### Confinement property preserved

This tick added no behavior, so no new confinement test was written. The
**no-location** (mediated enlivenment via closely-held OCapN network capability,
no locator in guest-visible handle, no toString URI leak), **no-identification**
(unlinkable per-grant tokens, identify/locate methods reject sturdyrefs), and
**opaque-and-unforgeable** (forged handles rejected, extra-property candidates
thrown) properties are all exercised by the above tests — **verified green via
real local execution this tick**, not merely CI inspection. This is the first
dispatch to run these suites locally.

### Blocker (unchanged)

The `endo-sturdyref-agent-surface-build-gauntlet` remains parked in `jobs/plan/`
behind the `go-ahead` gate (poisoned since 07-26, deadline-overrun). No
maintainer decision has arrived on the bus or GitHub since prior escalations.
The panel stage of #871 never started (zero reviews). #539's 5 review threads
are all substantively answered but unresolved — awaiting maintainer re-review.

No code was pushed this tick (avoiding collision with the active peer and the
parked gauntlet gate).

### Follow-ups

- Maintainer re-review of #539 (all 5 threads answered since 06-26) and
  promotion/reset of the #871 gauntlet remain the sole unblocks.
- If the gauntlet promotes out of `plan/`, a pool gardener should claim it to
  run the panel stage.
