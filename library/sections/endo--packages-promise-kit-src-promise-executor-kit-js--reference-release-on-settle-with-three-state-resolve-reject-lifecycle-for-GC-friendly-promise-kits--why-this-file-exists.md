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
title: §Why-this-file-exists
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

§The-problem: a plain `new Promise(executor)` captures the
resolve/reject functions in the executor closure. If the
holder of those captured functions never releases them, the
promise itself is kept alive — even after settlement.
§Reference-retention-prevents-GC.

§The-fix: separate the §resolve/reject-functions-the-holder-
needs from the §internal-resolve/reject-captured-during-
executor-invocation. After settlement, §null-out-the-
internal-references. §The-holder's-exported-handles-are-
no-ops-after-settle.

§Result: §the-promise-can-be-GC'd-after-settlement even if
the kit object is retained.
