---
title: §The name shifts from function to state
source-slug: endo--packages-lp32-src-host-endian-js
source-url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state
---

§The-helper-function-is-named-`isHostLittleEndian` (predicate shape) + §the-exported-constant-is-named-`hostIsLittleEndian` (state shape). §The-`is`-prefix-and-the-`Host`-subject-rearrange-when-the-shape-changes: §predicate (verb-first: *is the host little-endian?*) → §state (subject-first: *the host is little-endian*).

§The-name-IS-the-shape. §When-a-function-returns-a-fact-and-the-fact-is-cached-as-a-constant, §rename-from-predicate-to-state-form. §Predicate-form-with-`is`-prefix-asks-the-question + §state-form-with-subject-prefix-IS-the-answer.

§First-explicit-observation in library of §the-name-shifts-from-predicate-to-state-when-the-function-result-is-cached. §Sibling-to-cycle-237's-`stringCompare`-and-`pathCompare`-where-the-function-names-stay-stable-because-the-functions-themselves-are-the-exports; §contrast: cycle 243's function is internal scaffolding + the constant is the export.
