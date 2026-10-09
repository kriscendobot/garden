---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
arc: minion-town-mcp-ocapn
dispatch: automatic
---

# minion.town: build publish metering for Minion Town Credits without ERTP

Repo: kriscendobot/minion.town. The PR goes to a frozen `main-<sha7>` base.

**Maintainer decision (liaison muster, 2026-10-09):**
> build out metering without ERTP first. We need Mark Miller to design endo/ertp based on v2. That work is in design.

The only unchecked primary-phase box on the minion.town arc (kriscendobot/garden#58) is publishing that **charges** a credits account. Publishing is live, but the charge still goes through a `0n` stub (search `src/endo/gateway/publish.ts` and `src/endo/clip-payment.ts`).

**Goal:** a working metering path with no ERTP dependency.
- **Ledger:** a durable per-account credit balance with append-only charge records. Each publish debits the publisher's account by the metered amount. A publish that would overdraw the account is refused, with a clear error.
- **Design inputs:** `designs/clip-usage-metering.md` and `designs/ertp-credits.md`. Follow their metering semantics, units and amounts. Do **not** build the ERTP Phase 1 toy or any `@endo/gateway` ERTP layer in endo-but-for-bots.
- **Seam:** shape the charge behind a narrow seam (one place that debits an account), so that a later ERTP v2 purse/payment backend can replace the ledger without touching the publish path. Keep the seam capability-shaped. The publish capability holds an attenuated "charge this account" authority. It must not hold a global ledger or authorize by comparing identities (see `roles/builder/AGENT.md` on possession, not identity).
- **Grant path:** add an operator-only way to grant credits to an account, so the arc can be exercised. No user-facing purchase flow.
- **Tests:**
  - a charge on publish
  - a refusal on overdraft
  - no double charge on retry or idempotent re-publish
  - the operator grant
- **Design doc:** add a note to `designs/ertp-credits.md` that the ledger is the interim backend until ERTP v2 lands.

Open a DRAFT PR; the gauntlet follows. When it merges, tick the arc box on kriscendobot/garden#58 and say that ERTP itself stays deferred pending the v2 design.
