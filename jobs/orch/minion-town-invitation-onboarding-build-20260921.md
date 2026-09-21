---
order: serial
children: minion-town-endo-daemon-pin-refresh-20260921 minion-town-guest-web-invite-accept-fallback-fix-20260921
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-21T22:00:06Z
---

# Minion.town invitation-only guest onboarding — post-gate build

The Endo prerequisite (`EndoGuest.invite` + `EndoGuest.accept` on
`endojs/endo-but-for-bots@llm`) landed via PR #1310 (merged 2026-09-21T21:36:21Z),
clearing the long-standing gate for `build-minion-town-invitation-onboarding`.

`kriscendobot/minion.town` PR #81 already implements most of
`designs/invitation-only-guest-onboarding.md` (fragment-URL envelope, browser
shell, DB schema, deployment policy), but its same-daemon guest-pairing path
uses a forbidden app-mediated fallback (`storeIdentifier` called directly by
the app on both guests) instead of the guest-native `invite`/`accept`
primitives — because those primitives didn't exist yet when it was written.
Two sequential pieces of work close this out:

1. `minion-town-endo-daemon-pin-refresh-20260921` — minion.town's deployed/
   tested Endo commit is pinned ~2 months stale (predates #1310). Refresh the
   pin (3 synchronized copies) and verify against a real daemon.
2. `minion-town-guest-web-invite-accept-fallback-fix-20260921` — replace PR
   #81's `storeIdentifier` fallback with real `guest.invite`/`guest.accept`
   calls, and reconcile against the contract deltas the real Endo stack
   shipped with (invitation `cancel()`, no TTL, `@pins` namespace, field
   renames).

Serial: the fix needs a daemon that actually has `accept`, which only exists
after the pin refresh lands.
