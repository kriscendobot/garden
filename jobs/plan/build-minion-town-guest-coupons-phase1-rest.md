---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/199
priority: normal
role: builder
posted_by: producer
posted_at: 2026-10-18T10:41:15Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build the rest of guest-coupons phase 1 on kriscendobot/minion.town

Repo: kriscendobot/minion.town. Design: `designs/guest-coupons.md` (draft PR
https://github.com/kriscendobot/minion.town/pull/144, branch `design/guest-coupons`).
Predecessor slice: https://github.com/kriscendobot/minion.town/pull/199 (issuer,
ledger, books, air-drop, web redemption; default-off). This job is the
`Successor:` named in #199's phase-and-evidence ledger and owns every phase-1
item that slice deferred:

1. The MCP `invite` tool's `coupon` argument (design § 5).
2. `coupon.describe()` on the coupon formula (§ 3).
3. The daily counter reconciliation of the pool row (§ 4), skipping rather than
   overwriting when a counter write lands during the count (§ 10 test plan).
4. Severing (§ 1).

Also weigh the round-3 panel should-fix items on #199 that the slice left open
(see the panel review on #199, 2026-10-18): release or revoke a coupon attached
to an invitation once that invitation is accepted (locksmith 2); expire the
redemption nonce's replay window and clear it on "forget" in `guest.js`
(wire-watcher 1); align `guest.js` fragment parsing with `parseFragment`
(wire-watcher 2); a per-holder book index so `attachForHolder` does not scan
(saboteur 2 / engine-realist 2); a DynamoDB TTL on terminal rows (engine-realist 3).

When the evidence is in, update #199's ledger (or the successor PR's) to
`Disposition: deliverable`. Phase 2 (the daemon enclosure hook, § 7) is out of
scope unless the maintainer answers the design's open question 6.
