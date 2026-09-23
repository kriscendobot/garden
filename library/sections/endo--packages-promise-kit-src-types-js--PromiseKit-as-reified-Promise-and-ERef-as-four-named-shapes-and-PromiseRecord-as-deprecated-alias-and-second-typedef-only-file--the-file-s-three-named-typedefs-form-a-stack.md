---
title: §The file's three named typedefs form a stack
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

§Stack-of-named-typedefs: §`ERef<T>` is the input-shape-vocabulary + §`PromiseKit<T>` consumes ERef-resolved-to-T in its resolver + §`PromiseRecord<T>` is the deprecated-alias of PromiseKit. §The-three-typedefs-form-a-stack: §the-bottom-(ERef)-IS-the-most-general + §the-middle-(PromiseKit)-IS-the-canonical + §the-top-(PromiseRecord)-IS-the-deprecated-rename.

§First-explicit-observation in library of §stack-of-three-typedefs-in-one-file (general-input + canonical + deprecated-alias).

§Sibling-pattern-to-cycle-249's-five-named-typedefs-in-49-lines — §two-cycles-with-multiple-typedefs-in-one-file: §cycle-249 has-the-Trap-protocol's-six-typedefs + §cycle-256 has-the-Promise-kit's-three-typedefs. §Both-files-isolate-a-protocol-vocabulary in a typedef-only module.
