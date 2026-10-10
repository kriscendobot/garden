---
title: NVIDIA library discovery: desired behavior and existing ownership
source: docs/architecture/nvidia-library-discovery.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The discovery slice of NVIDIA-LIBS-001 lets a generated application start from a capability need (matrix multiply, sparse solve, NN primitives, ray queries) plus its selected language and discover an NVIDIA implementation with how to obtain, integrate, and prove it, preferring OSS while separately identifying binary SDKs, runtimes, and drivers. Vendor is a discovery facet, not a Flavor axis, and an external library stays a package dependency unless deliberately wrapped as a Component.

This assessment implements the discovery design slice of NVIDIA-LIBS-001 in the active queue (`docs/roadmap/active-work.md`). Library admission and execution qualification remain open. Sources were consulted on 2026-09-26; links are discovery references, not immutable build inputs or compatibility pins.

**Desired behavior.** A generated application should be able to start with a need such as matrix multiplication, sparse solving, neural-network primitives, or ray queries and discover an appropriate NVIDIA implementation for its selected language and target. The result must explain how to obtain, integrate, and prove that implementation. Prioritize NVIDIA OSS while identifying separately any required binary SDK, runtime, driver, or proprietary backend. A public repository or Python wrapper does not establish that the entire dependency closure is open source.

Use capability and language as the entry points. Vendor and product are discovery facets and provenance; they do not introduce a Flavor axis. Multiple libraries must coexist in one application without competing for an artificial exclusive vendor or library slot.

**Existing ownership and overlap.**

- CUDA Flavor (`flavors/accel-nvidia-cuda/flavor.md`): accelerator requirements and authoring inputs; currently scoped to `sample.portable-app` applicability.
- Stack selection (`skills/agent/select-nvidia-accelerated-stack/SKILL.md`): current worker observations, retained compatibility authority, exact packages, and `litai worker resolve-nvidia`.
- CUDA generation (`skills/specification-to-source/generate-nvidia-cuda-application/SKILL.md`): C++ and Python technique, dependency evidence, and actual device execution.
- Flavor composition (`component-flavors.md`): existing language, accelerator, toolchain, build, packaging, and deployment dimensions.
- Skill architecture (`skills.md`): agent-side discovery/preparation and separately pinned generation instructions; SkillEvaluator admission already exists.
- OVA boundary (`docs/user/ova-and-migration.md`): product policy and Omniverse/Isaac integration remain downstream. Reusable numerical or geometry libraries need not become an OVA dependency merely because NVIDIA authored them.

An external library remains a package/source dependency unless it is deliberately wrapped as a Component providing observable behavior. Do not turn every package into a Component. Add a Flavor only for a real target variation on an existing axis; attach technique to the Component or selected Flavor that needs it.

Source: [docs/architecture/nvidia-library-discovery.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/nvidia-library-discovery.md) at commit `fcc40bc`.
