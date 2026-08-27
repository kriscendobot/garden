---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design an invitation-only guest-onboarding system for
kriscendobot/minion.town.

**Shape:**
- GitHub identity **kriskowal** is the initial host — the root of trust
  who can invite guests. Every guest kriskowal (or a transitively-invited
  guest) invites can, in turn, invite further guests. No invitation-count
  limit per guest for now (explicitly deferred, not a permanent decision —
  we are not metering/limiting yet).
- Compose with the **existing in-daemon invite/accept workflow** rather
  than building a parallel bespoke mechanism: `packages/cli/src/commands/
  invite.js`, the invite-retention tests
  (`packages/daemon/test/invite-retention{,-ocapn}.test.js`), and
  `designs/familiar-deep-link-invitations.md` on `endojs/endo-but-for-bots`
  @ `llm`. Read these first; the point of this design is to graft
  minion.town's onboarding onto that real mechanism, not reinvent it.
- Each newly-invited guest should be created holding a **handle for the
  guest who invited them** — an actual capability/pet-name reference they
  can use to communicate with their inviter, consistent with the ocaps
  model already in play (this MCP server's whole guest surface is
  capability-based, not ACL-based — see the guest-tools design and the
  maintainer's standing direction: "we are an ocaps shop, not an ACLs
  shop"). That handle is also how a guest can *introduce* their invitees
  to other guests — the invite graph should be genuinely navigable/social,
  not just a one-shot admission ticket.

**Explicitly reconcile with `designs/account-creation-open-signup.md`.**
That design's mandate is OPEN self-signup — any authenticated GitHub /
Google / SIWE identity auto-provisioned with a baseline role, no
approval step. This new invitation-only design is a policy reversal of
that mandate, not an addition to it. State plainly whether this
supersedes open-signup entirely, or whether they coexist for different
entry points (e.g., invitation governs guest-to-guest growth while some
other admission path remains open) — do not leave the two designs silently
contradicting each other.

No usage metering/limiting as part of this design — that's a deliberately
separate, deferred concern.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T23:04:25Z
