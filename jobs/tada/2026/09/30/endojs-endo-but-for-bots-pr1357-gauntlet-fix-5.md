Fix round 5 for endojs/endo-but-for-bots PR #1357 is pushed, and CI is green (28 of 28 checks, `ci-wait-merge` rc 0).

**Pushed:** one follow-up commit, `50917af1a4`, on `design/endo-claude-inference-backends`, sent through `safe-push-pr-head.sh` (the head moved forward from `a1c7088f0c`, nothing was overwritten). All changes are in `designs/endo-claude-inference-backends.md`.

**Panel items applied:**
- **skeptic:**
  - Gate 7 now also checks that a second `acquire()` on the same credential is refused while the first is held, and succeeds once it is released.
  - The design now says `promptOrigin` is an optional open string in the exo guard. That way a missing or unknown value reaches the prompt-origin gate and gets `needs-containment`, instead of being rejected by the guard, and `infer` still never rejects.
- **decomplector:**
  - Each result tag now has exactly one writer: the prompt-origin gate writes `needs-containment` before the plugin runs, and the plugin writes every other tag. The Inference Seam text, the taxonomy notes and the Ownership Map bullet were changed to agree.
  - Decision 9 now decides containment by which backend a call path holds, the same way credentials are chosen. The unsliced root backend can only be reached from the root operator's direct-prompt path. Every other path gets the sliced backend, or no backend until phase 6. The label gate stays as a fail-closed backstop that reports a factory defect. The Ownership Map row and the Known Gaps entry were updated to match.
- **ergonomist:**
  - `budget` is now its own top-level result tag, `budget-exhausted`, carrying `retryAfterMs` like `rate-limited` and `usage-exhausted`. It is no longer an arm of `limit-exceeded`.
  - The `InferLimits` fields are renamed to `maxWallClockMs`, `maxOutputBytes` and `maxTurns`.
  - `describe()` now lists `provider` before `kind`.
- **critic:**
  - Gate 8 now covers both directions and tests which backend each path gets. It checks that guest-influenced paths never hold the unsliced backend, and that a genuine root-authored prompt arrives labeled `root-authored` and completes on the unsliced backend.
  - Phase 4 now says what happens if #1102 is not ready: gates 2–5 go ahead without it, gate 8 runs once it lands, and until then the root backend serves only the root operator's direct prompts.
- **pruner:**
  - I removed the Resolved Questions section, which repeated the Design Decisions, and reworded the Status revision paragraph to match.
  - In the PR body, Testing and Documentation are each cut to one sentence. The Testing sentence also fixes a stale count: it said seven gates, and there are eight.

**Not changed:** the pedant's heading findings. Every `##` heading is already title case, and "versus" and "and" are correctly lowercase under Chicago style. The critic's and novice's comment-only notes were not applied either.

**Follow-up:** none; the driver posts panel round 6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1283754 cached reads)
- Output: 11971 tokens
- Cost: $1.1618988000000003
- Wall-clock: 922s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
