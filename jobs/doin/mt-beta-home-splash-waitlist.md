---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-17T06:04:08Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Consolidate the minion.town home page into one root route, with a closed-beta splash and waitlist

Repo: https://github.com/kriscendobot/minion.town (private). Part of the maintainer-directed (kriskowal, 2026-10-17) closed-beta product pass; sibling jobs: build-minion-town-guest-coupons-closed-beta (coupon pool + GUEST_ADMISSION=coupon) and the other mt-beta-* children. Deliver DRAFT PRs; the gauntlet runs automatically. Real-execution evidence (browser or HTTP, not just unit tests) is required. Do not flip any production admission setting.

**Problem:** https://minion.town/ and the page behind the "home" link (find it: the home page vs the root route) are two different pages. Consolidate them into ONE.

**Behavior at https://minion.town/:**
- Visitor has a guest formula identifier (the existing guest URL/fragment/storage recovery path; reuse the guest-shell recovery code, never the address bar) -> render the clip shell.
- Otherwise -> a splash page for minion.town saying we are in a **closed beta**, with a waitlist form collecting an email address.

**Waitlist:** store email + timestamp (+ minimal abuse metadata such as a coarse rate-limit key; no tracking) in the existing persistence (DynamoDB or whatever the account store uses; secrets only in Secrets Manager). Validate and normalize, dedupe idempotently, rate-limit per IP, add a honeypot, no email verification or sending yet. Respond identically for new and already-listed addresses (no enumeration). Provide a root-only export (e.g. root-ctl waitlist list) so the maintainer can later draw invitations from the pool for these people. Document retention and a deletion path. The splash must expose no guest-creation affordance (admission is closed).

Remove or redirect the duplicate page so there is exactly one canonical landing. Keep existing guest URLs, OAuth callbacks, and the /mcp surface working.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T06:16:15Z
