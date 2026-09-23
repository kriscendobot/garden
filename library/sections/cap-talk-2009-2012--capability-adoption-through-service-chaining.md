---
title: "Capability adoption through service chaining"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-January.txt.gz
source_content_sha256: 1f363c176cbab71d236b7da358f59b37e6b4e31aa094080f915d00db9e517da2
source_authors: [Alan Karp, David Barbour, James A. Donald, Rob Meijer, Tim Freeman, Mark Stiegler]
source_date: 2011-01-03 to 2011-01-10
thread_subject: "Some good advice for disruptive technologies"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Alan Karp asked for the capability-security equivalent of a product demonstration that makes a disruptive technology fit an ordinary routine. The thread split between hiding the mechanism behind a familiar interface and exposing attenuation and delegation so users can gain powers that ambient-authority interfaces cannot express. Karp's concrete answer was **service chaining**: Alice asks Bob's service to use Carol's, but identity-based access control has no correct credential for Bob's call. Alice's credential over-authorizes Bob, Bob's credential can authorize work Alice cannot, and their union or intersection also fails. Passing a narrowly scoped capability through the chain carries exactly the authority Alice designated. The thread therefore identifies an adoption pattern, not a security lecture: demonstrate useful composition that is awkward under identity-based access control, while keeping capability plumbing out of the ordinary interface.

## The adoption argument

Karp borrowed the premise that a disruptive invention must be shown working, explained from several angles, and fitted into a routine. Replies warned that capabilities alone are not a product. David Barbour argued for a "killer application" whose useful behavior depends on capability composition, while James A. Donald argued that teaching users capability terminology signals a broken interface: a capability desktop should make file-open and messaging behave as users already expect. Rob Meijer objected that completely hiding attenuation, decomposition, and delegation leaves the user with an ambient-authority interface on a safer substrate and forfeits the model's expressive benefit.

Karp's service-chain example makes the distinction concrete. Alice invokes Bob, and Bob must invoke Carol to satisfy the request. Authentication-centered systems ask whose identity Bob should present. None of the standard answers represents the request's authority: Alice's full identity delegates too much, Bob's identity substitutes his powers for hers, and set operations on their standing permissions do not express the particular act Alice selected. A passed capability represents the act directly. Karp also pointed to a deployed remote-administration demonstration where a narrow capability permits selected privileged commands without revealing the root password. The capability is visible in the protocol but need not appear as a security concept in the UI.

## Bearing on Endo

Endo's eventual-send and sturdy-reference layers support this exact composition. Alice can give Bob one facet for Carol and Bob can forward or further attenuate it without impersonating Alice, consulting a global ACL, or acquiring the rest of her authority. The adoption lesson is also architectural: demonstrate a workflow whose reference graph is simpler than its identity-and-policy equivalent. Do not require a user to understand the graph before receiving its benefit.

Source: [cap-talk 2011-January archive](http://www.eros-os.org/pipermail/cap-talk/2011-January/) (Internet Archive original-bytes `id_` snapshot of `2011-January.txt.gz`, sha256 `1f363c17`), thread "Some good advice for disruptive technologies", 2011-01-03 to 2011-01-10.
