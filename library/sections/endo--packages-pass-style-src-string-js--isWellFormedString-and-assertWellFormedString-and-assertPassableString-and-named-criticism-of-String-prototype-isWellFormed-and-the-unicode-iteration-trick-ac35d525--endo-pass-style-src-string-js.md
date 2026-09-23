---
title: "`@endo/pass-style/src/string.js` — the passable-string utility module"
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
---

An 83-line file that is **not** a PassStyleHelper concrete instance but a utility module that exports **three named primitives** (`isWellFormedString` + `assertWellFormedString` + `assertPassableString`). Carries dense Unicode knowledge, feature-detection-at-module-load, named criticism of a standard API, and an explicit three-stage migration plan.

§First-explicit-observation in library: **§a-cluster-utility-module-that-IS-not-a-PassStyleHelper-but-carries-three-named-predicates-and-asserters — §the-pass-style-cluster-has-helper-files-(cycles 260 + 262 + 264 + 268)-and-utility-files-(cycle 272-string-js); §the-cluster-has-two-named-file-shapes-not-one**.
