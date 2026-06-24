---
title: "§The `Far` vocabulary: E + Far + getInterfaceOf + passStyleOf"
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package
---

The four re-exports are the §canonical-capability-vocabulary:

1. **§`E`** — the proxy `E(x).method(args)` for eventual-send (sibling: cycle 146).
2. **§`Far`** — the constructor for remotable far-refs (`Far('IfaceName', methods)`).
3. **§`getInterfaceOf`** — the introspection function for a far-ref's interface name.
4. **§`passStyleOf`** — the central pass-style dispatch function (sibling: cycle 71).

§The-four-form-a-cohesive-vocabulary-for-far-references-and-pass-style-discovery. §`@endo/far`-IS-the-package-name-that-makes-them-a-single-import-path.

§First-explicit-observation in library of §the-canonical-Far-vocabulary as the named-four-exports of `@endo/far`. §When-an-application-uses-far-references, §the-`@endo/far`-import-IS-the-canonical-entry-point + §the-application-doesn't-need-to-know-which-implementation-package-provides-which-export.

§The-curated-package-IS-the-abstraction: §the-application-imports-from-`@endo/far` + §the-implementations-can-move-between-`@endo/eventual-send`-and-`@endo/pass-style`-without-the-application-knowing. §Sibling-pattern-to-cycle-242's-`@endo/platform`-conditional-exports — §two-cycles-with-named-curated-package-as-stable-import-path (242 + 258). §Two-different-shapes: §cycle-242 conditional-exports-by-platform + §cycle-258 curated-re-export-set-from-multiple-packages.
