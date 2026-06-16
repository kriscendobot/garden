---
title: The four regex patterns that shorten kept call-site strings in concise stack traces; the four ad-hoc rules that govern path-prefix dropping (`/.../`-bracketed prefix; bare-`.../`-prefix; pre-`packages/` monorepo path; `file://` vs `file:///` distinction with the VS-Code-clickability rationale); the agoric-sdk#2326 cross-thread linked in two of the four comment blocks; the unit-test-export discipline for shortenCallSiteString
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "124-210 (CALLSITE_ELLIPSIS_PATTERN1/2 + CALLSITE_PACKAGES_PATTERN + CALLSITE_FILE_2SLASH_PATTERN + shortenCallSiteString)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The middle section of `tame-v8-error-constructor.js` defines four
  regex patterns that *shorten* kept stack-frame strings in concise
  mode. Each pattern encodes one ad-hoc rule for which path-prefix to
  drop. The rules are *deliberately heuristic* — concise stacks are
  optimized for human readability rather than completeness — and each
  is documented with a worked before/after example. Two of the four
  comments link to `agoric-sdk#2326#issuecomment-773020389`, the
  cross-thread where the patterns were originally argued. The four
  patterns and the `shortenCallSiteString` function pair with the §1
  filename-censor mechanism: filename-censoring decides *whether* a
  frame is kept; pattern-shortening decides *how much path* to show in
  the kept frame's stringification.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--abstract.md)
- [Body](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--see-also.md)
- [Common confusions](endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns--common-confusions.md)
