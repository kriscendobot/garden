---
ts: 2026-06-02T03:44:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--a9d075
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338365530
---

# dispatch: builder — #379 `makeNotifierWithResolver` helper + CommonJS reexport test

kriskowal review on #379 (state COMMENTED, with explicit asks — actionable per
`feedback_commented_review_with_asks_is_actionable.md`) on
`packages/ses/src/module-instance.js:396`:

> Naugtur and I agree there is a likely opportunity for refactoring, here. The
> notifier system would benefit from a synchronous variant on
> Promise.withResolvers, e.g., makeNotifierWithResolver, that can be used here
> and in makeVirtualModule, to reduce the likelihood that these parallel
> implementations will drift.
>
> Naugtur also asked for a test that verifies similar behavior if the
> reexporting module is CommonJS. I would like a test that at least verifies
> that the behavior is consistent with Node.js in that scenario.

## Task

Two parts; do both:

### Part 1 — `makeNotifierWithResolver` helper

The two parallel implementations in `packages/ses/src/module-instance.js`:

1. **`wireUpExportNotifier` deferred branch** (around lines 376-396): the
   star-export-cycle resolver, with `pendingUpdaters[]` queue + lazily
   resolved `resolvedUpstreamNotify`.
2. **`makeVirtualModuleInstance`** (around lines 75-78): notifier created for
   each `moduleSource.exports` entry, with `updaters[]` queue and `set` that
   replays to subscribers.

Both queue subscribers, both fire on a resolution event (upstream notify
arriving, or `set` being called).

Introduce a helper `makeNotifierWithResolver()` that returns
`{ notify, resolve }` (or similar shape — name the second function clearly;
"resolve" matches Promise.withResolvers terminology and kriskowal's framing
of it as "synchronous variant on Promise.withResolvers").

The resolver semantics: subscribers added via `notify(update)` before
`resolve` is called are queued; after `resolve(targetNotify)` is called,
queued updaters are forwarded immediately and subsequent `notify(update)`
calls pass through directly to `targetNotify`.

Place the helper in a location that both `module-instance.js` sites can
share — likely `packages/ses/src/notifier-resolver.js` (or near the existing
internal helpers; use your judgment after reading the existing structure).

Refactor both call sites to use it. Verify with `git grep -n
pendingUpdaters` and `git grep -n resolvedUpstreamNotify` that the local
state machinery is gone (or, if you decide one site doesn't fit the
abstraction cleanly, leave that one and document the asymmetry in the PR
description/commit message — do NOT force a fit that obscures semantics).

If you discover that the `makeVirtualModuleInstance` pattern is materially
different from the cycle-resolver pattern and the unification harms clarity,
implement the helper only in the cycle-resolver site and surface a one-line
comment on the PR explaining the asymmetry (this is a builder design
judgment — exercise it openly).

### Part 2 — CommonJS reexport test

Add a test that verifies cyclic star-export behavior is consistent with
Node.js when the reexporting module is CommonJS. Look at:
- Existing star-export-cycle tests: `packages/ses/test/import-gauntlet.test.js`
- Existing CJS infrastructure: `packages/ses/test/import-cjs.test.js`,
  `packages/ses/test/_enforce-cjs-strict.js`

Choose the right place for the new test (likely a new test case in
`import-cjs.test.js` or `import-gauntlet.test.js`; pick based on which file's
fixtures most naturally support the cyclic + CJS combination).

Run the existing test suite locally to confirm:
- The new test passes.
- The refactored helper does not regress any existing star-export-cycle or
  notifier-related test.

Use `cd packages/ses && yarn test` (or the project's standard test command).

## Per-action authorizations

- Create new file(s) under `packages/ses/src/` for the helper. Authorized.
- Edit `packages/ses/src/module-instance.js`. Authorized.
- Add test files / cases under `packages/ses/test/`. Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:fix/issue-59-star-export-cycle`. Authorized.
- Posting an explanatory PR comment if the unification design has to fall
  back to single-site. Authorized.

## Not authorized

- Force-pushing.
- Resolving the GitHub review thread (steward does that after builder
  reports).
- Un-drafting (PR is already non-draft; preserve that).
- Merging.
- Modifying files outside `packages/ses/{src,test}/`.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--a9d075/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--a9d075/garden/roles/builder/AGENT.md`
3. Skills referenced by the builder just-in-time. The
   `coverage-driven-testing` skill is relevant to Part 2; the
   `regression-evidence` skill applies if you decide to bench any code path.

Project worktree at `project/` on `fix/issue-59-star-export-cycle`
(head `96ea2c59c`).

## Report

A `result` journal entry. Include: new head SHA after push, list of files
modified/added, test command + outcome (existing tests still pass, new test
passes), the helper's chosen API (signature + brief semantics), and any PR
comment IDs posted (if Part 1 fell back to single-site).
