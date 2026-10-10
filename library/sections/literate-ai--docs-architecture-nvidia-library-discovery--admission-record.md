---
title: NVIDIA library discovery: the per-library admission record
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

> Abstract: The inventory stays in documentation until selection or validation consumes a typed catalog; each admitted library needs a seven-part record (capability limits, source and ownership, licensing per artifact, language access tier, exact installation, integration wiring, and a discovered/assessed/admitted/qualified status bound to a target tuple), and generation consumes only retained exact authority, so upstream doc drift or discovery-time network access never alters a locked recipe or grants permission to install.

Keep the first inventory in documentation. Introduce a typed catalog only when selection/validation consumes it, reusing existing dependency and lock contracts. An admission record needs:

1. **Capability and limitations:** operation, shapes, precision, error tolerance, memory footprint, batching, and CPU/GPU crossover where relevant.
2. **Source and ownership:** official repository/documentation, reviewed revision, retained content identity, upstream skill if used, and review date.
3. **Licensing by artifact:** library source, wrapper, SDK, runtime/backend, and redistribution requirements; unknown remains unknown until verified.
4. **Language access:** official direct API, official binding, framework-mediated access, community binding, or unavailable. A C ABI alone is not proof that every Literate AI language has a supported integration. Record upstream language support separately from Literate AI's qualified language Flavors.
5. **Installation:** exact distribution names versus import names, repository/native package/wheel/container route, hashes, supported OS/architecture/Python ABI, driver floor, toolkit/runtime compatibility, and device requirements.
6. **Integration:** include/link targets or imports, build-system wiring, memory ownership, layout, streams, synchronization, errors, and framework interop.
7. **Evidence/status:** discovered, assessed, admitted, or qualified for a specific target tuple. Bind the receipt and SBOM to that tuple, not to the vendor name.

Discovery can consult current upstream sources. Generation consumes only the selected, retained, exact authority. Upstream documentation changes must not silently alter a locked recipe. Network lookup during discovery is not permission to install packages or execute generated code.

Source: [docs/architecture/nvidia-library-discovery.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/nvidia-library-discovery.md) at commit `fcc40bc`.
