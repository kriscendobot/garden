CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** FIX round 4 of the PR #1084 gauntlet (`endojs/endo-but-for-bots`, design doc `designs/exo-stream-adaptive-pacing.md`).

**What I did:** Read the panel-4 verdict (aggregate **must-fix**; request-changes from critic, skeptic, decomplector, ergonomist, copyeditor) and applied every must-fix item once as a single review-feedback follow-up commit, then pushed and watched CI to green.

**Changes (`5296f904b`):**
- **decomplector + ergonomist (buffer overload):** Introduced a distinct optional **`pacing`** field for adaptive mode instead of overloading numeric `buffer`. `buffer` now stays strictly `number` on every reader (`iterateReader`, `iterateBytesReader`); `pacing` accepts a `CreditController` or descriptor; the two are mutually exclusive (supplying both is a `TypeError`). Rewrote the Surface section, the ts examples, the type-widening lines, the `iterateBytesReader` sibling bullet, and repurposed the "same option name, two domains" bullet into "buffer stays strictly numeric on every reader."
- **critic + skeptic (validation):** Added construction-time **range validation** (`min>=1`, `max>=min`, `alpha>0`, `beta` in `(0,1)`, positive `target0`/`target`/`interval`) with rationale, plus a boundary-value verification-plan test.
- **ergonomist (max/maxCredit):** Stated `maxCredit === configured max` explicitly at both introduction points.
- **critic (epoch counter):** Scoped the epoch counter to the `Filling` state (suspended/reset on entry to `Arming`/`Reducing`), reconciling the diagram/prose split and closing the post-reduction oscillation gap.
- **skeptic (BDP claim):** Qualified "settles at BDP" to consumer-/RTT-bound links; split the verification bullet so a bandwidth-bound producer asserts growth-to-`max`, not convergence.
- **decomplector (alpha coupling):** Recorded coupled-by-default as a deliberate maintainer decision with a first-class decouple path.
- **copyeditor + pedant:** Comma after "bandwidth-delay product", AIMD expanded at first use, "above"→"below" cross-reference fixed, the 114-col line rewrapped, and the producer-pre-buffer test folded into the list.

**Result:** Pushed via `safe-push-pr-head.sh` (advance mode, `9c6a1b978 → 5296f904b`). CI terminal **GREEN** (5/5 checks, 0 failed). Did not re-run the panel — the driver re-posts panel-5.

**Follow-ups:** none from me; the design's parameter-defaults, writer-dual, and default-flip open questions remain intentionally open for the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 75 tokens (3569430 cached reads)
- Output: 32848 tokens
- Cost: $3.667721999999999
- Wall-clock: 882s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
