---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-08T22:00:10Z
---
# Token-space topology papers: relationship to Garden and Endo AI safety

Ingested two papers as six library sections:

- Michael Robinson, Sourya Dey, and Shauna Sweet, *The structure of the token space for large language models* (2024), 3 sections, PDF SHA-256 `f105a7c3674a3fd81c83f1db567ffb2f8f0e45ca996e68f6620bfe7e7fac02e2`.
- Michael Robinson, Sourya Dey, and Taisa Kushner, *Probing the Topology of the Space of Tokens with Structured Prompts* (2025), 3 sections, PDF SHA-256 `81d7ad5505f068fc5feed289f639b364147d2a9ba0dadc18a02b3ff833399d71`.

The 2024 work estimates local dimension and Ricci scalar curvature directly from open-model token embeddings and reports varying-dimensional strata plus strongly negative fitted curvature across GPT-2, Llemma-7B, and Mistral-7B. The 2025 sequel converts a fixed-prefix, per-token response experiment into reconstructed coordinates and proves a generic Whitney/Takens-style embedding result: with enough suitable measurements, the response map preserves a compact bounding manifold and therefore the token set up to homeomorphism. Its Llemma-7B experiment validates local dimension as a proxy, not full homeomorphism.

Headline judgment: the work is useful to Garden as a future **model-characterization and regression signal**, especially for qualifying local backends, comparing fine-tunes or quantizations, and selecting boundary regions for targeted behavioral tests. It is not yet a practical fleet gate: the black-box method needs stable context reset, per-token prompts, enough probability observations, and substantial sampling; it has been validated on one open model, and topology does not recover metric geometry, semantic correctness, prompt-injection resistance, or tool-use safety.

The relationship to Endo is complementary and intentionally orthogonal. These papers investigate why a probabilistic model may behave discontinuously or become unstable under retraining. Endo's SES and object-capability discipline constrain which effects the model-driven agent can cause even when the model is wrong. In shorthand: topology can help estimate **where behavior may be unreliable**; Endo limits **what unreliable behavior is authorized to affect**. A Garden experiment should therefore run the probe behind narrow rate, cost, storage, and network capabilities and feed its output into model evaluation/routing, never treat a favorable topology measurement as authority or certification.

Library updates: new topic `llm-token-space-geometry`; new concept `token-subspace-topology`; source, topic, concept, keyword, section, and projected indexes updated. No follow-on job was posted because both requested papers fit this cycle's six-section budget.

Verification: `library-link-check.sh --source-slug` passed for both sources after landing; `regenerate-topics-counts.sh --check` reported current; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` landed the generated indexes.

Self-improvement: nothing this time.
