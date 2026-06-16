---
title: Abstract
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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining
---

Section 8 introduces **promises** as the return-value of an eventual-send and **pipelining** as the streaming optimization that lets `def r3 := x <- a() <- c(y <- b())` ship three messages in one network round-trip. A promise is initially an *eventual reference for the result*; the eventual-send's pending-delivery carries a *resolver* (the right to choose what the promise designates), and when the spawned turn completes the vat reports the outcome to the resolver, *resolving* the promise so it becomes a reference to the *resolution*. Messages may be eventual-sent to a promise *before* it resolves; they buffer in FIFO order within the promise and forward in order once resolution lands. Pipelining (§8.2) extends this to remote vats: if `x` and `y` live on `VatR`, the three pending deliveries are serialized and streamed to `VatR` together; `VatR` queues the first two locally (since their targets are known), and sends the third on a local promise whose resolver is the answer to `a()`. The "Three-Vat-Attack" geometry (where `r1` resolves to a third vat) shows how `c(r2)` is *forwarded* to wherever `r1` resolves, not held back at the originating vat. Latency is the motivation: bandwidth and buffers improve, but the speed of light is fixed; pipelining symmetrically generalizes Bogle's "Batched Futures" (BL94) and is critical for plan composition over a high-latency link. §8.3 names **datalock** (circular data dependencies that prevent progress, like the `epimenides` self-referencing promise), distinguishes it from deadlock (datalock manifests reproducibly, deadlock manifests sporadically), and reports two datalock bugs in 60-programmer-years of experience. §8.4 introduces the **explicit promise** primitive `def [p, r] := Ref.promise()` for hand-rolled postponement. §8.5 introduces **broken-reference contagion**: an exception that terminates an eventual-sent turn does *not* signal back into the caller's control flow; instead the vat catches it and *breaks* the promise by resolving it to a *broken reference* containing the exception. Immediate-call on a broken reference throws; eventual-send on a broken reference breaks the new send's promise with the same exception. The control-flow / data-flow split parallels signaling vs non-signaling NaNs in IEEE floating point: broken-reference contagion *does not hinder pipelining* in the way thrown exceptions would.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
