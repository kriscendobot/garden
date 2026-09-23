---
ts: 2026-06-22T23:53:20Z
kind: result
role: fixer
worktree: dispatches/fixer--59c00c/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr: 405
branch: feat/inventory-grouping-by-type
frozen-base: llm-65b0abe
---

# PR #405 — inventory grouping by formula type: kriskowal review response

Addressed kriskowal's review comment (id 4765703096, 2026-06-22T06:59:24Z) on
PR #405 (`feat/inventory-grouping-by-type`).

## Rebase onto `origin/llm` tip `65b0abe27`

Rebased the PR's 3 commits (`66337466b`, `9a991d7ef`, `dbebc5061`) onto
`65b0abe27` (the concurrent Preact migration commit — `feat(daemon): add
editMessage and messageHistory`). Created frozen base branch `llm-65b0abe`
(already pushed to origin from the rebase setup) and updated the PR base via
`gh pr edit 405 --base llm-65b0abe`.

The only rebase conflict was `packages/chat/inventory-component.js`, which the
Preact migration deleted. Resolution: `git rm` the file and re-implement the
grouping logic inside the new `packages/chat/inventory/inventory.js`.

## Code changes

### `packages/chat/inventory/tree-source.js`

Added `INVENTORY_GROUPS` (array of `{ key, label, icon, types: Set<string> }`)
and `groupKeyForType(formulaType)` — both exported, both hardened. The four
groups are Handles (`handle`), Hubs (`directory`, `host`, `guest`,
`pet-store`), Workers (`worker`), and Everything Else (catch-all). Shared
between the component and the tests.

Added `InventoryGroup` JSDoc typedef for type-checking.

### `packages/chat/inventory/inventory.js`

- Added `InventoryGroupSection` component: collapsible group header + body.
Returns `null` when `names.length === 0` (the FRB `filter{items.length > 0}`
projection applied declaratively in Preact — empty groups are entirely absent
from the rendered tree).

- Added `typesByName: Map<string, string>` state in `InventoryList`. Updated
from two paths:
  1. `followNameChanges` add events carry a `type` field (enriched daemon
  path) — `setTypesByName` immediately, no `locate()` round-trip. This fixes
  the `/mkdir` reactive update bug.
  2. `onTypeResolved(name, formulaType)` callback from `InventoryItem` (older
  daemons that omit the `type` field).

- `InventoryList` renders `InventoryGroupSection` components (one per group)
when the `grouped` prop is `true` (the default at the top level). Nested
`InventoryList` instances pass `grouped: false`.

- Fixed jessie `safe-await-separator` lint warning: lifted the first `await`
out of the `try` block in `onToggle` via an `{ ok, value/error }` wrapper.

### `packages/chat/index.css`

Removed the duplicate `.pet-type-badge` rule introduced at a later cascade
position by the llm Preact migration; the PR's earlier rule (which includes
`flex-shrink: 0`) is the one that takes effect.

### `packages/daemon/test/endo.test.js`

Fixed `makeRefIterator` (undefined in that file) → `iterateReader` (already
imported) in the `followNameChanges existing names carry type` test.

### `packages/chat/test/helpers/mock-powers.js`

Added `addNameWithType(name, formulaType)` to the `MockPowersResult` API.
Emits `{ add: name, type: formulaType }` to simulate the enriched daemon
stream. Updated `nameChangeResolvers` type annotation to support the optional
`type` field.

### `packages/chat/test/component/inventory-component.test.js`

Fixed the pre-existing `hub-typed rows accept drop; leaf-typed rows do not`
test: positional `:nth-child` selectors broke when items moved into group
sections; replaced with a `rowFor(petName)` helper that locates the wrapper by
`.pet-name` span text.

Added 7 per-category entity tests:
1. `directory created via addNameWithType appears in the Hubs group`
2. `handle type appears in the Handles group`
3. `worker type appears in the Workers group`
4. `readable-blob type appears in the Everything Else group`
5. `eval type appears in the Everything Else group`
6. `empty group is hidden and non-empty group is shown`
7. `/mkdir reactive update: directory appears via addNameWithType without locate()`

## Test results

- `packages/chat` inventory component tests: 18 passed, 0 failed.
- `packages/daemon` `followNameChanges` tests: 9 passed, 0 failed.

## Pre-push gates

One pre-existing gate failure: `test-package-no-main` for
`packages/chacha12-fast-check-test/package.json` (has an `"exports"` field).
None of the PR's commits touch this package. The failure exists on the llm base
branch and is not a regression.

## Delivery

- Force-pushed with lease anchor `0136ea703`:
  `0136ea703...0b1ccfbc2 HEAD -> feat/inventory-grouping-by-type (forced update)`
- PR base updated to `llm-65b0abe` via `gh pr edit 405 --base llm-65b0abe`.
- Top-level summary comment posted at
  https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4774196088

## Self-improvement

Nothing this time.
