---
title: "SES/lockdown compatibility: the @chainsafe/libp2p-yamux patch requirement"
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
topics: [hardened-javascript, daemon]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@metamask/ocap-kernel` is designed to run under SES (lockdown),
> and its README documents that one transitive dependency —
> `@chainsafe/libp2p-yamux` (a libp2p stream multiplexer) — **does not run
> under a locked-down environment unmodified** and must be patched. The patch
> files ship in the package's `patches/` directory and are listed in
> `package.json`'s `patchedDependencies`; consumers apply them with
> `patch-package` via a `postinstall` script. This is a concrete, cross-
> comparable data point about the cost of running a real libp2p networking
> stack under Hardened JavaScript: the multiplexer is not lockdown-clean out
> of the box.

The README's only substantive (non-boilerplate) section is **SES/Lockdown
Compatibility**. Verbatim shape of the claim and procedure:

- The package "is designed to run under [SES](https://github.com/endojs/endo/tree/master/packages/ses) (Secure ECMAScript lockdown)."
- One dependency, **`@chainsafe/libp2p-yamux`**, "requires a patch to work in a locked-down environment."
- The required patches are listed in the `patchedDependencies` field of the package's `package.json`; the patch files live in the package's `patches/` directory.
- Consumers apply them with [`patch-package`](https://github.com/ds300/patch-package): install `patch-package` as a dev-dependency, copy `node_modules/@metamask/ocap-kernel/patches/*` into the consumer's own `patches/`, add a `"postinstall": "patch-package"` script, and re-run install.

**Why this matters as a sibling-implementation signal.** Endo's daemon does
not currently embed a libp2p stack; OCapN's network layer is being designed
fresh (the `ocapn-noise-network` / `ocapn-tcp-syrups-framing` design cluster).
ocap-kernel's note is direct evidence that a production libp2p multiplexer
needs lockdown-targeted patching — a hidden cost any garden design that
reaches for an off-the-shelf libp2p transport under SES would inherit. The
patch-package-via-postinstall pattern is also a maintenance burden the garden
would want to weigh against a from-scratch lockdown-clean transport.

External-lineage flag: this is a MetaMask/ocap-kernel choice read for
reference, not an Endo or garden practice. We do not import this package.

Source: [packages/ocap-kernel/README.md](https://github.com/MetaMask/ocap-kernel/blob/e3352518864775c8b16b13a50246e7be2df9db45/packages/ocap-kernel/README.md) at commit `e335251`.
