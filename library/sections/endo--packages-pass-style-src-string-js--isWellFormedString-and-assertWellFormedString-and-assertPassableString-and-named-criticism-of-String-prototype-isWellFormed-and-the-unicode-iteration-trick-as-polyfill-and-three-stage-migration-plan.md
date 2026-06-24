---
title: "@endo/pass-style/src/string.js — isWellFormedString + assertWellFormedString + assertPassableString + named criticism of String.prototype.isWellFormed + the unicode-iteration-trick as polyfill + three-stage migration plan named explicitly"
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
kind: index
section_count: 15
---

Sections:

- [`@endo/pass-style/src/string.js` — the passable-string utility module](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--endo-pass-style-src-string-js.md)
- [§The named criticism of `String.prototype.isWellFormed`](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-named-criticism-of-string.md)
- [§The feature-detection-at-module-load with conditional binding](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-feature-detection-at-modul.md)
- [§The unicode-iteration-trick as polyfill strategy](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-unicode-iteration-trick-as.md)
- [§Three named exports — predicate + asserter + extended-asserter](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--three-named-exports-predicate.md)
- [§The ONLY_WELL_FORMED_STRINGS_PASSABLE environment option](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-only-well-formed-strings-p.md)
- [§The three-stage migration plan named explicitly](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-three-stage-migration-plan.md)
- [§The performance-uncertainty acknowledgment](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--the-performance-uncertainty-ac.md)
- [§Cycle 272 first-explicit-observations roundup (eleven)](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--cycle-272-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 272](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-ac35d525--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-a-ac35d525--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-a-ac35d525--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-a-ac35d525--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-a-ac35d525--pattern-summary-tag-prefixed.md)
