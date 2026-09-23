---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the broader SES error-handling surface.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors` — the prior section in this source: the permit list + filename-censors that decide *whether* a frame is kept.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` — the next section: how the tameV8ErrorConstructor function wires the attenuation into V8's `Error.prepareStackTrace` hook.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the complementary pass-style-side V8-stack-accessor work.
