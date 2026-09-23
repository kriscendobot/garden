---
title: "Capability IDs and revocation by destroyable indirection"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro]
source_date: 1998-03-17
thread_subject: "Card Keys, capabilities, counters"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, revocation]
status: current
---

Abstract: Shapiro on the engineering of capability identifiers and the *destroyable indirection object* as EROS's revocation primitive. Three design commitments: the key ID should be **opaque** to the holder (it is none of the holder's business whether two keys name the same object with distinct IDs); a capability should occupy a **fixed, uniform size** (like a pointer — the counterexample, an early Cray with differently-sized pointers, "was a bloody nuisance"); and because the ID field is therefore small (16 bits in EROS), a **larger logical ID space is obtained by interposing an indirection object** that rewrites an argument register from a value stored inside itself. The same destroyable indirection object is what makes a capability revocable: destroy the indirection and the derived key stops working — the mechanism [Capability Myths Demolished](papers--miller-capability-myths-demolished-2003--irrevocability-myth.md) later names the forwarder/revoker (Redell's 1974 caretaker).

## Key IDs are opaque and capabilities are fixed-size

> First, the ID should in most cases be opaque to the key holder. It is none of the key holder's business if two keys point to the same object with distinct key ID values or if they point to different objects -- this is an encapsulation argument ...

> For a variety of reasons, it is desirable for a capability to occupy a fixed amount of storage, and for all capabilities to be the same size. Imagine, by way of analogy, a system in which pointers of different types are different sizes or have differing interpretations. One of the early Crays actually did the latter, and it was a bloody nuisance.

In EROS the ID field is 16 bits, "easy to get without growing the capability," adequate for most applications but "clearly inadequate for a card key system."

## Indirection objects for a larger ID space (and for revocation)

> One EROS application that requires a larger ID space is the space bank ... Nominally there are many space banks, but in fact all space bank capabilities name the same object with distinct key IDs.

> This is handled by using an indirection object. A key alleging to be an EROS space bank key is in fact a key to an indirection object ... The indirection object, among other options, has a mechanism for replacing one of the passed argument registers with a value taken from within the indirection object itself. By creating indirection objects with suitable ranges of values, a large key ID space (32 bits, though it could be made larger easily) is obtained.

The indirection is transparent to the caller (subject to one argument register being taken over by the mechanism). The load-bearing point for revocation, stated earlier in the [Card Keys](cap-talk-1998--card-keys-are-capabilities.md) reply: because the user holds a capability to a *destroyable* indirection object rather than to the target directly, destroying the indirection rescinds the access without disturbing any other key. This is the primary-source origin, in EROS practice, of the pattern the Endo/Agoric library calls the *caretaker* and generalizes as [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md).

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), messages from Jonathan S. Shapiro, 1998-03-17.
