---
title: "The KeyKOS/EROS practical model, explained to a newcomer"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-August/
source_snapshot: http://web.archive.org/web/20130603003816id_/http://www.eros-os.org/pipermail/cap-talk/2000-August.txt.gz
source_content_sha256: d7fb39c750675db600c3fe5cd0e1869b2d9eb5ee7203a533da2452404430c95b
source_authors: [John Rudd, Norman Hardy, Jonathan S. Shapiro, David L. Nicol]
source_date: 2000-08-18
thread_subject: "Just learning about Eros OS and Capabilities Systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, revocation]
status: current
notes: "Derived summary, not the original messages. Spans 2000-July (Rudd's opening questions) and 2000-August (the answers)."
---

Abstract: A newcomer (John Rudd) reads the EROS FAQ and asks the concrete questions every capability-OS learner asks: where does a process's capability list physically live, how is a login session restored, how does anyone get the first capability to a newly created object, is there a universal broker (a "root"), and are objects passive or active. Norman Hardy (answering for KeyKOS) and Jonathan Shapiro (for EROS) give the canonical answers. Together they lay out the practical model: capabilities live in a kernel-protected per-process node, everything is orthogonally persistent so logout is just a disconnected terminal, the *creator* of an object receives its sole initial capability (there is no universal broker and no root), objects are active entities that run code when invoked, and capabilities are *copied* not delegated (the sender cannot later reclaim one, which is why revocation needs a deliberately interposed nullifiable indirection).

## Where capabilities live, and buffer-overflow worries

Shapiro: "Each process has an in-kernel data structure that captures its state. Among the entries in this structure are the capabilities, or at least a pointer to a capability table." In EROS the area is backed by a per-process capabilities node; the in-kernel process table "is only a cache of the other state." On attack surface: "In abstract, the entirety of any OS is vulnerable to such attacks. There is nothing particular to capabilities here." EROS narrows it in practice because "all system calls have the same API at a low level (pass one string, receive one string) and the decoding of this string is done at a single point in the OS."

## Persistence makes login a reconnection

Shapiro: "In EROS, it is not reinitialized. There is no need to do so, because everything (including your login session) is persistent. When you log out, what your shell sees is that you have walked away for a long time. The session manager simply disconnects your physical terminal from the shell. Later, when you log in, the new terminal is reconnected and the shell never knows you were gone." There is no `kill`-style signal; the closest analogue to destroying a session is "to destroy your master space bank," after which "your account is simply gone" (top-level banks are usually made non-destructible to discourage the error).

## No universal broker, no root: the creator holds the first key

Hardy: "The universal pattern is that the requestor of the object gets the only copy of the new capability to the new object. He may deposit it in a public or private directory ... send it through the internal mail to a friend, or ... just remember that it is there." Shapiro: "When you create an object, you receive an initial capability to that object. If you have (or can obtain) some other capability that lets you communicate with me, you can transfer the object capability to me." Rudd's fear of a "universal capability broker" that would recreate Unix root is answered directly: "In a sense the kernel is your capability broker ... You do not log in to the kernel as you do root." And on making capabilities from nothing: "At no point do you get to make up capabilities from whole cloth."

## Objects are active; capabilities are copied, not delegated

Hardy: "At the kernel abstraction level, only domains act. All other kernel objects are passive. Most user constructed objects are passive in that they wait around to be called or invoked ... Ideally they compute furiously and return." Shapiro corrects the word "delegate": "In EROS, capabilities are not really delegated. They are copied. Once I send a capability to you, you hold the capability in the same first-class way that I do. I can not just reclaim it."

Because a copy cannot be reclaimed, revocation is a deliberate construction, not a built-in. Hardy: "I cannot take back a capability that I have sent to you but I can send you a version B, of a capability A which I can prearrange to be able to nullify. Until I nullify (revoke) B it will behave just as A." (He points at his Rescind note and proposes a user interface where such revocable wrappers, plus a sender-side record of what was sent to whom, are the default; "We did not do this in KeyKOS.") This is the primary-source antecedent of the caretaker pattern and the library's [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md) concept.

## Namespaces are not capabilities (Plan 9 / Inferno)

Rudd asks whether Plan 9 / Inferno per-process name spaces are like capabilities. Shapiro: "The models are extremely different. In Plan 9 and Inferno, everything is done with access control lists. You have a name space, and at each open call you must present credentials." He grants the analogy is "worth considering further," and Rudd relays the Inferno community's view that "the ability to name a resource functions similar to a capability" because there is no universal name space, only per-process ones. On distributed EROS: "There isn't one. Our view is that when we know how to build one secure node it will be reasonable to contemplate connecting two of them together." (E and CapTP are where that distributed story is actually built; see the [2001 off-line-representation-vs-protocol section](cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md).)

Source: [cap-talk 2000-August archive](http://www.eros-os.org/pipermail/cap-talk/2000-August/) (Internet Archive original-bytes snapshot `web/20130603003816id_/.../2000-August.txt.gz`, sha256 `d7fb39c7`), messages by John Rudd, Jonathan S. Shapiro, Norman Hardy, and David L. Nicol, 2000-07-26 to 2000-08-22. Rudd's opening questions appear in the [2000-July bundle](http://www.eros-os.org/pipermail/cap-talk/2000-July/) (sha256 `52cc13f4`).
