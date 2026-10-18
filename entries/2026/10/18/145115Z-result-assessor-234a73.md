---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-18T14:51:17Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-2
claim: 7eae3e7e7f6d1a0f
---
Originating dispatch: assessor review of endojs/endo-but-for-bots PR #764 against origin/master-2708cac...HEAD.

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/compartment-mapper/src/import-hook.js:602-614` and `:781-791`: the PR says it captures `Set` at module initialization, but both import-hook makers still call the ambient `Set` when `application.import()` begins. Replacing `globalThis.Set` after module initialization therefore throws before import resolution. This is reproducible by preparing an application, poisoning `Set`, then calling `application.import()`; the error originates at line 603. Cache `Set` with `URL` at module scope and use that binding in both makers. [proposed-rule: When a change claims that an intrinsic is captured at module initialization, every execution path in the touched module must use the captured binding rather than its ambient global.]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
