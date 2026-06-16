---
title: Implications for Endo
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction
---

This paper is the upstream root for the **eventual-send / vat / promise-pipelining** triad that Endo's `@endo/eventual-send` package realizes. Endo's API differs in surface (JS function-style `E(remote).foo()` vs E's infix `remote <- foo()`) but is semantically the same: the paper's primitive split (immediate-call vs eventual-send) is the same split JS makes between synchronous `.` and `await E(...)`.

The paper's framing of plan-coordination-as-the-real-problem grounds an Endo design discipline: when designing a daemon-facing API, the question is not "is this thread-safe" but "does this API let independent agents' plans cooperate without forcing them to know about each other's internal state". The `statusHolder` example's translation into Endo would be a daemon-side handle holding a `setStatus` capability + a `subscribe(handler)` capability — the same separation the paper introduces in §7.2 (statusGetter/statusSetter) as a POLA refinement.

The Hayekian aside (Footnote 1) prefigures a recurring theme in Endo / Agoric / OCapN: *encapsulation of authority is to plan coordination what property rights are to human cooperation*. This is the philosophical scaffold for the principle-of-least-authority discipline running through later sections and through the entire Endo lineage.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
