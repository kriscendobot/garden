Fix round 5 for endojs/endo-but-for-bots#1355 is pushed, and CI is green: `ci-wait-merge.sh` exited 0 with 28 of 28 checks passing and none failed.

**What the panel asked for.** Panel round 5 posted a must-fix verdict on head `ff0e38fc`, from the copyeditor, pedant and skeptic seats. The full per-seat text wasn't available. The GitHub review and the recorded panel run (`panel-runs/…/138021176e4d`) both cut each item short, so I fixed from those shortened summaries and my own reading of the doc.

**What I changed.** One follow-up commit, `3c06675b1b`, pushed with `safe-push-pr-head.sh` as a fast-forward from `ff0e38fc14`:

- **Name contradiction (skeptic, must-fix):** the body now uses the shipped name `%InitialURL%` everywhere instead of `%URL%`. The Status section says once that the proposal called it `%URL%` and that the doc now uses shipped names throughout. The old name stays only in the historical note at the end of the doc.
- **Evidence for the completion claims (skeptic, must-fix):**
  - The merge commit `30147f5aa1` is now a link, and I checked that it's reachable in the fork.
  - The "22 tests" claim is now linked per file: `url.test.js` has 16, `url-blob-remove.test.js` has 4 and `url-missing.test.js` has 2. I counted them.
  - The Status section names the test that covers the `%URLPrototype%.constructor` pin.
- **Test plan out of step with what shipped (skeptic, should-fix):**
  - Item 3 now describes the constructor pin, with an "As shipped" note.
  - Item 9 (the XS smoke test) now says it was not delivered as written: the XS runner only calls `lockdown()` and asserts nothing about `URL`.
- **Why the constructor pin matters (skeptic, should-fix):** the cross-compartment `instanceof` section now explains the escape the pin closes. Without it, a shared compartment could reach `new URL(...).constructor.createObjectURL`. The Status section adds that with `urlBlobTaming: 'remove'` the start compartment's constructor comparison becomes `true`.
- **Wording (copyeditor):**
  - The unclear "`new URL(` sweep was not done" sentence now spells out Phase 3's optional second task and says it remains open.
  - The XS sentence is clearer.
  - The audit findings are now a parallel bullet list.
  - The Status section now says outright that the design accepts the `urlBlobTaming` naming as shipped.
- **Paths and punctuation (pedant):** file references in Status are now consistent relative links. The "; and" punctuation in the lists was corrected.
- **Dates:** the Updated date is now 2026-09-30 in both the doc header and the `designs/README.md` table.

**Follow-ups:** none from this stage. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1352347 cached reads)
- Output: 8859 tokens
- Cost: $1.0138414000000002
- Wall-clock: 765s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
