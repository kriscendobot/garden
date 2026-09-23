---
title: Getting more precise — what a capability is; creation, transfer, endowment
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

## Abstract

Morningstar's precise definition and the object-capability model. **A capability is a
single thing that both designates a resource and authorizes some kind of access to
it** — combining designation and authority in one object. Three properties follow:
capabilities are **transferable** (whoever holds one can convey it, which is precisely
what makes *delegation* of authority possible — and which makes ACL-camp people "freak
out"); they are **unforgeable** (you cannot by yourself manufacture a capability to a
resource you don't already have access to — pathnames and C++ pointers are forgeable,
Java/Smalltalk object references are not); and in an **ocap** system a *reference to an
object is a capability*, the object being both a wielder of capabilities and a resource
itself. The section names the ocap system's two extra requirements over ordinary OOP —
**unforgeable references** and **strong encapsulation** — and the **three (and only
three) ways to come to hold a capability: creation, transfer, endowment**, with
transfer (the Alice→Carol→Bob narrative) as the graph-changing case that yields a form
of *confinement* ("you can't leak a capability unless you have another capability that
lets you communicate with someone to whom you'd leak it"). It closes with the
philosophical divergence: ocap access-control decisions are *subsumed by the code of
the objects themselves*, arising only at the periphery where the system meets human
users — "ocaps are just object oriented programming with some additional strictness."

## Content

We said separating designation from authority is dangerous and the two should be
combined — but what does combining them actually mean? The precise definition:

> **A capability is a single thing that both designates a resource and authorizes
> some kind of access to it.**

Unpacking the abstract words:

- **Resource** — anything the access-control mechanism controls access to: a file, an
  I/O device, a network connection, a database record, or any object. The mechanism
  itself does not care what kind of thing it is.
- **Access** — actually doing something with the resource: reading, writing, invoking,
  using, destroying, activating. The *specific kind of access is one of the things the
  capability embodies* — a read capability to a file is a *different thing* from a
  write capability to the same file, and a read+write capability is a third thing.
- **Designation** — indicating which resource. **Authorizing** — allowing the access.

Because the capability combines designation with authority, the possessor exercises
their authority by **wielding the capability itself**. "If you don't possess the
capability, you can't use it, and thus you don't have access. Access is regulated by
controlling possession."

**Transferability and delegation.** Capabilities are transferable: whoever possesses
one can convey it to someone else. The implication is that **capabilities
fundamentally enable delegation of authority** — pass a capability to someone and they
too are now able to do the thing. Delegation is one of the main things that make
capabilities powerful, but it also makes many people "freak out at the apparent loss
of control," prompting attempts to invent mechanisms to limit or forbid delegation —
"a terrible idea [that] won't work anyway." (A teaser to meditate on: two capabilities
that authorize the same access to the same resource are not necessarily the same
capability.)

**Unforgeability.** A capability must be **unforgeable**: "you can't by yourself create
a capability to a resource that you don't already have access to." Pathnames are highly
forgeable — anybody can type any string — so they work as designators but cannot
themselves authorize access. A C++ object pointer is forgeable (cast an integer to a
pointer); a reference in Java, Smalltalk, or any memory-safe language is unforgeable.

**Objects as the model.** Morningstar shifts from personified "you" to **objects** in
the OOP sense. In an **object-capability ("ocap") system, a reference to an object is a
capability.** Objects are both *wielders* of capabilities and *resources* themselves.
You **wield** a capability (an object reference) by invoking methods on it; you
**transfer** one by passing a reference as a method parameter, returning it, or storing
it in a variable. An ocap system adds two requirements to ordinary OOP: (1) object
references must be **unforgeable**, and (2) there must be **strong encapsulation**, so
one object can hold references that cannot be reached from outside it. (You can make
Java itself into a pure ocap language with a few extra rules.)

**Three ways to acquire a capability.** In an ocap system there are only three:

- **Creation** — you created the resource yourself; by convention the creator receives
  a full-access capability to the new resource (natural in OOP, where a constructor
  returns a reference). Creation is optional in principle, but if a system can produce
  new resources, handing them to their creator is a good way to admit them.
- **Transfer** — somebody else gave the capability to you. "The most important and
  interesting case," and how the **authority graph** changes over time. Alice has a
  capability to Bob; Alice passes it to Carol; now Carol also has it. The subtleties:
  (1) Alice must actually possess the capability to Bob; (2) Alice must also have a
  capability to *communicate with* Carol — which yields a form of **confinement**: "you
  can't leak a capability unless you have another capability that lets you communicate
  with someone to whom you'd leak it"; (3) Alice had to *choose* to pass it — nobody
  could cause the transfer without her participation (this is what motivates strong
  encapsulation).
- **Endowment** — you were born with the capability; a creator gives an object a
  reference as part of its initial state. Endowment is "just creation followed by
  transfer," but treated separately because it is how an *immutable* object can hold a
  capability and how the rules avoid infinite regress. Endowment is also how objects
  end up with capabilities realized by the ocap *system implementation itself* — an
  ocap language framework wrapping a conventional OS's file system, or an ocap OS
  (KeyKOS, seL4) wrapping primitive hardware; such privileged objects cannot be created
  within the ocap rules, so the system endows them.

**Summary and the philosophical divergence.** "In the ocap model, a resource is an
object and a capability is an object reference. The access that a given capability
enables is the method interface that the object reference exposes. ... ocaps are just
object oriented programming with some additional strictness." A key difference from
ACLs: ocap resources and access modes are more diverse, finer-grained, and more
dynamic — introduce new kinds of resources and access simply by defining new classes,
where a typical ACL framework has a fixed set of resource types and a small set of
access modes baked in. The deeper divergence is *where access decisions live*: ACL
decisions rest on **configuration settings** administered (often manually) through the
access-control machinery, whereas the ocap approach dispenses with most configuration
— "the vast majority of access control decisions are realized by the logic of how the
resources themselves operate," subsumed by the code of the corresponding objects. Only
"at the periphery, where the system comes into actual contact with its human users," do
policy and intent arise, and often intent can be inferred from ordinary UI acts
(picking a file, clicking save). Consequently "thinking about access control policy and
administration is an entirely different activity in an ocap system," extending into the
architecture of applications, languages, frameworks, network protocols, and OSes.

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
