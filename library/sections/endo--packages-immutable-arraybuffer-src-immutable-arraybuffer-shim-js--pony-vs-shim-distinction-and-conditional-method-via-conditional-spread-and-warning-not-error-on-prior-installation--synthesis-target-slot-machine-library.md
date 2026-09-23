---
title: §Synthesis target — slot machine library
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

For a slot machine library:

- §Pony-vs-shim-distinction for §game-rule-engine-pony-vs-shim — the pony is the standalone rule logic, the shim installs the rules onto the game-engine prototype.
- §Conditional-method-via-conditional-spread for §game-rule-features-that-depend-on-optional-game-engine-extensions.
- §The-`opt`-prefix for §game-engine-functions-that-may-or-may-not-be-available.
- §Better-fidelity-emulation-of-class-prototype for §game-engine-method-installation-matching-class-semantics.
- §Strip-enumerability-via-defineProperty-loop for §game-engine-methods-not-leaking-via-Object.keys-iteration.
- §Warning-not-error-on-prior-installation for §game-rule-update-warns-but-doesn't-block-redeploy.
- §Install-via-defineProperties-plus-getOwnPropertyDescriptors for §game-engine-installs-rule-set-as-batch.
- §TS-flow-inference-workaround-via-local-rebinding for §game-engine-TypeScript-edge-cases.
- §Getter-as-property-syntax for §game-state-properties-not-methods.
