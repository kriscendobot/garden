---
gate: orchestrated
orchestrated_by: mt-beta-product-pass-20261017
priority: normal
posted_by: producer
posted_at: 2026-10-17T06:01:31Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the "New Clip" clip, which can metamorphose into a petname inventory browser

Repo: https://github.com/kriscendobot/minion.town (private). Part of the maintainer-directed (kriskowal, 2026-10-17) closed-beta product pass; sibling jobs: build-minion-town-guest-coupons-closed-beta (coupon pool + GUEST_ADMISSION=coupon) and the other mt-beta-* children. Deliver DRAFT PRs; the gauntlet runs automatically. Real-execution evidence (browser or HTTP, not just unit tests) is required. Do not flip any production admission setting.

Build a **New Clip** clip: the default blank clip a user opens from the shell. It must be able to **metamorphose itself** into a **petname inventory browser** (the user's guest pet-name directory: browse names, drill into directories, see each value's kind). The browser has a **big plus button** for creating new entries through various means (at least: new directory, new text value, import by locator/invitation, and a clip/app from the existing clip types; leave a clear extension point for more). Draw heavily from the existing Chat/inventory UI in the Endo repo (endojs/endo-but-for-bots, branch llm: packages/chat and the daemon's petname/directory APIs) as a reference for flows and UX, but **do not import upstream code yet**; these are expected to diverge. Keep the metamorphosis honest: one clip id before and after (see designs/shell clip iframe embedding, PR #189), fail closed on errors, respect the gateway rule that only the Minion Town shell frames a clip (#194). Browser-test it with a real guest.

