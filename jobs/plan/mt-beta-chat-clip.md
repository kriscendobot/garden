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
# Build a Chat clip for minion.town

Repo: https://github.com/kriscendobot/minion.town (private). Part of the maintainer-directed (kriskowal, 2026-10-17) closed-beta product pass; sibling jobs: build-minion-town-guest-coupons-closed-beta (coupon pool + GUEST_ADMISSION=coupon) and the other mt-beta-* children. Deliver DRAFT PRs; the gauntlet runs automatically. Real-execution evidence (browser or HTTP, not just unit tests) is required. Do not flip any production admission setting.

Build a **chat clip** for the clip shell: a guest's message inbox/conversation view (read messages, reply, send to a petname'd peer, handle requests/invitations as the Endo daemon exposes them via the guest's mailbox). Draw heavily from the existing Chat application in endojs/endo-but-for-bots (branch llm, packages/chat) for interaction design and flows, but **do not reuse upstream code yet**; the two are expected to diverge, so build it natively in minion.town's clip stack. Same constraints as the New Clip clip (one clip id, fail closed, only-the-shell-may-frame). Coordinate with the ocap-mailboxes job (build-minion-town-ocap-mailboxes) so the two do not diverge on the message model: read its design/state first and say how you align. Browser-test with two real guests exchanging a message.

