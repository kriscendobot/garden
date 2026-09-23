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
title: §Tier-1 vocabulary borrowing candidates
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

§Two-state-iterator-state-machine (named states +
implicit-null-as-state-discriminator).

§Zero-copy-fast-path (subarray-instead-of-allocate when
data fits in one chunk).

§Allocate-on-multi-chunk (one allocation per message; not
per chunk).

§Sanity-caps-defense-in-depth (maxMessageLength +
maxPrefixLength).

§Four-pieces-of-context-per-error (what / actual-bytes /
offset / name).

§Dangling-message-detection at EOF.

§Tier-2: §pre-computed-byte-constants (COLON, COMMA,
ZERO, NINE), §legacy-export-as-alias (migration
discipline), §state-encoded-as-null-vs-not-null.
