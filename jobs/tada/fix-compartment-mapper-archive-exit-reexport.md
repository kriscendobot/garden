Work complete. Here is my report.

---

## Completion report: fix-compartment-mapper-archive-exit-reexport

**Outcome:** Fixed. DRAFT PR opened with fully green CI. The root cause was in **compartment-mapper, not SES** — no SES change was needed (contrary to the job's hypothesized cross-package fix).

### Root cause (corrected attribution)
The bug was entirely in `packages/compartment-mapper/src/import-hook.js`, in `exitModuleImportHookMaker`. When an exit/host module is supplied through the `modules` map, the hook synthesized a virtual module source from the module **descriptor object itself** rather than its `.namespace`:

```js
const ns = modules[specifier];            // { namespace: { meaning: 42 } }
exports: ns ? keys(ns) : [],              // → ['namespace'], NOT ['meaning']
```

So the exit module appeared to export only `namespace`, with no export notifier for `meaning`. A module that re-exported it (`export { meaning } from 'h2g2:meaning'`) then hit SES's `wireUpExportNotifier` with an undefined notifier → `TypeError: notify is not a function`. The `importHook` channel already worked because its `{ namespace }` record goes through SES's correct `{namespace}` promotion. The fixture's "apparent SES bug" comment was a misattribution.

### Fix
Unwrap the `{ namespace }` third-party descriptor shape in the hook (mirroring SES's own acceptance of both a bare namespace object and a `{ namespace }` descriptor), while still accepting a bare namespace object — the shape `test/scaffold.js` supplies as `{ builtin: namespace }`. Both provisioning channels now yield equivalent module instances. Verified safe for all existing `modules`-map value shapes (`null`, `true`, bare namespace, `{ namespace }`).

### Changes
- `src/import-hook.js` — descriptor unwrap + explanatory comment.
- `test/exit.test.js` — removed the `test.failing` marker (now passes).
- `test/fixtures-exit/reexport.js` — refreshed the now-stale "apparent SES bug" comment.
- `.changeset/exit-module-reexport-via-modules-map.md` — `@endo/compartment-mapper` patch.

### Verification
- `exit.test.js`: both tests pass (was 1 pass + 1 known failure).
- Full compartment-mapper suite: **903 passed**; known failures **12 → 11** (this class resolved).
- `eslint` + `tsc` clean on the package; prettier-formatted.
- **CI fully green** on PR #533 (16/16 after rerun). One macOS run initially failed on `endo › indirect cancellation via worker` — an unrelated flaky `@endo/daemon` worker-cancellation test; confirmed flake by rerun (ubuntu/24.x had passed throughout).

### Deliverable
- DRAFT PR **#533** on `endojs/endo-but-for-bots` (`master` base): https://github.com/endojs/endo-but-for-bots/pull/533
- Branch `fix/cm-archive-exit-reexport` pushed to origin. Local worktree torn down, local branch deleted.

### Follow-ups
- PR is DRAFT with green CI, ready for the gamut's remaining stages (panel review → un-draft) by the downstream judge/fleet; I did not self-un-draft.
- 11 of the original 12 `classify-compartment-mapper-failures` classes remain open as separate jobs.
