---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a level of indirection so formula identifiers can be rotated

Repo: https://github.com/endojs/endo-but-for-bots, base branch `llm`, for the daemon or the
minion.town variant of it (decide which; see below). No arc budget was named, so this is
unallocated unless the supervisor re-tags it.

## Maintainer's idea (2026-10-08)

There is no way to rotate a formula identifier today, because the identifier is the
capability: a locator, a sturdyref record, and a pet-store entry capture it. The idea is to
add a level of indirection so that **formula identifiers become strictly internal**, and
sturdyref records and locators **refer to formula identifiers without capturing them**.
Rotating a shared link then means re-pointing or reissuing the indirection, not changing the
formula. The consumer is a minion.town design,
`design-minion-town-ocap-site-crawler-leak-rotation`, which needs `rotate -> new locator, old
revoked` for clips whose links leaked.

Read first: `designs/daemon-locator-reference.md` (internal formula identifier to locator
conversion), `packages/daemon/src/locator.js`, the sturdyref designs and PRs on `llm`, the
formula inspector design, the retention-path notation design, and
`designs/daemon-cross-peer-gc.md` (an indirection changes what keeps a formula alive).

## Sift: direction versus speculation

The maintainer asked for this to be sifted explicitly. Start the design with a section that
sorts every claim below into one of three bins, with the evidence for each:

- **Direction (design to this):** formula identifiers internal only; locators and sturdyref
  records hold an indirection, not the identifier; rotation = revoke and reissue the
  indirection without touching the formula.
- **Analogy to verify, not assume:** the ocap-kernel keeps terse kernel slots internally and
  projects them outward as encrypted, salted slots in shared locator URLs. Check what the
  ocap-kernel actually does (read its source and docs, do not rely on this description) and
  report where the analogy holds, where it does not, and what is cheaper to borrow.
- **Speculation (list it, do not design it, do not let it constrain the design):** that this
  could later admit vat identifiers and vat slots, or "slot machine". State at most what
  property of the chosen design would keep that door open or shut, and stop there.

## What the design must settle

1. **The indirection:** what the new record is, who mints it, what it contains, whether it is
   encrypted and salted (and what the salt buys), and how one formula can have many
   independently revocable references (one per share).
2. **Rotation and revocation semantics:** revoke one reference; reissue; what an old locator
   does (fails closed); what happens to live CapTP sessions and cached references.
3. **Migration:** the existing locators, sturdyref records, and pet-store entries that
   capture identifiers today. Is there a compatibility period, how are old locators mapped,
   and what is the registry/state migration (note the earlier crash-loop from a missing
   `registry` migration when a pin was bumped; plan the upgrade pass explicitly).
4. **GC and retention:** whether indirection records count as roots, and the effect on
   cross-peer GC.
5. **Daemon versus minion.town variant:** which layer owns it. minion.town is meant to be a
   thin configuration layer over Endo, with reusable components in `@endo/*`; justify the
   split.
6. **Threat model:** what rotation does and does not protect (a leaked indirection versus a
   leaked formula identifier already shared in the old scheme), and the cost of the extra hop.
7. **Options and a recommendation**, including the do-nothing and the simpler
   "mint a fresh formula and copy" alternatives, with a staged rollout.

Include mermaid diagrams (no ASCII art) and an `## Ownership map`. Open the design as a
DRAFT PR on `endojs/endo-but-for-bots`. The maintainer reviews every Endo change, so end the
job by sending the PR link to the maintainer inbox with one sentence on what to read first.
