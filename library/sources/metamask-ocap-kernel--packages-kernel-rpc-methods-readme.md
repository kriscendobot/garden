---
source: packages/kernel-rpc-methods/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-rpc-methods/README.md
source_branch: main
source_commit: d5a703d3f3ebcf5ba7034b51ab4572d4f3355def
source_date: 2025-05-02
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Per-package-README cluster, sixth ocap-kernel ingest. Pure
  boilerplate stub. Records the architectural contrast the name
  implies: ocap-kernel's host/kernel control plane is JSON-RPC,
  distinct from CapTP-over-syrups.
---

> Abstract: the README of `@metamask/kernel-rpc-methods` ("Utilities for
> implementing Ocap Kernel JSON-RPC methods"), a pure boilerplate stub. The
> reference-relevant fact is architectural: ocap-kernel exposes a **JSON-RPC**
> control surface between its host runtimes and the kernel — a different
> boundary technology from Endo's CapTP, and a point of contrast for comparing
> how each system frames its host/kernel control plane.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [json-rpc-method-utilities-package-purpose](../sections/metamask-ocap-kernel--packages-kernel-rpc-methods-readme--json-rpc-method-utilities-package-purpose.md) | captp, daemon | current |

## Provenance

- Fetched 2026-06-27 from `worktrees/metamask-ocap-kernel.git`
  (`MetaMask/ocap-kernel`, `main` HEAD `a3eff0efb`). File-specific
  commit `d5a703d` (2025-05-02, Erik Marks).
- License: dual Apache-2.0 + MIT.
- Per-package-README cluster, sixth ocap-kernel ingest.
- Sibling-implementation genre: read for reference, not imported.
