---
title: "Sample portfolio review: catalog criteria and sample roles"
source: docs/architecture/sample-portfolio-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Literate AI's sample catalog serves both as executable conformance evidence and as an adaptable design library; the review scores samples separately for correctness surface, composition and adaptation value, and framework coverage, then assigns each entry a portfolio role so conspicuous product examples lead while specialized torture cases remain available as regression evidence.

The sample catalog has two jobs. It is executable conformance evidence for Literate AI,
and it is the first design library most people will read, fork, and adapt. A technically
valuable torture case may remain in the catalog without pretending to be a product, but
the first screen must lead with Components that solve recognizable problems.

This review uses four criteria:

1. **Correctness surface** — bounded inputs, explicit invalid cases, deterministic
   ordering and arithmetic, a closed output contract, and independently known results.
2. **Composition value** — a public capability or boundary that can sensibly participate
   in a larger application.
3. **Adaptation value** — behavior a reader might preserve while changing vocabulary,
   interfaces, or selected Flavors.
4. **Framework coverage** — a lifecycle, language, topology, cache, publication, or
   inverse-generation path that needs executable regression evidence.

The value score is about likely reuse, not implementation difficulty. The test score is
about architectural coverage, not product popularity.

| Sample | Portfolio role | Reuse value | Test value | Review |
| --- | --- | ---: | ---: | --- |
| Greeting Card Starter | start-here tutorial | 2/5 | 4/5 | Correct and intentionally small. Good first lifecycle, normalization, aggregation, and known-output example; not presented as a production architecture. |
| Loan Risk Gate | specification-provider sample (DMN + assets) | 4/5 | 5/5 | Genuine UNIQUE loan-risk table plus pinned income-band JSON and an explicit portable public interface. Proves `specification_provider: dmn` and MEDIUM-layer `assets:` without inventing a DMN engine. |
| Playback Controller | specification-provider sample (SCXML) | 4/5 | 5/5 | Parallel transport/audio regions with deep history plus an explicit portable public interface. Proves `specification_provider: scxml` and a production `.trace.json` sidecar. |
| Containerized Access-Log Tally | deployment-axis matrix sample | 3/5 | 4/5 | Owns the deploy-docker + container-assembly cell and demonstrates the specification hierarchy (interfaces/spec.md wire boundary; image rules live wholly in the Flavor and its skill). Not yet wired into the live ladder pending authenticated generation. |
| Critical Path Scheduler | reusable planning engine | 5/5 | 5/5 | Strong real algorithm with validation, integer bounds, stable tie-breaking, full earliest/latest schedule, slack, and useful project/workflow/build applications. |
| Build Pipeline Dependency Planner | reusable Rust planning kernel | 4/5 | 5/5 | Correct smaller DAG/topology/longest-chain boundary. It overlaps the scheduler deliberately to prove a Rust-only recipe and a simpler build-pipeline contract. |
| Content-Addressed Record Vault | reusable storage kernel | 4/5 | 5/5 | Deduplication, SHA-256 identity, ordered recovery, empty-cache fill, and restart behavior are useful in artifact stores and offline queues. It is not a distributed CAS. |
| Portable Deployment Matrix | reusable release-planning kernel | 4/5 | 5/5 | Recognizable CI/release function and the clearest independent Flavor-axis example. Artifact/toolchain mappings are intentionally small, not a universal platform database. |
| Full-Stack Rust and JavaScript Release Dashboard | reusable full-stack pattern | 5/5 | 5/5 | Compelling two-role application with explicit protocol ownership, integer risk calculation, frontend view model, and trusted orchestration boundary. |
| Exact Statistics Library | reusable library + consumer | 4/5 | 5/5 | Exact rational statistics are broadly useful and demonstrate independently generated library consumption. The statistical surface is intentionally basic. |
| JavaScript Ledger Workbench | reusable finance kernel | 5/5 | 5/5 | Strong integer-money, reconciliation, budget, ordering, and deterministic tie-breaking example with obvious personal-finance and expense-control forks. |
| Private AI Endpoint Router | reusable AI infrastructure | 4/5 | 4/5 | Valuable privacy and capability-routing primitive with explainable fallback. It models selection, not health probing, load balancing, credentials, or remote egress policy. |
| Multi-Role Text Job Pipeline | compositional topology example | 3/5 | 5/5 | The API/worker source-role boundary is useful; word counts are deliberately simple so the topology remains visible. Fork this shape, not its toy workload. |
| Reproducible Release Manifest | reusable supply-chain primitive | 5/5 | 5/5 | Canonical path ordering, per-file hashes, and one release identity are broadly applicable to plugins, sites, configuration, and asset bundles. |
| Warehouse Manifest Round-trip | reusable fulfillment kernel + semantic oracle | 4/5 | 5/5 | Rich normalization, aggregation, integer discounting, ranking, and stable identity make it credible product logic and the best forward/inverse comparison fixture. |
| Deployment Security Gate | reusable policy kernel | 4/5 | 5/5 | Explicit blocked/constrained/maximum-privilege decisions and persistent override warning are useful admission-policy behavior. It is not a vulnerability scanner. |
| Framework Compatibility Readiness | framework conformance only | 1/5 | 5/5 | Correctly proves repository-independent version/skill readiness and authority separation. Keep it in the regression catalog, but do not recommend it as an end-user starting point. |
| Composable Invoice Service | reusable Component graph | 5/5 | 5/5 | Best small Component-composition example: application, service, and integer-money library have distinct ownership and public capability edges. |
| Linux Cgroup Budget Interpreter | reusable container resource boundary | 4/5 | 5/5 | Real cgroup v2 semantics, native C++, Conan selection, and an exact Linux-only scheduling boundary. It parses supplied kernel values rather than claiming live host inspection. |
| Windows Path Auditor | reusable installer/workspace boundary | 4/5 | 5/5 | Drive, UNC, rooted, and relative path behavior is recognizable Windows infrastructure work and proves Windows-only native C++ plus Conan selection. |
| macOS LaunchAgent Catalog | reusable desktop-service boundary | 4/5 | 5/5 | A concrete LaunchAgent catalog in Swift proves the Apple toolchain, macOS-only scheduling, and Homebrew Flavor composition without pretending to install a service. |
| CUDA Vector Transform | reusable NVIDIA C++ GPU primitive | 4/5 | 5/5 | Exact affine transform on device memory with a CPU oracle, proving generate-nvidia-cuda-application and nvcc selection on a healthy NVIDIA worker. |
| CUDA Matrix Product | reusable NVIDIA Python GPU primitive | 4/5 | 5/5 | Exact CuPy matrix product on the selected CUDA device, proving the Python CUDA stack preflight and the same accelerator Flavor path. |
| Cluster Health Service | reusable persistent-service pattern | 4/5 | 4/5 | Paginated HTTP, typed 404, MCP tool, and scheduled worker over SQLite. Sample-host JSON probe is the harness surface; live generation passed 2026-08-29 (`cursor-agent` / `gpt-5.6-sol-high`). |
| Cluster Metrics Dashboard | reusable web-application pattern | 4/5 | 4/5 | Series selection independent of fetch, graph/table switch, and multi-key sort. Pinned to JavaScript; harness admits `web-application`. |
| Durable Snapshot Dashboard | durable four-boundary portfolio | 5/5 | 5/5 | Two ordinary root locks preserve frontend → read-only API → SQLite cache and collector → write-only cache boundaries. The executed flow proves restart-independent reads, atomic partial-failure handling, bounded retries, single-winner leases, expiry recovery, and shared freshness without flattening the application into one prompt. |

Source: [docs/architecture/sample-portfolio-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sample-portfolio-review.md) at commit `fcc40bc` (source lines 1–49).
