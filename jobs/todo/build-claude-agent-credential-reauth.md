---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: credential-expiry detection and operator-mediated reauth for Claude agents (kriscendobot/minion.town)

Maintainer directive: kriskowal approved design PR
https://github.com/kriscendobot/minion.town/pull/96 (review
https://github.com/kriscendobot/minion.town/pull/96#pullrequestreview-5324704742)
with "Please conduct and dispatch a builder, with gauntlet."

Implement `designs/claude-agent-credential-reauth.md` in kriscendobot/minion.town
(read it from `main` once #96 merges — a conductor job
`kriscendobot-minion.town-pr96-conduct` is merging it now — otherwise from the PR
head branch `design/claude-agent-credential-reauth`). Scope is the design's
build-now half: detection (incl. the `usage-exhausted` sentinel, transient /
rate-limit / model-unavailable held out of reauth), the `@operator` binding with
its fallback, the concierge-minted single-use expiring `ReauthTicket` mailed over
ocap-mailboxes, and the manual-reauth fall-through. Do NOT build the deferred
browser OAuth relay (tracked by parked job
`evaluate-reauth-escalation-default-after-oauth-relay`). Split into a stacked
series if the design is too large for one reviewable PR.

Base branch `main`. Open the PR(s) DRAFT via ensure-pr.sh and name them in the
report. The maintainer has explicitly requested a gauntlet: the blocked
follow-up `build-claude-agent-credential-reauth-run-gauntlet` will post it once
this build completes, so do not post a gauntlet yourself.
