---
title: Recovering token topology through structured prompts
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

# Recovering token topology through structured prompts

> Abstract: Robinson, Dey, and Kushner give a black-box procedure that queries each token under one fixed, reset context, repeats generation to estimate selected next-token probabilities, and uses the resulting response vectors as reconstructed coordinates. Under the paper's generic smoothness and dimension assumptions, this preserves the hidden token subspace up to homeomorphism, not metric geometry.

For every token, Algorithm 1 clears the context, appends that token to a fixed prefix, generates a response of length `m`, and repeats the query `r` times to estimate `l` selected token probabilities at each response position. Flattening these measurements yields a coordinate vector for the queried token. With direct access to model logits, one deterministic next-token distribution can replace repeated output sampling.

The construction adapts delay-coordinate recovery from nonlinear dynamical systems. It is attractive for closed models because it depends on observable response behavior, not access to the input-embedding matrix. The recovered coordinates are not the model's original coordinates: a homeomorphism preserves topological properties such as local dimension, clusters, and homology, while distances and curvature may change substantially.

Source: [Probing the Topology of the Space of Tokens with Structured Prompts](https://doi.org/10.3390/math13203320) (2025), PDF SHA-256 `81d7ad5505f0`.
