Rebased PR #388 onto current `llm` and pushed head `32ce72b71a7721353bfa634059e69a3b215d32ae`.

Implemented review follow-ups:

- Centralized constant-time comparison in `@endo/bytes`.
- Added CapTP cancellation-driven registration cleanup.
- Moved gateway typedefs to `src/types.ts` with `@import` use sites.
- Folded socket-path resolution into `@endo/where`.
- Preserved immutable `ArrayBuffer` at Exo boundaries: a strict `Uint8Array` experiment typechecked but failed 22 runtime tests because mutable typed arrays are not passable.
- Confirmed existing garden commits `3d918054a` and `33a6994ef` cover the requested builder guidance, typist juror, and deterministic probe.

Replied to all 15 preceding inline feedback threads and posted a top-level completion summary.

Verification: 114 gateway tests and 33 bytes tests passed; focused TypeScript and ESLint checks passed; repository-wide Prettier and `git diff --check` passed. CI has no failures; several full-suite jobs remain pending, so reviewer re-request was deferred until green.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr388-review-3f255add.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1672s

<!-- garden-usage-end -->
