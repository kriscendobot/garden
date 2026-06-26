# Advance the competing sturdyref + formula-retention design pair (#510 vs #511) to a comparison

Maintainer directive on **endojs/endo-but-for-bots #500** (kriskowal, 2026-06-23): *"dispatch
designers to produce a pair of competing plans to address the same problem."* The pair already
exists (created that day) — **complete both as genuine competitors and tee them up for a
comparison/decision**. Wear the **designer** then **solicitor** role (design panel compares the
two). Bot repo, bot identity. Look for relevant Endo issues to inform (e.g. endo#3038 Ocap
Glossary; OCapN locator specs). Align both with **#521** (`feat(pass-style): first-class
'sturdyref' pass-style; ocapn defers to it`).

## The shared problem (both plans must fully address)

1. **pass-style sturdyref support.** A SturdyRef is an **opaque object, like a presence**, that
   must be **registered with HandledPromise**, corresponding to an **OCapN locator**. Design the
   **parsed representation of a locator**. A CapTP impl (incl. OCapN) boxes/unboxes SturdyRefs;
   OCapN provides the **closely-held capability** to associate a SturdyRef with its locator or
   reveal the locator for a SturdyRef. SturdyRefs serialize **in-band in all supported marshaling
   layers** (as already specified for OCapN).
2. **SturdyRef as petname placeholder.** Any daemon agent method that accepts a **pet-name-path**
   should also accept a **sturdyref**, so a **confined guest/subagent (who must never see a
   locator)** can refer to a formula without naming it.
3. **The retention dilemma (the differentiator).** Hard invariant: **the user must have agency** —
   able to mention **any retention root** and force **disincarnation / reincarnation /
   revocation-by-deletion** for any formula with a living reference. No name makes this hard.

## The two competing approaches (one per plan)

- **#511 — FinalizationRegistry worker-tracking** (option a): identify every worker holding a
  not-yet-GC'd SturdyRef via FinalizationRegistry, so the user exercises agency by **disincarnating
  the worker** that holds the SturdyRef / a live value.
- **#510 — no ephemeral worker retention + endor syscall** (option b / the alternative): workers do
  NOT retain ephemeral formula references; instead a mechanism **ephemerally retains any reference
  returned by an agent method until collected and REVEALS the ephemeral worker retention roots**,
  with an **`endor` worker-protocol "syscall" to retain/release references**.

## The crux to engage explicitly

This is potentially **the crux between the ocap-kernel and petname-formula-daemon design spaces**:
*not having to explicitly manage retention* is ocap-kernel's virtue; *revocation-by-deletion* is
the daemon's virtue. **Strive to keep the advantages of both without inheriting the disadvantages
of either.** Each plan must say where it lands on this and what it trades. (Cross-reference the
ocap-kernel ingest already queued in the library.)

## Deliverable

Bring **#510** and **#511** each to a complete, standalone plan covering items 1–3 with its
approach, the user-agency invariant preserved, and the crux engaged. Then **compare them** (a
solicitor design-panel pass): a side-by-side of trade-offs and a recommendation (adopt one, or a
synthesis), surfaced on #500 and to the maintainer for the decision. Do NOT implement; these are
design plans.

## Definition of done

#510 and #511 each completed as a full competing plan (pass-style sturdyref + petname-placeholder
+ their retention approach, agency invariant preserved, crux engaged, informed by relevant Endo
issues and #521), plus a comparison + recommendation surfaced on #500. Report both PR states and
the recommendation.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 42
  claimed_at: 2026-06-26T00:51:54Z
