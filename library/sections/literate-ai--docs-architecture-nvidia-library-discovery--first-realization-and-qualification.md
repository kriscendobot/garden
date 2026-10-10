---
title: NVIDIA library discovery: first realization and qualification evidence
source: docs/architecture/nvidia-library-discovery.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The first realization is Python + CUDA via CUDA Python (comparing `cuda.core` and `cuda.bindings`, keeping CuPy as a distinct choice and recording the remaining library choice before generation), then a matrix operation, one cuDNN primitive, and one ray-query app judged by known geometric intersections; each needs isolated reproducible install, exact SBOM closure, actual GPU execution, independent correctness acceptance, and negative compatibility tests, since an import, matching output, or CPU fallback cannot qualify GPU execution.

Start with Python + CUDA using CUDA Python. Compare `cuda.core` and `cuda.bindings` against the desired operation and pin the required packages; do not assume installing the `cuda-python` metapackage supplies every interface. Preserve the existing CuPy path as a distinct implementation choice. Python + CUDA constrains the target but does not uniquely select CUDA Python, CuPy, nvmath-python, or a framework. Record that remaining choice explicitly before generation, using existing dependency/authoring contracts where possible.

Next, qualify a matrix operation through a suitable math interface, then one cuDNN primitive, and one ray-query application. For cuDNN, select the required operation, precision, shape, hardware, and direct versus framework access; neural-network intent alone does not imply universal applicability or a direct cuDNN dependency. Ray-query acceptance should use known geometric intersections, not a subjective rendered-image check.

Each realization needs a reproducible installation in an isolated environment, an exact dependency closure in source/resolved SBOMs, actual GPU execution, independent correctness acceptance, and negative compatibility tests. Measure performance only with a declared workload, and include transfers and startup when the application contract requires them. A successful import, matching output, or CPU fallback alone cannot qualify GPU execution.

Admit narrowly scoped generation skills only after their upstream resources and licenses are retained, contradictions with Literate AI authority are resolved, and `make skills-check` plus the affected behavioral scenario pass. Coverage of all families is a maintained inventory objective; execution support grows through these explicitly evidenced realizations.

Source: [docs/architecture/nvidia-library-discovery.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/nvidia-library-discovery.md) at commit `fcc40bc`.
