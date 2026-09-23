---
title: "Process allocation, branding, and the minimal TCB (the No Domain Creator debate)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-November/
source_snapshot: http://web.archive.org/web/20130603011234id_/http://www.eros-os.org/pipermail/cap-talk/2000-November.txt.gz
source_content_sha256: 77a320166ed3cf7c699f5dbe553ff9a7bf9aa2ab29400b14947824540d1d7882
source_authors: [Charles Landau, Jonathan S. Shapiro, Bill Frantz, Joerg Bornschein]
source_date: 2000-11-07
thread_subject: "On the other hand (process tool restriction)"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. EROS-architecture-specific, retained for its capability-design content (branding as rights amplification, the minimal-TCB argument, resume-key semantics)."
---

Abstract: The November 2000 "process tool restriction" thread (largely EROS-architecture, cross-posted to eros-arch) works out who should allocate and *brand* processes/domains, and it surfaces two capability-design ideas worth carrying past EROS. Charles Landau's "No Domain Creator" proposal argues the domain/process creator is unwise and that the space bank should allocate processes; Shapiro concurs on the migration but debates whether *branding* (the factory's "did you create this?" test) should move with it. Frantz proposes a write-once brand slot plus a separate brand tool. The load-bearing capability idea: branding is a rights-amplification primitive, and the "is this your yield?" test lets a factory verify a process it built without holding excess authority. The second idea, from the parallel call-count thread: consuming the resume capability on use is a bug-catching feature, not a security feature.

## Move allocation to the space bank; keep branding separable

Landau (citing his NoDC proposal): the domain/process creator "is unwise, which implies that the domain/process tool should be restricted to the space bank." Shapiro agrees the space bank should allocate processes because "the decision to implement processes as a collection of nodes is an accident of implementation ... there is no good reason for this accident of implementation to be exposed," and doing so lets "the simple fact that a process capability/key exists" be "a priori proof that the process is well-formed."

But allocation and branding are orthogonal: "the decision about who allocates processes is orthogonal to the decision about who brands them." The factory/constructor "must be able to answer the question: did you create this process?" Shapiro's engineering conclusion is to keep the brand tool separate from the space bank and let the factory hold it directly, because "there is no amplification of authority from letting the factory/constructor also hold the brand tool in addition to the space bank. It already knows that the source of space is trusted." Frantz's brand-slot mechanism: a write-once (later refined to write-with-knowledge-of-the-old-value) slot on the domain, with "a separate brand tool" providing the compare-equal operation, so a Trojan cannot steal the brand key.

## Branding as rights amplification, and the "is this your yield?" test

The brand mechanism is a rights-amplification construction: the brand tool "is in cahoots with the kernel concerning the process abstraction. The branding mechanism should work only on a well-formed process, and only the kernel is in a position to say officially whether a process is well formed." Validating a brand discloses nothing (the test brand is not revealed by the brand tool), so a factory can confirm "I built this" without leaking its brand. This is the same amplification-from-a-held-reference shape the 1999 seals/equality thread describes (see [rights-amplification-from-seals-and-equality](cap-talk-1999--rights-amplification-from-seals-and-equality.md)).

## The minimal TCB spans kernel and space bank

Landau argues the kernel should not trust the space bank ("In KeyKOS the kernel did not trust the space bank"). Shapiro replies that for trust purposes the distinction is null: "both of these things are in the minimal possible TCB. No reasonable system can be built without trusting both the source of storage and the source of processes." Good engineering paranoia still argues for minimal mutual assumptions, "but not security reasons." This is the November instance of his July claim that the TCB is per-application, not singular (see [the-tcb-is-not-singular](cap-talk-2000-2001--the-tcb-is-not-singular.md)).

## Resume-key consumption is bug catching, not security

In the parallel "Questioning need for Call Count" exchange, Joerg Bornschein worries that checking serial numbers in user space "would be the first concept in EROS which relied on some kind of password capability," open to brute force. Shapiro reframes it: "I believe you may be confusing a security feature for a bug catching feature. The consumption of the resume capability on use is not a security feature ... The issue here is catching bugs in servers that return multiple times." Whether the once-only resume semantics deserve kernel enforcement or a cheaper user-level check remains an open EROS design question in the thread.

Source: [cap-talk 2000-November archive](http://www.eros-os.org/pipermail/cap-talk/2000-November/) (Internet Archive original-bytes snapshot `web/20130603011234id_/.../2000-November.txt.gz`, sha256 `77a32016`), messages by Charles Landau, Jonathan S. Shapiro, Bill Frantz, and Joerg Bornschein, 2000-11-06 to 2000-11-13.
