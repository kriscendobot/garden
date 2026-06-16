---
title: Related material in the library
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
---

- **cycle 201 @endo/immutable-arraybuffer**: §ponyfill+shim sibling — both designs anticipate future native arrival.
- **cycle 215 @endo/hex**: §ponyfill-with-load-time-dispatch sibling + §native-error-rerun-polyfill-for-better-diagnostic sibling (different error-context pattern).
- **cycle 217 @endo/errors**: §`__HIDE_`-prefix-protocol sibling (cycle 223 has the `͏` invisible-prefix, cycle 217 has the visible `__HIDE_` prefix).
- **cycle 199 + 205 + 213 + 217 + 223**: §runtime-version-or-environment-compat-hacks family (cycle 223 adds the fifth member with the babel-NESM-RESM matrix).
- **cycle 132 + 146 + 154 + 199 + 219 + 223**: §freeze-not-harden-with-named-correctness-argument family (cycle 223 is the sixth member).
- **cycle 221 @endo/bundle-source**: §parsed-result-cache sibling (cycle 221 caches by SHA-512; cycle 223 caches by reference in-memory).
- **cycle 222 endoclaw-skill-registry**: §discriminated-union-via-key-presence sibling (cycle 223's `new.target === undefined` is a different shape of §catch-mistakes-early-with-clear-error).
- **cycle 218 familiar-localhttp-protocol**: §canary-DNS-resolution sibling (the §minimal-prefix-that-preserves-other-properties shape; cycle 223's shebang-comment-out is the same shape at the lexical layer).
- **cycle 200 worker-rust-xs**: §engine-level-confinement sibling (different layer, both deal with §SES-Compartment-internal-contract).
- **cycle 211 @endo/common**: §honest-disclosure-of-load-order-constraint sibling.
