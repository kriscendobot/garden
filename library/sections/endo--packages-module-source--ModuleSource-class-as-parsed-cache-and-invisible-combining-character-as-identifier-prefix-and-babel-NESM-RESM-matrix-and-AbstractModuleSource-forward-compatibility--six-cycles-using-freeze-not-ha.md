---
title: §Six-cycles-using-freeze-not-harden-with-named-correctness-argument family
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

| Cycle | Source | Reason |
|-------|--------|--------|
| 132 | local.js | eventual-send evaluates before SES lockdown completes |
| 146 | E.js | `freeze` but not `harden` the proxy target so it remains trapping (stabilize-discipline) |
| 154 | trap.js | same as E.js (verbatim-comment-shared-across-derived-files) |
| 199 | trampoline | classic-uncurry-this with pre-lockdown capture |
| 219 | ses-ava | instantiation must precede lockdown; reachable objects are intrinsics |
| 223 | module-source | must be parseable pre-lockdown; cast comment names the readonly-marking workaround |

§Six-different-reasons-for-the-same-mechanism.
