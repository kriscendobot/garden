CI is GREEN (rc 0). Both must-fix items applied, pushed, and verified.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1061 (`refactor(marshal): move public types to declarations`).

**Panel round-4 verdict** (must-fix) had two blocking items; both addressed:

1. **prover — `EncodingUnion` one-directional pin.** Added a bidirectional `expectType<true>(null as unknown as Equal<EncodingUnion, <fully-spelled union>>)` in `packages/marshal/src/types.test-d.ts`, alongside the existing assignability positives and `@ts-expect-error` negatives, mirroring the file's own load-bearing `Equal<...>` technique. Verified by the exact mutation the panel cited: adding a disjoint `EncodingClass<'mystery'>` arm to `types.d.ts` now reddens `tsc` (`TS2345: 'false' is not assignable to 'true'`); restored after.

2. **scribe — missing completion-summary comment.** Posted a top-level summary ([issuecomment-5460660126](https://github.com/endojs/endo-but-for-bots/pull/1061#issuecomment-5460660126)) mapping the round-4 findings to fixes plus a backfill of the un-summarized round-3 push, with head SHA and lint/types/test status.

**Push:** commit `87f4cf5ca` fast-forwarded onto `origin/refactor/marshal-types-declaration-module` (923b23fd6 → 87f4cf5ca) via `safe-push-pr-head.sh` (advance mode).

**Local verification before push:** `tsc -p packages/marshal` green, `eslint` green, `prettier --check` green. Diff is types-only (`types.test-d.ts`), no runtime delta.

**CI:** watched bounded to terminal — 14/14 checks, 0 failed → **GREEN** at ~365s.

Did not re-run the panel (the driver re-posts panel-5). Non-blocking advisory notes (`PartialComparison` `NaN`→`number` widening, no c8 report for a types-only diff) were left as-is per the panel marking them advisory.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1197556 cached reads)
- Output: 9593 tokens
- Cost: $1.3390330000000001
- Wall-clock: 585s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
