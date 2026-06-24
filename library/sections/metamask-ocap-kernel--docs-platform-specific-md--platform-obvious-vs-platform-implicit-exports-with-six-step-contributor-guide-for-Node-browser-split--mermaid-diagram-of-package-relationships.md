---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Mermaid-diagram-of-package-relationships
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> ```mermaid
> graph TD
>     A["Core Kernel Packages"] -->|browser implementation| B["kernel-browser-runtime"]
>     A -->|node implementation| C["nodejs"]
>     B -->|e2e testing| D["extension"]
>     C -->|e2e testing| E["kernel-test"]
> ```

§Visual-of-the-package-graph. Four packages named:
kernel-browser-runtime, nodejs, extension, kernel-test.

§Mermaid-as-doc-tool. §Diagram-shows-arrow-direction-of-
dependency (core → runtime → e2e-test). The arrows say
*who imports whom*.

§E2E-testing-packages-as-distinct-layer: the testing
infrastructure is its own package per platform (not mixed
into the runtime package). §Test-isolation-as-package-
isolation; cycle 153's §ci-no-npm-lifecycle three-layer-
auditable defense has a sibling here: §test-package-as-
auditable-boundary.
