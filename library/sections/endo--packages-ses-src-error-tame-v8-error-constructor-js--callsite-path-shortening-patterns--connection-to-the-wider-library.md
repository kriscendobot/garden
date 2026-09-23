---
title: Connection to the wider library
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
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns
---

This section is the **canonical worked example of *path-shortening via ordered regex patterns*** at the SES error layer. Three threads:

1. **The first-match-wins-via-ordered-list pattern**. Each pattern is more or less specific; the first that matches captures the intended transformation. Reusable for any rewriting pipeline where multiple patterns might apply but only one should fire per input.

2. **The `agoric-sdk#2326#issuecomment-773020389` cross-thread linking discipline**. The patterns reference the GitHub discussion where they were designed. Future maintainers reading the code can follow the link to understand *why* these patterns were chosen.

3. **The export-for-testability + non-API-status comment pair**. Both `filterFileName` and `shortenCallSiteString` are *internal*-but-*exported* with the `// Exported only so it can be unit tested.` comment. The pattern signals *don't depend on this from outside the package*.
