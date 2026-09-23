---
title: "Creating and granting capabilities (space bank, ownership, storage accounting)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro]
source_date: 1998-03-10
thread_subject: "Creating capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

Abstract: Shapiro's answer to "how are capabilities granted in the first place, if not by an ACL check?" He unpacks the buried question into three: how objects are created, how granting is decided, and what "ownership" means. In EROS, **objects are not created — all objects already exist** as pages and nodes on disk; an agent buys unallocated storage from a *space bank*, arranges it, and receives a capability to the arrangement. Granting is entirely the holder's discretion (an ACL is merely one mechanism a holder might use); you transmit a capability only by invoking a capability you already hold. "Ownership" is not primitive: two holders of the same capability have equal authority, and the only asymmetry is that the party who paid for the storage can reclaim it — which is why explicit storage accounting beats garbage collection.

## Objects are allocated, not created

> Objects are *not* created. Ultimately, all the objects you are ever going to have are already there -- the pages and nodes (fixed-length capability arrays) on the disk. What happens is that some agent comes along, purchases some unallocated pages and nodes from a storage manager (known as a space bank), arranges those objects in a useful way, and hands you a capability to the arrangement.

A *constructor* lets one party describe how to build an object for another party to use, such that the user provides the storage for their instance and the constructor makes security guarantees about it. The space bank is trusted code. In either the EROS design or a conventional dynamic-allocation kernel, "you initially become the sole holder of a capability to the new object, because part of the contract is that the constructor won't give that capability to anyone else."

## Granting is the holder's discretion

> If you are the only program who holds a capability, you are in complete control of who gets a copy of it. You can do this however you wish -- by building an access list, by giving it only to selected objects that work for you, by random distribution, or by some other means. An ACL is merely one of the mechanisms you might use.

Weaker capabilities (e.g. a read-only view of a memory object) can be derived from an initial capability and handed out instead. Every user account receives at creation a directory of initial capabilities (services, the per-user storage manager). The transmission rule: **you can only transmit a capability by invoking some other capability that you already have** — the connectivity axiom later formalized as "only connectivity begets connectivity" in [Structure of Authority (2004)](papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority.md).

## Ownership and storage accounting

> If two parties hold the same capability, they have the same authority. In this sense, they are equally "owners" of the object that the capability names.

The one asymmetry: in a system with properly accounted storage, the party who paid for the storage is "more equal" — they can reclaim it out from under other parties, which is essential for correct accounting. Shapiro contrasts this with garbage collection: "The problem with [GC] is that you cannot account for the storage correctly." (This tension — explicit revocable storage vs. transparent persistence — recurs across the archive and bears directly on Endo's persistence and revocation model; see [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md).)

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), message from Jonathan S. Shapiro, 1998-03-10.
