---
title: "The Three Laws of Security: integrity, availability, confidentiality, in that order"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-April.txt.gz
source_content_sha256: 42f9e9e68c840b78c8e926839d54b6765df86c1a5f6681d967cab8dd83100ccd
source_authors: [Mark Miller, David Barbour, Jonathan Shapiro]
source_date: 2010-04-02
thread_subject: "The Tree Laws of Security"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. The subject line's \"Tree\" for \"Three\" was a typo the thread kept as a running joke."
---

Abstract: On April 2, 2010 Mark Miller posted a compact, Asimov-styled formulation of the classic confidentiality/integrity/availability triad as three ordered laws governing a single object, deliberately mirroring Asimov's Three Laws of Robotics so that each law is subordinate to the ones before it. Law of Integrity: "An object may not injure its invariants, nor, through lack of defense, allow its invariants to come to harm." Law of Availability: "An object must obey the messages sent to it by its clients, except when doing so would conflict with the integrity law." Law of Confidentiality: "An object must protect the secrets entrusted to it, as long as such protection does not conflict with the integrity or availability laws." The formulation's content is the *ordering*: integrity is paramount, availability is subordinate to integrity, and confidentiality is subordinate to both. That ordering is what the thread contested. David Barbour immediately objected that he was "not convinced that Confidentiality shouldn't supersede Availability," making the priority of the last two laws a genuine, unsettled disagreement rather than an obvious ranking.

## The formulation and its ordering

The Asimov mapping is exact: as a robot's Second Law yields to its First and its Third to both, an object's availability obligation yields to its integrity obligation and its confidentiality obligation yields to both. Read operationally for an object-capability object, integrity comes first because an object that cannot defend its own invariants cannot be trusted to do anything else correctly (a defensively-correct object must never be driven into an inconsistent state by any sequence of client messages). Availability comes next: subject to keeping its invariants, an object should answer its clients. Confidentiality comes last: an object protects entrusted secrets only when doing so does not force it to violate an invariant or refuse a legitimate service. Barbour also suggested integrity might be better framed "in terms of contracts than invariants," questioning the assumption that objects can "own" invariants.

## The disputed ranking

Barbour's challenge is substantive, not pedantic. There are real systems where leaking a secret is worse than refusing service (a key-management object, a medical-records store), which argues confidentiality should outrank availability; and there are systems where refusing service is the greater harm. Miller's ordering encodes a specific stance (an object that stonewalls its clients to protect a secret has failed at being a useful object more fundamentally than one that reveals a secret), but the thread does not establish that ordering as universal. Whether a fixed global ranking of the triad is even the right shape, versus a per-object or per-contract policy, is left open.

## Bearing on Endo

The Integrity-first law is the on-list statement of *defensive correctness*, the property Endo's remotables and hardened objects are built to have: a `harden()`-ed exo must maintain its invariants against every possible client message sequence, which is exactly "may not injure its invariants, nor allow them to come to harm." Availability-subordinate-to-integrity is the reason Endo objects may throw or refuse rather than proceed into an inconsistent state, and confidentiality-last is the reason a capability's protection of a held secret never justifies corrupting itself. The disputed availability-versus-confidentiality ranking is recorded as open question 51. See the [[principle-of-least-authority]] and [[object-capability]] concepts, and the neighboring [cap-talk-2009-2012--defensive-correctness-versus-consistency](cap-talk-2009-2012--defensive-correctness-versus-consistency.md) section on what "defensive correctness" demands.

Source: [cap-talk 2010-April archive](http://www.eros-os.org/pipermail/cap-talk/2010-April/) (Internet Archive original-bytes `id_` snapshot of `2010-April.txt.gz`, sha256 `42f9e9e6`), thread "The Tree Laws of Security", 2010-04-02.
