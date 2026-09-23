---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: "§The-design-rule: §conditional-vs-unconditional-depends-on-whether-the-target-is-correct"
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

§Two-rules-implicit-in-the-two-shims:

1. **If-the-target-may-be-correctly-installed-by-another-shim**:
   conditional install (§respect-prior-correctness).
2. **If-the-target-is-known-broken**:
   unconditional replacement (§don't-pretend-the-platform-is-
   correct-just-because-it's-the-default).

§Compare-to-cycle-180-hex-package's §belt-and-suspenders-for-
input-but-not-for-output. §Both-are-§asymmetric-disciplines-
based-on-which-side-needs-defense.

§The-`/* global globalThis */` ESLint directive at the top of
eventual-send/shim.js is necessary because shim.js is loaded
pre-lockdown when globalThis is not yet a tamed reference.
§Pre-lockdown-shim-discipline (cycle 181 base64 + cycle 183
init) requires acknowledging the global.
