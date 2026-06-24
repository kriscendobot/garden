---
source_kind: source
source_repo: endojs/endo
source_path: packages/daemon/src/deferred-tasks.js
source_line_range: 1-23
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 370 chat-lane ingest paired to cycle 369 designs-lane
  @endo/daemon README. 23-line internal task-deferral utility
  from the daemon package. Eighteenth AUTHORED conformant
  single-body section doc in post-refactor era. Sixty
  consecutive non-garden sources after the pivot (310-370).
  §sixty-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  readonly-cast-as-parallel-safety-discipline — line 16
  reads `/** @type {Readonly<T>} */ (param)`. The same
  parameter is shared across all parallel tasks during
  `execute`; the cast COMMUNICATES to the type system that
  no task should mutate it. Defensive design at the type-
  system level, not the runtime level (the cast doesn't
  freeze; it just tells the checker the value must be
  treated as read-only). §the-named-type-level-defense-
  against-parallel-mutation as tier-3 meta-pattern.

  §The-named-two-phase-register-then-execute — the API has
  `push` (registration phase) and `execute` (commit phase).
  Tasks accumulate during registration, then all run
  together during commit. §the-named-batch-execution-at-
  commit-time as tier-3 meta-pattern.

  §The-named-parallel-isolated-task-execution — `Promise.
  all(tasks.map(...))` runs all tasks concurrently. Each
  task receives the same parameter but cannot read other
  tasks' state. §the-named-fan-out-via-Promise-all as
  tier-3 meta-pattern.

  §The-named-twenty-three-line-utility-from-thousands-of-
  lines-of-daemon — daemon is roughly 8,000 lines across
  many source files (daemon.js 2778; host.js 767; mail.js
  714; etc.); deferred-tasks.js is 23 lines. The chat-lane
  source picks ONE TINY UTILITY from the daemon's
  engineering substrate. §the-named-fragmentary-HOW-from-
  minimal-README-shape — the WHAT-VS-HOW shape (cycle
  361→362 ses-ava framing) becomes fragmentary when the
  README is minimal (14 lines, cycle 369) and the source
  is one of many implementation files.

  §The-named-ts-check-pragma-as-opt-in-checking — line 1
  `// @ts-check`. Sibling to cycle 369's check-bundle/json.js
  observation; opts the JavaScript file into TypeScript
  checking for the file alone.

  §The-named-JSDoc-import-syntax — line 3 `@import {
  DeferredTasks, DeferredTask } from './types.js'`. JSDoc's
  recent `@import` syntax (TypeScript 5.5+) for type-only
  imports without runtime import statements. §the-named-
  type-only-import-without-runtime-import as tier-3 meta-
  pattern.

  §The-named-template-generic-T-constrained-to-Record —
  `@template {Record<string, string | string[]>} T`
  constrains the parameter type to be a record of
  strings-or-string-arrays. The deferred tasks accept some
  specific shape of parameter; the template generic
  preserves the shape across the push/execute boundary
  while constraining what shapes are allowed. §the-named-
  constrained-generic-parameter as tier-3 meta-pattern.

  §The-named-factory-returning-execute-and-push-pair — the
  factory makeDeferredTasks returns an object with two
  methods. §the-named-tiny-two-method-API as tier-3 meta-
  pattern, sibling to cycle 364's §the-named-two-function-
  API in benchmark.

  Closes seven citation arcs: cycle 369 (1, adjacent
  forward pair daemon README → daemon utility; the source
  is orthogonal to the README's operational narrative;
  WHAT-VS-HOW with fragmentary HOW because daemon README
  is minimal and daemon implementation is vast) + cycle
  368 (1, exo's prepare-as-fourth-verb-pattern uses similar
  staging discipline: prepare during first crank, use after;
  deferred-tasks's push-then-execute is the same shape
  scaled down) + cycle 366 (1, cycle 366's skel/test
  injected helpers via dependency-as-prepared-state; cycle
  370's deferred-tasks is push-then-execute at the runtime
  layer, sibling shape of staged-composition) + cycle 364
  (1, benchmark's two-function-API; deferred-tasks is also
  a two-method-API) + cycle 362 (1, ses-ava's env-mutation
  via additive-augment was also a staged-composition; the
  deferred-tasks pattern generalizes that idea into a
  reusable utility) + cycle 326 (43, pure-naming-as-
  discipline sibling) + cycle 322 (44, @endo/errors not
  used here; the utility is so small it doesn't need
  error decoration). Pushes citation-arc-closures-in-pivot
  to TWO-HUNDRED-SIXTY (253 + 7 net new).
---

23-line internal task-deferral utility from @endo/daemon. Chat-lane after cycle 369 designs-lane daemon README. §the-named-readonly-cast-as-parallel-safety-discipline (single most structurally interesting move — type-level defense against parallel mutation). §the-named-two-phase-register-then-execute (push during registration; execute as commit). §the-named-parallel-isolated-task-execution (Promise.all fan-out). §the-named-twenty-three-line-utility-from-thousands-of-lines-of-daemon (fragmentary HOW from minimal README). §the-named-ts-check-pragma-as-opt-in-checking. §the-named-JSDoc-import-syntax (`@import` TS 5.5+ syntax). §the-named-template-generic-T-constrained-to-Record. §the-named-tiny-two-method-API (sibling to cycle 364 benchmark's two-function-API). Seven citation arcs closed.
