---
title: Common confusions
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "9-22 (§3 Dynamic Sealing + §4 Caretaker + §5 Membrane)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane
---

- **"The intervals client's robust safety is obvious."** It would be obvious *if* one could trust untrusted code to pass real interval handles. But untrusted code can pass *anything*. The robust-safety argument is that *even when arbitrary garbage is passed*, the verified code either (a) gets stuck (via assume-failure on unseal) or (b) succeeds with a verified-interval, never (c) silently corrupts. The proof relies on UnsealAnySpec's *may-get-stuck* triple semantics.
- **"The caretaker's disable is racy with the wrap call."** The `sync` lock serializes them. Even if disable and wrap-call happen concurrently, the sync lock makes them mutually exclusive: either disable wins (and the wrap-call sticks on `assume(!enabled)`) or the wrap-call wins (and disable waits for it to finish). The verified code's invariant survives either ordering.
- **"The membrane is just a wrapper."** It is a *recursive* wrapper that lifts location-transformations to value-transformations. Simple wrappers (per the readonly motivating example) handle individual references; the membrane handles *all values transitively reachable from a wrapped value*. The recursive-instantiation structure is what makes the membrane powerful.
- **"The public membrane breaks encapsulation."** It *preserves* encapsulation through the shadow-location indirection. From the client's perspective, the shadow location is *the* location; from the library's perspective, the shadow is mediated and can be re-aligned with the private location whenever the invariant should be restored. The encapsulation is *bidirectional* (writes propagate via `pubunwrap` + checks; reads propagate via `shadowread` + invariant-check).
- **"OCPL can verify Caja itself."** OCPL verifies *patterns* (sealer-unsealer, caretaker, membrane). Caja is a *language sandbox* that uses these patterns. Verifying Caja proper would require modeling Caja's broader semantics (JSLint filter, ADSafe runtime, etc.) — out of scope for the OCPL paper but tractable as future work.
- **"The intervals interval ordering is not preserved across untrusted code."** The proof shows the ordering *is* preserved as long as the unseal calls succeed. If untrusted code passes a non-interval value, the *unseal* gets stuck before any ordering check happens — the verified-code-side invariants never see the bad value.
