---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-17T06:45:13Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Simplify the clip shell settings view (menu, logout rule, account deletion)

Repo: https://github.com/kriscendobot/minion.town (private). Part of the maintainer-directed (kriskowal, 2026-10-17) closed-beta product pass; sibling jobs: build-minion-town-guest-coupons-closed-beta (coupon pool + GUEST_ADMISSION=coupon) and the other mt-beta-* children. Deliver DRAFT PRs; the gauntlet runs automatically. Real-execution evidence (browser or HTTP, not just unit tests) is required. Do not flip any production admission setting.

The settings view should be much simpler. The menu contains exactly:
1. **Connect CLI**
2. **Connect MCP**
3. **Invite a Friend (N available)** where N is the inviter's available invitations from the coupon pool. If the coupon pool/API from build-minion-town-guest-coupons-closed-beta is not landed yet, code against a narrow interface with a stub that returns the real value when present and hides the count otherwise; say so in the PR.

**Log out** is shown ONLY when the account has at least one bonded OAuth provider, because without one, logout is tantamount to account deletion (the guest URL is the only credential). Reuse the existing bond listing from the guest-recovery work.

There must still be an explicit way to reach **account deletion** from settings (a clearly separated, de-emphasized item, e.g. "Delete account"). It must be irreversible-aware: explain what is lost, require a typed confirmation, and perform the deletion server-side with an audit record. If an account deletion path does not exist yet, build the minimal correct one and flag the data it removes (guest, bonds, clips, pool units, waitlist email if any) for maintainer review in the PR body.

Remove every other settings clutter from the view; list what was removed in the PR body.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T07:23:14Z
