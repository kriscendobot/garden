---
id: token-subspace-topology
aliases: ["token subspace", "token-space topology", "LLM token topology", "stratified token manifold", "behavioral embedding recovery"]
topics: [llm-token-space-geometry]
---

# token-subspace-topology

An LLM's **token subspace** is the finite vocabulary as placed by the learned input-embedding map inside a higher-dimensional latent space, treated as samples from a supporting topological space. Robinson and collaborators report that this space is better modeled as varying-dimensional attached strata than as one manifold, and show that systematic response measurements can reconstruct its topology up to homeomorphism. This provides model diagnostics, not a security boundary: it may locate behavioral discontinuities or model-version changes, while object-capability confinement still determines what a model-driven agent can affect.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [estimators](../sections/papers--robinson-structure-token-space-2024--estimators.md) | Defines scalable measurements for local dimension and curvature. |
| [empirical findings](../sections/papers--robinson-structure-token-space-2024--empirical-findings.md) | Reports stratified, negatively curved token spaces in three open models. |
| [safety interpretation](../sections/papers--robinson-structure-token-space-2024--safety-interpretation.md) | Separates useful model diagnostics from security enforcement. |
| [structured prompt recovery](../sections/papers--robinson-probing-token-topology-2025--structured-prompt-recovery.md) | Reconstructs token topology from observable model responses. |
| [theorem and validation](../sections/papers--robinson-probing-token-topology-2025--theorem-and-validation.md) | States the genericity bound and the limited one-model validation. |
| [closed-model limits](../sections/papers--robinson-probing-token-topology-2025--closed-model-limits.md) | Bounds what the black-box method establishes in practice. |

## See also

- [[object-capability]] — authority-by-reference model used by Endo to constrain effects independently of model reliability.
- [[principle-of-least-authority]] — the deployment discipline that bounds consequences even when an LLM behaves unpredictably.
- [[policy-vs-capability-authorization]] — why model evaluation and policy do not substitute for capability-level enforcement.
- [[model-routing]] — a possible consumer of token-topology regression signals, after target-model validation.
