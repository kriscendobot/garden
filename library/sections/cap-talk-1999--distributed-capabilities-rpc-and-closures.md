---
title: "Distributed capabilities, RPC, and closures"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-October.txt.gz
source_content_sha256: 476c44f473c633a47e37e9ace68a41ee7c29b8a7317f2f8979b150af6fd38cb8
source_authors: [Gavin Thomas Nicol, Paul Snively, Jonathan S. Shapiro, Mark S. Miller]
source_date: 1999-10-08
thread_subject: "Capabilities and RPC calls..."
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, captp, eventual-send]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Nicol notices that an RPC invocation already carries an object identifier, method identifier, and arguments, and asks whether it is a capability invocation. The discussion answers that wire shape is insufficient: a distributed capability system must ensure that possession of the reference is the authorization, preserve reference identity, constrain what an endpoint can designate, and mediate how references are introduced. Miller then connects object capabilities to lexical closures: in a secure lambda language, a closure is a capability because its freely referenced state is exactly its authority-bearing acquaintance set.

## RPC becomes capability transport only with the reference discipline

Traditional RPC often treats security as a separate identity check over a globally addressable object. A capability protocol treats the received reference itself as the right to invoke a behavior subset. An endpoint cannot name an arbitrary hidden object merely by constructing a public identifier; it can refer only to objects within the scope created by prior introductions.

## Distributed objects thin behavior, not merely type

The participants debate whether a capability is an object plus a type signature. Miller's sharper formulation is designation of a thing plus access to a subset of that thing's behaviors. Different references may therefore expose different facets of one implementation even when an RPC type system would assign them a shared representation.

## Closures are the local model

A closure's state is the subset of its lexical environment it actually captures. Those captured references determine what effects the closure can cause. This is the local analogue of a remote reference's acquaintance set and directly anticipates E, eventual send, and CapTP. Garbage-collection correctness also depends on this semantic state boundary: an object not reachable from any captured state need not remain alive merely because it once appeared in a larger spawning environment.

Source: [cap-talk 1999-October archive](http://www.eros-os.org/pipermail/cap-talk/1999-October/) (Internet Archive original-bytes snapshot, sha256 `476c44f4`), messages by Gavin Thomas Nicol, Paul Snively, Jonathan S. Shapiro, and Mark S. Miller, 1999-10-08 to 1999-10-27.
