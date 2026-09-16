---
title: "What is a Capability, Anyway? (swipe cards vs. keys)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Gregory Frascadore]
source_date: 1998-03-10
thread_subject: "Your essay: What is a Capability, Anyway?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

Abstract: The message that seeded the cap-talk mailing list. Gregory Frascadore, having read Jonathan Shapiro's essay "What _is_ a Capability, Anyway?", writes with the intuition that capabilities resemble physical keys on a keyring while access-control lists resemble the "swipe card" reader (which looks up your identity at each door), and argues from that analogy that *ACLs and capabilities are inseparable* because the building owner must ultimately consult an ACL to decide whether to grant you a key in the first place. This is the naive-but-natural equivalence intuition that Shapiro (and, five years later, Miller-Yee-Shapiro's *Capability Myths Demolished*) sets out to demolish; the whole founding debate of the list unfolds as the answer.

## The seeding argument

Frascadore compares two physical access systems: **keyed entry** (real keys on a keyring, which he takes to resemble a capability system) and **swipe cards** (swipe through a reader; a computer looks up your id and verifies your right to entry at that doorway, which he takes to resemble an ACL). He observes that modern buildings move toward swipe cards (ACLs) over keys (capabilities) and lists the apparent advantages of swipe cards:

- it is easy to delete access without retrieving the card;
- it is easier to control/limit access (entry counting: once someone is inside using a card, a copy cannot be used to get in);
- one need possess only one physical card but can use it at multiple doorways;
- one can use the card to attempt access to doorways that were unknown or did not exist when the card was obtained.

He asks whether these advantages "extend to ACLs over capabilities," and notes that capabilities "seem stateless" so it is not clear how to do entry-count-type access control.

## The equivalence intuition (the myth to be demolished)

The message's central claim, offered tentatively, is:

> I'm beginning to conclude that ACLs and capabilities are inseparable. There is a certain intermix ratio of how often ACLs are checked (to obtain capabilities) and how often capabilities are used.

Frascadore's reasoning: when he obtains a capability against an object *o*, "does the owner of *o* not apply an access list type mechanism to determine if the capability should be granted?" (the building owner consults an ACL before handing out a key). He closes by asking for references on how a "pure capability" system grants capabilities without ACLs, and on Shapiro's claim "that it is impossible to build a capability-based system on top of an ACL system."

This is the historical primary-source statement of the **Equivalence Myth** that [Capability Myths Demolished (Miller-Yee-Shapiro 2003)](papers--miller-capability-myths-demolished-2003--equivalence-myth.md) later names and refutes. The list's founding exchange is Shapiro answering it in real time (see [card-keys-are-capabilities](cap-talk-1998--card-keys-are-capabilities.md), [acls-on-capabilities](cap-talk-1998--acls-on-capabilities.md), and the [challenge problems](cap-talk-1998--acl-vs-capability-challenge-problems.md)).

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), message from Gregory Frascadore, 1998-03-10.
