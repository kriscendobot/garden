---
job: c50e55
posted_by_role: steward
posted_by_host: endolinbot
posted_at: 2026-06-06T05:02:08Z
verb: action-followups
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 351
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - liaison
refs:
  - projects/endo-but-for-bots/followups/endo-but-for-bots--351.md
  - https://github.com/endojs/endo/pull/2422
preconditions: []
---

# Action follow-ups for endojs/endo-but-for-bots#351

Triggered by upstream `endojs/endo#2422` merging at 2026-06-06T04:59:50Z (mergedBy: kriskowal). Bot-side PR #351 was closed at 2026-06-06T05:01:03Z with kriskowal's "Merged upstream." narrator comment; the upstream-merge trigger fires first per the steward role's *Parked followup revisit* rule.

The retconned 4-commit shape this steward dispatched on the bot side (per `entries/2026/06/06/044200Z-result-steward-6482f8.md`) was re-ferried upstream by a concurrent liaison's boatman (per the in-flight dispatch noted in `entries/2026/06/06/044451Z-dispatch-liaison-f00965.md`), and upstream merged that shape.

## Items (verbatim from `projects/endo-but-for-bots/followups/endo-but-for-bots--351.md`)

- [ ] **`packages/compartment-mapper/src/policy.js:520-548` `attenuateModule`'s four-branch shape enumeration has two reachable throw paths (descriptor with non-virtual `source`; bare descriptor with no virtual-source shape) that no test covers.**
  **Recommended action**: open a follow-up test PR on `endojs/endo`. Add policy.test.js fixtures exercising each of the two uncovered throw branches: (a) a `SourceModuleDescriptor` whose `source` is a `PrecompiledModuleSource` or `NamespaceModuleDescriptor`; (b) a bare `NamespaceModuleDescriptor` (no `imports`/`exports`/`execute`). Optionally, replace the four-branch case-analysis test set with a `fast-check` property test over a discriminated-union arbitrary.

- [ ] **`packages/compartment-mapper/test/exit.test.js` `test.failing('can make, parse, and import an archive with a URL-scheme-prefixed modules map exit to a host module', ...)` cites no tracking issue.**
  **Recommended action**: file a tracking issue on `endojs/endo` describing the `modules:` map exit shape that does not yet round-trip through `makeArchive`/`parseArchive`/`app.import`. Cross-link the merged upstream PR (endojs/endo#2422) for context.

- [ ] **`packages/compartment-mapper/src/types/external.ts:684,689` `ExitModuleImportHook` / `ExitModuleImportNowHook` return-type widening from `ThirdPartyStaticModuleInterface` to `ModuleDescriptor` admits `string` and `PrecompiledModuleSource` shapes that `attenuateModule` will throw on.**
  **Recommended action**: open a follow-up issue or PR on `endojs/endo` proposing either (a) narrowing the return type to `StrictModuleDescriptor | VirtualModuleSource` for the policy path; or (b) surveying every caller in `import-archive-lite.js`, `import-hook.js`, and downstream agoric-sdk consumers and documenting the caller contract explicitly.

- [ ] **`packages/ses/types.d.ts:135` `StrictModuleDescriptor` is exported but may not be reachable via the public surface (`import('ses').StrictModuleDescriptor`).**
  **Recommended action**: verify that `import { StrictModuleDescriptor } from 'ses'` (or `import type { ... }`) resolves from a downstream consumer. The changeset promises consumers can use the type; the four-way surface (package.json exports, index.js thunk, types-index, types.d.ts) must agree. If a surface gap is found, open a follow-up PR on `endojs/endo` adding the re-export to whichever surface is missing it.

- [ ] **`packages/import-bundle` changeset bumps `minor` for "thread the `importHook` option through" but only a test change appears in this diff.**
  **Recommended action**: audit `packages/import-bundle/src/import-bundle.js`'s git log for the `importHook`-threading commit. If it predates this PR, the import-bundle changeset entry is over-bumping. Open a follow-up changeset-correction PR (or amend the changeset if not yet released). If the production-side change is genuinely missing, open a follow-up PR adding it.

## Five items, all upstream-targeted

Each item recommends opening a follow-up issue or PR on `endojs/endo`. The consumer (steward or liaison) routes to a builder, designer, investigator, or boatman per the item's scope. No bot-side action is needed; bot-side PR #351 is closed.
