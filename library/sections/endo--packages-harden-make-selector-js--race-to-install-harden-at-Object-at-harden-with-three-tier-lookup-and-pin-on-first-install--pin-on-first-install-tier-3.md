---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §Pin-on-first-install (tier 3)
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

```js
Object.defineProperty(Object, symbolForHarden, {
  value: harden,
  configurable: false,
  writable: false,
});
```

§Non-configurable-and-non-writable: §nobody-can-replace-
this-later, not even the same code re-importing.

§Why-this-matters: §later-imports-find-it-via-tier-1 (no
fresh make). §The-harden-identity-is-stable across all
later imports.

§The-comment-warns:

> *We should not reach this point if a harden
> implementation already exists here. The non-
> configurability of this property will prevent any
> HardenedJS's lockdown from succeeding. Versions that
> predate the introduction of Object[@harden] will be
> unable to remove the unknown intrinsic. Versions that
> permit Object[@harden] fail explicitly.*

§Explicit-incompatibility-with-pre-Object[@harden]-
HardenedJS-versions. §Honest-warning: pinning this slot
on an older HardenedJS implementation will *break*
lockdown.

§The-trade-off: §forward-compat-via-pin vs §backward-
compat-via-non-installation. §This-file-chooses-forward-
compat.
