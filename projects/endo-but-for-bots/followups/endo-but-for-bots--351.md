---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 351
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 2422
created_at: 2026-05-22T02:25:00Z
last_appended_at: 2026-05-22T02:25:00Z
status: actioned
actioned_at: 2026-06-06T05:02:08Z
merge_event: 2026-06-06T04:59:50Z
actioned_via: jobs/open/20260606T050208Z--c50e55--endo-but-for-bots-351-host-module-exits.md
---

# Follow-ups for endojs/endo-but-for-bots#351

Created from the barrister panel verdict (26-seat code panel, in-band fallback) on the host-module-exits mirror PR (mirror of endojs/endo#2422). Five follow-up items warrant revisit at merge time; the eight summary-fix items land in this PR via a separate fixer dispatch, and the rest of the panel's findings resolved as acknowledge.

## Items

- [ ] **`packages/compartment-mapper/src/policy.js:520-548` `attenuateModule`'s four-branch shape enumeration has two reachable throw paths (descriptor with non-virtual `source`; bare descriptor with no virtual-source shape) that no test covers.**
  **Source juror(s)**: corner-prober, fast-checker.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR on `endojs/endo` once this mirror merges. Add policy.test.js fixtures exercising each of the two uncovered throw branches: (a) a `SourceModuleDescriptor` whose `source` is a `PrecompiledModuleSource` or `NamespaceModuleDescriptor`; (b) a bare `NamespaceModuleDescriptor` (no `imports`/`exports`/`execute`). Optionally, replace the four-branch case-analysis test set with a `fast-check` property test over a discriminated-union arbitrary that asserts the function either returns a frozen wrapper or throws with the documented message; this is what the fast-checker proposed.

- [ ] **`packages/compartment-mapper/test/exit.test.js` `test.failing('can make, parse, and import an archive with a URL-scheme-prefixed modules map exit to a host module', ...)` cites no tracking issue.**
  **Source juror(s)**: prover.
  **Round**: 1.
  **Recommended action**: file a tracking issue on `endojs/endo` describing the `modules:` map exit shape that does not yet round-trip through `makeArchive`/`parseArchive`/`app.import`. The test currently documents the gap inline (it would fail if marked passing); a tracking issue makes the deferred work discoverable from the issue tracker rather than only from the test source. Cross-link the upstream PR (endojs/endo#2422) discussion if it covers the deferral.

- [ ] **`packages/compartment-mapper/src/types/external.ts:684,689` `ExitModuleImportHook` / `ExitModuleImportNowHook` return-type widening from `ThirdPartyStaticModuleInterface` to `ModuleDescriptor` admits `string` and `PrecompiledModuleSource` shapes that `attenuateModule` will throw on.**
  **Source juror(s)**: typist, migrator.
  **Round**: 1.
  **Recommended action**: open a follow-up issue or PR on `endojs/endo` proposing either (a) narrowing the return type to `StrictModuleDescriptor | VirtualModuleSource` for the policy path so the type matches what `attenuateModule` accepts; or (b) surveying every caller in `import-archive-lite.js`, `import-hook.js`, and downstream agoric-sdk consumers and documenting the caller contract explicitly (which shapes does each caller actually consume). The widening is correct at the implementer surface but the call-graph telegraphs more flexibility than the policy attenuator honors.

- [ ] **`packages/ses/types.d.ts:135` `StrictModuleDescriptor` is exported but may not be reachable via the public surface (`import('ses').StrictModuleDescriptor`).**
  **Source juror(s)**: surfacer.
  **Round**: 1.
  **Recommended action**: after this PR merges, verify that `import { StrictModuleDescriptor } from 'ses'` (or `import type { ... }`) resolves from a downstream consumer. The changeset promises consumers can use the type; the four-way surface (package.json exports, index.js thunk, types-index, types.d.ts) must agree. If a surface gap is found, open a follow-up PR on `endojs/endo` adding the re-export to whichever surface is missing it.

- [ ] **`packages/import-bundle` changeset bumps `minor` for "thread the `importHook` option through" but only a test change appears in this diff. The production-side change may be in a prior commit on master (in which case the bump should be `patch` or dropped) or may be missing from this PR.**
  **Source juror(s)**: curator, changeset-auditor.
  **Round**: 1.
  **Recommended action**: after this PR merges, audit `packages/import-bundle/src/import-bundle.js`'s git log for the `importHook`-threading commit. If it predates this PR, the import-bundle changeset entry is over-bumping (test-only changes do not warrant `minor`). Open a follow-up changeset-correction PR or amend the changeset if not yet released. If the production-side change is genuinely missing, open a follow-up PR adding it; the new import-bundle test exercises behavior that may not yet be plumbed end to end.
