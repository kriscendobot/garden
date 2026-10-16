---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-10-16T08:29:07Z
---

---
role: builder
requires: host=endolin-garden1
pr: https://github.com/kriscendobot/minion.town/pull/193
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Live run of the minion.town OCapN guest canary (successor to PR #193)

PR https://github.com/kriscendobot/minion.town/pull/193 is a draft slice of
design #191 Section 6 (`designs/root-canary-reader-identity.md`): the
deterministic two-guest canary, tested only offline. This job owns the rest:

1. On the canary host, provision two guests' invitations into
   `~/.garden-state/ocapn-canary/guests.json` (needs the maintainer's one
   interactive step), then run `node deploy/probe/ocapn-canary.mjs` by hand and
   record what happens. This checks the assumed `endo accept` invitation shape,
   the `endo eval` endowment and output form, `E(guest).evaluate("@main", ...)`
   for the inert probe, and `endo net ensure ocapn`. Fix the canary where the
   live surface differs, and post the token-free audit record on #193 as
   acceptance evidence.
2. Add the Claude-operated guest leg (Section 6, "Several guests").

Parked go-ahead: it needs the maintainer to provision invitations on the canary host.
