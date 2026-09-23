---
source: packages/ocap-kernel/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/README.md
source_branch: main
source_commit: e3352518864775c8b16b13a50246e7be2df9db45
source_date: 2026-03-12
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 2
status: current
notes: |
  Sixth ocap-kernel ingest; first of the per-package-README
  cluster from the cycle-161 overview plan. Sibling-
  implementation genre (reference-not-substrate). The README
  is a near-boilerplate stub whose only substantive content is
  the SES/lockdown `@chainsafe/libp2p-yamux` patch note —
  captured as its own section because it is a concrete cross-
  comparable cost-of-libp2p-under-SES data point.
---

> Abstract: the published README of `@metamask/ocap-kernel`, the kernel-and-vat
> core package of the [[ocap-kernel]] monorepo. A near-boilerplate stub: a
> one-line "Ocap Kernel core components" description, install commands, a
> pointer to the monorepo contributing guide, and one substantive section on
> **SES/lockdown compatibility** — the fact that the `@chainsafe/libp2p-yamux`
> stream multiplexer must be patched (via `patch-package`) to run under
> lockdown. The package's architectural substance lives in its TypeScript
> source (`Kernel.ts`, `VatHandle.ts`, …), queued as comment-fragment ingests.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [ocap-kernel-core-components-package-purpose](../sections/metamask-ocap-kernel--packages-ocap-kernel-readme--ocap-kernel-core-components-package-purpose.md) | daemon, capability-security | current |
| [ses-lockdown-libp2p-yamux-patch-requirement](../sections/metamask-ocap-kernel--packages-ocap-kernel-readme--ses-lockdown-libp2p-yamux-patch-requirement.md) | hardened-javascript, daemon | current |

## Provenance

- Fetched 2026-06-27 from the bare clone at
  `worktrees/metamask-ocap-kernel.git` (`MetaMask/ocap-kernel`,
  `main` HEAD `a3eff0efb`). File-specific commit `e335251`
  (2026-03-12, Erik Marks).
- License: dual Apache-2.0 + MIT.
- **Sixth ocap-kernel ingest**; first of the per-package-README cluster.
- Sibling-implementation genre: read for reference, not imported.
