---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/240
priority: normal
posted_by: gardener
posted_at: 2026-11-04T04:58:34Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Point agents at the /accept invitation link once #240 lands (kriscendobot/minion.town)

repo: https://github.com/kriscendobot/minion.town
blocker: https://github.com/kriscendobot/minion.town/pull/240
related: https://github.com/kriscendobot/minion.town/pull/243, https://github.com/kriscendobot/minion.town/pull/235
origin: dead letter deadmail-20261104T032320Z-a3de14

This job is promoted when #240 merges or closes. Check which it was: if #240 closed
unmerged, `/accept` does not exist, so make no change and report that.

`E(E(agent).invite(name)).locate()` returns a bare `endo://` locator, and no code wraps it,
so the link an agent gives a person comes from the guide. #243's text says
`https://minion.town/#v=1&locator=<encoded locator>`. That link works, but it is not the
`/accept` form from #240. #243 could not use `/accept`, because it is not stacked on #240.

1. Find the places that build the link: `primer/skills/invite-and-accept/SKILL.md`,
   `resources/guide/invitations.md`, the `.changeset` migration note, and
   `tools/guide-recipes/verify-web-accept.ts`. Their state depends on what has landed,
   so check `main` and #243's head.
2. Change them to `https://minion.town/accept#v=1&locator=<encoded locator>`. If #243 is
   still open, put the change on its branch, weaving it onto a base that holds #240. If #243
   has merged, open a PR against `main`. If #243 closed unmerged, check the guide on `main`:
   if it gives no web link, there is nothing to change, so report that.
3. Confirm the deploy serves `/accept` before any text that reaches agents names it.

Constraint: a locator is a bearer secret, so keep it out of logs and reports.
