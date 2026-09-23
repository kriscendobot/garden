---
title: "The TCB is not singular: per-application TCBs and the universal TCB"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-July/
source_snapshot: http://web.archive.org/web/20130603012702id_/http://www.eros-os.org/pipermail/cap-talk/2000-July.txt.gz
source_content_sha256: 52cc13f4e94b1cfc1ffd047f9bdf8742c8f66c9a0b0f35b1e9b03c04c88b0924
source_authors: [Jonathan S. Shapiro]
source_date: 2000-07-24
thread_subject: "Meaning of TCB"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A short but load-bearing note from Shapiro (2000-07-24, splitting off the "Capability Concepts" thread) arguing that speaking of *the* trusted computing base is nonsensical in a component-based capability system. Each application has its own TCB, defined as everything it relies on that its author did not write; the "universal TCB" is only the intersection of all application TCBs. This reframing matters because it is the capability-system reading of least authority applied to trust itself: trust is per-relationship, not global, so two applications on the same machine can have different, incomparable trusted bases.

## Per-application TCB, then the intersection

Shapiro: "After a lot of discussion back and forth with Paul Karger and Leendert van Doorn, I have concluded that speaking of the TCB is nonsensical. In the context of a component-based system, different applications may well rely on different components in establishing trust contracts. In defining the TCB, we must divide an application into the code written by the author and the (often opaque) middleware used by the application. The TCB of the application is all of the stuff that is not written by the application author."

The universal TCB is derived, not primitive: "For a given set of applications, each having a TCB, we can imagine taking the intersection of the application TCBs. In practice, in some given system, there is some intersection that is common to all application TCBs. I refer to this as the universal TCB. Usually, when people speak of the TCB they are speaking of this universal TCB."

He hedges its list utility ("I am not sure if it makes a useful distinction for this list") but the distinction recurs across the era: the November 2000 process-branding thread turns on exactly which parties (kernel, space bank, factory) are in an application's minimal TCB (see [process allocation, branding, and the minimal TCB](cap-talk-2000-2001--process-allocation-branding-and-the-minimal-tcb.md)).

## Why this is the capability reading of trust

In an ambient-authority system the TCB is monolithic because every program runs with the user's full authority, so anything trusted must be trusted by everyone. In a capability system authority is per-reference, so trust decomposes the same way: an application trusts only the components it actually holds references to and depends on. The "universal TCB" shrinks to the small kernel-plus-primordial-services intersection every application unavoidably shares. This is the same modular decomposition that the later Miller-Tulloh-Shapiro *Structure of Authority* (2004) frames as security-as-modularity.

Source: [cap-talk 2000-July archive](http://www.eros-os.org/pipermail/cap-talk/2000-July/) (Internet Archive original-bytes snapshot `web/20130603012702id_/.../2000-July.txt.gz`, sha256 `52cc13f4`), message by Jonathan S. Shapiro, 2000-07-24.
