---
title: Capability patterns — modulation, attenuation, abstraction, combination
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-security, patterns]
status: current
---

## Abstract

Morningstar's four rough categories of **compositional capability patterns** — the
part of the essay that answers the ACL-camp's anxieties by showing what you *build*
with capabilities. **Modulation**: interpose an object that modulates access to
another; the canonical case is the **revoker** (a message forwarder that can be
commanded to drop its pointer), answering "what if I want to take access back?" —
generalizable to switchable, time/location-conditional, rate-limited, use-once, or
pay-per-use intermediaries, and to **auditable delegation** (the intermediary logs who
was delegated to and why, so misuse is attributable). This directly rebuts the "an ACL
tells you who has access" belief — that is an *illusion* because credential sharing is
invisible to the ACL; what an ACL really gives you is *who to hold responsible*, which
capabilities do better. **Attenuation**: reduce a capability's scope of authority
(both which operations and which resources) — a filesystem capability attenuated to
one file or subtree (a cleaner `chroot`), a full file capability attenuated to
read-only; attenuators are how you package the non-capability world into capabilities.
**Abstraction**: refactor an attenuated capability into a more narrowly-purposed object
(a read-only file capability becomes an input stream), which is where the **Principle
of Least Authority (POLA)** enters, along with the authority-vs-permission distinction
(the Unix `passwd` command as abstraction, and why ACL systems must lean on the
confused-deputy-prone `setuid`). **Combination**: use two-or-more capabilities together
to make something new — the worked example being a capability-phone OS combining
camera + GPS + clock + a private key to yield signed, authenticated, timestamped,
geo-referenced images for police body cameras and dashcams.

## Content

To show what "affecting fundamental architecture" means, Morningstar returns to the
ACL-background reader's concerns. The ocap approach both enables and relies on
**compositionality** — putting things together to make new kinds of things, which "isn't
really part of the ACL toolbox at all." He groups the patterns into four rough
categories (nothing fundamental about the grouping; just useful for presentation).

**Modulation** — having one object modulate access to another. The most important
example is a **revoker**. A major ACL-camp anxiety is that a capability can escape
control: if I gave you a capability, you have it — how do I take it back? *The answer is
that I didn't give you my capability.* Instead I gave you a **new** capability I
created — a reference to an intermediate object that holds my capability but remains
controlled by me so I can disable it later. "A rudimentary form of this is just a simple
message forwarder that can be commanded to drop its forwarding pointer." Modulation can
go further: a capability I can switch on or off at will; access conditional on
time/date/location; controls on frequency or quantity (a **use-once** capability with a
built-in expiration); even an intermediary that requires payment. "The possibilities are
limited only by need and imagination."

Revocation solves *taking access back*, but what about **controlling delegation**?
Capabilities are essentially **bearer instruments** — they convey authority to whoever
holds them, so a recipient can pass one on to someone I don't approve of. This is a real
property, not a misunderstanding: in the capability model there is no way to know who has
access. But *the ACL model has the same problem*, because credential sharing is
invisible to it: "There's a widespread belief that an ACL tells you who has access, but
this is just an illusion." What an ACL really gives you is **who to hold responsible** —
"and if you think about it, this is what you actually want anyway." Credential sharing
(a secretary knowing the boss's password — "almost universal") is *too permissive* (the
LDAP password unlocks far more than the calendar) and *destroys accountability* (logs
tied to the boss's name cannot distinguish the boss's accesses from the assistant's;
shared credentials even provide the boss plausible deniability). The revoker extends to
make delegation **auditable**: delegate by passing an intermediary that records who was
delegated to and why, logging it on use — "if the resource is misused, we actually know
who to blame." (Credential sharing is not limited to passwords: ask someone to run a
program for you and whatever it does gets done with *your* credentials — the reason some
firms forbid running unapproved software.)

**Attenuation** — reducing what a capability lets you do, its **scope of authority**,
across both the operations enabled and the range of resources reachable. The resource
dimension matters because object methods commonly *return references to other objects*
(foreign to the ACL world). From a capability to a whole file system, an **attenuator**
can instead grant access to a single file or a subdirectory tree — "a less clumsy
version of what the Unix chroot operation does." Attenuating *functionality* is likewise
possible: from a file capability supporting read/write/append/delete/truncate, produce a
**read-only** capability by having the intermediary support only reads. These compose
(a read-only capability to one file, out of a whole-filesystem capability). Attenuators
are "particularly useful for packaging access to the existing, non-capability oriented
world into capabilities" — filesystem wrappers, network mediation (limiting connections
to particular domains, distributing applications across datacenters without letting them
talk to arbitrary hosts — firewall-like control without the operational overhead), and
display-surface control.

**Abstraction** — once authority is narrowed, it often makes sense to refactor the
capability into something with a more appropriately narrow set of affordances (package a
read-only file capability as an **input stream** object rather than a file). Is this
different from ordinary good OOP? "The short answer is, it's not — capabilities and OOP
are strongly aligned. ... the capability perspective usefully shapes how you design
interfaces." Here the **Principle of Least Authority (POLA**, "happily pronounceable")
enters: **objects should be given only the specific authority necessary to do their
jobs, and no more** — "the fewer things an object can do, the less harm can result if it
misbehaves or if its integrity is breached." Morningstar distinguishes the vocabulary:
capability people prefer **"authority"** (the full scope of what something can actually
do) over **"permission"** (a particular set of access settings). On Unix he lacks
permission to modify `/etc/passwd`, but has permission to execute the `passwd` command,
which *does* have permission and makes selected changes on his behalf — thus giving him
the *authority* to change his password (but not the authority to delete the file, which
`passwd` could do but does not expose). `passwd` abstracts low-level file access into a
narrower, meaningful operation. This kind of access-refactoring is awkward in the ACL
world, which must lean on "slippery abstractions like the Unix **setuid** mechanism" —
the thing that makes `passwd` possible but is "a potent source of confused deputy
problems," behind "an astonishing number of Unix security exploits." The ocap approach
avoids the missteps because the reduction in authority "often comes for free as a natural
consequence of the straightforward implementation of the operation being provided."

**Combination** — using two-or-more capabilities together to make a new capability to
some joint functionality. Sometimes this is just the intersection of two authorities;
the interesting cases create something truly new. The worked example: a smartphone
running a capability-oriented OS, where hardware features are accessed via capabilities.
Combine three — **capture images from the camera**, **read geographic position from
GPS**, **read the system clock** — inside an object holding a (manufacturer-provided)
**private cryptographic key**, and you get a new capability that yields **signed,
authenticated, timestamped, geo-referenced images**. Grant it to applications needing
high-integrity imaging — police body cameras, dashcams, journalistic apps — and if it
is the *only* way those apps can reach the camera, their developers "don't have to be
trusted to maintain a secure chain of evidence for the imagery." This simplifies the
apps (focus on their unique needs, not signatures and image formats) and makes their
output far more trustworthy (no need to prove the app code doesn't tamper — "you still
have to trust the phone and the OS, but that's at least a separable problem").

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
