---
title: "The ACL-vs-capability challenge problems (the unsettled equivalence question)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro, Gregory Frascadore]
source_date: 1998-03-18
thread_subject: "Card Keys, capabilities, counters / Challenge Solution"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
---

Abstract: Shapiro posed two concrete challenge problems to test the "ACLs and capabilities are equivalent" intuition, and Frascadore attempted a solution — the founding worked example of the debate the whole list orbits. Challenge scenario 1: process A holds authority over objects W, X, Y and wants to grant B access to X only, and to guarantee B never gains access to *subsequently created* objects Z, Z', Z''. Shapiro's claim: this cannot be solved in the pure ACL model, *can* be solved with "relatively minor surgery" to it, but an *efficient* primitive implementation "appears to be intractable." Scenario 2: implement the UNIX `passwd` program in a purely ACL-oriented model (no setuid, no VMS program-privilege table — those "step outside the ACL model"). This is filed under `cap-talk-open-questions` because it is the list's canonical *unsettled* problem: the participants did not converge in 1998, and the question of whether ACLs and capabilities are equivalent was only settled (in the negative) by *Capability Myths Demolished* in 2003.

## Challenge scenario 1

> Consider two processes A and B. A is a client application, and B is a supporting component that A wishes to create and then use. ... Imagine that A has authority to manipulate objects W, X, and Y ... It wishes to grant to B the right to access X, but not W or Y. In addition, it wishes to ensure that B never gains access to subsequently created objects Z, Z', Z'', Z''' etc.
>
> Challenge 1: Describe a conceptually sound solution to this problem using only ACLs.
> Challenge 2: Design an *efficient* primitive mechanism to implement the key element(s) of your solution.

Shapiro's verdict: "Challenge 1 cannot be solved in the pure ACL model, but *can* be solved with relatively minor surgery to the ACL model. Challenge 2 appears to be intractable. Dynamic allocation of kernel data structures to solve the problem leads to kernel deadlock, and is therefore not acceptable." (The deadlock point recurs in the [select-like service](cap-talk-1998--rescinded-keys.md) discussion of EROS's fixed-size kernel tables.)

## Challenge scenario 2

> Describe how to implement the UNIX passwd program within a purely ACL-oriented model. Remember that the setuid mechanism in UNIX and the program privilege table in VMS are bolt-ons -- they step outside the ACL model.

## Frascadore's attempted ACL solution

Frascadore attempted challenge 1 assuming a Java-VM-like environment where "encapsulation really works and object references cannot be forged," explicitly *excluding* Java security-manager stack-scanning tricks (which he judged outside "the pure ACL model"). His central difficulty was diagnostic:

> The main problem I faced was one establishing the identity of the caller of foobar(). Once foobar() knew the identity of the caller, it was easy to check the ACL.

He built a `Process` class assigning each thread a unique monotonic ID so a called method could recover "who is calling" and consult an ACL. That the *hard part of the ACL solution is reconstructing caller identity* — a thing a capability system never needs, because holding the capability *is* the authority — is precisely the asymmetry Shapiro was pointing at, and the seed of the confused-deputy analysis: an ACL check must ask "who is asking?" and can be fooled about the answer, whereas a capability carries designation and authority together.

## Why this is an open question in the archive

In 1998 the thread did not resolve to a shared conclusion; Frascadore's "ACLs and capabilities are inseparable" intuition and Shapiro's "efficient primitive is intractable" verdict coexisted. The equivalence question is the archive's foundational *unsettled notion*, and its later resolution is external to the list: Miller-Yee-Shapiro's [Capability Myths Demolished (2003)](papers--miller-capability-myths-demolished-2003--equivalence-myth.md) formalizes the four models and shows Model 4 (object-capabilities) is *not* equivalent to ACLs, refuting the Equivalence Myth. See [cap-talk-open-questions](../topics/cap-talk-open-questions.md).

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), messages from Jonathan S. Shapiro (1998-03-18) and Gregory Frascadore (1998-03-22).
