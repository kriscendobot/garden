---
title: NVIDIA library discovery: initial candidate inventory
source: docs/architecture/nvidia-library-discovery.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: A non-exhaustive candidate table maps needs to NVIDIA discovery sources (CUDA Python, the CUDA math libraries, nvmath-python, CUTLASS/CuTe, CCCL, cuDNN Frontend, the CUDA-X catalog, the OptiX SDK), each needing separate per-library, per-language admission; a broader backlog (cuBLASLt through TensorRT, including non-`cu*` projects) must track renamed, deprecated, unavailable, and proprietary entries so omission cannot masquerade as coverage, and NVIDIA's skills catalog is supplementary technique only.

These are candidates, not a claim of Literate AI support or an exhaustive `cu*` inventory. Each family needs separate per-library, per-language admission records.

| Need | Candidates / primary discovery source | Language and integration direction |
| --- | --- | --- |
| Python device control and kernel execution | CUDA Python (github.com/NVIDIA/cuda-python) | Separate `cuda.core` and low-level `cuda.bindings`; select exact distributions and APIs for Python + CUDA. Kernel authoring/compiler choices are separate dependencies. |
| Dense, sparse, FFT, random, tensor, and solver operations | CUDA library documentation — cuBLAS, cuSPARSE, cuFFT, cuRAND, cuSOLVER; CUDA-X — cuTENSOR | Inspect each native API and binding. Toolkit/library binaries, language wrappers, and their licenses are separate records. |
| Python access to math libraries | nvmath-python | Candidate Python interface for supported math operations; do not infer complete coverage of every native API. |
| Custom matrix kernels | CUTLASS / CuTe | C++ templates and Python DSLs; choose by required kernel customization, precision, and hardware. |
| Parallel primitives | CCCL | Thrust, CUB, and libcu++; inspect the release-specific Python interfaces separately. |
| Neural-network primitives | cuDNN Frontend | C++ and Python interfaces plus selected OSS kernels; record backend requirements independently. Framework-mediated use may already supply the required integration. |
| Dataframes, ML, graphs, search, optimization, images | CUDA-X catalog — cuDF, cuML, cuGraph, cuVS, cuOpt, cuCIM | Inspect the product's native/Python APIs and installation matrix separately; prefix membership is not a shared language or platform guarantee. |
| Ray tracing | OptiX SDK | Native SDK headers and samples call driver-provided functionality. Inspect SDK terms and any Python binding separately; do not label the whole stack OSS. |

The broader inventory must also assess cuBLASLt, cuSPARSELt, cuDSS, cuFFTMp, cuTENSORMg, cuQuantum and its constituent libraries, cuEquivariance, cuPQC, and domain-specific `cu*` offerings. This is a discovery backlog, not verified availability. Include useful non-`cu*` projects such as NCCL, NVSHMEM, NIXL, Warp, AmgX, DALI, CV-CUDA, nvComp, and TensorRT where relevant. Naming is not the coverage boundary. Track renamed, deprecated, unavailable, and proprietary entries explicitly so omission cannot masquerade as full coverage.

The NVIDIA skills catalog (github.com/NVIDIA/skills) is a supplementary technique source. Product repositories and official library documentation remain necessary for installation, binding coverage, and compatibility evidence. Assess individual skills against the existing contracts; do not load the suite into every CUDA recipe.

Source: [docs/architecture/nvidia-library-discovery.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/nvidia-library-discovery.md) at commit `fcc40bc`.
