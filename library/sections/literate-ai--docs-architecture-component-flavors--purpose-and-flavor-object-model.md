---
title: Flavor purpose and the FlavorDefinition object model
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Flavors let one target-neutral Component realize many OS, architecture, accelerator, language, build, toolchain, packaging, and deployment targets without contaminating its behavioral spec; a Flavor is a first-class versioned object with one primary axis, typed contributions, and exact lineage, and cross-axis behavior factors into OS, language, and toolchain-realization layers.

Flavors let one target-neutral Component participate in multiple operating-system, architecture, accelerator, language, build-system policy, toolchain, packaging, or deployment realizations. They keep requirements such as "build with MSVC on Windows", "optionally use CUDA", or "generate the Rust implementation" out of the Component's durable behavioral specification. "Mix-in" describes how a Flavor contributes to an effective revision; it does not mean free-form YAML merging, inheritance, or runtime monkey-patching.

A Flavor is a first-class catalog, vocabulary, cache, package, and publication object. A `FlavorDefinition` declares:

- a stable `flavor://<namespace>/<name>` coordinate and immutable revision;
- exactly one primary `FlavorAxis`, plus optional secondary constraints;
- applicability through capabilities and semantic version ranges;
- provided/required capabilities and compatibility constraints;
- content-pinned spec fragments and authoring skills;
- typed workflow, validator, builder, toolchain, package, and runtime contributions;
- conflicts, co-requisites, ordering constraints, and exactly one primary-axis target value per revision;
- exact source-snapshot and parent lineage on the `FlavorRevision`.

Every build-affecting contribution stays visible in dependency evidence: the source CycloneDX graph holds intended relationships, the resolved graph the exact closure observed after the Flavor's native build. A Flavor may add or constrain dependencies but cannot remove a base/managed node or weaken graph completeness. A Flavor may be implemented and published by a Component, but its variation contract remains a distinct object, so target selection does not look like an ordinary runtime dependency edge.

Cross-axis behavior is factored into three layers: an OS Flavor owns universal host facts (including best-effort NTP clock sync on remote workers), a language Flavor owns portable source semantics, and a toolchain realization owns their intersection (compiler/SDK discovery, host constraints, mitigation). A language can declare an exactly-one `co_requisite_groups` set; resolution rejects zero or several members, and each realization's secondary `platform.os` constraint rejects a mismatched OS before model selection. The Swift catalog is the reference shape: a portable `swift` language Flavor plus `swift-apple`, `swift-linux`, and `swift-windows` toolchain Flavors, so Apple developer tools stay out of generic macOS policy and Windows SDK prerequisites stay out of portable Swift.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
