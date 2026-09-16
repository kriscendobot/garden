---
title: "A capability is behavior, not an object reference"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-November/
source_snapshot: http://web.archive.org/web/20130603011234id_/http://www.eros-os.org/pipermail/cap-talk/2000-November.txt.gz
source_content_sha256: 77a320166ed3cf7c699f5dbe553ff9a7bf9aa2ab29400b14947824540d1d7882
source_authors: [Charles Landau]
source_date: 2000-11-07
thread_subject: "Capabilities and RPC calls..."
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Charles Landau (2000-11-07), replying to a question about whether two capabilities carrying "the same object reference but totally different collections of interfaces" are equal, argues that framing capabilities in terms of object references and interface thinning is off the mark. The fundamental definition is behavioral: a capability is something you can invoke; invoking means sending a message; and a capability is fully described by the behavior it exhibits when a message is sent to it. Object and access-right talk is a convenient description, not a necessary abstraction. The practical payoff is a clean account of capability equality (DISCRIM): two capabilities are equal only if they are behaviorally the same reference, so a read facet and a write facet over one shared variable are not equal, and KeyKOS/EROS start keys carrying different data bytes are not equal.

## The behavioral definition

Landau: "I believe that all this talk of object references and thinning of interfaces is off the mark. At a fundamental level, a capability is simply something that you can invoke; invoking means sending a message; a message contains some data and some capabilities. A capability is described by describing its behavior when a message is sent to it. It may be helpful to describe the behavior using concepts such as object and access rights, but it is not necessary."

The read/write example: "capability A's behavior may be to return the datum that was last sent to capability B. Think of A as a capability to read, and B as a capability to write, a shared variable. I do not have to say whether A and B refer to the same object. The means by which A and B share the variable is entirely internal to A and B."

## Equality follows from behavior, and the data byte is incidental

Landau treats the KeyKOS/EROS "data byte" or "tag" carried by a start key as an implementation convenience, not a fundamental abstraction: "It is an implementation convenience, not a fundamental abstraction, that KeyKOS and EROS start keys can carry a data byte or tag in addition to a reference to a domain/process." The consequence for equality: "It follows from this view that A and B are not considered equal (by Discrim), and start keys with different data bytes are likewise unequal."

This behavioral framing is the same one the 1999 grant-matching thread needed (a comparison predicate that bottoms out in primitive reference sameness; see [grant-matching-and-object-sameness](cap-talk-1999--grant-matching-and-object-sameness.md)) and it is the ancestor of E's `==` reference-sameness predicate and of the facet discipline: different facets of one implementation are genuinely different capabilities, not thinned views of a shared identity.

Source: [cap-talk 2000-November archive](http://www.eros-os.org/pipermail/cap-talk/2000-November/) (Internet Archive original-bytes snapshot `web/20130603011234id_/.../2000-November.txt.gz`, sha256 `77a32016`), message by Charles Landau, 2000-11-07.
