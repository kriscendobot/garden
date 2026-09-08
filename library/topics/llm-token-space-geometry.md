# Topic: llm-token-space-geometry

> Abstract: Topological and geometric study of the learned subspace occupied by an LLM's token embeddings: local dimension, stratification, curvature, behavioral correlations, and black-box reconstruction from systematic prompts. This is a model-characterization and evaluation topic, distinct from `context-engineering` (choosing inference context), `frontier-model-apis` (backend access and features), and `capability-security` (confining what model-driven agents may do).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [estimators](../sections/papers--robinson-structure-token-space-2024--estimators.md) | Robinson, Dey, Sweet 2024 | Estimates local dimension and Ricci curvature from neighborhood-volume scaling without constructing simplicial complexes. |
| [empirical findings](../sections/papers--robinson-structure-token-space-2024--empirical-findings.md) | Robinson, Dey, Sweet 2024 | Three open models exhibit varying-dimensional strata and strongly negative fitted curvature, correlated with numerical fluency. |
| [safety interpretation](../sections/papers--robinson-structure-token-space-2024--safety-interpretation.md) | Robinson, Dey, Sweet 2024 | Token-space structure motivates uncertainty and regression diagnostics but does not provide authorization or confinement. |
| [structured prompt recovery](../sections/papers--robinson-probing-token-topology-2025--structured-prompt-recovery.md) | Robinson, Dey, Kushner 2025 | Fixed-prefix per-token response statistics reconstruct hidden token topology up to homeomorphism, not metric geometry. |
| [theorem and validation](../sections/papers--robinson-probing-token-topology-2025--theorem-and-validation.md) | Robinson, Dey, Kushner 2025 | A generic smooth embedding theorem supports the method; one Llemma-7B experiment validates local dimension as a proxy. |
| [closed-model limits](../sections/papers--robinson-probing-token-topology-2025--closed-model-limits.md) | Robinson, Dey, Kushner 2025 | Closed-model use faces exhaustive prompting, sampling, reset, API, cost, and hidden-serving-state constraints. |

## See also

- [frontier-model-apis](frontier-model-apis.md) — APIs through which a closed-model probe might run, subject to their token/log-probability and rate-limit surfaces.
- [local-model-serving](local-model-serving.md) — open or locally served models provide direct logit and embedding access for cheaper, deterministic measurements.
- [capability-security](capability-security.md) — the enforcement layer that limits consequences when model behavior remains uncertain.
- [agent-conventions](agent-conventions.md) — behavioral threat classes, including prompt injection, that token topology does not itself resolve.
