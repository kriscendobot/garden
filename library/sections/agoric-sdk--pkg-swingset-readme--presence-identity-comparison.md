---
title: Presence Identity Comparison (three-vat round-trip rule + promise-identity-not-preserved)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, marshal]
status: current
notes: The two-Vat asymmetric case (sending a Remotable to two Vats yields incomparable Presences in those two Vats, BUT becomes comparable when both forward to a third Vat) is non-obvious and load-bearing for correctness in distributed identity reasoning. The promise-identity-not-preserved rule is a footgun for code that compares promise objects directly — wait until `.then()` for identity work.
---

> Abstract: **Presences preserve identity** as they cross Vat boundaries, with one important asymmetric case. The three rules: (1) sending the same Remotable multiple times yields the same Presence on the receiver; (2) sending a Presence back to its "home Vat" arrives as the original Remotable; (3) sending one Remotable to **two different Vats** yields Presences in those Vats that **cannot be compared directly** (the two Vats communicate only by messages) — but if both of those Vats then forward their Presences to a **third Vat**, they arrive as the same Presence object on that third Vat. **Promises are *not* intended to preserve identity** — Vat code should not compare promise objects directly; wait until they pass out of a `.then()` resolution handler.

### Presence Identity Comparison

Presences preserve identity as they move from one Vat to another:

* Sending the same Remotable multiple times will deliver the same Presence on the receiving Vat
* Sending a Presence back to its "home Vat" will arrive as the original Remotable
* Sending a Remotable to two different Vats will result in Presences that cannot be compared directly, because those two Vats can only communicate with messages. But if those two Vats both send those Presences to a third Vat, they will arrive as the same Presence object

Promises are *not* intended to preserve identity. Vat code should not compare objects for identity until they pass out of a `.then()` resolution handler.

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
