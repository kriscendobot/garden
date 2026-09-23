---
title: The tameV8ErrorConstructor function that wires censoring + shortening into V8's `Error.prepareStackTrace` hook; the system-vs-user prepareFn distinction; the WeakSet branding that ensures only system prepareFns ever receive an unattenuated SST; the captureStackTrace + prepareStackTrace pair with the `stackInfos` WeakMap; the getStackString shim of the proposed error-stack TC39 special-power
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "212-end (tameV8ErrorConstructor function and exports)"
topics: [hardened-javascript, errors, capability-security]
status: current
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--abstract.md)
- [Body](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--see-also.md)
- [Common confusions](endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns--common-confusions.md)
