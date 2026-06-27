---
title: "@metamask/kernel-utils: Ocap Kernel utilities (package purpose)"
source: packages/kernel-utils/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-utils/README.md
source_path: packages/kernel-utils/README.md
source_commit: e3352518864775c8b16b13a50246e7be2df9db45
source_date: 2026-03-12
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [tooling, exo]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@metamask/kernel-utils` is the published npm package described
> upstream as **"Ocap Kernel utilities."** Its README is a near-boilerplate
> stub (one-line description, install commands, a SES/lockdown patch note,
> contributing pointer). The garden's interest in this package is sharper
> than the README reveals: per the cycle-161 overview, `kernel-utils` is
> where **`makeDefaultExo`** lives — the wrapper the ocap-kernel AGENTS.md
> mandates in place of importing `Far` from `@endo/far` directly. This
> section records the package identity and flags `src/exo.ts` (the
> `makeDefaultExo` source) as a queued comment-fragment ingest target.

`@metamask/kernel-utils` (README title `utils`) is the shared-utility package
of the [[ocap-kernel]] monorepo. The README itself says only "Ocap Kernel
utilities" plus install/lockdown/contributing boilerplate.

The substance the garden cares about is **not in the README** but in the
package's source, recorded here from the overview ingest so a future reader
finds it: the overview observed that ocap-kernel's AGENTS.md style **forbids
importing `Far` from `@endo/far`** and instead routes remotable creation
through a `makeDefaultExo` wrapper. That wrapper lives in this package
(`packages/kernel-utils/src/exo.ts`, with `exo.test.ts` alongside). The "exo"
in the cycle-161 plan's `kernel-utils/exo` line refers to that file, which is
a code-comment-fragment ingest target rather than a README source — flagged
here and carried into the follow-on plan.

External-lineage flag: read for reference (sibling implementation), not
imported. The `forbid-direct-Far`-in-favor-of-`makeDefaultExo` discipline is
ocap-kernel's, not Endo's or the garden's.

Source: [packages/kernel-utils/README.md](https://github.com/MetaMask/ocap-kernel/blob/e3352518864775c8b16b13a50246e7be2df9db45/packages/kernel-utils/README.md) at commit `e335251`.
