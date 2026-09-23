---
title: "Principal policy and confinement debate"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-November.txt.gz
source_content_sha256: e8ae4d7b298314e98a9030b008c37daeb846a9cb0f457751c6a889fd5fa298aa
source_authors: [Jonathan S. Shapiro, Mark S. Miller, Norman Hardy, Al Gilman, Andre Stemmet]
source_date: 1999-11-01
thread_subject: "Capability vs ACL's"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The November thread makes explicit a disagreement among capability advocates. Everyone accepts that an unrestricted program can proxy or disclose authority. Miller's position, as Shapiro reports it, is that capabilities capture the protections enforceable in the real world and principal-based ACLs often assert unenforceable ones. Shapiro leaves more room for principal policy when programs begin inside suitable confinement compartments and a reference monitor mediates their channels. Gilman presses the countercase: trusted computation can test an agent predicate, perhaps including multi-party or biometric authentication. The archive does not resolve whether these controls establish the intended human principal or merely another mediated program state.

## People do not directly hold machine authority

Programs hold authority on people's behalf. A computer cannot generally tell whether a program exposes authority because its user intended that result, because it is malicious, or because it was tricked. This reframing weakens claims that an ACL entry naming a person proves who caused an effect.

## Confinement may make narrower policies enforceable

Shapiro distinguishes unrestricted programs from programs born into controlled compartments. A confinement boundary can restrict channels, and a labeled lattice can be built from compartments. He therefore resists the strongest claim that every principal-oriented policy is impossible, while agreeing that commodity systems frequently misapply them.

## The unsettled question

Gilman's multi-key and biometric examples ask whether a trusted predicate over candidate agents can define a useful ACL class. The proxy objection remains: authenticating a body or credential does not prove who directs the software using it. The thread ends with the policy goal, enforcement mechanism, and attribution claim still partly conflated, making it a useful warning rather than a settled theorem.

Source: [cap-talk 1999-November archive](http://www.eros-os.org/pipermail/cap-talk/1999-November/) (Internet Archive original-bytes snapshot, sha256 `e8ae4d7b`), thread contributions attributed to Jonathan S. Shapiro, Mark S. Miller, Norman Hardy, Al Gilman, and Andre Stemmet, 1999-11-01.
