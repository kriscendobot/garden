CI is green. All panel-5 must-fix items applied, pushed as a follow-up commit, CI terminal green.

## Completion report

**Job:** Gauntlet FIX round 5 for endojs/endo-but-for-bots PR #1156 (`docs(pass-style): design a Node-condition-gated reified-symbol variant`).

**What I did:** Read the panel-5 verdict (five request-changes seats plus comment-only seats), verified every factual claim against the actual `llm` sources, applied the must-fix items to `designs/pass-style-symbol-condition.md` and `designs/README.md`, pushed one follow-up commit (`2a01aeeb7`) to the PR head, and watched CI to green.

**Changes applied (by seat):**
- **pedant (must-fix):** removed all em-dashes from the design doc, per instance (parentheses/colons/periods). Verified 0 remain; README additions were already clean.
- **skeptic (must-fix):** added a new "The reader-side surface (`nameForPassableSymbol`)" subsection running the paired reader grep — names `workflow/journal.js` and `patterns/patternMatchers.js` as recoverable-class breaks the earlier drafts missed, notes `rankOrder.js` swaps cleanly. Rescoped the "exhaustive" claim to the producer leaf only. Named `marshal/tools/marshal-test-data.js` as the eighth producer site with its `'@@@@foo'` import-crash hazard.
- **critic (must-fix):** Rollout step 3 now requires the OCapN variant test config to exclude syrup tests or ship atomically with the syrup fix (aligned the README size-estimate paragraph); named `far/test/e.test.js:113` as a concrete property-key (unrecoverable) instance outside OCapN and widened the audit target to `@endo/far`/exo method keys.
- **ergonomist (must-fix):** resolved the world-query vocabulary seam and bare-string hazard with a firm recommendation (one vocabulary + named predicate/enum), added open question 10; stated the two-file `SymbolHelper` as an accepted deviation.
- **decomplector / copyeditor / novice (should/comment):** made split-file tests the recommendation not a coin-flip; dropped first-person voice, fixed the tense mismatch, untangled the `assertValid` sentence, corrected "exists to protect"; dropped the undefined "Panel round 2" jargon.

Validated all 19 intra-doc anchors resolve. Did **not** re-run the panel (the driver re-posts panel-6).

**Result:** follow-up pushed, CI terminal GREEN (5/5 checks, 0 failed).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 146 tokens (8087891 cached reads)
- Output: 39706 tokens
- Cost: $6.367908499999998
- Wall-clock: 1092s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
