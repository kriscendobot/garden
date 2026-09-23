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
title: §The-naming-discipline-§releasing-as-qualifier
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

§makeReleasingExecutorKit names the §release-discipline in
the function name. §The-name-tells-you-the-pattern.

§Alternative-names that would lose this:
- `makeExecutorKit` — silent about release behavior
- `makeKitExecutor` — doesn't say *kit* clearly

§Releasing-as-adjective-in-function-name is the §borrow-
this-naming pattern. §If-your-function-does-cleanup-name-
the-cleanup-in-the-function-name.

§Cycle-118's-defendPrototype follows similar discipline
(*defend* names the protection mechanism). §Cycle-90's-
trackTurns (track = causal annotation). §Cycle-138's-
safe-promise (safe = reentrancy-safe). §Action-verb-or-
adjective-in-function-name is the @endo discipline.
