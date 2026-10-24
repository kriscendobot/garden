---
gate: blocked
blocked_on: build-recursive-dynamodb-capabilities
priority: normal
posted_by: gardener
posted_at: 2026-10-24T03:41:47Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: builder
---
In kriscendobot/minion.town, migrate the guest coupon ledger and the confined coupon issuer onto the generic `@endo/exo-dynamodb` attenuator, in a separate PR, per `designs/recursive-dynamodb-capabilities.md` (design PR https://github.com/kriscendobot/minion.town/pull/221, § migration path for `designs/guest-coupons.md`). The issuer must receive only a derived facet, never wider authority than today's coupon-specific ledger facet.

Precondition: the `@endo/exo-dynamodb` build PR from job `build-recursive-dynamodb-capabilities` must exist. This plan is parked `blocked_on` that job; if you are claimed and that build PR is still absent, re-park rather than building against a nonexistent package.

Successor of `fu-design-recursive-dynamodb-capabilities-2`, which was claimed on 2026-10-24 before its precondition held (design #221 still draft; build job not yet posted) and re-parked here.
