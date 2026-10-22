**Viability: proceed.** PR #1541 is still needed, and nothing newer has replaced it.

Deciding question: Is PR #1541 still the only open work that applies the #1540 type-location recommendation across Endo's JavaScript-first packages, and does the maintainer still want that done?

Evidence:
- **PR state:** #1541 is open, a draft and not merged. It was created at 2026-10-22T20:55Z, minutes before this check, and has no reviews or comments yet. It targets `master-ebc7904`, and its body says it closes #1540.
- **Motivating request still stands:** On issue #1540 (still open), kriskowal asked us to "produce a pull request that makes Endo consistently apply the recommendation, run the gauntlet, shepherd through CI." #1541 is the PR the bot opened in answer to that request.
- **The recommendation still holds:** #1540 rests on Endo's current TypeScript conventions from turadg (commit `6b979ac`) and on the `packages/patterns` example: shared type definitions live in checked `src/types.ts` files, and `types-index.d.ts` files only re-export them. Nothing has reversed that.
- **Not superseded:** Searching the repo's pull requests found no other normalization effort. #1393 (marshal) is still open, and #1541 deliberately leaves `@endo/marshal` alone so the two do not overlap. That makes #1393 a companion PR, not a replacement. #546 (support `.ts` runtime modules) is a different concern, and #1540 explicitly says a future TypeScript-at-runtime pipeline is not enough on its own.
- **Base history:** `master` is 77 commits ahead of `ebc7904`. Their subject lines cover immutable-arraybuffer, pass-style, retiring the `function` keyword, stream, patterns, cbor and CI. None of them moves type definitions or changes how declarations are routed, so the PR's premise is unchanged.

No code changes and no garden commits were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1541-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (161034 cached reads)
- Output: 1484 tokens
- Cost: $0.4044788
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
