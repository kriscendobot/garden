---
title: "Capability representation: partitioned, tagged, and password capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-July/
source_snapshot: http://web.archive.org/web/20130603012702id_/http://www.eros-os.org/pipermail/cap-talk/2000-July.txt.gz
source_content_sha256: 52cc13f4e94b1cfc1ffd047f9bdf8742c8f66c9a0b0f35b1e9b03c04c88b0924
source_authors: [Norman Hardy, Gernot Heiser, Jonathan S. Shapiro]
source_date: 2000-07-13
thread_subject: "Capbility Concepts"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The July 2000 "Capability Concepts" thread sorts out how a capability is *represented* and why the representation choice decides whether confinement is even possible. Norman Hardy opens with the claim that "all successful capability systems bottom out in capabilities as names" and that capabilities must be the only system-level naming scheme; Gernot Heiser pushes back with password capabilities (a UID plus a password), where the UID alone names an object. The thread then builds a representation taxonomy: capabilities can be **partitioned/segregated** (kept in memory the holder cannot read as data, as in the Plessey 250), **tagged** (interspersed with data but marked by a hardware bit, as in IBM's System/38 and AS/400), or **password/sparse/cryptographic** (bits exposed but protected by a secret, as in the Monash Password Capability System and its XOR trick). Shapiro's load-bearing point: only representations that keep the holder from fabricating or reading capability bits ("abstracted" in Hardy's later coinage) can support confinement, because otherwise a confinement checker cannot tell whether a binary image has capabilities embedded in its data.

## Bottoming out in capabilities as names

Hardy: "we may not say, or say often enough, that capabilities must be the only naming scheme on the system level ... all successful capability systems bottom out in capabilities as names." He worries the claim sounds "overly dogmatic" and that "bottoming out" is itself slippery, since much text is spent describing how lower hardware and software levels support the capability foundation.

Heiser's objection: password capabilities consist of a UID and a password, and "the UID taken by itself names an object." Shapiro's answer distinguishes bootstrap from steady state: "A password capability system does not bottom out in the way that Norm describes, because the operating system itself cannot be bootstrapped without either some set of available bootstrap passwords or some other means to load code."

## The representation taxonomy: partitioned, tagged, abstracted

Shapiro objects to Hardy's terms "protected/unprotected" and proposes **partitioned/unpartitioned** (citing Gehringer and Levy). Hardy has used **segregated** for the same idea and settles on **abstracted** to mean "capabilities whose bits you cannot see, partitioned or otherwise."

Three concrete architectures anchor the taxonomy:

- **Plessey 250**: "segregated data and capabilities into different memory segments and had segregated data and capability registers."
- **IBM System/38 / AS/400** (tagged): "devoted a hardware bit in memory for each 16 memory bits to mark a location as holding part of a capability. Capabilities were 64 bits long and allocated amidst other user data but hidden by the extra bit." Unprivileged code could copy a capability, "but the hardware would turn off the capability bit then, converting it to simple data." Hardy on the operational cost: "It is hassles like this which sour me on interspersed abstracted capabilities. Doing I/O was a bitch." A modified 64-bit PowerPC added "variant load/store instructions that set or do not set the tag bit in memory."
- **Password/sparse/cryptographic** (Monash Password Capability System, "Pose" paper): bits exposed, protected by a secret. Shapiro flags that leaving the object-identity bits in the clear "is a flaw." A hybrid keeps the bits exposed but applies "a process-specific XOR late in the game," which he counts as partitioned "because the process never has access to the true representation of the capability."

## Why representation decides confinement

Shapiro: "Non-partitioned systems suffer from a total failure of confineability, because it is impossible to determine whether the binary image has embedded within it one or more capabilities that are unknown to the confinement checker." A conservative approximation check exists but is prohibitively expensive and defeats transitive read-only sharing. He separates two distinct properties EROS/KeyKOS provide at once: a **referential encapsulation property** (a process cannot generate bits later interpreted as a capability) and **sensory access** / transitive read-only shareability (KeyKOS's "sense capability"). Remove sensory access and "you must enforce deep copy at process instantiation," which is expensive and, worse, "requires a widely held means by which to compare two capabilities for identity" to preserve object identity during the copy.

A recurring worry: "the most basic difficulty with password and cryptographic capabilities is that there is no way to determine when all capabilities to an object are gone," making garbage collection and lost-space recovery hard without scanning the whole disk.

## Translation

| cap-talk 2000 term | Endo / modern reading |
|---|---|
| partitioned / segregated / abstracted capability | unforgeable reference the holder cannot read as raw bits (a JavaScript object reference under SES) |
| tagged capability (System/38) | hardware-marked reference; no direct SES analogue (SES uses language, not memory tags) |
| password / sparse / cryptographic capability | bearer token (a swiss number, an unguessable URL); see [card-keys](../concepts/card-keys.md) |
| sensory access / sense capability | transitive read-only view of a structure across a confinement boundary |
| referential encapsulation | unforgeability of references (Property in the Miller-Yee-Shapiro sense) |

Source: [cap-talk 2000-July archive](http://www.eros-os.org/pipermail/cap-talk/2000-July/) (Internet Archive original-bytes snapshot `web/20130603012702id_/.../2000-July.txt.gz`, sha256 `52cc13f4`), messages by Norman Hardy, Gernot Heiser, and Jonathan S. Shapiro, 2000-07-13 to 2000-07-18.
