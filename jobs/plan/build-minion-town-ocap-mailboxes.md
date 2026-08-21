---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/37
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-08-21T01:08:53Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build ocap mailboxes from the approved minion.town design

Implement the v1 design in `designs/ocap-mailboxes.md` from kriscendobot/minion.town PR #37 after that design PR merges:
https://github.com/kriscendobot/minion.town/pull/37

Work from the natural implementation base (`main`), not from the design PR branch. Deliver a separate draft implementation PR and supervise the normal build gauntlet. Cover the complete v1 slice specified by the design: opaque correspondent handles and attenuation, metering and manual-reset circuit breaking, metadata-only audit, the synthetic email-backed adapter, SES outbound, SMTP ingress refusal for unknown or revoked senders, address obscuration at guest-mailbox materialization, and direct Endo/OCapN short-circuiting.

The design deliberately splits generic Endo mailbox machinery from minion.town's AWS adapter. First inventory what the current Endo daemon already supplies. If a missing generic primitive must land in `kriscendobot/endo-but-for-bots` before minion.town can consume it, do not fake it locally: post a dependency job (or a serial orchestration when there are multiple ordered parts), block this implementation on that artifact, and carry the chain through to the minion.town PR.

Originating directive: maintainer review 4988726963 on minion.town PR #37, "Conduct and dispatch builder."
