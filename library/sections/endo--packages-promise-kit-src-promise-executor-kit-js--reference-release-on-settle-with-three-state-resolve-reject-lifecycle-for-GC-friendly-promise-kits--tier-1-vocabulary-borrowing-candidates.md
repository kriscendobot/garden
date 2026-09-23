---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: §Tier-1 vocabulary borrowing candidates
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

§Three-state-internal-reference-lifecycle (undefined →
function → null).

§Reference-release-on-settle (explicit-release-on-known-
event, distinct from §weak-when-no-strong-ref).

§Releasing-as-qualifier-in-function-name (cleanup
mechanism named in the function name).

§Symmetric-release-of-paired-references (resolve releases
both internalResolve AND internalReject).

§undefined-vs-null-meaningful-distinction (state encoding
via JS value).

§Tier-2: §two-functions-named-vs-one-with-mode-arg
(intentional readability over DRY), §assert-without-
condition-as-bug-not-user-error.
