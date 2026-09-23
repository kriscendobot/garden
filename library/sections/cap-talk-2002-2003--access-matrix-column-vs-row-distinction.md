---
title: "An access-control-matrix model of capabilities: column versus column-and-row"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-May/
source_snapshot: http://web.archive.org/web/20160729233100id_/http://www.eros-os.org/pipermail/cap-talk/2003-May.txt.gz
source_content_sha256: 60b919c86e2817d0e8bd20b8715cd75374779b6749313c8f6f13385d2b098c97
source_authors: [David Wagner, Jonathan S. Shapiro, Mark S. Miller, Zooko]
source_date: 2003-05-28 to 2003-05-31
thread_subject: "an access control matrix model of capabilities / \"a matrix model of capabilities\" redux"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages. Extends the access-matrix framing indexed under cap-talk-2002-2003--normal-users-can-construct-least-authority (2003-April)."
---

Abstract: The May 2003 access-matrix thread tests Zooko's candidate for *the* key distinction between ACLs and capabilities, expressed over Lampson's access-control matrix. His "Idea 3": to extend a privilege in an ACL system you need access to the resource — the matrix *column*; to extend it in a capability system you need access to the resource *and* to your intended recipient — the *column and the row*. David Wagner opens by insisting ACL systems can also signal intention explicitly: Unix `seteuid`/`setegid` is the ACL analogue, where a setgid `write(1)` enables its special authority (`setegid(tty)`) only when it intends to use it, avoiding a confused deputy at the cost of care and discipline. Wagner is unconvinced Idea 3 is decisive — it enables covert-channel countermeasures he is skeptical of, and the transitive-reachability assurance argument it supports (from the Dean-Wagner DARPA report) might also be reconstructed for well-engineered name-based ACLs. Jonathan Shapiro grounds the matrix historically (the "own" right is in Lampson's *Protection* paper, reflecting then-common practice) and warns that the discretionary reading is dangerous: `setegid` is a purely discretionary control, and a penetrated untrusted program will simply reactivate any authority merely "disabled" that way. Mark Miller points to his erights.org "perspective game," where the same distinction appears at the foundations, before confinement.

## Idea 3: the extra factor is the recipient

Zooko's formulation isolates what possession adds. Both models need authority over the resource to hand it on; capabilities additionally require a reference to *whom* you are handing it to. That second factor is what makes the capability graph a graph — authority flows only along existing references — and is the basis for reasoning about transitive reachability.

## Wagner's caution: ACLs can be explicit too

Wagner's `write(1)` example is the standing rebuttal to "ACLs are inherently ambient." A disciplined setuid/setgid program signals its intent by toggling its effective ids, which is how one avoids confused deputies in Unix. His skepticism is that Idea 3's practical payoff (covert-channel resistance, transitive-reachability assurance) is either uninteresting or replicable by careful ACL engineering.

## Shapiro's caution: discretionary controls do not survive untrusted code

Shapiro's point cuts the other way. `setegid` disabling authority is discretionary — it relies on the program not choosing to re-enable it. Against untrusted, penetrable code (which, over 100K lines, is effectively all code, since we cannot inspect it), the attacker reactivates the authority; this is routine in real penetrations. The capability model's advantage is not that it can signal intention — ACLs can too — but that authority a subject never received cannot be reactivated at all. The thread thus reframes the ACL-vs-capability question from expressiveness to what holds under a hostile, un-inspectable program, the assumption the 2003 paper era builds on.

Source: [cap-talk 2003-May archive](http://www.eros-os.org/pipermail/cap-talk/2003-May/) (Internet Archive original-bytes snapshot `web/20160729233100id_/.../2003-May.txt.gz`, sha256 `60b919c8`), messages dated 2003-05-28 to 2003-05-31.
