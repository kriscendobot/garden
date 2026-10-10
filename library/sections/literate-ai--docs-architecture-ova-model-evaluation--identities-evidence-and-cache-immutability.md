---
title: OVA evaluation: source identities, evidence retention, and cache immutability
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: OVA's source digests are not yet uniform content identities (URL+revision digests, unverified mutable refs, synthesized local commits, no signed LFS or aggregate locks); its evidence pipeline parses presentation Markdown, lets vocabulary exhaust a 140,000-character budget, and retains digests but not evidence bytes; and its "immutable" package manifests are mutated to record dependents. The fixes are canonical tree manifests, CAS-backed evidence, selected-closure-first budgets, and a separate rebuildable reverse-dependency projection with typed edges.

**Source identities are not yet uniformly content identities.**

- Remote `content_digest` is derived from repository URL and resolved revision rather than a canonical tree digest.
- Mutable or retagged remote refs are resolved at fault time. The resulting commit is locked, but signature and transparency-log verification are not implemented.
- Local snapshots use a fixed ignore list, synthesize Git commits, and can include file mode or platform normalization ambiguity.
- Git LFS skips non-source payload smudging and fails if known source paths remain pointers, but signed LFS object identities are not modeled.
- Source collections such as ROS distribution manifests require a first-class aggregate source lock rather than pretending a manifest repository contains the APIs.

The neutral source layer needs canonical tree manifests, source-provider attestations, aggregate snapshots, and explicit dirty-source policy.

**Evidence retention and prompt allocation are weaker than the lock model.**

- `CodeGraphRetriever` normalizes human-oriented Markdown with regular expressions, so a presentation change can become an intelligence-protocol change.
- Vocabulary evidence for every usable Component is appended before detailed evidence and subjected to one sequential 140,000-character limit; a large catalog can consume the budget before selected-component API/lifecycle evidence.
- Provenance retains evidence references and content digests, but not the evidence bytes or a durable artifact-store address; removing the checkout can make an old decision impossible to reconstruct.
- File-level evidence IDs prove the model declared a binding, not that generated source uses only those symbols or that the derived contract is semantically faithful.

Use structured provider results, CAS-backed evidence artifacts, selected-closure-first token-aware budgets, and language/provider analyzers that reconcile proposed API-use graphs with source contracts.

**Cache immutability is partially violated.** `ObjectPackageManifest` contains `depending_components`; when a new consumer is built, `_record_dependent()` mutates the dependency's stored object manifest, so an object presented as immutable changes because of an external event. The fix keeps immutable package manifests content-addressed and stores reverse edges in a separate, rebuildable dependency-index projection; mutable `latest` aliases also live outside package identities. Object-package construction also removes and rebuilds an existing destination directory; `latest_object_packages()` silently omits uncached dependency objects, so a source lock can name a requirement missing from the recorded build closure; and generated cache records and source packages flatten every transitive locked Component into `requires`, losing direct/transitive and build/runtime/optional edge meaning. The new package model must preserve typed edges, fault or fail on every required artifact, and reject a content-address collision instead of overwriting it.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
