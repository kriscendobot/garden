---
title: Estimating local dimension and Ricci scalar curvature
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

# Estimating local dimension and Ricci scalar curvature

> Abstract: Robinson, Dey, and Sweet estimate two local properties of an LLM's learned token point cloud without constructing a simplicial complex: dimension from the slope of log neighborhood volume against log radius, and Ricci scalar curvature from the next quadratic term. Abrupt changes in the fitted dimension are evidence against a single-manifold model and for attached strata of different dimensions.

The input embedding places the model's finite vocabulary in an ambient Euclidean latent space. The authors treat these points as samples from a supporting token subspace and count how many embedded tokens lie in balls of increasing radius around each token. For a locally smooth space, small-ball volume scales primarily as a power of radius determined by local dimension; curvature contributes a higher-order correction. Linear regressions over log volume and log radius therefore give a scalable estimator of local dimension followed by a residual-based curvature estimate.

This construction avoids persistent-homology's explicit simplex growth, though it depends on choices of radii, approximate local uniformity, and the ambient embedding's metric. A knee or abrupt slope transition in a volume-versus-radius curve indicates that neighborhoods are changing effective dimension, the signature used here for stratification.

Source: [The structure of the token space for large language models](https://arxiv.org/abs/2410.08993) (2024), PDF SHA-256 `f105a7c3674`.
