---
created: 2026-05-13
updated: 2026-05-13
author: liaison
project: ocapn
---

# ocapn

The OCapN protocol and specification. The garden holds a fork at `kriscendobot/ocapn` for internal reference only. **This project carries unusually strict engagement rules**; read the *Rules of engagement* section below before any agent acts on anything ocapn-related.

## Rules of engagement (READ FIRST)

These rules are explicit maintainer constraints, set 2026-05-13. They apply to **every** agent, role, and dispatch that touches this project. Treat them as inviolable until the maintainer records a `message` entry relaxing them.

1. **No comments on `ocapn/ocapn`** under any circumstances. The kriscendobot identity, the kriskowal identity, and any boatman dispatch must not post a comment, review, review-comment, or reaction on any issue, PR, or commit in the ocapn organization's repository.
2. **No cross-references to `ocapn/ocapn`**. Do not include `ocapn/ocapn#<n>` or `https://github.com/ocapn/ocapn/...` references in any commit message, PR body, journal entry that will be referenced externally, or comment posted anywhere. (Internal-only journal entries that index ocapn material may reference our own fork at `kriscendobot/ocapn`; the constraint is on outward-facing artifacts.)
3. **Refer to the OCapN specification as obliquely as possible** in any artifact the garden produces. When a garden-authored document needs to mention the specification, prefer phrases like "the upstream protocol," "the spec," or "the OCapN-family protocol" rather than the canonical name and URL. The bot is not a contributor to OCapN; outward-facing artifacts should reflect that.
4. **No monitoring** of `ocapn/ocapn` or `kriscendobot/ocapn`. The standing-monitors discipline excludes this project. (See [Monitoring safety constraint](../../../CLAUDE.md) on the main branch for the broader rule about which repositories the garden is permitted to poll.)

The garden may still **read** the ocapn specification, hold a local fork at `kriscendobot/ocapn`, and write internal journal notes about ocapn-related work. The constraints are about what reaches the public.

## Upstream

- Upstream organization: `ocapn` (do not link directly in outward-facing text; use "the upstream organization" or similar).
- Local fork: `kriscendobot/ocapn` (bare clone at `worktrees/kriscendobot-ocapn.git/` on this host).
- Default branch: `main`.

## Identities

- Read access to upstream: anonymous (the spec is public).
- Write access to `kriscendobot/ocapn`: the bot identity (kriscendobot) owns the fork and may push branches to it.
- No identity may push to upstream `ocapn/ocapn`. Even with `identity_switch_authorized: true`, the boatman role must refuse a dispatch that targets upstream ocapn.

## Engagement so far

None. The fork was created on 2026-05-13 as scaffolding; no work has been done against the spec yet. When work begins, per-topic detail accumulates as `<topic>.md` files alongside this README per the context-library discipline.

## Why these constraints

Recorded for the next agent who reads this README and is tempted to "just leave a quick comment." The garden's bot identity is not a contributor to the OCapN protocol. Any outward sign of bot involvement risks contaminating an upstream conversation that has its own contributors and its own norms. The constraints are the cheapest way to keep that boundary clean.

If the maintainer ever relaxes a constraint, the relaxation is recorded as a `message` entry tagged `project: ocapn` and this README is updated to cite that entry. Until then, the rules above are the contract.
