CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 2 for endojs/endo-but-for-bots PR #997 — a design-doc PR (`design(daemon): reassess worker retention, revocation, and the batch-flush retention root`).

**What I did:** Read the panel-2 request-changes verdict (8 seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice + one comment-only) and applied its must-fix and high-value should-fix items in one authored pass over `designs/worker-retention-and-revocation.md` and `designs/README.md`.

**Substantive fixes:**
- **Thread 3 / Q4 discriminator + premature-collection hole** (critic must-fix, skeptic #2): stated the discriminator once (a wire message is a protocol fact whatever prompted it; keying on your *own* GC or on timing is forbidden) and applied it consistently. Corrected the release condition to require question resolution **and** absence of any cross-peer import edge — closing the fourth (cross-peer) window where releasing on resolution alone would collect an intermediate a counterparty still directly imports. A counterparty's `op:gc-exports` is now correctly classed as an authoritative wire fact; `op:gc-answers`/own finalizer as an optimization hint only.
- **Formula-ID confinement** (skeptic must-fix): retracted the absolute "no formula ID is guest-reachable" framing — the general guest can already *redeem* an ID via `lookupById`/`storeIdentifier` — and recorded the pre-existing exposure as new Open Question Q6; DD2 now commits only that the sugar adds no *new* leak, on both call directions.
- **Q4 sizing** (skeptic must-fix): distinguished "no OCapN *wire* change" from the fact that a new `@endo/captp` question-observation seam (à la landed `provideImport`) is a prerequisite, since `questions`/`answers` are module-local Maps. Updated the Dependencies row and README sizing.
- **WorkerDiscipline** (decomplector/ergonomist/skeptic): remodeled as a discriminated union (invalid states unrepresentable, no request-time validator); moved per-edge `identity` off the descriptor; moved coherence checking to per-edge at succession time; reused exo taxonomy vocabulary; settled on one name ("worker discipline").
- **Decoupling** (decomplector): separated the buildable daemon-internal `question:<answer-pos>` edge (over landed `pinTransient`) from the unlanded guest-facing `makeRetainedValue` handle.
- **Provenance** (critic/decomplector): DD1 now records revocation provenance at grant time, making the fail-safe an optimization boundary.
- **Novice must-fixes:** added a vocabulary/thread-map intro (defines formula, host/guest, batch-flush root), a Thread 2 worked before/after example + surface sketch, and named the Thread 2→5 dependency-edge hand-off (critic should-fix).
- **README count contradiction:** labeled the historical (152) vs authoritative Current-totals (151) lineages so the reader isn't left with two same-dated counts.

**Mechanical:** removed all 121 em-dashes (headings→colons); ran the typist-friendly-code-points auto-fix (arrows, ellipsis, checkmarks, minus signs); fixed citation form (parenthetical years), `§ *Name*` spacing, `-ly` hyphens, `vs.`, the saboteur-seat/voice/grammar copyedits, and added the `Updated` metadata field.

**Result:** Committed as review-feedback follow-up `2cfe72550`, safe-pushed to the PR head, CI watched to terminal — **GREEN** (5/5 checks, 0 failed).

**Follow-ups:** none required for this stage; the driver re-posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (4194985 cached reads)
- Output: 60002 tokens
- Cost: $5.0725945
- Wall-clock: 1178s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
