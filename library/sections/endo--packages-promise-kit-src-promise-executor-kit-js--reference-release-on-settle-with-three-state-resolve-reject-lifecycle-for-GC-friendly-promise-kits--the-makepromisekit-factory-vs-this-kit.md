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
title: §The-makePromiseKit-factory-vs-this-kit
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

`@endo/promise-kit` exports `makePromiseKit()` (the
canonical name). This file exports `makeReleasingExecutorKit
()` — note the §releasing-qualifier in the name.

§The-distinction:

- `makePromiseKit()` (in another file, not this one): the
  §full-kit including the promise itself.
- `makeReleasingExecutorKit()` (this file): the §executor-
  half only — resolve/reject + executor function, no
  promise. §Caller-passes-executor-to-Promise-constructor.

§This-file-is-the-§executor-half; the promise itself is
constructed by the caller. §Decomposed-for-composition.

§Why-decompose: §the-promise-constructor-can-be-any (not
just `Promise` — could be `HandledPromise`, a future
variant, etc.). §The-executor-kit-is-promise-agnostic.

§Cycle-66's-HandledPromise + cycle-146's-E.js use this
flexibility — they construct §HandledPromises with executors
from kits like this one.
