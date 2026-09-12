---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Harden minion.town @sites clip publish: deferred PR #69 panel findings

Repo: `kriscendobot/minion.town`. These are genuine findings from PR #69's
round-7 29-seat panel that were deliberately deferred out of the merge so it
could land; they are test/type hardening and defense-in-depth, not merge
blockers. Work against current `origin/main` (PR #69 is merged). Run the gauntlet
after.

Address, preserving the maintainer-required `confirmPublicBuiltIn` acknowledgement
gate (do NOT replace it with the retired host-shape/blocklist design):

1. **Type soundness (typist).** `GuestSiteAuthority<Directory extends
   SiteDirectory = SiteDirectory>` (`src/endo/gateway/publish.ts`) is instantiated
   as `GuestSiteAuthority<PendingSiteDirectory>` by `makeDaemonGuestSiteAuthority`,
   but `ClipPublisher.publish`/`upgrade`, `http.ts`, and `daemon-clip-wiring.ts`
   bind the default `SiteDirectory`; method-shorthand bivariance lets a plain
   `SiteDirectory` reach `discardDirectory`/`evaluateRegister` which read
   `workerName`/`directoryPetName`. Make `publish`/`upgrade` generic in `D extends
   SiteDirectory`, or keep them monomorphic and narrow inside the daemon impl.

2. **Register anchoring (locksmith/adversarial), defense-in-depth.** In
   `daemon-site-registry.ts` `evaluateRegister`, `expectedHash` is derived from
   the guest-supplied `result.directoryId`, so the hash check only proves the
   guest's two return fields agree. Assert `result.directoryId ===
   directory.formulaId`, and anchor via the operator-held cap (`E(sites).directory(id)`
   → `lookup('front') === directory.front`) before `store.register`. (Not a
   regression — `main` accepted any canonical hash, and formula ids are unguessable
   caps — but worth closing.) Verify against the live daemon (`ENDO_CHECKOUT`).

3. **Property/boundary tests.** `assertPowerName` boundary sweep (`""`, `"."`,
   `".."`, 255 vs 256 length, `"a/b"`, embedded NUL, non-string); `validateVhostRecord`
   fixpoint + `requireDirectory` monotonicity over `fc.anything()`; `base32`/`labelToId`
   round-trip via `fc.uint8Array({minLength:32,maxLength:32})`; `isFormulaId`
   property vs `/^[0-9a-f]{64}(:[0-9a-f]{64})?$/`.

4. **Live suite coverage (breaker).** The B1 `@sites` acceptance publishes only
   `@` specials; restore one ordinary pet-name publish (the ungated recommended
   path). Add tests for the two new compensating branches (`publish.ts`
   discard-then-rollback failure; `daemon-site-registry.ts` owner-conflict
   rollback).

5. **Falsy-back guard asymmetry (breaker).** `powers-plane.ts` and `gateway.ts`
   now reject `undefined|null` `back`; `0`/`""`/`false` still pass and become the
   CapTP bootstrap. Reject them too, or document why they are admissible.

6. **Review-thread closure (benchmarker).** Post the sweep result / decline note
   for `#discussion_r3939501084` (retire intermediate formula ids on Guest facets:
   `E(guest).identify` at `daemon-site-registry.ts` and `site-registry-exo.ts`
   `storeIdentifier` still mint intermediates). The per-serve scout measurement and
   TLS-at-scale measurement remain deployment-time follow-ups (need a deployed
   daemon), not fix-loop work.

Maintainer question (do not act without an answer): stylist flagged that the
public MCP parameter `confirmPublicBuiltIn` contradicts the repo's "special name"
convention and its own error text, and proposed `confirmPublicSpecialName`. It is
a maintainer-named, public tool parameter, so renaming it is a maintainer
decision — surface it, do not rename unilaterally.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=1120 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-12T04:04:28Z
