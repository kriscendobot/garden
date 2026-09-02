---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design guest-native invitation acceptance in Endo

Target: https://github.com/endojs/endo-but-for-bots/tree/llm/packages/daemon

Design the Endo daemon API that lets every `EndoGuest` both extend and accept
invitations directly. The required surface should support
`guest.invite(guestName)` and
`guest.accept(invitationLocator, hostName)` (names remain provisional while the
daemon tool renaming settles), consume an invitation once, accept into the
calling guest without minting a replacement guest, and bind reciprocal handles
under independently chosen pet names. Cover same-daemon and cross-daemon
semantics, authority attenuation, cancellation, concurrency, crash recovery,
and retained integration tests. The current `llm` surface exposes `invite` and
`accept` only on `EndoHost`; `EndoGuest` exposes neither.

This closes the dependency identified by kriskowal's review of
https://github.com/kriscendobot/minion.town/pull/56#discussion_r3909478669.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-02T00:08:53Z
