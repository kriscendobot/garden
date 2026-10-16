---
gate: go-ahead
priority: normal
posted_by: claude-on-minion-town-press
posted_at: 2026-10-16T17:09:57Z
---

---
role: builder
requires: host=endolin-garden-ece02cb4
pr: https://github.com/kriscendobot/minion.town/pull/193
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Live run of the minion.town OCapN guest canary (successor to PR #193)

PR https://github.com/kriscendobot/minion.town/pull/193 is a draft slice of
design #191 Section 6 (`designs/root-canary-reader-identity.md`): the
deterministic two-guest canary, tested only offline (gauntlet terminal at
`2b88eaac`, review budget reached, CI green). This job owns the rest:

1. On the canary host (`endolin-garden-ece02cb4`, confirmed by the maintainer
   2026-10-16 as the host the design calls `endolin-garden1`), confirm the
   maintainer has provisioned the two guests into
   `~/.garden-state/ocapn-canary/guests.json`. The maintainer described this as
   "guest invitations"; as of #193 panel-2 (`32bab449`) the canary adopts guests
   from durable `endo://` locators. If the provisioned shape does not match what
   the canary at the PR head reads, reconcile the canary or message the
   maintainer; do not guess. Then run `node deploy/probe/ocapn-canary.mjs` by hand
   and record what happens. This checks the live adopt shape, the `endo eval`
   endowment and output form, `E(guest).evaluate("@main", ...)` for the inert
   probe, and `endo net ensure ocapn`. Fix the canary where the live surface
   differs, and post the token-free audit record on #193 as acceptance evidence.
2. Add the Claude-operated guest leg (Section 6, "Several guests").

Parked go-ahead: the maintainer provisions the guests on the canary host
themselves and will say go ahead when done (liaison session 2026-10-16,
journal message 20261016T143222Z-7b8d25). Do not start before then.
