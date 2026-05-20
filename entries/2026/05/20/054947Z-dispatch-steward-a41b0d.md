---
ts: 2026-05-20T05:49:47Z
kind: dispatch
role: steward
to: builder
dispatch_id: a41b0d
dispatch_root: /home/kris/dispatches/builder--a41b0d
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 307
    role: source
---

# Dispatch builder a41b0d — implement explain-mismatch submodule (per merged #307)

Design #307 merged at 2026-05-20T05:46:59Z (`08dc3039d`). kriskowal directive: "Please dispatch to the conductor and then a builder to implement. Note that when this is complete, we should then integrate with lal."

Builder implements the design at `designs/patterns-diagnostic-feedback.md` (now on llm). Key surface:

- New submodule: `@endo/patterns/explain-mismatch.js` (lives at `packages/patterns/src/explain-mismatch.js` or similar)
- Exported via package.json `exports` key
- Single public function: `explainMismatch({ specimen, pattern, context? }, options?): string | undefined`
  - `options`: `{ format?: 'compact' | 'expanded', width?, color? }`
  - Returns multi-line rendered diagnostic string or undefined on match
  - Default `format: 'compact'`: one-line-per-mismatch with ` | ` separators (`path | found | expected | reason`)
  - Expanded format: indented Rust-compiler-style line-art
- Non-throwing — mirrors `matches({specimen, pattern})` shape
- Internal `Trace` type (not exposed)
- Production matcher path unchanged — opt-in callers only pay the cost

Builder should:
1. Read the merged design at `designs/patterns-diagnostic-feedback.md` carefully for the API + rendering spec.
2. Use existing `@endo/patterns` internals (matchHelpers, confirmMatches) for the tracing recursion — the submodule pivot's key win is in-place reuse vs. drift.
3. Add unit tests covering common mismatch patterns + the rendering format.
4. Build the design's intent end-to-end — when complete, lal can integrate via `import { explainMismatch } from '@endo/patterns/explain-mismatch.js'`.

Mark as DRAFT initially per build-time convention. Run pre-push gates before push.
