---
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_title: "Robust and Compositional Verification of Object Capability Patterns (Long Version)"
source_year: 2017
source_venue: "OOPSLA 2017 (Long Version with full appendices); Max Planck Institute for Software Systems, Saarland Informatics Campus"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/robust-and-compositional-verification-of-object-capability-patterns.pdf
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_pdf_pages: 34
ingested: 2026-05-29
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2017 Swasey-Garg-Dreyer paper that **presents OCPL — a Logic for Object Capability Patterns** — *the first program logic for compositionally specifying and verifying OCPs in a language with closures, mutable state, and concurrency*. OCPL is built on **Iris** (the higher-order concurrent separation logic developed for RustBelt). The paper's central technical device is **robust safety**: *programs that export properly wrapped values to their environment can be proven robustly safe, meaning that their untrusted environment cannot violate their internal invariants*. The paper introduces three formal devices: (1) the **HLA** (Higher-order, Locations, Assertions) programming language with assertion expressions tracked by a *goodness bit*; (2) **OCPL** with high vs low locations, the *lift Ψ* logical relation lifting location-predicates to value-predicates, and progressive/non-progressive Hoare triples; (3) the **RobustSafety** meta-theorem stating that verified code returning only low values remains safe (no failed assertions) when linked with arbitrary adversarial untrusted contexts. The paper applies OCPL to three OCPs: (a) **dynamic sealing** (Morris 1973 sealer-unsealer with the intervals worked client); (b) **caretaker** (API + location, with the *temporary-invariant-break* pattern); (c) **membrane** (generalizing per-pattern lifting; the **public membrane** is Google Caja's *language-invariants* pattern verified formally — a backward-compatibility-preserving discipline that lets a library introduce internal invariants without breaking existing clients via shadow locations). The entire metatheory is **machine-checked in Coq**; the formalization is online at `plv.mpi-sws.org/iris/` (OCPL 2017 tag).

The paper is **the third formal-foundation paper in the library's capability-theory cluster**, joining cycle 85's Drossopoulou et al *Reasoning about Risk and Trust* (Hoare-logic for trust-and-risk) and cycle 91's Taly et al *Automated Analysis of Security-Critical JavaScript APIs* (Datalog points-to + soundness theorem for API confinement). The three foundations are complementary:

- **Cycle 85 Drossopoulou** — Hoare four-tuples + `obeys`/`MayAccess`/`MayAffect` for *trust-and-risk* in open-world OCPs.
- **Cycle 91 Taly** — flow-insensitive context-insensitive Datalog points-to + soundness theorem for *API confinement at the JavaScript layer*.
- **Cycle 94 OCPL (this paper)** — Iris concurrent separation logic + RobustSafety meta-theorem for *compositional OCP pattern verification at the program-logic layer*.

The paper directly cites three prior library ingests (cycles 82, 85, 91) and identifies the **actual Stiegler 2006 paper** as *How Emily tamed the Caml* (HPL-2006-116) — resolving the cycle-85 search for the original Stiegler paper, which was *not* the *Reasoning about Risk and Trust in an Open World* paper (that one is Drossopoulou et al 2015b, the cycle-85 paper itself).

The library can cite this paper whenever a design needs:

- **A formal program-logic foundation for OCP verification.** OCPL is Iris-built and Coq-mechanized; suitable for any design that wants formal-with-mechanization guarantees about an OCP's safety properties.
- **The robust-safety meta-theorem.** *Verified code with a low-value postcondition remains safe when linked with arbitrary adversarial untrusted contexts.* The single most quotable formal capability-guarantee.
- **The high vs low location classification.** A verification-time annotation that lets the proof track which locations the verifier trusts privately versus which the verifier shares with untrusted code. Reusable for any separation-logic verification of capability-based code.
- **The lift Ψ logical relation.** Generalizes from location-predicates to value-predicates over higher-order types; reusable for any system that needs *extensional* safety properties.
- **The three formally-verified OCPs.** Dynamic sealing (sealer-unsealer + intervals); caretaker (API + location + temporary-invariant-break); membrane (recursive lifting + public-membrane backward-compatible invariants).
- **The public membrane pattern.** The canonical *backward-compatibility-preserving-with-internal-invariants* discipline; lets a library evolve internal invariants without breaking existing client code.
- **The Iris-Coq-mechanization linkage.** Any design that wants to *eventually* be formally verified can target Iris as the foundation; OCPL shows the approach works for OCPs.

## The argument arc

1. **The readonly motivating example** — wrapping a reference `ℓ` with `readonly` to share read-only access with untrusted code, illustrated by the higher-order question: *what conditions on `ℓ` are needed for `readonly ℓ` to be safely sharable?*
2. **Low-integrity-value concept** (adapted from Abadi 1999 cryptographic-protocol verification) — a value safe to share with untrusted code; *from which no code can possibly extract a direct reference to private state*. Formalized via Iris's logical relation with guarded recursive predicates.
3. **HLA language** — call-by-value λ-calculus with recursive functions, references, fork-based concurrency, *plus assertion expressions and a goodness bit* tracking whether any assertion has failed.
4. **OCPL program logic** — Iris-based concurrent separation logic with high vs low location classification, progressive/non-progressive Hoare triples, and the `lift Ψ` logical relation.
5. **RobustSafety meta-theorem** — verified code returning low values remains safe when linked with arbitrary adversarial untrusted context.
6. **Dynamic sealing** verified (Morris 1973) — six rules `MakeSealSpec` / `SealSpec` / `UnsealSpec` / `UnsealAnySpec` / `SealedInv` / `SealedAgree` with the intervals worked client.
7. **Caretaker** verified — API caretaker (enable/disable wraps any function set) + location caretaker (built on API caretaker); the temporary-invariant-break pattern.
8. **Membrane** verified — generic recursive lift of location-transformations to value-transformations; the public membrane = Caja's language-invariants pattern with shadow locations.
9. **Related work** — Devriese 2016 (Kripke logical relations, closest predecessor); Drossopoulou 2015 (cycle 85; Hoare-logic for trust-and-risk); Taly 2011 (cycle 91; ENCAP Datalog static analysis); ownership types (Clarke 1998, Banerjee-Naumann, Patrignani).
10. **Future work** — Firefox same-origin-policy membrane (sophisticated automatic membrane; OCPL should scale); Coq automation (proofs are tedious-but-tractable; better automation needed).

## For the Endo / Agoric library

This paper is the **canonical formal-foundation for OCP verification at the program-logic level**. The library now has:

- **Cycle 85 Drossopoulou** — Hoare four-tuples for trust-and-risk.
- **Cycle 91 Taly** — Datalog points-to for API confinement.
- **Cycle 94 OCPL (this paper)** — Iris separation logic for compositional pattern verification.

Together these three cover the *formal-foundations trilogy* of capability-program verification. Each handles a complementary dimension:

| Dimension | Cycle 85 | Cycle 91 | Cycle 94 |
| --------- | -------- | -------- | -------- |
| Framework | Hoare four-tuples + obeys/MayAccess/MayAffect | Datalog points-to + soundness | Iris separation logic + RobustSafety |
| Granularity | Specific worked example (escrow exchange) | Specific JavaScript APIs (ADSafe, Sealer-Unsealer, Mint) | Compositional patterns (dynamic sealing, caretaker, membrane) |
| Mechanization | Manual proof | bddbddb Datalog tooling | Coq formalization |
| Trust dimension | Hypothetical trust under multi-case reasoning | Trust as forbidden-label-disjointness | Trust as low-value-vs-high-location separation |
| Strength | Captures dynamic-trust nuances | Decidable, automated | Compositional, mechanized |

The Endo / Agoric library can deploy any of the three depending on the verification need:
- Need to argue about *dynamic-trust nuances* in a single contract? Use Drossopoulou.
- Need to verify *API confinement* statically? Use Taly's ENCAP.
- Need *compositional patterns* with Coq-mechanized proofs? Use OCPL.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [hla-language-program-logic-and-robust-safety](../sections/papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety.md) | capability-security, capability-theory, hardened-javascript | current |
| [three-ocps-verified-dynamic-sealing-caretaker-membrane](../sections/papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane.md) | capability-security, capability-theory, hardened-javascript | current |
| [related-work-iris-foundation-and-future-firefox-membrane](../sections/papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane.md) | capability-security, capability-theory, hardened-javascript | current |

The paper's seven top-level sections (§1 Intro + §2 OCPL + §§3-5 three OCPs + §6 Related Work + §7 Conclusion + appendices A-F) collapse to three argument-cluster sections. §1 + §2 → section 1 (OCPL foundation). §3 + §4 + §5 → section 2 (three OCPs verified). §6 + §7 → section 3 (related work + Iris foundation + future work).

## Provenance

- Fetched 2026-05-29 from `papers.agoric.com/assets/pdf/papers/robust-and-compositional-verification-of-object-capability-patterns.pdf`.
- PDF SHA-256 `e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef`, 34 pages (Long Version with appendices A-F; main paper through page 24).
- OOPSLA 2017 publication (per copyright + acknowledgment of OOPSLA reviewers).
- **First MPI-SWS-authored paper** in the library; **first Coq-mechanized formal-verification paper distinct from Drossopoulou 2015 and Taly 2011**.
- Drafted by the liaison via orchestrator-direct-draft.

## Stiegler-2006 paper identification

This paper's reference [Stiegler-Miller 2006] confirms that the actual Stiegler 2006 paper is *How Emily tamed the Caml* (Technical Report HPL-2006-116, HP Laboratories) — not the *Reasoning about Risk and Trust in an Open World* paper. The cycle 85 ingest correctly identified the Reasoning paper as Drossopoulou-Noble-Miller-Murray 2015b. *How Emily tamed the Caml* would be a future paper-lane candidate; its title suggests it formalizes a capability-safe subset of OCaml.
