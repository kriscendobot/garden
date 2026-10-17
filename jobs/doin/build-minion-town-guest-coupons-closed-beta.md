---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: closed beta for minion.town via guest coupons (maintainer-authorized, 2026-10-17)

Maintainer decision (kriskowal, liaison session 2026-10-17): switch minion.town to a **closed beta now**, before frictionless guest account creation invites denial of service.
- The root account decides whether to grow the invitation pool, distributes invitations to guests (air-drop), and redistributes them when they expire.
- Federated invitations between sites keep working with no gate.
- Invitations for new users on minion.town spend one token (coupon) from the inviter's pool.

This is already designed, not built: draft PR https://github.com/kriscendobot/minion.town/pull/144 (`designs/guest-coupons.md`, plus `designs/invitation-only-guest-onboarding.md`). Base the build on that design; fetch it from the #144 head, since it is not on main. Its § 11 open questions each carry a recommendation: adopt the recommendations unless they contradict the decision above, and list each choice in the PR body for the maintainer to veto. Minimum slice that makes the closed beta real: the coupon-issuer caplet and ledger (conditional-write claim), pool capacity/outstanding/redeemed accounting with expiry and revocation returning units, `root-ctl coupons` (grow pool, airdrop round-robin when short), the `coupon=` fragment-envelope field, and `GUEST_ADMISSION=coupon` replacing open `createGuest` in the unauthenticated bootstrap. Federated, Familiar, and pet-daemon accepters must ignore the coupon. Split into a serial stack of small PRs if it is large. If the stale July job `open-signup-gate-flip-minion-town` (which would open signup to all) is still on the board, do not run it; it contradicts this decision.

Deliver DRAFT PRs; the gauntlet runs automatically. Do NOT flip `GUEST_ADMISSION=coupon` in production yourself: ship it default-off, with a deploy note and a real-execution test of both modes (coupon spent, pool exhausted refuses, expired coupon returns to pool, federated invitation passes ungated). Report the exact flip step for the maintainer.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T06:52:20Z
