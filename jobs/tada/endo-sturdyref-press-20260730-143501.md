## SturdyRef press tick endo-sturdyref-press-20260730-143501 — real-execution confinement verification; no code pushed

### What I did

A peer press job (endo-sturdyref-press-20260730-082002) is in `doin/`, so I
avoided branch pushes and focused on the real-execution evidence gap that every
prior dispatch reported as "not verified" — running the confinement regression
suites locally at PR #871's actual head `c3fa894c9` (kriscendobot fork, not the
endojs-side orphan `cf9c795a`).

**GitHub state assessed** (gh, ~21:00Z): full stack green and unmoved:
#871 (21/21), #698 (24/24), #700 (24/24), #541 (21/21). #539 has 5 unresolved
review threads all answered in `aa104684c` (06-26); maintainer said "These
should be my last feedback" and never re-reviewed. #511 deferred. The
`endo-sturdyref-agent-surface-build-gauntlet` remains parked in `jobs/plan/`
behind the `go-ahead` gate (poisoned since 07-26).

### Real-execution evidence (isolated checkout at #871 head, direct ava cli.js)

- `@endo/agent-tools` sturdyref-escrow: **3 passed** — unlinkable grants, no
  locator in handle, forged handle rejected, clear() invalidates.
- `@endo/daemon` agent-sturdyref-surface: **3 passed** — only
  lookup/maybeLookup/list admit a sturdyref; identify/locate/listIdentifiers/
  listLocators reject it; evaluation slots admit but naming slots do not.
- `@endo/ocapn` sturdyref: **10 passed** — opaque (no location/secret
  property), reveal closely-held (no surface, no toString URI leak), locator
  only via closely-held mapping, reveal scoped to minting instance.
- `@endo/ocapn` sturdyref-uri: **7 passed × 3 configs** — format/parse
  round-trip, base64url vectors, hint sorting, malformed rejection.
- `@endo/daemon` foreign-sturdyref: **7 passed** — self-minted resolves,
  forged look-alike yields undefined, foreign internalizes, rejection/reveal
  never names swiss-num, dedup converges, distinct swiss-nums share peer.
- `@endo/pass-style` sturdyref: **10 passed × 2 configs** — opaque, hardened,
  distinct identity, forgery rejected, makeTagged imposter rejected.

### Confinement property preserved

No behavior added this tick. The **no-location** (mediated enlivenment, no
locator in guest handle, no URI leak), **no-identification** (unlinkable
per-grant tokens, identify/locate reject sturdyrefs), and
**opaque-and-unforgeable** (forged handles rejected, extra-property candidates
thrown) properties are all exercised by the above tests — **verified green via
real local execution**, the first dispatch to do so.

### Follow-ups

- Maintainer re-review of #539 (all 5 threads answered since 06-26) and
  promotion/reset of the #871 gauntlet are the sole unblocks.
- If the gauntlet promotes out of `plan/`, a pool gardener should claim it to
  run the panel stage.
- Posted progress entry
  `entries/2026/07/30/210528Z-progress-gardener-c1e4f0.md`.

Self-improvement: nothing this time.
