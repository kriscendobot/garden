---
source: packages/kernel-utils/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-utils/README.md
source_branch: main
source_commit: e3352518864775c8b16b13a50246e7be2df9db45
source_date: 2026-03-12
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 2
status: current
notes: |
  Per-package-README cluster, sixth ocap-kernel ingest.
  Near-boilerplate stub. The garden's real interest in this
  package is `src/exo.ts` (`makeDefaultExo`, the AGENTS.md-
  mandated replacement for `Far` from `@endo/far`), which is a
  comment-fragment follow-on target, not in this README.
---

> Abstract: the published README of `@metamask/kernel-utils` ("Ocap Kernel
> utilities"). A near-boilerplate stub with one substantive SES/lockdown
> section (dependency patches applied automatically via `postinstall`). The
> package houses `makeDefaultExo` (`src/exo.ts`) — the wrapper ocap-kernel's
> AGENTS.md mandates instead of importing `Far` from `@endo/far` directly —
> but that is source, not README content, and is carried to the comment-
> fragment follow-on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [ocap-kernel-utilities-package-purpose](../sections/metamask-ocap-kernel--packages-kernel-utils-readme--ocap-kernel-utilities-package-purpose.md) | tooling, exo | current |
| [ses-lockdown-patch-requirement](../sections/metamask-ocap-kernel--packages-kernel-utils-readme--ses-lockdown-patch-requirement.md) | hardened-javascript, tooling | current |

## Provenance

- Fetched 2026-06-27 from `worktrees/metamask-ocap-kernel.git`
  (`MetaMask/ocap-kernel`, `main` HEAD `a3eff0efb`). File-specific
  commit `e335251` (2026-03-12, Erik Marks).
- License: dual Apache-2.0 + MIT.
- Per-package-README cluster, sixth ocap-kernel ingest.
- Sibling-implementation genre: read for reference, not imported.
