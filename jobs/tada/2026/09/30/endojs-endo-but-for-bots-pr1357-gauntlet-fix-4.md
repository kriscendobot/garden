Fix round 4 for endojs/endo-but-for-bots PR #1357: I applied the round-4 panel's must-fix items to the design doc, pushed them, and CI is green (`ci-wait-merge.sh --no-merge` returned 0).

**What changed:** one follow-up commit, `a1c7088f0c`, pushed to the PR head `design/endo-claude-inference-backends` with `safe-push-pr-head.sh`, moving it from `d53fa42dff` to `a1c7088f0c`. It edits only `designs/endo-claude-inference-backends.md` (131 lines added, 59 removed).

- **critic + skeptic (the caller sets the prompt-origin label and nothing checks it):**
  - Decision 9 now says outright that `promptOrigin` is set by the caller with no structural check.
  - New gate 8 runs real guest-influenced input through every factory path that can set `root-authored`, and checks that the request arrives labeled `guest-influenced` and is refused. Gate 2 only tests the point that reads the label.
  - Until gate 8 passes, the backend without OS containment serves only the root operator's own direct prompts.
  - Added a Known Gaps entry for the missing structural check.
- **skeptic (Phase 3 deployed before gate 1 ran):** Phase 3 now runs the root subscription backend only as a canary, with gate 1's usage-accounting check. Production traffic waits for gate 1 to pass, and per-token billing stops the rollout for a maintainer decision. Phase 4 now runs gates 2–4 and 8. Decision 5 now says near its start that the stored `setup-token` has not yet run under `--bare`.
- **decomplector:**
  - A refused `acquire()` now returns a new `AdmissionRefusal` (`rate-limited`, `usage-exhausted` or `budget`, plus an optional retry time) instead of a finished result. The backend plugin maps it to an `InferResult`, so the plugin is the only thing that classifies outcomes.
  - The prompt-origin gate now returns its own `needs-containment` tag instead of `unavailable` with a reason string that callers had to parse.
  - Decision 8 now names which layer produces each usage-record field. The deployment hands each usage recorder its backend's `secretId` when it builds it, and "verified effect" comes from the evaluation harness. The title no longer says "the broker persists".
  - The ownership map, Decision 7 and gate 2 now match these changes.
- **copyeditor / pedant / novice:**
  - Fixed the line-206 grammar, missing serial commas, the unparallel examples in Decision 9 and the wording of "only so the usage recorder can write it".
  - Fixed the ambiguous "which" in Status and linked the revision notes to § Resolved Questions.
  - Replaced the "pending" probe PR with a link to draft #1369, and updated the Updated row.
- **ergonomist (comment-only seat):** I added the note that `promptOrigin` is still checked at run time. I did not do the `Infer*` vs `Inference*` naming change.

**Follow-up:** the gauntlet driver should post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1342833 cached reads)
- Output: 18008 tokens
- Cost: $1.3275185999999999
- Wall-clock: 906s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
