---
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 16
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.12 clean, slant neutral at confidence 0.95; fetched raw content sha256 c79bfb37"
---

> Abstract: Literate AI ADR 0044 replaces layer-barrier scheduling with an exact action DAG across every safe compatible worker, and adds layered provider-neutral caches whose hits are always untrusted.

| Section | Topics | Status |
|---------|--------|--------|
| [Layer-barrier scheduling and cache gap](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--cache-and-scheduling-gap.md) | agentic-sdlc, content-addressed-storage | current |
| [Action DAG projection and late assembly edges](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--action-dag-projection.md) | agentic-sdlc, software-supply-chain | current |
| [Execution provider custody and input scope](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--execution-input-scope.md) | agentic-sdlc, capability-security | current |
| [Event-driven ready queue and slot bounds](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--ready-queue-and-slots.md) | agentic-sdlc, worker-observability | current |
| [Selecting every safe compatible worker](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--compatible-worker-selection.md) | agentic-sdlc, worker-observability | current |
| [Layered provider-neutral cache configuration](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--layered-cache-configuration.md) | content-addressed-storage, software-supply-chain | current |
| [Cache hits are untrusted inputs](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--cache-hits-untrusted.md) | content-addressed-storage, capability-security | current |
| [Qualification and sliced rollout](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--qualification-and-rollout.md) | testing, agentic-sdlc | current |
| [Scheduler and shared-cache consequences](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--consequences.md) | agentic-sdlc, content-addressed-storage | current |
| [Command action wire boundary](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--command-action-wire-boundary.md) | agentic-sdlc, capability-security | current |
| [HTTP artifact transport and local retention](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--artifact-transport-and-retention.md) | content-addressed-storage, software-supply-chain | current |
| [Private cache configuration and read-only Bazel custody](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--private-config-and-read-only-bazel.md) | content-addressed-storage, capability-security | current |
| [Cargo and native C++ compiler-cache composition](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--compiler-cache-composition.md) | content-addressed-storage, software-supply-chain | current |
| [Worker-side source indexing and the production index port](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--worker-side-source-indexing.md) | agentic-sdlc, content-addressed-storage | current |
| [Phase capability and hardware admission](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--phase-capability-admission.md) | worker-observability, capability-security | current |
| [Windows long-path CAS and SSH action transport](../sections/literate-ai--docs-decisions-0044-action-dag-and-shared-cache--windows-paths-and-ssh-transport.md) | agentic-sdlc, capability-security | current |
