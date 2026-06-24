---
ts: 2026-06-14T08:10:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--71b7f5
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
  - repo: Agoric/agoric-sdk
    pr: 12527
    role: upstream-source
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/Agoric/agoric-sdk/pull/12527
  - https://github.com/Agoric/agoric-sdk/pull/12527#pullrequestreview-4472042222
---

# dispatch: fixer — apply Copilot review feedback to PR #5 mirror

User directive (2026-06-14T~08:09Z): "Please apply feedback
from copilot review …pull/12527#pullrequestreview-4472042222
to our mirror of that PR."

Copilot's review on upstream `Agoric/agoric-sdk#12527`
(state COMMENTED, 2026-06-10T22:23:55Z) has 3 inline asks
to be applied to the bot-fork mirror PR #5.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh`
  at `5e15800304ae557dd0c75805604147b4ee7823ea` (most
  recent push from the stalled fixer c997e7's
  drive-to-green work; FETCH if newer).

## Copilot's 3 inline asks (on upstream #12527)

1. **`services/ymax-planner/src/utils.ts:67`** (Copilot
   comment id `3391919653`):
   > `lookupValueForKey` now accepts `key: string`, which
   > removes the compile-time guarantee that the key is one
   > of the keys of `source` (K) and can allow accidental
   > typos to slip through to a runtime throw. Consider
   > restoring a `key: K` overload (while keeping a `string`
   > overload for call sites that only have `string`) so
   > callers still get type safety when possible.

2. **`packages/SwingSet/tools/test-swingset.js:46`**
   (Copilot id `3391919693`):
   > `bundleFromSourceSpec` is declared to return a
   > `Promise<EndoZipBase64Bundle>` (see
   > `BundleFromSourceSpecPower`), but this currently casts
   > the result to `Promise<any>`, which discards useful
   > type checking. Prefer an explicit `EndoZipBase64Bundle`
   > annotation here instead of `any`.

3. **`packages/SwingSet/src/kernel/slogger.js:38`**
   (Copilot id `3391919734`):
   > `@ts-expect-error` will cause CI to fail if
   > `objectMap(...)` stops triggering an error on the next
   > line (TS2578: expected an error, but none occurred).
   > If the goal is just to silence a noisy type mismatch,
   > `@ts-ignore` avoids that brittleness while keeping the
   > intent clear.

## Task

In your `project/` worktree on
`mirror/12527-endo-sync-refresh` at `5e15800304`:

1. **Locate the analogous lines** on the mirror branch.
   The mirror cherry-picks upstream #12527's commits, so
   the file paths should match. Verify each path exists +
   inspect the current line content. If line numbers have
   drifted, find the analogous code by context.
2. **Apply Ask 1** (lookupValueForKey overload):
   - Edit `services/ymax-planner/src/utils.ts` to add a
     `key: K` overload alongside the `string` overload.
     Both overloads route to the same implementation.
3. **Apply Ask 2** (Promise type annotation):
   - Edit `packages/SwingSet/tools/test-swingset.js` to
     replace the `as Promise<any>` cast with explicit
     `EndoZipBase64Bundle` annotation. Import the type
     from `@endo/bundle-source` (or wherever it's defined)
     if not already imported.
4. **Apply Ask 3** (ts-ignore swap):
   - Edit `packages/SwingSet/src/kernel/slogger.js:38` to
     swap `@ts-expect-error` for `@ts-ignore`. Preserve the
     surrounding eslint-disable if present.
5. **Run** `corepack yarn workspace ymax-planner lint:types`
   (or the appropriate per-workspace check) for each of
   the three touched packages.
6. **Commit per ask** OR bundle if changes are tightly
   coupled. Suggested:
   - `fix(ymax-planner): restore key: K overload on
     lookupValueForKey per copilot`
   - `fix(SwingSet): annotate bundleFromSourceSpec return
     type per copilot`
   - `fix(SwingSet): swap @ts-expect-error for @ts-ignore
     on slogger objectMap per copilot`
7. **Push** to `mirror/12527-endo-sync-refresh` (append
   push; force-with-lease if amend pattern needs it).
8. **Post a top-level comment** on PR #5 at-mentioning
   `@kriskowal`:
   - Note the 3 Copilot asks from upstream
     `pullrequestreview-4472042222`.
   - List the 3 commit SHAs.
   - Brief description of each change.
9. **Do NOT post** on the upstream Agoric/agoric-sdk PR
   #12527 — we have no authority there. The mirror's
   changes flow upstream only via boatman ferry from the
   credentialed host (separate engagement).

## Authorizations

- **Push commits** to `mirror/12527-endo-sync-refresh`
  (append or force-with-lease). Implicit in the fixer
  dispatch.
- **Top-level comment** on PR #5 at-mentioning kriskowal.
- Do NOT re-request review (the maintainer is actively
  routing this PR; the fix lands as part of the
  drive-to-green work).

## Out of scope

- Do NOT touch upstream Agoric/agoric-sdk.
- Do NOT chase the broader drive-to-green work the
  parallel fixer (now torn down due to stall) was doing
  — apply ONLY Copilot's 3 asks.
- Do NOT rebase the PR base.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/`
naming:

- Pre/post head SHAs.
- The 3 commit SHAs.
- Per-ask resolution: file path + line + change description.
- Local lint:types result for each touched workspace.
- The PR #5 comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
