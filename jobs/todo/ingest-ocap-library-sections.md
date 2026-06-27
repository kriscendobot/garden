<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T08:09:34Z -->

# PLAN: scholar — ingest sources for six missing ocap library sections

Maintainer: the library lacks sections on **grant matching, three-party hand-off,
pass-invariant equality, eventual send, sturdyrefs, and distributed confinement** —
plan to ingest sources for them. Wear the **scholar** role (library curator;
`journal/library/`). Deferred plan; when promoted, ingest authoritative sources for
each topic into the library per its conventions (`journal/library/{concepts,sources,
sections,topics}`, `conventions.md`), and keep the scholar's discipline: ground every
claim in a real source, cite it, and flag external lineage vs. in-corpus material.

## The six topics (and where the sources likely live)

For each, find and ingest the authoritative source(s), then curate a concept/section:

1. **Grant matching** — the capability-granting/matching pattern. Locate the canonical
   source (the ocap-pattern literature and/or any Endo/agoric grant/petname material);
   if it is named differently in our corpus, reconcile the naming.
2. **Three-party hand-off** — the classic ocap three-party introduction (Alice introduces
   Bob to Carol) and its CapTP realization (the gift/handoff / "3-vat" protocol; the
   Granovetter operator). Sources: the **OCapN/CapTP** spec material and Mark Miller's
   "Robust Composition" thesis; cite erights.org lineage as external where used.
3. **Pass-invariant equality** — passable equality invariant under marshalling. Sources:
   the Endo packages **`@endo/pass-style`** and **`@endo/marshal`** (the equality /
   `isWellFormed`/`sameValueZero`-style passable equality); ground in the actual code/docs.
4. **Eventual send** — E-style eventual send (`E()`, `HandledPromise`, the `~.` operator).
   Sources: **`@endo/eventual-send`** (and `@endo/captp`), the E language references, and
   gtor where it overlaps with change-propagation.
5. **Sturdyrefs** — sturdy (persistent) capability references. Sources: the E/Joule
   sturdyref material (external lineage) and any Endo persistence/locator realization;
   distinguish the literature from our implementation.
6. **Distributed confinement** — confinement in a distributed ocap system (SES object
   confinement + CapTP across vats; the confinement problem applied to ocap). Sources:
   the SES/ocap material and Mark Miller's work; cite the classical confinement lineage
   as external.

## Approach

- Per topic: identify the authoritative source(s), ingest as **source pages**, write a
  **concept/section** synthesizing the idea, and **cross-link** to adjacent library
  material (these six interlock — three-party handoff ↔ grant matching ↔ sturdyrefs ↔
  eventual send ↔ distributed confinement; pass-invariant equality underlies marshalling
  across all of it). Add a **topic** if it helps organize them.
- Honesty discipline (as elsewhere in the library): assert from a source or flag it as
  external lineage; never fabricate a citation. If a topic has no in-corpus grounding,
  ingest the external source and mark it clearly.
- This is a sizable ingest: do a solid first pass across all six and **post follow-on
  `scholar-ingest-<topic>` jobs** (plans, deferred) for any that need deeper coverage.
- Surface a synthesis summary through the **bulletin** (`message-user`) when meaningful
  progress lands; full curation lives in the library on `journal2`.

## Definition of done

Source pages + concept/section pages ingested for the six topics (or a solid first pass
with deferred follow-on plans for the rest), cross-linked, with honest grounding flags,
and a bulletin synthesis. Report what was curated per topic and any topic whose
authoritative source you could not locate.
