---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §Object.freeze-not-harden (the index.js discipline)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
// (index.js comment)
// Re-exports the package's named bindings.  Each source module
// (`./src/encode.js`, `./src/decode.js`, `./atob.js`, `./btoa.js`)
// applies `Object.freeze` to its export at module-evaluation time, so
// the bindings are hardened on both the public path through this
// module and on the pre-lockdown shim path that `@endo/init/pre.js`
// uses (`@endo/base64/shim.js` -> `./atob.js` / `./btoa.js`).  Using
// `Object.freeze` rather than `@endo/harden` keeps the shim path free
// of any module that would install a fallback `harden` before SES
// `lockdown()` freezes the well-known properties of `globalThis`.
```

§This-is-the-§canonical-design-choice that cycle 180 hex-package
did NOT explicitly name. §Why-Object.freeze-instead-of-harden:

- §`@endo/base64`-loads-pre-lockdown via `@endo/init/pre.js` →
  `@endo/base64/shim.js` → `./atob.js` / `./btoa.js`.
- §If-the-shim-path-imported-`@endo/harden`, it would install a
  fallback `harden` before SES lockdown freezes globalThis.
- §That-fallback-install would be on the §race-to-install-at-
  well-known-slot path (cycle 175 make-selector.js) and would
  fire before lockdown could pin the canonical `harden`.
- §Object.freeze-is-primordial-and-doesn't-touch-globalThis,
  so it's safe to call from a pre-lockdown shim.

§This-is-§pre-lockdown-shim-discipline that cycle 175's race-
to-install-harden mechanism interacts with. §Object.freeze-at-
module-init-is-§the-safe-equivalent-of-harden-for-pre-lockdown-
shims.

§Cycle-180-hex-package omits `atob.js` / `btoa.js` / `shim.js`,
so hex doesn't need to participate in the pre-lockdown shim
path; §but-it-still-uses-Object.freeze-on-its-exports (per the
SES considerations in its design) to match @endo/base64's
discipline for consistency.
