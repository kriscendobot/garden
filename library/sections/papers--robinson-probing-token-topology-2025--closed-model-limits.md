---
title: Closed-model applicability, limits, and system implications
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

# Closed-model applicability, limits, and system implications

> Abstract: In principle, a closed model's token topology can be reconstructed without weights, but practical black-box use requires exhaustive per-token prompting, stable context reset, adequate probability estimates, and an API that exposes or permits the needed token-level observations. Sampling error, cost, hidden serving transformations, and prompt-prefix geometry limit the result; the method should be treated as a research probe, not a safety certification.

The closed-model case is the paper's central advance and its hardest operating regime. If full probabilities are unavailable, repeated sampled responses must estimate a heavy-tailed distribution. Runtime scales with vocabulary size and repeats, even though queries parallelize. High coordinate noise can change inferred topological features. Providers may also insert hidden system prompts and sampling transforms; a stable hidden prefix is compatible with the theorem's fixed-prefix shape, but an API that changes hidden state between calls is not obviously so.

The method preserves topology rather than distances: recovered curvature values differ markedly from those computed on the original embedding. The experiment covers one open model and validates local dimension as a proxy. Longer prompt templates, geometric effects of different prefixes, broader model replication, and reliable topology tests remain open work.

For an agent system, these limits imply a bounded evaluation lane: a model-routing or regression signal can supplement behavioral tests, while rate, cost, network, and tool authority remain capability-controlled. The probe reveals information about a model; it does not prevent the model from producing an unsafe action.

Source: [Probing the Topology of the Space of Tokens with Structured Prompts](https://doi.org/10.3390/math13203320) (2025), PDF SHA-256 `81d7ad5505f0`.
