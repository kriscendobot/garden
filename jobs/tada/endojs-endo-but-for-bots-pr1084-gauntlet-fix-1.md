CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** FIX round 1 for the `endojs-endo-but-for-bots-pr1084-gauntlet` — a **design-doc PR** (#1084, "docs: Design adaptive exo-stream pacing and buffer control").

**What I did:** Read the panel-1 verdict (request-changes across seven seats, disposition must-fix) and applied every finding once to `designs/exo-stream-adaptive-pacing.md` plus the `designs/README.md` blurb, then pushed and watched CI to green.

**What changed (by seat):**
- **critic** — redefined `outstanding` as *issued − consumed* (not acked/arrival) and stated the credit pump is gated on consumption, restoring the hard memory-bound claim; added an explicit cold-start (`W = min`, prime first credits) replacing the synchronous pre-buffer loop.
- **skeptic / pedant** — removed the fabricated `readableblob-lines.md` citation (that file lives only on the unmerged `design/readableblob-lines` branch), cited PR #832 as the real origin everywhere; added the multi-stream-over-one-transport case as an explicit non-goal; added a `ReadableBlob.lines()` end-to-end integration test to the plan.
- **ergonomist** — named the discriminant for each `buffer` union branch (brand vs descriptor), specified the `CreditController` interface (`record`/`floor`) where introduced, renamed `makeCodelBuffer` → `makeCodelCreditController` to match its returned type, documented the `lines` vs `iterateReader` option-domain divergence, and split `target0` (base) from effective `target`.
- **decomplector** — took a position on the alpha knob (coupled by default, `target` as an explicit decoupling override) and made the count-based fallback a separate `makeOccupancyCreditController` the CoDel maker delegates to.
- **copyeditor / pedant** — replaced all typist-hostile code points with ASCII, rewrote all 13 em-dashes, glossed `responder (producer)`, dropped the first-person "our queue", capitalized the "Alpha sweep" list item. Typist probe passes.
- **novice** — clarified the `undefined` synchronization payload, added a worked numeric trace to the control loop, expanded AIMD.

**Push:** `68face71c..ef55668e6` on `design/exo-stream-adaptive-pacing` via `safe-push-pr-head.sh --mode advance`.
**CI:** rc 0 — GREEN (5/5 checks, 0 failed).

**Follow-ups:** none required from this stage. Per the gauntlet contract I did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1421572 cached reads)
- Output: 23629 tokens
- Cost: $2.060293
- Wall-clock: 750s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
