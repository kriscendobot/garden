---
title: OVA evaluation: build semantics, set acceptance, and workflow provenance
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: OVA's builder is a Python-bytecode placeholder that runs before any classification lock exists, a present contradiction of its own security spec that keeps general build APIs disabled until a compiler guard and adversarial tests exist; generated files are accepted one at a time rather than as an atomic set; and its workflow/provenance model hard-codes four stages, omits response identities and cost data, lacks resumability and a structural taint model, and conflates timestamped history with deterministic run-input identity.

**Build semantics are a Python-specific placeholder.** `build_object_package()` compiles `.py` to checked-hash bytecode and copies every other file as a resource. That is useful test coverage for package lineage, not a general builder, and it runs before the planned classification lock exists. The framework needs builder ports, toolchain locks, hermetic execution requests, classification authorization, and typed artifacts. No builder, Python included, may be invoked without the security transition once enforcement is enabled.

This is a present contract contradiction, not only missing hardening: `SourceGroundedGenerator.generate()` invokes the Python object builder before any classification lock exists, while the checked-in security specification says unclassified source must never compile. General build APIs remain disabled until the compiler guard and adversarial tests are executable.

**Acceptance is not transactionally atomic as a set.** Each generated file is written atomically, but `ProjectGenerationTransaction.accept()` updates files one at a time, so a crash can leave a project containing part of a generation set. Lock files and provenance are written after source acceptance, further separating state. Use an immutable workspace tree or transactional directory swap followed by an atomic revision-reference update, and a run event store for restart/reconciliation.

**Workflow and provenance need stronger semantics.**

- Four model stages are required by the Component schema even for non-code workflows.
- Prompt template identities exist, but raw model response identities, decoding parameters, seeds, token/cost accounting, and policy decisions are incomplete.
- Repair is bounded, but orchestration is not resumable and durable state is implicit in files.
- Source excerpts are treated as untrusted in the system prompt, but there is no structural taint model or tool-output policy.
- A timestamp-bearing provenance object is useful history but should not be confused with the deterministic identity of a run's inputs.

Separate deterministic run-input identity from execution events and operational timestamps; make workflow definitions, stage contracts, and policy decisions versioned objects. Endpoint `locality` is asserted metadata, not a verified transport/network property, and CLI loading does not uniformly apply Settings' URL checks. `ModelPortfolio.decisions` is mutable shared history, which makes concurrent provenance unsafe. The new model layer must enforce prompt-egress policy and record isolated request/response artifacts, model revision/fingerprint, parameters, token/cost data, retry/failure/fallback reasons, and data classification for each call.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
