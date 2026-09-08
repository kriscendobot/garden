---
title: Generic embedding theorem and Llemma-7B validation
source: Probing the Topology of the Space of Tokens with Structured Prompts
source_kind: paper
source_authors: [Michael Robinson, Sourya Dey, Taisa Kushner]
source_year: 2025
source_venue: Mathematics 13(20), 3320
source_url: https://doi.org/10.3390/math13203320
source_pdf_sha256: 81d7ad5505f068fc5feed289f639b364147d2a9ba0dadc18a02b3ff833399d71
source_pdf_pages: 22
source_mirror_url: http://web.archive.org/web/2id_/https://www.mdpi.com/2227-7390/13/20/3320/pdf?version=1760709980
ingested: 2026-09-08
ingested_by: scholar
topics: [llm-token-space-geometry]
status: current
---

# Generic embedding theorem and Llemma-7B validation

> Abstract: The paper proves that, for residual sets of smooth measurement and autoregressive functions and enough collected response dimensions, the response map embeds a compact manifold bounding the token set; its restriction therefore preserves token topology. Experiments on Llemma-7B recover local base-dimension estimates from three measurement options, validating dimension rather than full homeomorphism.

The theorem assumes smooth finite-dimensional spaces and maps, a compact bounding manifold of dimension `d`, a fixed context prefix, and an output dimension satisfying a Whitney-style lower bound greater than `2d`. Its genericity statement is ordered: a suitable measurement function is selected first, then almost every compatible autoregressive model works. That is weaker than establishing that a particular production model and API meet the hypotheses.

On open Llemma-7B, the authors compare three response-coordinate choices with the known input embedding. The recovered local dimension aligns primarily with the lower-dimensional base component of the fiber-bundle interpretation reported by the earlier paper. The experiment supports dimension recovery for one model; the authors explicitly do not verify a full homeomorphism, which is computationally and theoretically difficult to test.

Source: [Probing the Topology of the Space of Tokens with Structured Prompts](https://doi.org/10.3390/math13203320) (2025), PDF SHA-256 `81d7ad5505f0`.
