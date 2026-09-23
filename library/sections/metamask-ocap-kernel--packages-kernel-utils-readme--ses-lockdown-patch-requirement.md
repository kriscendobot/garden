---
title: "SES/lockdown compatibility: auto-applied dependency patches"
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
topics: [hardened-javascript, tooling]
genre: sibling-implementation-comparison
status: current
---

> Abstract: like `@metamask/ocap-kernel`, `kernel-utils` "is designed to run
> under SES (lockdown)" and ships dependency patches in its `patches/`
> directory. The notable difference from the ocap-kernel package: here the
> patches are **applied automatically** via the package's own `postinstall`
> script (also using `patch-package`), so a consumer only needs
> `patch-package` as a dev-dependency rather than copying patch files into
> their own tree. The README does not name which dependencies are patched
> (the ocap-kernel README named `@chainsafe/libp2p-yamux` explicitly).

The README's SES/Lockdown Compatibility section states:

- The package "is designed to run under SES (Secure ECMAScript lockdown)."
- "Some of its dependencies require patches to work in a locked-down environment."
- The patch files are included in the package's `patches/` directory and are **applied automatically via the `postinstall` script** using `patch-package`.
- The only consumer obligation is to add `patch-package` as a dev-dependency.

Cross-comparable signal: two packages in the same monorepo both need
lockdown-targeted dependency patches, confirming that running a real
networking/utility stack under Hardened JavaScript routinely requires
patching third-party code. The two packages chose **different application
ergonomics** for the same `patch-package` mechanism — ocap-kernel asks the
consumer to copy and wire a `postinstall`; kernel-utils self-applies on its
own install. See the sibling section
[ses-lockdown-libp2p-yamux-patch-requirement](metamask-ocap-kernel--packages-ocap-kernel-readme--ses-lockdown-libp2p-yamux-patch-requirement.md)
for the named-dependency case.

External-lineage flag: ocap-kernel practice, read for reference.

Source: [packages/kernel-utils/README.md](https://github.com/MetaMask/ocap-kernel/blob/e3352518864775c8b16b13a50246e7be2df9db45/packages/kernel-utils/README.md) at commit `e335251`.
