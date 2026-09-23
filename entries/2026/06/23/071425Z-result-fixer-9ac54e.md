---
ts: 2026-06-23T07:14:25Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/23/071425Z-result-fixer-9ac54e.md
---

Addressed kriskowal's review comment on PR #474 (id 4776353908).

**Design moved**: `designs/retire-function-keyword.md` removed; new permanent
location is `docs/house-style/function-keyword.md`.
Reframed from proposal to declarative house-style documentation:
declarative prose, no "design" or "proposal" framing, rationale and exception
catalogue preserved.

**AGENTS.md updated**: House style section added near the top, linking to
`docs/house-style/function-keyword.md` with a one-line rule summary.
`CLAUDE.md` delegates via `@AGENTS.md`, so the link is reachable from the
repo root.

**CI fix**: lint job was failing in `yarn docs` (typedoc) with two errors in
`packages/immutable-arraybuffer/src/lib.js`:
- `TS2353`: prettier commit `17a065f0d` had moved `@type {(this: object) => ArrayBuffer}`
  from the `get buffer()` method to the outer `taGetters` JSDoc, making
  TypeScript infer the object as a function type.
- `TS2339`: the same prettier commit deleted the `@ts-expect-error` comment
  that suppressed the `PropertyDescriptor.get` narrowing error.
Both restored in the fix commit.

**Files touched**: AGENTS.md, designs/retire-function-keyword.md (deleted),
docs/house-style/function-keyword.md (new), packages/immutable-arraybuffer/src/lib.js.

**Lease anchor**: 17a065f0d8bf8f2a555f5cb437607939f911e000 (prior HEAD).
**New HEAD**: ca341e5bd89c47e22dfe6b6734dfb5759f022160.
**Summary comment**: https://github.com/endojs/endo-but-for-bots/pull/474#issuecomment-4776681425

CI status before push: all checks except lint passing; lint failure was the
two typedoc errors above (both introduced by the prettier commit in this PR,
not pre-existing on master).

Gardener dispatch to be issued by liaison separately.

Self-improvement: message to liaison — prettier format commits can silently
relocate JSDoc `@type` tags to an outer binding's block, breaking TypeScript's
type inference for the inner property. Worth adding to pre-push-gates notes or
as a known pitfall for style commits.
