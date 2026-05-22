---
ts: 2026-05-22T01:04:15Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/cleaner--ab2eab/project
refs:
  - dispatches/cleaner--ab2eab
---

Cleaner pass on PR #313 (`feat(patterns): explainMismatch submodule for rich
diagnostics`), branch `feat/patterns-explain-mismatch`.

## Coverage delta on `packages/patterns`

| surface                          | baseline | after  | delta   |
| -------------------------------- | -------- | ------ | ------- |
| `src/explain-mismatch/` overall  | 65.05%   | 91.29% | +26.24  |
| `src/explain-mismatch/trace.js`  | 52.93%   | 93.42% | +40.49  |
| `src/explain-mismatch/render.js` | 83.65%   | 88.01% | +4.36   |
| `packages/patterns` overall      | 84.53%   | 89.77% | +5.24   |

Test count: 638 to 665 (+27). All new tests are integration tests that drive
the public `explainMismatch` entry point against patterns the original
15-test surface left unreached:

- combinators: `M.and` (per-branch attribution, all-fail), `M.recordOf`
  (per-value, per-key, non-record specimen), `M.splitArray` (required-prefix
  type-mismatch, optional+rest, too-short-required, non-array specimen),
  `M.splitRecord` (optional present-and-bad, rest pattern, non-record
  specimen).
- copyArray and copyRecord patterns directly (length mismatch, per-element,
  mismatched-key-set, wrong specimen kind).
- opaque tagged patterns (`M.kind`) and literal-string patterns (the
  non-pattern-style fallthrough at trace.js:539).
- `renderFound`'s per-passStyle branches (bigint, boolean, null, undefined,
  symbol).
- expanded-format `reason:` lines on or-disjunctions and arrayOf.
- the default-format branch of `renderTrace` (compact via omitted `format`).

Plus two regression-evidence tests pinned to the trace recursion: one for
`M.and` per-branch attribution, one for `M.splitArray` index-attribution-with-
rest. Both were verified load-bearing by disabling their target branch and
confirming the test fails; same procedure run for the splitRecord-rest test
and the splitArray-rest test.

## Single commit landed

```
b633a0109 test(patterns): cleaner coverage pass on explainMismatch
  1 file changed, 300 insertions(+)
  packages/patterns/test/explain-mismatch.test.js
```

No production source touched. No dead-code deletion (deferred per the
panel-surface notes below). No yarn.lock churn (no new dependencies).

## CI state on the cleaner's HEAD

Pushed `d1a77a400` to `b633a0109`. All `test (*, *)` matrix jobs and the
patterns suite specifically: pass. Pre-existing red unchanged by the push:

- `cover (20.x, ubuntu-latest)`, `cover (24.x, ubuntu-latest)`: fail due to
  `Uncaught exception in test/netlayer-tcp-syrup.test.js` — the test imports
  `makeClient` from `../src/client/index.js` which no longer exports it after
  PR #326 landed on `llm`. Unrelated to patterns.
- `lint`: fails on the same `makeClient` import (1 error, 1992 warnings).
- `zizmor`: fails on `familiar-release.yml` security warnings (overly broad
  permissions, code-injection template expansion). Workflow file, not source.

Comparison: the prior HEAD (`d1a77a400`) passed all three checks; base branch
`llm` has drifted by 10 commits since this PR opened, and the red is from
that drift. The PR's `mergeable_state` is still `MERGEABLE` (no file-level
conflict), so this is a soft-stale rather than a hard-conflict; the judge
panel can proceed against the cleaner's HEAD as-is, or the orchestrator can
dispatch a weaver to rebase onto current `llm` before the panel if it wants
the per-PR CI surface to be all-green for the panel's verification step. The
patterns-package surface itself is green.

## Panel-surface notes (left for the jury, not coverage targets)

These are quality observations the cleaner surfaced while raising coverage;
they are not the cleaner's lane to fix.

1. `countLeaves` (trace.js:549-562) is exported but its only caller in source
   is `void countLeaves` in render.js:353, an unused-import-keep stub. The
   renderer's `count = leaves.length` at render.js:260 computes the same
   value inline. Either the renderer should consume `countLeaves` (replacing
   the inline `.length` and dropping `void countLeaves`) or the export and
   its no-op import should both be removed. The dead-code-on-life-support
   pattern is the case the cleaner skill explicitly calls out.
2. `renderPath`'s path-step cases for `mapKey`, `mapValue`, `setElement`,
   `bagElement`, `bagCount`, `andBranch` (render.js:104-131) are reachable
   from `renderPath`'s public API but the trace walker in trace.js never
   emits those step kinds because `mapOf`, `setOf`, `bagOf`, and the
   `andBranch` path are not unrolled (the implementation handles `and` but
   the path-step `andBranch` is never produced because the trace builds the
   step inline as `{kind: 'andBranch', ...}` only when the andBranch
   unroller fires — it does, but the render side is untested because no
   integration test reaches the renderer with `.children` containing
   `andBranch` path-steps that aren't already absorbed by collectLeaves).
   Either trim the unused cases in `renderPath` or add `mapOf`/`setOf`/
   `bagOf` unrollers to trace.js so the renderer's cases are reachable.
3. `render.js` `passableAsJustin` catch fallbacks (lines 26-27, 39-43,
   60-61) are defensive against unpassable inputs. Not coverage-driven by
   the public API (would require an adversarial test).
4. Trace.js defensive fall-through returns (138-144, 201-202, 240-241,
   301-302, 315-316, 331-332, 372-373, 461-462, 523-524) protect against
   divergence between the trace walker and the production matcher. Left in
   place per the four-criterion dead-code threshold (each is genuinely
   reachable if a future matcher tweak diverges).
5. Header pluralization typo: `mismatch (1 leaf)` versus `mismatch (2
   leafes)` (render.js:261 emits `leafes` for count !== 1). Cosmetic; the
   fixer can correct to `leaves` if desired.

## Judge readiness

The cleaner pass is done: coverage moved, CI shape on the head is
patterns-green and the only red is base-drift pre-existing. The PR remains
DRAFT (the cleaner does not un-draft). The judge can be dispatched next per
the gauntlet chain: barrister (first-round code panel) → fixer loop (if
must-fix-loop items) → justice (re-runs) → optional appellate → un-draft.

Self-improvement: nothing this time.
