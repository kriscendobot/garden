---
title: Abstract
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

The §middle cluster of `tame-v8-error-constructor.js` defines four regex patterns used to shorten kept call-site strings in *concise* stack traces. The four patterns and their rules: **CALLSITE_ELLIPSIS_PATTERN1** — *any likely-file-path or likely url-path prefix, ending in a `/.../` should get dropped*; example: `'Object.bar (/vat-v1/.../errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (errors/test/deep-send.test.js:13:21)'`. **CALLSITE_ELLIPSIS_PATTERN2** — *any likely-file-path or likely url-path prefix consisting of `.../` should get dropped*; the simpler form when the `.../` is at the path's start. **CALLSITE_PACKAGES_PATTERN** — *any likely-file-path or likely url-path prefix, ending in a `/` and prior to `packages/` should get dropped*; example: `'Object.bar (/Users/markmiller/src/ongithub/agoric/agoric-sdk/packages/errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (packages/errors/test/deep-send.test.js:13:21)'`. *Note that `/packages/` is a convention for monorepos encouraged by lerna.* **CALLSITE_FILE_2SLASH_PATTERN** — *any likely-file-path or likely url-path prefix of the form `file://` but not `file:///` gets dropped*. The §2slash rationale: *`file:///` usually precedes an absolute path which is clickable without removing the `file:///`, whereas `file://` usually precedes a relative path which, for whatever vscode reason, is not clickable until the `file://` is removed*. The four patterns are tried *in order*: the first matching pattern's capture-groups define the kept-parts; if no pattern matches, the original string is returned unchanged. The `shortenCallSiteString` function is *exported only so it can be unit tested* (same convention as §1's `filterFileName`).
