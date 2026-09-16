---
title: "Capabilities for immutable data: is a sealed value a capability?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-April.txt.gz
source_content_sha256: f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1
source_authors: [Sandro Magi, David Barbour, Alan Karp, Bill Frantz, David Wagner, Mark Miller, Rob Meijer]
source_date: 2011-04-06 to 2011-04-29
thread_subject: "Capabilities for immutable data"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. The densest 2011 thread (71 messages)."
---

Abstract: The longest thread of 2011 asks whether a *sealed value* (an immutable datum divided from the permission and means to access what it seals) is itself a capability. Sandro Magi argued that a sealed value carries authority worth reasoning about, because transporting it to the right context can cause effects, and so deserves to be counted in an authority analysis. David Barbour held the opposite: a sealed value is not a capability because it cannot be exercised directly (you must first move it to the context that can unseal it) and, more fundamentally, because it is a value, not a reference. Alan Karp reframed the confusion as a conflation of *permission* (what a capability grants: the right to invoke what it designates) with *authority* (what a designated object can then do). David Wagner reduced the dispute to definitional pragmatics: a definition earns its keep by the useful distinctions it draws and by staying stable, not by matching an a priori intuition. The list did not converge, but it sharpened the distinction between data and objects, and between implementation and abstraction, that the SES and Endo `passStyle` classification later mechanizes.

## The sealed value: authority worth mention, or not a capability?

Sandro Magi's position is that a sealed value is a kind of protected reference with distinct properties, and that holding one "carries authority worthy of mention, because transporting it to the right context can cause effects." David Barbour rejected both halves. First, a capability is exercised *directly*: you invoke it where you hold it, whereas a sealed value does nothing until it reaches the holder of the matching unsealer. Second, and for Barbour more basic, a sealed value is not a reference at all but a value, and he pressed the distinction between objects (which have identity and behavior reached through a reference) and values (which are immutable data). His summary: a sealed value "(1) does carry authority worth mention" but "(2) is NOT a capability," and Magi's error was treating (1) and (2) as mutually exclusive.

Bill Frantz offered the KeyKOS Factory as the awkward middle case: an object whose available interface changes over its lifetime (a construction phase, then a sealed product-building phase whose construction methods are not yet callable). The factory shows that "what a reference can do" is not fixed, which complicates any rule that classifies references by their present exercisable effect.

## Permission versus authority, and the criteria for a good definition

Alan Karp said he was "baffled" until he noticed the disputants were using *permission* and *authority* interchangeably. His correction: a capability grants the *permission* to invoke what it designates; how that designated thing then uses its own permissions is what grants the invoker *authority*. Rewriting the thread with "authority" replaced by "permission" where appropriate dissolved part of the disagreement.

David Wagner pushed the meta-question: this is an argument over definitions, so what criteria choose between them? He proposed judging a definition by whether it facilitates communication, and asked for concrete statements about capabilities that one definition makes easy and the other makes hard. Barbour answered that a definition's utility is extrinsic: (a) the useful distinctions it lets its users draw (broadening "capability" to swallow sealed values, SPKI certificates, or identity-based schemes erodes the distinctions the word exists to make), and (b) stability across users and time (redefining a shared term sows confusion regardless of the new definition's merits). Rob Meijer added the boundary case of sparse capabilities: out of context a sparse capability is just a string of bits, yet the community counts it as a capability because it is *exercised* as one and the bit-string is an implementation detail. Meijer's caution was to keep "capability" and "object-capability" distinct: something can be a capability without being an object-capability.

## Implementation versus abstraction

The recurring fault line Barbour named is confusing implementation with abstraction. A sparse capability is a capability because the abstraction presented to developers is a reference (communicable in messages, reaching an object through a common protocol), even though it is *represented* by bits. By the same token, being able to *model* X with a capability does not make X a capability: identity-based authority can be modeled with capabilities without thereby being one. "X is modeled with Y" does not license "X is a Y," or, in Barbour's words, logic breaks down and pigs fly. This is the same move that governs the companion [type-passing thread](cap-talk-2009-2012--type-passing-and-rights-amplification.md): a reversible representation is not an identity of abstractions.

## Bearing on Endo

Endo's `passStyle` classification is the settled engineering answer to the question the list left open. Hardened copy-data (records, arrays, tagged values) is *passable* but carries no authority: it has no methods to invoke, so possession of it designates and authorizes nothing. Remotables and promises are the reference-like pass styles that do carry authority. A sealed value in Endo terms is closest to the output of a sealer/unsealer pair, an authority-amplification pattern where the sealed box is inert copy-data until presented to the matching unsealer that reconstitutes the reference. So Endo agrees with Barbour that the sealed datum is not itself the capability, while agreeing with Magi that its *movement* toward the unsealer is a real event an authority analysis must track. The permission-versus-authority distinction Karp drew is exactly why Endo reasons about the object graph (who can reach whom) rather than about the static set of values a subject holds.

Source: [cap-talk 2011-April archive](http://www.eros-os.org/pipermail/cap-talk/2011-April/) (Internet Archive original-bytes `id_` snapshot of `2011-April.txt.gz`, sha256 `f28a7548`), thread "Capabilities for immutable data", 2011-04-06 to 2011-04-29.
