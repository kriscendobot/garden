---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §Helpful error messages
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

Every throw includes:
- §What-was-expected-or-what-went-wrong.
- §The-actual-bytes-at-fault (`JSON.stringify`'d, or
  `String.fromCharCode`).
- §Offset-into-the-stream (§where-in-the-byte-stream).
- §Name (caller-supplied; §what-stream-this-was).

§Four-pieces-of-context per error. §Debuggable-rejection.

§Comparison-with-cycle-149-unhandled-rejection-display:
§error-rendering-discipline shared. §Both-care-about-
producing-actionable-diagnostics.
