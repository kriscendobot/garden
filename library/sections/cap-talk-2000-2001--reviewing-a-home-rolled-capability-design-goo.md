---
title: "Reviewing a home-rolled capability design (Hanson's Goo): handles, tickets, and why not SPKI"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2001-July/
source_snapshot: http://web.archive.org/web/20060613194941id_/http://www.eros-os.org/pipermail/cap-talk/2001-July.txt.gz
source_content_sha256: 7e0ec8b293ccc94a2fbef27573b7a83d5e5ab9a38cb00d46e2f0531776f6931e
source_authors: [Johan Hanson, David L. Nicol, Jonathan S. Shapiro]
source_date: 2001-07-09
thread_subject: "Request for comments on Hanson Goo"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Johan Hanson posts (2001-07-09) a draft design for "Goo," a home-rolled capability scheme for distributed realtime interprocess communication, and asks the list for review. Goo splits capabilities into two kinds: **Handles** (usable for all purposes but not passable between processes) and **Tickets** (passable, send-only, single-use, valid only for a limited time), with propagation forming a conceptual tree of Tickets-as-branches and Handles-as-nodes. The review is a compact case study in how the list critiques a new capability design: David Nicol questions the is-a subclassing of the two kinds (prefer has-a), and Shapiro poses the standing gatekeeper question, "Why is a new capability model either required or appropriate? Why is not the capability subset of SPKI appropriate?" Hanson's answer is the useful part: he rejects SPKI because its certificate chains make a capability *grow* as rights are *removed* in delegation, force disclosure of a delegatee's rights, and violate the principle that capabilities should be lightweight primitives.

## The Goo model: handles and tickets

From the draft (gooey.sourceforge.net/cap.html), as quoted by Nicol: "There are two types of capabilities, Handles and Tickets. A Handle can be used for all purposes but can not be passed between processes. Tickets can be passed from one process to another, but can only be used for sending messages, can only be used once and is only valid during a limited (implementation-defined) time period. The propagation of the capabilities to a specific object form a conceptual tree with Tickets as the branches and Handles as the nodes and leaves." Nicol likes the base definition, "a reference to an object with bundled access rights valid for that object, and that object only," but urges a has-a rather than is-a relation between handles/tickets and capabilities.

## The gatekeeper question and the SPKI critique

Shapiro's review question is the standing one for any new design: "Why is a new capability model either required or appropriate? Why is not the capability subset of SPKI appropriate?"

Hanson's reply is a concrete critique of SPKI as a capability substrate: "I view SPKI more like an implementation mechanism ... However, I do not want to. In my opinion, SPKI violates the idea that capabilities should be lightweight primitives. What I dislike the most is certificate chains. They introduce much unneeded complexity. The size of a capability GROWS when access rights are REMOVED in delegation. You must disclose some of the access rights that delegatees are in possession of, something that I am fundamentally against. One could bypass certification chains by issuing shortcuts, but then these certificates would not be revokable." He is more interested in feedback on "the model of access rights and implicit restriction in delegation" from an API user's perspective than on the wire mechanism.

This exchange sits alongside Miller's parallel judgment (see [off-line-capability-representation-vs-on-line-protocol](cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md)) that SPKI is only "approximately a capability system." The shared open question of the era: is a certificate-chain authorization system a capability system at all, or only an approximation with the wrong cost model (attenuation should shrink authority and stay cheap, not grow the token and disclose the residue)?

Source: [cap-talk 2001-July archive](http://www.eros-os.org/pipermail/cap-talk/2001-July/) (Internet Archive original-bytes snapshot `web/20060613194941id_/.../2001-July.txt.gz`, sha256 `7e0ec8b2`), messages by Johan Hanson, David L. Nicol, and Jonathan S. Shapiro, 2001-07-09 to 2001-07-18.
