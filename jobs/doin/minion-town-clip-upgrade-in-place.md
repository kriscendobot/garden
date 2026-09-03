---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Close a real, confirmed gap: a published
clip cannot be updated in place — every content change requires a fresh
`publish` under a new hash, and the old one has to be `unpublish`ed by hand.

## Confirmed, not hypothetical

Read directly from `src/endo/gateway/daemon-site-registry.ts` (the live
`makeDaemonGuestSiteAuthority`) and verified live against a real clip tonight:

- `front` is **not** a live capability. `guestRegisterSource` stores it via
  `E(self).storeValue(front, [name, 'front'])` — a plain snapshotted string
  (the interned content-root/manifest digest), not a copied-in reference the
  way `back` is (`E(self).copy([powerPetName], [name, 'back'])`). There is no
  live `front` object anywhere to mutate; confirmed live by checking
  `E(counterDir).has('front')` from the publishing guest's own side —
  `false`. The gateway serves bytes from the static CAS
  (`record.contentRoot`) set once at register time, fully decoupled from any
  capability.
- The daemon authority's `assertUpgradable()` and `writeDirectory()` both
  unconditionally `throw new Error("upgrade is not yet supported on the live
  daemon @sites path")`. The file's own doc comment names this as a known
  residual: "R2. upgrade on the live path (rewrite front/back in place)
  remains."

## What "closing the gap" means

Make it possible to update a clip's `front` content (and, if useful, `back`)
without changing its hash/URL and without the owner having to unpublish and
republish by hand. Concretely, at minimum:

1. Design and implement the live-path counterpart of `assertUpgradable()` /
   `writeDirectory()` — the register/upgrade flow already has the shape
   (`guestRegisterSource`, the vhost `ClipStore` record keyed by `id`); the
   gap is specifically the rewrite-in-place case for an *existing* `id`,
   re-interning a new manifest/content-root and updating the vhost record's
   `contentRoot` while keeping `id` (and therefore the served URL) stable.
2. Decide and document the authorization story for who may upgrade a clip
   they don't hold `back` for anymore, versus normal owner-gated `unpublish`
   — don't just silently reuse `back`'s authority if that's not the right
   fit; say explicitly what capability grants the right to rewrite `front`.
3. Wire it through the `publish`/`upgrade` MCP tool surface so a caller can
   actually invoke it (the `upgrade` tool already exists and documents
   itself as "not yet available when publishing is served live" — this is
   that gap, closed).
4. Test coverage matching the file's own existing verification-status
   discipline (the doc comment there already tracks what's exercised by
   `npm test` vs. the skip-gated `ENDO_CHECKOUT` integration suite — extend
   both, don't leave the new path CI-invisible).

If in-place upgrade turns out to be architecturally unwise for some reason
this brief doesn't anticipate (e.g. it would break the immutability guarantee
`cache-control: public, max-age=31536000, immutable` currently promises to
every client and CDN in front of `*.ocap.site`), say so explicitly and
propose the real alternative (e.g. a stable alias/pointer name that itself
gets rewritten to point at successive immutable hashes) rather than silently
declining the ask.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->
<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-09-05T03:00:00Z -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T03:29:24Z
