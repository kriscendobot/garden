---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/3-evaluator.md
source_content_sha256: 06d24cd6225d7d4f1063978b07f0a262b3788e18b22a532e18ebc08a848c4d62
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 2
status: current
notes: "TC39 Compartments layer 3 (3-evaluator.md), Evaluators (Stage 1). Default branch `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments/blob/master/3-evaluator.md. This is the layer the fresh minimal-Compartments design DEFERS when it shares the surrounding realm's global object. Part of the tc39-module-harmony cluster (job scholar-research-module-harmony-compartments-layers)."
---

The **Evaluators** layer (layer 3) adds an `Evaluators` constructor producing a fresh `eval`, `Function`, and `Module` whose execution contexts refer back to that evaluator set, with a given global object and a virtualized `importHook`/`importMeta`. It is the layer that supplies a *distinct global object without a distinct realm*: spec-level, execution contexts and the evaluator instances rebind from *realm* to *evaluators* (a `[[Context]] → [[Evaluators]] → [[Realm]]` indirection) so multiple evaluator sets can coexist in one realm; direct eval is unchanged but the creator must thread `evaluators.eval` into scope. Motivation is domain-specific languages (a per-entrypoint global, concurrently, without realm identity-discontinuity) and the principle of least authority / supply-chain isolation (including TC53 embedded hosts with no origin for a same-origin policy). The open question is the shared-vs-separate-`globalThis` axis — exactly the global-object-sharing choice a minimal Compartments spec that shares the surrounding realm's global is deferring.

| Section | Topics | Status |
|---------|--------|--------|
| [evaluators-constructor-and-realm-rebinding](../sections/tc39-module-harmony--compartments-evaluator--evaluators-constructor-and-realm-rebinding.md) | module-harmony, compartments | current |
| [evaluators-motivation-dsl-and-least-authority](../sections/tc39-module-harmony--compartments-evaluator--evaluators-motivation-dsl-and-least-authority.md) | module-harmony, compartments | current |
