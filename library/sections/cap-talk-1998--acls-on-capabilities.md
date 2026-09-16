---
title: "ACLs on capabilities (and why capabilities cannot be built on ACLs)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro]
source_date: 1998-03-10
thread_subject: "ACLs on Capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

Abstract: Shapiro's constructive half of the asymmetry argument: a concrete recipe for building an ACL-like mechanism on top of capabilities, and a concrete argument for why the reverse is infeasible. The ACL-on-capabilities recipe uses a *group manager* and a first-class *user object*; the only refinement needed over traditional ACLs is interposing a per-process trusted intermediary so the user object cannot be manipulated. The reverse-direction argument: capabilities require that a reference name a *single unique object*, but user identity in an ACL authorizes *multiple* objects, so simulating capabilities on ACLs forces a set-intersection on every access and separates authority from the object identifier. He closes with the observation that **UNIX already uses capabilities internally (a file descriptor is a capability)** but breaks the model by making descriptors non-transferable and by not protecting everything with them.

## Building an ACL on capabilities

> First, invent two objects: a group manager and a "user" object. Assume that you can compare two user objects for equality. Assume that a group manager accepts a user object capability and says "yes" or "no" according to whether that user object is a member of the group.

Services must be trusted not to abuse the user object, but "they already have the authority to act on your behalf; this is not an extension of new authority to the server objects." The one difference from traditional ACLs is that the user object is *first class*, so it could be passed around; the fix is to "interpose a trusted intermediary through whom all of my service requests go. The intermediary is per-process, and carries the user object associated with that process." This prevents the user object from being manipulated by the process.

## Why capabilities cannot be built on ACLs

> Basically, the problem is that user identity authorizes multiple objects. This violates the requirement that a capability must name a single unique object.

Simulating capabilities on ACLs (a new group per process, a new user identity per object, plus machinery to pass identities around) is possible on paper but "highly inefficient -- you then need to do a set intersection on every object access." Worse, "the authority and the object identifier become separated, in that the process doesn't explicitly specify the user identity (capability) under which it is performing each operation." The pure-ACL test question he poses: "How do I grant to a single process being run by you (and not to you in general) the authority to access a specific set of my objects." (See the [challenge problems](cap-talk-1998--acl-vs-capability-challenge-problems.md) for the sharpened version.)

## UNIX file descriptors are capabilities

> UNIX in practice uses an ACL system to control access to the persistent store (the file system), but internally uses capabilities. A file descriptor is a capability. The fatal flaws in this model are that file descriptors cannot be transferred between processes ... and that not everything is protected by file descriptors. Processes, for example, have an intrinsic right to perform some fairly powerful system calls.

The "intrinsic right to powerful system calls" is *ambient authority* — the property that [Capability Myths Demolished](papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) later isolates as Property D (No Ambient Authority) and that Tyler Close's [ACLs don't](papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat.md) names as the structural root of the confused-deputy family.

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), message from Jonathan S. Shapiro, 1998-03-10.
