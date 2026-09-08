---
title: Stratified token spaces and negative curvature
source: The structure of the token space for large language models
source_kind: paper
source_authors: [Michael Robinson, Sourya Dey, Shauna Sweet]
source_year: 2024
source_venue: arXiv:2410.08993v1 [math.DG, cs.AI]
source_url: https://arxiv.org/abs/2410.08993
source_pdf_sha256: f105a7c3674a3fd81c83f1db567ffb2f8f0e45ca996e68f6620bfe7e7fac02e2
ingested: 2026-09-08
ingested_by: scholar
topics: [llm-token-space-geometry]
status: current
---

# Stratified token spaces and negative curvature

> Abstract: Measurements over GPT-2, Llemma-7B, and Mistral-7B support a token subspace made of attached manifolds with varying local dimension rather than one manifold; fitted curvature is strongly negative within the observed strata. Numeric-token organization differs sharply by model and correlates with the models' mathematical fluency, but the evidence is observational rather than a causal safety guarantee.

Across all three studied open-weight models, local dimension varies abruptly along connected regions. The authors interpret this as strong evidence for stratified manifolds. The token subspace's estimated dimension is also far below the ambient embedding dimension, with fine-tuned Llemma-7B and Mistral-7B showing especially large codimension.

GPT-2's numeric tokens cluster on a comparatively low-dimensional connected region, while many numeric tokens in the math- and code-oriented models are separated from one another. The paper relates this structural difference to the models' different numerical performance. Estimated Ricci scalar curvature is substantially negative across the three models, with variations by stratum.

These results are model-specific measurements over three moderate-size models. Correlation between topology, curvature, and fluency motivates hypotheses about inference and retraining instability, but does not itself establish causation or a model-independent predictor.

Source: [The structure of the token space for large language models](https://arxiv.org/abs/2410.08993) (2024), PDF SHA-256 `f105a7c3674`.
