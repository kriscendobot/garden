---
title: Flavor examples, lifecycle integration, product boundary, and conformance matrix
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Worked examples (Windows/MSVC, optional CUDA, Python versus Rust, Bazel preference) show target concerns kept out of the base spec; Flavors thread through vocabulary, generation, inverse authoring, cache, security, publication, settings, and refresh, but can request and never grant privileges; the framework owns Flavor semantics while products own concrete Flavor content, with a ten-item conformance matrix.

**Examples.**

- *Windows without contaminating the base.* The base spec says the application starts, serves requests, persists state, and shuts down safely. A `windows-msvc` Flavor separately contributes service lifecycle, MSVC toolchain constraints, filesystem conventions, packaging, and Windows acceptance tests; a Linux Flavor coexists without either appearing in base requirements.
- *Optional CUDA.* The base defines correct CPU-observable, performance-neutral behavior. A CUDA Flavor adds `compute.cuda`, driver/toolkit/architecture requirements, accelerator generation skills, validators, builder bindings, and performance scenarios. It cannot remove correctness tests or grant GPU/device privileges; security policy authorizes those separately.
- *Language ecosystem.* Python and Rust Flavors bind different workflows, skills, validators, dependency providers, builders, and packages while implementing the same base contracts; mutually exclusive for a single-role Component, or one per named role slot in a multi-language topology, with a separate slot-to-revision relation so nothing is duplicated.
- *Build-system preference.* The standard `bazel` Flavor selects the value `bazel` (avoiding a false "built with Bazel" assertion). Its skill defaults the model toward faithful fine-grained Bazel targets unless authority calls for another system or the ecosystem cannot be modeled honestly; a Bazel wrapper around Mix, `zig build`, or opaque generation remains a coarse action, and build evidence records the actual source-to-binary path.

**Lifecycle integration.** Vocabulary exposes descriptors for all discoverable Flavors without materializing their sources. Generation prompts receive base behavior plus the exact selected Flavor set, and source contracts retain which Flavor introduced each claim. Source-to-specification skills classify observed target-specific behavior into `FlavorDraftSet` objects instead of polluting base specs. Cache keys for target-sensitive runs/builds/artifacts include the effective revision and Flavor set. A Flavor can request privileges but cannot grant them, lower dependency risk, select `yolo`, or bypass source/classification/build/observation authorization. Base Components and Flavors publish independently; artifact releases name their exact effective revision and target profile. Target profiles and Flavor preferences are their own settings section. Source, Flavor, policy, toolchain, or target changes produce impact records only for affected effective revisions.

**Product boundary.** literate-ai owns Flavor contracts, resolution semantics, identities, and lifecycle integration; a derived product owns concrete domain policies and Flavor content (development hosts, accelerator levels, middleware distributions, supported language/toolchain combinations). No product-specific Flavor name belongs in the framework core.

**Conformance matrix.** Living samples must cover one portable base across Linux, macOS, and Windows; CPU-only and optional/required CUDA; Python versus Rust; compatible multi-axis composition; conflicting singleton, version, and target constraints; Flavor source/signature failure and unavailable toolchains; cache reuse without cross-target aliasing; security monotonicity and explicit yolo separation; independent Flavor publication/import; and source-to-specification separation of base and target behavior.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
