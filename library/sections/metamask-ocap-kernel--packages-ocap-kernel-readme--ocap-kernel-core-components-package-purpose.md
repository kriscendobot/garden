---
title: "@metamask/ocap-kernel: core components (package purpose)"
source: packages/ocap-kernel/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/README.md
source_path: packages/ocap-kernel/README.md
source_commit: e3352518864775c8b16b13a50246e7be2df9db45
source_date: 2026-03-12
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, capability-security]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@metamask/ocap-kernel` is the published npm package holding the
> "Ocap Kernel core components" — the kernel, vat-handle, vat-supervisor,
> kernel-queue, kernel-router, and kernel-service-manager source that the
> overview ingest surveyed. Its public README is a near-boilerplate stub
> (one-line description, install commands, the SES/lockdown patch note
> below, and a pointer to the monorepo contributing guide); the package's
> substance lives in its TypeScript source, queued for comment-fragment
> ingest. This section records the package's identity and the fact that its
> README intentionally carries no architectural prose.

`@metamask/ocap-kernel` is described upstream simply as **"Ocap Kernel core
components."** It is the kernel-and-vat heart of the [[ocap-kernel]] monorepo:
the SwingSet-derived object-capability kernel whose internals (`Kernel.ts`,
`VatHandle.ts`, `VatSupervisor.ts`, `KernelQueue.ts`, `KernelRouter.ts`,
`KernelServiceManager.ts`) are the queued code-comment-fragment sources from
the cycle-161 overview plan.

This is a **sibling-implementation** source (the reference-not-substrate
stance from the overview): the garden reads ocap-kernel's choices to inform
its own OCapN / slot-machine work in `endojs/endo-but-for-bots`; it does not
import this package. The published name is `@metamask/` (public) as opposed
to the `@ocap/` private-namespace packages — the public/private split the
overview flagged as a divergence from Endo's flat naming.

Source: [packages/ocap-kernel/README.md](https://github.com/MetaMask/ocap-kernel/blob/e3352518864775c8b16b13a50246e7be2df9db45/packages/ocap-kernel/README.md) at commit `e335251`.
