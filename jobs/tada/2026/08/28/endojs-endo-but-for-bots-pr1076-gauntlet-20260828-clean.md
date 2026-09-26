## Clean stage — PR #1076 complete

**PR:** endojs/endo-but-for-bots #1076 — `test(hardened262): pin %ThrowTypeError% intrinsic metadata`

**What the change is:** A test-only addition to `packages/hardened262`. It adds one new test262-style test (`test/intrinsics/ThrowTypeError/intrinsic-metadata.js`) pinning the `%ThrowTypeError%` poison-pill intrinsic's metadata (shared, frozen, zero-length, anonymous accessor reached via the strict `callee` descriptor, with the cross-route `Function.prototype.caller`/`arguments` invariant guarded where those accessors survive), plus the regenerated pass/skip baseline `.txt` lists across every host×mode combination (sesNode/sesXs/xs).

**Coverage pass:** Not applicable in the source-coverage sense — the PR touches only test fixtures and baseline lists; no production source was changed, so no code was orphaned and there is no dead code to remove. The meaningful verification is that the new test lands in the correct passed/skipped baseline for each host×mode, which the diff already reflects and which CI validates.

**CI:** Drove to a terminal state. All 24 checks COMPLETED / SUCCESS (lint, build, test matrix on 22.x + 24.18.0 across ubuntu/macos, test262, cover, test-xs, test-ironhorse, test-hermes, build-xsnap, build-wasm, etc.). CI is fully GREEN at the current head.

**Follow-ups:** None. No push was needed (the PR was already correctly shaped). The PR remains draft, as expected for a mid-gauntlet stage — the next stage owns un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1076-gauntlet-20260828-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 28 tokens (820797 cached reads)
- Output: 4130 tokens
- Cost: $1.0120915
- Wall-clock: 686s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
