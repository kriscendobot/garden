---
ts: 2026-06-02T03:57:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/034400Z-dispatch-steward-a9d075.md
  - entries/2026/06/02/035451Z-result-builder-a9d075.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
---

# result: builder chain on #379 — `makeNotifierWithResolver` (single-site) + CommonJS reexporter test; asymmetry explained on PR thread

The builder chain to address kriskowal's COMMENTED review on #379 (the
"missed" item the maintainer flagged) completed cleanly.

## Builder outcome (result `a9d075`)

- **New helper**: `packages/ses/src/notifier-with-resolver.js` exports
  `makeNotifierWithResolver() → { notify, resolve }`. Sync analogue of
  `Promise.withResolvers`: `notify(update)` queues pre-resolve and forwards
  post-resolve; `resolve(targetNotify)` is one-shot, drains queue, switches
  mode.
- **Refactor**: `wireUpExportNotifier` deferred branch in
  `packages/ses/src/module-instance.js` now uses the helper. The
  `pendingUpdaters[]` + `resolvedUpstreamNotify` local state is gone.
- **Asymmetry**: the helper was NOT applied to `makeVirtualModuleInstance`.
  That site is a live-cell fan-out (`set` called repeatedly; every subscriber
  must receive every future value), structurally distinct from the
  one-shot-redirect shape of `makeNotifierWithResolver`. The builder's
  judgment was that unifying would require a "repeat-resolve" semantic or a
  current-value protocol — either obscures local semantics. Documented in
  the refactor commit message and via inline PR comment (see below).
- **Test**: added `cyclic star-export with CommonJS reexporter` case to
  `packages/ses/test/import-cjs.test.js`. CJS `star-reexporter.cjs` captures
  via property assignment; ESM `export-renamer.mjs` does `export { y as x }
  from './star-reexporter.cjs'`. Assertions pinned to Node.js parity (the
  builder verified Node behavior directly against a pure-CJS variant since
  Node rejects ESM-in-CJS-cycle outright): `ns1 = {x: undefined, y: 45}`,
  `ns2 = {x: 45, y: 45}`, `captured = undefined`. SES matches exactly.
- **New head**: `8a608ce86d295a504c7dbeff6c10ed35b3d2a6ce` (was
  `96ea2c59c`; two commits appended).
- **Test command + outcome**: `cd packages/ses && yarn test` reports 504
  passed + 2 known failures + 2 skipped (baseline was 503 + 2 + 2; +1 new
  test). `yarn eslint` and `yarn prettier --check` on the three changed
  files: clean.

## Steward post-builder actions

- **PR thread reply**: posted comment 3338583474 in reply to
  3338365530 explaining the single-site application and asymmetry
  rationale, with the offer to revisit (forced unification, or a separate
  `makeLiveNotifier` for the fan-out site).
  https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3338583474
- **Review thread NOT resolved**: the partial application is a design call
  the maintainer should accept or push back on. Resolving would imply "fully
  addressed" — it isn't.

## Net effect on #379

PR #379 has two new commits atop `96ea2c59c`:

```
8a608ce86  refactor(ses): apply makeNotifierWithResolver to cycle-resolver
           [+ test(ses): cyclic star-export with CommonJS reexporter parity]
```

(Two logical commits; exact SHAs in the builder's result entry. Last commit
hash is the new head.)

PR remains non-draft (preserved per dispatch); reviewDecision still empty
(no CHANGES_REQUESTED state was on this PR). Awaits maintainer follow-up
on the asymmetry call.

## Cleanup

`dispatches/builder--a9d075` torn down.

## Adjacent queue change observed

- **#345 MERGED** at 03:48:21Z (the long-running cancel-package PR). No
  steward action; just noting it as queue clearance.
- **#388, #389** newly opened (kriscendobot DRAFT, design/gateway-package
  stack phase 2 and 3); not yet engaged.

## Next

Watch for kriskowal follow-up on the asymmetry comment. If accepted, the
review thread closes naturally. If pushed back ("force the unification" or
"do a separate `makeLiveNotifier`"), the next dispatch is another builder
to either unify (with the documented semantic stretch) or land
`makeLiveNotifier` and refactor `makeVirtualModuleInstance`.

## Steward queue post-engagement

- **#379** builder commits landed; asymmetry surfaced on review thread;
  awaiting maintainer follow-up.
- **#387** rename applied earlier; CI green; DRAFT; awaiting maintainer
  re-review.
- **#345** MERGED.
- **#388, #389** newly opened kriscendobot DRAFT stack (gateway phase 2/3);
  awaiting auto-DRAFT-gauntlet pickup.
- **#377** awaiting kriskowal reply.
- **#357** APPROVED, UNSTABLE.
- **#343** CHANGES_REQUESTED; CI re-ran earlier.
- **#358**, **#335**, **#329**, **#231**, **#138**, **#241**, **#320**,
  **#79** unchanged.
- **kriskowal/garden#3** unchanged.
