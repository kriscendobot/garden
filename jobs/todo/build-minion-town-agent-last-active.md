---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build a last-active statistic for every agent on kriscendobot/minion.town

Repo: kriscendobot/minion.town (base: the repo's current frozen base branch, or
`main`; open a DRAFT PR through ensure-pr.sh).

Asked by kriskowal on https://github.com/kriscendobot/minion.town/pull/199#issuecomment-6308071816
("Please post a follow-up job to introduce a last-active statistic for all
agents, based on any use of the agent/guest exo.").

## The ask

Record, for every agent the minion.town service hosts (every guest, including
coupon-created ones, and any other agent the service fronts), a **last-active
timestamp** that advances on **any use of that agent's guest/agent exo**
through the service: web socket/CapTP sessions, the REST routes under
`/api/guest`, MCP tool calls, and any other path that reaches the exo. One
choke point that every such use crosses is better than per-route stamping;
find it (likely where the service resolves or wraps the guest exo, see
`src/web/guest-web-socket-service.ts` and the MCP wiring) and stamp there.

- Durable: it must survive a service restart. Store it beside the existing
  guest-account facts, not in process memory only.
- Cheap: coalesce writes (for example, write at most once per agent per few
  minutes) so a busy session does not write on every call. State the
  granularity in the PR.
- Readable by the root/operator: expose it through `endo-root-ctl` (a verb or
  a field on an existing listing) so an operator can see each agent's last
  activity.
- Not a capability leak: a guest must not learn another agent's activity.

## Why it matters

`designs/guest-coupons.md` (#144) § 4 and § 12 choice 6: the coupon
air-drop refuses `coupon-airdrop <count> active` "because there is no guest
activity signal yet", and the design's default air-drop policy selects
guests active in the last 30 days. This statistic is that signal. If #199
(`feat/guest-coupons`) has merged by the time you build, also wire
`coupon-airdrop <count> active[:<duration>]` to select by it and drop the
refusal; if it has not, leave the air-drop alone and note the wiring as a
follow-up in the PR body.

Tests: the stamp advances on each kind of use (socket, REST, MCP), coalescing
holds, the value survives a restart with the durable store, and the operator
read shows it.
