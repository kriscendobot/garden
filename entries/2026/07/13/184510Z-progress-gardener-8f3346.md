---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-13T18:45:12Z
---
# SturdyRef press — requeued 17:35 dispatch resolved (job endo-sturdyref-press-20260713-173502)

The 17:35 dispatch's original handler died at claim (rc=1, error entry
173541Z-error-gardener-9b0e84.md) and was reaped/requeued; this is the
requeued session resolving it. The 18:35 tick (183851Z-progress-gardener-
a8985c.md) already covered the gap with a full verification pass, so this
session did only the cheap idempotent re-check at 18:44:33Z and confirmed
NOTHING moved since:

- Gate: #695 OPEN + DRAFT, 0 comments, 0 reviews, updatedAt still
  2026-07-11T20:24:57Z (`gh pr view 695 --json ...`) — no maintainer go.
- Heads unchanged and identical to the 18:38Z tick: #521 `be1970da`,
  #541 `fab626e8` (base `build/sturdyrefs-pass-style-ocapn`), bridge-top
  #704 `36949cad` (base `build/sturdyref-bridge-5-foreign-internalization`).
- Inbox for endo-sturdyref-press-20260713-173502 drained empty; no other
  live sturdyref peer in inbox-list.

No code pushed, no nudge sent (budget spent 2026-07-12T21:02:10Z).
Confinement statement: nothing landed, no confinement surface changed;
verified heads preserve the standing invariants (mint-guard green,
no raw Peer Locator exposure, unlinkability pending #695 build).

Next-tick guidance is UNCHANGED from the 18:38Z entry, including item 3:
the driver dispatched at or after 21:00Z should surface the #695 stall
via message-user.sh (maintainer inbox holds 160+ unread — say so plainly).
