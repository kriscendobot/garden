CI is green (rc 0). All fix items applied and verified.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1018 — gauntlet FIX round 5 (design PR, `designs/ironhorse-panic.md`).

**What I did:** Read the panel round-5 request-changes verdict and applied every actionable finding as one review-feedback follow-up commit (`fd4c5a494`), pushed to the PR head (`endojs/design/ironhorse-panic`), and watched CI to green.

**Must-fix (skeptic):**
- Pinned the `panic-on-reference-error` setting into the `snapshot` transcript record and specified that the supervisor **rejects a resume-for-replay** whose setting differs from the run that produced the transcript (a deterministic replay fault, like the engine-signature check), closing the replay-lineage divergence hole where a caught `ReferenceError`'s in-heap-only effect could silently replay to a different heap state.

**Should-fix (from the request-changes seats):**
- Added a Verification bullet asserting the classification-discipline clippy lint is wired into CI and fails on a commit-path variant match bypassing `is_panic()`/`CrankOutcome` (critic).
- Added a Verification bullet covering the Coda's own behavior: on/off panic-vs-catchable at each ref-error site, the `<panic>` wire message under an attached debugger, and the replay-pinning rejection (skeptic).

**Comment-only findings also applied** (cheap doc quality): softened the "no commit-path consumer matches `Halt` directly" claim to name its convention+lint enforcement inline (decomplector); explained the `EngineFault.location` vs `ReferenceError.site` field divergence and marked `is_panic()`'s `Decode`/`StepLimit` answer as provisional-with-no-type-signal (ergonomist); prose fixes — split the ambiguous "which" antecedent, de-dangled the `raise_js` participial, removed the lone second-person "you" (copyeditor); unnested the hangover-inconsistency parens and glossed a TDZ read (novice); normalized quotation punctuation to American style and flagged added emphasis in a quotation (pedant); reordered the `<panic>` wire-kind enum to match `PanicKind` order (ergonomist note).

**Not applied:** novice finding 3 (relocate the opening status/caveat block) — a structural "consider moving" suggestion from a comment-only seat; higher-risk restructuring with low value, left as-is.

**CI:** GREEN — 5/5 checks, 0 failed. I did not re-run the panel (the driver re-posts panel-6).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3016299 cached reads)
- Output: 21633 tokens
- Cost: $3.1006475000000004
- Wall-clock: 751s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
