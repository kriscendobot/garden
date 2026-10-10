---
title: OVA evaluation: settings, publication, self-hosting, and lifecycle limits
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: OVA's Settings and publication are functional vertical slices (OVA env vars, a mixed Litestar page, no setting scopes, filesystem-only publication of a mutable `cache.json`, an unhonored `auto_publish`); its self-hosting sample proves only recursive composition, not a clean-cache regenerate-build-test bootstrap; and several sample specs make normative promises their tests do not execute. Versioning, scale, registry recovery, and the coexistence of two development models remain prototype limits to turn into explicit contracts.

**Settings and publication are functional vertical slices, not framework contracts.**

- Core settings are OVA environment variables and paths.
- The Litestar page mixes filesystem discovery, model configuration, cache status, and publication actions.
- There is no setting scope model for repository, workspace, user, machine, and one-run overrides, nor schema migration.
- Publication supports a filesystem target, but not registry capabilities, signed manifests, resumable upload, revocation, retention, or promotion channels.
- Publication copies a whole mutable `cache.json` rather than publishing a signed immutable release manifest, and has no verified pull/import lifecycle.
- `auto_publish` is modeled but neither exposed nor honored; source-security settings are absent.

The neutral core should expose typed settings sections and publication ports that a CLI, JSON API, or optional UI can render; OVA keeps its Litestar presentation.

**The current self-hosting proof is intentionally narrow.** `samples/ova-self-hosting` proves that OVA can be selected as a Component and that a new immutable generated Component can be produced from that composition. The deterministic backend emits a descriptor file; it does not regenerate OVA's complete source tree, rebuild its distribution, run its full tests, or compare behavior. True framework self-hosting requires a clean-cache bootstrap that regenerates a candidate framework revision, builds it with an accepted toolchain and classification, runs conformance tests, and uses the candidate to repeat the process with stable semantic results. Several sample specifications also use normative language for classification, relinking, and self-hosting behavior that their descriptor/fixture tests do not execute; until end-to-end gates exist, those samples are architectural promises rather than implementation evidence.

**Versioning, scale, and operational lifecycle remain early.**

- Component IDs and `kind` use inconsistent validation/taxonomies across manifests, catalog entries, generated records, and packages; several version fields are unvalidated strings.
- Project package metadata and the root Component manifest report different OVA version concepts without a declared relationship.
- Source/index/query preparation is sequential and revisits every usable Component on each generation.
- JSON registries have no general schema migration, recovery scan, pin, quota, retention, or garbage-collection framework.
- Runtime artifact locks exist in the model but are not populated by composition.
- The source-grounded v2 generator remains a separate CLI while the Studio still owns an older creator path, so two development models coexist.

These are acceptable prototype limits but must become explicit contracts, projections, operations, and downstream integration gates before the framework or OVA can claim one unified lifecycle.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
