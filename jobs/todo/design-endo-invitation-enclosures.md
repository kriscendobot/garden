---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design generic invitation enclosures for Endo

Design the optional phase-2 daemon mechanism described in
`kriscendobot/minion.town` PR #144, `designs/guest-coupons.md` section 7: a
generic `InvitationFormula.enclosures` record whose entries travel in an
`endo://` invitation locator (for example, `&enc.coupon=`) and round-trip
through `locate` and invitation acceptance without making coupons a special
daemon formula type.

The resulting design belongs on the appropriate `endojs/endo-but-for-bots`
design branch and review surface. This is design-only; do not build the daemon
hook in this job.

Ground the proposal in the existing `InvitationFormula`, locator parser and
formatter, `locate`, and invitation-acceptance paths. Settle at least:

- the exact type and encoding of enclosure names and formula identifiers;
- authority checks proving the inviter holds every enclosed capability;
- duplicate keys, size limits, unknown enclosures, and malformed locators;
- what the accepter receives and how existing callers remain compatible;
- cross-daemon and same-daemon round trips, including the coupon consumer; and
- an ownership map plus tests for parsing, authority, non-leakage, and replay.

Origin: kriskowal's inline review directive on
https://github.com/kriscendobot/minion.town/pull/144#discussion_r4333035650
(`designs/guest-coupons.md`, open question 1), approved in review
https://github.com/kriscendobot/minion.town/pull/144#pullrequestreview-5594963376.
